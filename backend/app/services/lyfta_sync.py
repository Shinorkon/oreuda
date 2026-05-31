"""
Lyfta Sync Service

Handles all communication with the Lyfta gym workout tracker API,
including validation, fetching, and importing workouts into Shnuk.

KEY FIXES (2026-05-04):
- Distinguishes workout PROGRAMS from COMPLETED sessions
- Parses full exercise sets/reps/weight data from Lyfta
- Calculates realistic calories using sport-science formulas
- Maps each exercise to primary + secondary muscle groups
- Delta sync: only fetches new workouts since last sync
"""
import base64
import hashlib
import logging
from dataclasses import dataclass
from datetime import datetime, timedelta, timezone
from typing import Any, Dict, List, Optional, Tuple

import httpx
from sqlalchemy import func
from sqlalchemy.orm import Session
from fastapi import HTTPException

from app.core.config import settings
from app.models.exercise import Exercise, ExerciseCategory, WorkoutLog, WorkoutSource
from app.models.lyfta_integration import LyftaIntegration
from app.models.user import User
from app.services.calorie_engine import calculate_workout_calories
from app.services.lyfta_muscle_map import (
    safe_parse_ids,
    resolve_muscles_from_ids,
    resolve_zone_groups,
    SET_TYPE_MAP,
    EQUIPMENT_ID_MAP,
    BODY_PART_ID_MAP,
)

try:
    from cryptography.fernet import Fernet
except ImportError:
    Fernet = None

logger = logging.getLogger(__name__)


# ═══════════════════════════════════════════════════════════════════════════════
# Exercise → Muscle Group Mapping
# ═══════════════════════════════════════════════════════════════════════════════

EXERCISE_MUSCLE_MAP: Dict[str, Dict[str, List[str]]] = {
    # ── Chest ──
    "bench press": {"primary": ["chest"], "secondary": ["triceps", "shoulders"]},
    "incline bench press": {"primary": ["chest", "shoulders"], "secondary": ["triceps"]},
    "dumbbell press": {"primary": ["chest"], "secondary": ["triceps", "shoulders"]},
    "chest fly": {"primary": ["chest"], "secondary": ["shoulders"]},
    "cable crossover": {"primary": ["chest"], "secondary": []},
    "push up": {"primary": ["chest"], "secondary": ["triceps", "shoulders", "core"]},
    "dip": {"primary": ["chest", "triceps"], "secondary": ["shoulders"]},
    "pec deck": {"primary": ["chest"], "secondary": []},
    "chest press": {"primary": ["chest"], "secondary": ["triceps"]},
    # ── Back ──
    "barbell row": {"primary": ["back"], "secondary": ["biceps", "core", "forearms"]},
    "dumbbell row": {"primary": ["back"], "secondary": ["biceps", "core"]},
    "lat pulldown": {"primary": ["back"], "secondary": ["biceps"]},
    "pull up": {"primary": ["back", "biceps"], "secondary": ["core"]},
    "chin up": {"primary": ["back", "biceps"], "secondary": ["core"]},
    "deadlift": {"primary": ["back", "legs", "glutes"], "secondary": ["core", "traps", "forearms"]},
    "romanian deadlift": {"primary": ["back", "hamstrings", "glutes"], "secondary": ["core", "forearms"]},
    "hyperextension": {"primary": ["back", "glutes"], "secondary": ["hamstrings"]},
    "face pull": {"primary": ["back", "shoulders"], "secondary": []},
    "shrugs": {"primary": ["traps"], "secondary": ["forearms"]},
    "t-bar row": {"primary": ["back"], "secondary": ["biceps", "core"]},
    "seated cable row": {"primary": ["back"], "secondary": ["biceps", "core"]},
    " Meadows row": {"primary": ["back"], "secondary": ["biceps", "core"]},
    # ── Legs ──
    "squat": {"primary": ["legs", "glutes"], "secondary": ["core", "back"]},
    "leg press": {"primary": ["legs", "glutes"], "secondary": []},
    "hack squat": {"primary": ["legs", "glutes"], "secondary": []},
    "lunges": {"primary": ["legs", "glutes"], "secondary": ["core"]},
    "leg extension": {"primary": ["legs"], "secondary": []},
    "leg curl": {"primary": ["hamstrings"], "secondary": []},
    "calf raise": {"primary": ["legs"], "secondary": []},
    "hip thrust": {"primary": ["glutes"], "secondary": ["core", "hamstrings"]},
    "goblet squat": {"primary": ["legs", "glutes"], "secondary": ["core", "shoulders"]},
    "front squat": {"primary": ["legs", "glutes", "core"], "secondary": ["shoulders", "back"]},
    "bulgarian split squat": {"primary": ["legs", "glutes"], "secondary": ["core"]},
    # ── Shoulders ──
    "overhead press": {"primary": ["shoulders"], "secondary": ["triceps", "core"]},
    "military press": {"primary": ["shoulders"], "secondary": ["triceps", "core"]},
    "lateral raise": {"primary": ["shoulders"], "secondary": []},
    "front raise": {"primary": ["shoulders"], "secondary": []},
    "rear delt fly": {"primary": ["shoulders", "back"], "secondary": []},
    "arnold press": {"primary": ["shoulders"], "secondary": ["triceps"]},
    "upright row": {"primary": ["shoulders", "traps"], "secondary": ["biceps"]},
    # ── Arms ──
    "bicep curl": {"primary": ["biceps"], "secondary": ["forearms"]},
    "hammer curl": {"primary": ["biceps", "forearms"], "secondary": []},
    "preacher curl": {"primary": ["biceps"], "secondary": []},
    "concentration curl": {"primary": ["biceps"], "secondary": []},
    "tricep pushdown": {"primary": ["triceps"], "secondary": []},
    "skull crusher": {"primary": ["triceps"], "secondary": []},
    "overhead tricep extension": {"primary": ["triceps"], "secondary": []},
    "close grip bench": {"primary": ["triceps", "chest"], "secondary": []},
    "tricep dip": {"primary": ["triceps"], "secondary": ["chest", "shoulders"]},
    "wrist curl": {"primary": ["forearms"], "secondary": []},
    # ── Core ──
    "plank": {"primary": ["core"], "secondary": ["shoulders", "back"]},
    "crunch": {"primary": ["core"], "secondary": []},
    "leg raise": {"primary": ["core"], "secondary": []},
    "russian twist": {"primary": ["core"], "secondary": ["obliques"]},
    "hanging leg raise": {"primary": ["core"], "secondary": ["forearms"]},
    "ab wheel": {"primary": ["core"], "secondary": ["shoulders", "back"]},
    # ── Cardio (full-body) ──
    "running": {"primary": ["legs"], "secondary": ["core"]},
    "jogging": {"primary": ["legs"], "secondary": ["core"]},
    "cycling": {"primary": ["legs"], "secondary": ["core"]},
    "stationary bike": {"primary": ["legs"], "secondary": ["core"]},
    "elliptical": {"primary": ["legs"], "secondary": ["core", "arms"]},
    "rowing": {"primary": ["back", "legs"], "secondary": ["core", "biceps"]},
    "treadmill": {"primary": ["legs"], "secondary": ["core"]},
    "walking": {"primary": ["legs"], "secondary": []},
    "hiit": {"primary": ["legs", "core"], "secondary": ["back", "chest", "shoulders"]},
    "sport": {"primary": ["legs", "core"], "secondary": ["back", "chest", "shoulders"]},
    "swimming": {"primary": ["back", "chest", "shoulders", "core"], "secondary": ["legs", "arms"]},
    "jump rope": {"primary": ["legs", "core"], "secondary": ["shoulders", "forearms"]},
}


def resolve_muscle_groups(exercise_name: str) -> Dict[str, List[str]]:
    """Map an exercise name to primary + secondary muscle groups."""
    name_lower = (exercise_name or "").lower().strip()
    for key, groups in EXERCISE_MUSCLE_MAP.items():
        if key in name_lower:
            return groups
    # Fallback: try keyword matching
    keyword_map = {
        "chest": {"primary": ["chest"], "secondary": ["triceps", "shoulders"]},
        "bench": {"primary": ["chest"], "secondary": ["triceps", "shoulders"]},
        "press": {"primary": ["chest", "shoulders"], "secondary": ["triceps"]},
        "row": {"primary": ["back"], "secondary": ["biceps", "core"]},
        "pulldown": {"primary": ["back"], "secondary": ["biceps"]},
        "pull": {"primary": ["back", "biceps"], "secondary": ["core"]},
        "deadlift": {"primary": ["back", "legs", "glutes"], "secondary": ["core", "traps"]},
        "squat": {"primary": ["legs", "glutes"], "secondary": ["core", "back"]},
        "leg": {"primary": ["legs"], "secondary": ["glutes"]},
        "lunge": {"primary": ["legs", "glutes"], "secondary": ["core"]},
        "calf": {"primary": ["legs"], "secondary": []},
        "shoulder": {"primary": ["shoulders"], "secondary": []},
        "delt": {"primary": ["shoulders"], "secondary": []},
        "lateral": {"primary": ["shoulders"], "secondary": []},
        "curl": {"primary": ["biceps"], "secondary": ["forearms"]},
        "tricep": {"primary": ["triceps"], "secondary": []},
        "extension": {"primary": ["triceps"], "secondary": []},
        "pushdown": {"primary": ["triceps"], "secondary": []},
        "crunch": {"primary": ["core"], "secondary": []},
        "plank": {"primary": ["core"], "secondary": ["shoulders", "back"]},
        "run": {"primary": ["legs"], "secondary": ["core"]},
        "cycle": {"primary": ["legs"], "secondary": ["core"]},
        "swim": {"primary": ["back", "chest", "shoulders", "core"], "secondary": ["legs", "arms"]},
    }
    for keyword, groups in keyword_map.items():
        if keyword in name_lower:
            return groups
    return {"primary": [], "secondary": []}


@dataclass
class SyncResult:
    workouts_imported: int = 0
    exercises_imported: int = 0
    programs_skipped: int = 0
    calories_total: float = 0.0


class LyftaSyncService:
    BASE_URL = "https://my.lyfta.app"
    REQUEST_TIMEOUT = 30.0

    @classmethod
    def _get_fernet(cls) -> "Fernet":
        """Derive a deterministic Fernet key from the app's SECRET_KEY."""
        if Fernet is None:
            raise RuntimeError("cryptography library is required for Lyfta API key encryption")
        key = hashlib.sha256(settings.secret_key.encode()).digest()
        fernet_key = base64.urlsafe_b64encode(key)
        return Fernet(fernet_key)

    @classmethod
    def _encrypt_api_key(cls, api_key: str) -> str:
        """Encrypt an API key for safe database storage."""
        return cls._get_fernet().encrypt(api_key.encode()).decode()

    @classmethod
    def _decrypt_api_key(cls, encrypted_key: str) -> Optional[str]:
        """Decrypt a stored API key. Returns None on failure."""
        try:
            return cls._get_fernet().decrypt(encrypted_key.encode()).decode()
        except Exception as e:
            logger.error("Failed to decrypt Lyfta API key: %s", e)
            return None

    @classmethod
    def _headers(cls, api_key: str) -> Dict[str, str]:
        return {
            "Authorization": f"Bearer {api_key}",
            "Accept": "application/json",
        }

    @classmethod
    def validate_api_key(cls, api_key: str) -> dict:
        """Call GET /api/v1/workouts?limit=1 to validate the API key."""
        try:
            with httpx.Client(timeout=cls.REQUEST_TIMEOUT) as client:
                response = client.get(
                    f"{cls.BASE_URL}/api/v1/workouts",
                    headers=cls._headers(api_key),
                    params={"limit": 1},
                )
            try:
                data = response.json()
            except Exception:
                if response.status_code == 200:
                    return {"valid": True, "error": None}
                data = {}

            status = data.get("status")
            if status in (True, "success", "ok", 1, "valid"):
                return {"valid": True, "error": None}

            if isinstance(data, dict):
                nested_data = data.get("data") or data.get("workouts") or data.get("items")
                if isinstance(nested_data, list) and len(nested_data) > 0:
                    return {"valid": True, "error": None}

            return {"valid": False, "error": data.get("message", "Invalid API key")}
        except httpx.RequestError as e:
            logger.warning("Lyfta API validation request failed: %s", e)
            return {"valid": False, "error": f"Cannot reach Lyfta API. Please check your internet connection and try again. ({type(e).__name__})"}

    @classmethod
    def fetch_exercise_library(cls, api_key: str) -> Dict[int, Dict[str, Any]]:
        """Fetch all exercises from Lyfta API and build ID lookup table."""
        try:
            with httpx.Client(timeout=cls.REQUEST_TIMEOUT) as client:
                response = client.get(
                    f"{cls.BASE_URL}/api/v1/exercises",
                    headers=cls._headers(api_key),
                    params={"limit": 1000, "page": 1},
                )
            response.raise_for_status()
            data = cls._normalize_response(response.json())
            exercises = data.get("data", []) if isinstance(data, dict) else []
            lookup: Dict[int, Dict[str, Any]] = {}
            for ex in exercises:
                ex_id = ex.get("id")
                if ex_id and ex_id != "null":
                    try:
                        lookup[int(ex_id)] = ex
                    except (ValueError, TypeError):
                        pass
            logger.info("Lyfta exercise library loaded: %d exercises", len(lookup))
            return lookup
        except Exception as e:
            logger.warning("Failed to fetch Lyfta exercise library: %s", e)
            return {}

    @classmethod
    def fetch_workout_summaries(cls, api_key: str) -> Dict[int, int]:
        """Fetch workout summaries and return workout_id → duration_minutes mapping."""
        try:
            with httpx.Client(timeout=cls.REQUEST_TIMEOUT) as client:
                response = client.get(
                    f"{cls.BASE_URL}/api/v1/workouts/summary",
                    headers=cls._headers(api_key),
                    params={"limit": 1000, "page": 1},
                )
            response.raise_for_status()
            data = cls._normalize_response(response.json())
            summaries = data.get("data", []) if isinstance(data, dict) else []
            duration_map: Dict[int, int] = {}
            for s in summaries:
                wid = s.get("id")
                if wid and wid != "null":
                    try:
                        wid_int = int(wid)
                    except (ValueError, TypeError):
                        continue
                    dur = s.get("workout_duration", "")
                    if dur and dur != "null":
                        parts = str(dur).split(":")
                        if len(parts) == 3:
                            minutes = int(parts[0]) * 60 + int(parts[1]) + round(int(parts[2]) / 60)
                            duration_map[wid_int] = minutes
                        elif len(parts) == 2:
                            minutes = int(parts[0]) + round(int(parts[1]) / 60)
                            duration_map[wid_int] = minutes
            logger.info("Lyfta workout summaries loaded: %d durations", len(duration_map))
            return duration_map
        except Exception as e:
            logger.warning("Failed to fetch Lyfta workout summaries: %s", e)
            return {}

    @classmethod
    def fetch_workouts(cls, api_key: str, page: int = 1, limit: int = 50) -> Dict[str, Any]:
        """Call GET /api/v1/workouts with pagination. Return parsed JSON."""
        try:
            with httpx.Client(timeout=cls.REQUEST_TIMEOUT) as client:
                response = client.get(
                    f"{cls.BASE_URL}/api/v1/workouts",
                    headers=cls._headers(api_key),
                    params={"page": page, "limit": limit},
                )
            response.raise_for_status()
            return cls._normalize_response(response.json())
        except httpx.HTTPStatusError as e:
            logger.error("Lyfta API returned error: %s", e)
            raise HTTPException(status_code=e.response.status_code, detail=f"Lyfta API error: {e.response.text}")
        except httpx.RequestError as e:
            logger.error("Lyfta API request failed: %s", e)
            raise HTTPException(status_code=503, detail="Unable to reach Lyfta API. Please try again later.")

    @staticmethod
    def _normalize_response(data: Any) -> Dict[str, Any]:
        """Normalize Lyfta API response to a dict with a 'data' key."""
        if isinstance(data, list):
            return {"data": data}
        if not isinstance(data, dict):
            return {"data": []}
        if "data" in data:
            return data
        for key in ("workouts", "exercises", "items", "results"):
            if key in data:
                return {**data, "data": data[key]}
        if "id" in data or "title" in data or "perform_date" in data:
            return {**data, "data": [data]}
        return data

    @staticmethod
    def _safe_float(value: Any) -> float:
        """Safely coerce Lyfta API numeric fields that may be 'null' strings."""
        if value is None:
            return 0.0
        if isinstance(value, (int, float)):
            return float(value)
        if isinstance(value, str):
            cleaned = value.strip().lower()
            if cleaned in ("", "null", "none", "nan"):
                return 0.0
            try:
                return float(cleaned)
            except (ValueError, TypeError):
                return 0.0
        return 0.0

    @staticmethod
    def _safe_int(value: Any) -> int:
        """Safely coerce Lyfta API integer fields that may be 'null' strings."""
        if value is None:
            return 0
        if isinstance(value, int):
            return value
        if isinstance(value, float):
            return int(value)
        if isinstance(value, str):
            cleaned = value.strip().lower()
            if cleaned in ("", "null", "none", "nan"):
                return 0
            try:
                return int(float(cleaned))
            except (ValueError, TypeError):
                return 0
        return 0

    @staticmethod
    def _extract_exercise_name(ex: Dict[str, Any]) -> Optional[str]:
        """Extract exercise name from multiple possible Lyfta API field paths."""
        # Direct fields
        for key in ("name", "exercise_name", "excercise_name", "ExcerciseName", "title", "exercise_title"):
            val = ex.get(key)
            if val and str(val).strip() and str(val).lower() != "null":
                return str(val).strip()
        # Nested paths: ex["exercise"]["name"] or ex["Excercise"]["name"]
        for nested_key in ("exercise", "Excercise", "Exercise"):
            nested = ex.get(nested_key)
            if isinstance(nested, dict):
                for name_key in ("name", "exercise_name", "excercise_name", "title"):
                    val = nested.get(name_key)
                    if val and str(val).strip() and str(val).lower() != "null":
                        return str(val).strip()
        return None

    @classmethod
    def _parse_workout_date(cls, workout: Dict[str, Any]) -> datetime:
        """Robustly parse workout date from multiple possible fields and formats."""
        # Try fields in order of preference
        for field in ("workout_perform_date", "perform_date", "date", "performed_date", "created_at"):
            raw = workout.get(field)
            if not raw or raw == "null" or raw == "none":
                continue
            if isinstance(raw, (int, float)):
                # Unix timestamp (seconds or milliseconds)
                ts = float(raw)
                if ts > 1e12:  # milliseconds
                    ts = ts / 1000
                return datetime.fromtimestamp(ts, tz=timezone.utc)
            if not isinstance(raw, str):
                continue
            raw = raw.strip()
            # ISO with T
            if "T" in raw:
                try:
                    return datetime.fromisoformat(raw.replace("Z", "+00:00"))
                except ValueError:
                    pass
            # Space-separated datetime
            if " " in raw and ":" in raw:
                for fmt in ("%Y-%m-%d %H:%M:%S", "%Y-%m-%d %H:%M", "%d-%m-%Y %H:%M:%S", "%m/%d/%Y %H:%M:%S"):
                    try:
                        return datetime.strptime(raw, fmt).replace(tzinfo=timezone.utc)
                    except ValueError:
                        pass
            # Date-only
            for fmt in ("%Y-%m-%d", "%d-%m-%Y", "%m/%d/%Y"):
                try:
                    return datetime.strptime(raw, fmt).replace(tzinfo=timezone.utc)
                except ValueError:
                    pass
            logger.warning("Could not parse date field '%s' value '%s' for workout '%s'", field, raw, workout.get("title", "Untitled"))
        logger.warning("No parseable date found for workout '%s' — using now", workout.get("title", "Untitled"))
        return datetime.now(timezone.utc)

    @staticmethod
    def _decode_unicode_escapes(text: str) -> str:
        """Decode JSON-style unicode escapes like \\uD83D\\uDE41 into actual characters.
        Handles UTF-16 surrogate pairs correctly (e.g. \\uD83D\\uDE41 → 😟).
        """
        if not text or "\\u" not in text:
            return text
        try:
            # Use json.loads with a JSON string wrapper to handle surrogate pairs
            import json
            return json.loads(f'"{text}"')
        except json.JSONDecodeError:
            # Fallback: regex-based replacement for simple cases
            import re
            def replace_unicode_escape(match):
                code = int(match.group(1), 16)
                try:
                    return chr(code)
                except ValueError:
                    return match.group(0)
            return re.sub(r'\\u([0-9a-fA-F]{4})', replace_unicode_escape, text)

    @staticmethod
    def _parse_duration(duration_str: Optional[str]) -> int:
        """Parse a duration string like '01:06:25' into total minutes (rounded)."""
        if not duration_str:
            return 0
        parts = duration_str.strip().split(":")
        try:
            if len(parts) == 3:
                hours = int(parts[0])
                minutes = int(parts[1])
                seconds = int(parts[2])
                return round(hours * 60 + minutes + seconds / 60)
            elif len(parts) == 2:
                minutes = int(parts[0])
                seconds = int(parts[1])
                return round(minutes + seconds / 60)
            elif len(parts) == 1:
                return int(parts[0])
        except (ValueError, TypeError):
            pass
        return 0

    @staticmethod
    def _map_exercise_type(exercise_type: Optional[str]) -> ExerciseCategory:
        """Map Lyfta exercise_type to closest ExerciseCategory."""
        if not exercise_type:
            return ExerciseCategory.STRENGTH
        type_lower = exercise_type.lower()
        if any(word in type_lower for word in ("cardio", "run", "cycle", "bike", "swim", "row", "elliptical", "treadmill")):
            return ExerciseCategory.CARDIO
        if any(word in type_lower for word in ("stretch", "yoga", "pilates", "mobility", "flex")):
            return ExerciseCategory.FLEXIBILITY
        if any(word in type_lower for word in ("sport", "game", "match", "ball", "tennis", "basketball", "football", "soccer")):
            return ExerciseCategory.SPORT
        return ExerciseCategory.STRENGTH

    @staticmethod
    def _levenshtein_distance(s1: str, s2: str) -> int:
        """Simple edit distance for fuzzy matching."""
        if len(s1) < len(s2):
            return LyftaSyncService._levenshtein_distance(s2, s1)
        if len(s2) == 0:
            return len(s1)
        previous_row = range(len(s2) + 1)
        for i, c1 in enumerate(s1):
            current_row = [i + 1]
            for j, c2 in enumerate(s2):
                insertions = previous_row[j + 1] + 1
                deletions = current_row[j] + 1
                substitutions = previous_row[j] + (c1 != c2)
                current_row.append(min(insertions, deletions, substitutions))
            previous_row = current_row
        return previous_row[-1]

    @classmethod
    def _find_or_create_exercise(
        cls,
        db: Session,
        exercise_name: str,
        exercise_type: Optional[str],
        exercise_definition: Optional[Dict[str, Any]] = None,
    ) -> Tuple[Exercise, bool]:
        """Try to match exercise name to existing Exercise; create new if no match.
        
        If exercise_definition is provided (from Lyfta API), use its muscle IDs,
        equipment, and image data instead of fuzzy keyword matching.
        """
        name_lower = exercise_name.lower().strip()

        # 1. Case-insensitive exact match
        exercise = (
            db.query(Exercise)
            .filter(
                func.lower(Exercise.name) == name_lower,
                Exercise.is_custom == False,  # noqa: E712
            )
            .first()
        )
        if exercise:
            # If we have new Lyfta data, update the exercise metadata
            if exercise_definition:
                cls._update_exercise_from_definition(exercise, exercise_definition, name_lower)
                db.commit()
                db.refresh(exercise)
            return exercise, False

        # 2. Fuzzy match (edit distance <= 2) with length pre-filter
        name_len = len(name_lower)
        candidates = (
            db.query(Exercise)
            .filter(
                Exercise.is_custom == False,  # noqa: E712
                func.abs(func.length(func.lower(Exercise.name)) - name_len) <= 3,
            )
            .all()
        )
        best_match = None
        best_distance = 999
        for candidate in candidates:
            if not candidate.name:
                continue
            dist = cls._levenshtein_distance(name_lower, candidate.name.lower().strip())
            if dist <= 2 and dist < best_distance:
                best_distance = dist
                best_match = candidate
        if best_match:
            if exercise_definition:
                cls._update_exercise_from_definition(best_match, exercise_definition, name_lower)
                db.commit()
                db.refresh(best_match)
            return best_match, False

        # 3. Create new exercise with muscle groups from Lyfta data
        category = cls._map_exercise_type(exercise_type)
        muscle_groups = cls._build_muscle_groups(exercise_name, exercise_definition)
        calories = 6.0  # default, recalculated during sync
        image_url = exercise_definition.get("exercise_image") if exercise_definition else None

        new_exercise = Exercise(
            name=exercise_name.strip(),
            category=category,
            calories_per_minute=calories,
            is_custom=False,
            user_id=None,
            muscle_groups=muscle_groups,
            image_url=image_url,
        )
        db.add(new_exercise)
        db.commit()
        db.refresh(new_exercise)
        return new_exercise, True

    @staticmethod
    def _build_muscle_groups(
        exercise_name: str, exercise_definition: Optional[Dict[str, Any]]
    ) -> Dict[str, Any]:
        """Build muscle groups dict from Lyfta definition or fallback to fuzzy matching."""
        if exercise_definition:
            target_ids = safe_parse_ids(exercise_definition.get("Target_muscles_id"))
            synergist_ids = safe_parse_ids(exercise_definition.get("Synergist_muscles_id"))
            if target_ids or synergist_ids:
                muscle_names = resolve_muscles_from_ids(target_ids, synergist_ids)
                zone_groups = list(resolve_zone_groups(muscle_names["primary"] + muscle_names["secondary"]))
                bp_ids = safe_parse_ids(exercise_definition.get("body_part_id"))
                eq_ids = safe_parse_ids(exercise_definition.get("equipment_id"))
                return {
                    "primary": muscle_names["primary"],
                    "secondary": muscle_names["secondary"],
                    "zone_groups": zone_groups,
                    "target_muscle_ids": sorted(target_ids),
                    "synergist_muscle_ids": sorted(synergist_ids),
                    "body_part_ids": sorted(bp_ids),
                    "equipment_ids": sorted(eq_ids),
                    "source": "lyfta_api",
                }
        # Fallback to fuzzy keyword matching
        return resolve_muscle_groups(exercise_name)

    @staticmethod
    def _update_exercise_from_definition(exercise: Exercise, definition: Dict[str, Any], correct_name: str = "") -> None:
        """Update an existing Exercise with richer Lyfta metadata."""
        # Fix generic fallback names like "Push Day — Exercise 2"
        if correct_name and (" — Exercise " in exercise.name or exercise.name.startswith("Lyfta:")):
            exercise.name = correct_name.strip()
        if not exercise.image_url:
            exercise.image_url = definition.get("exercise_image")
        target_ids = safe_parse_ids(definition.get("Target_muscles_id"))
        synergist_ids = safe_parse_ids(definition.get("Synergist_muscles_id"))
        if target_ids or synergist_ids:
            muscle_names = resolve_muscles_from_ids(target_ids, synergist_ids)
            zone_groups = list(resolve_zone_groups(muscle_names["primary"] + muscle_names["secondary"]))
            bp_ids = safe_parse_ids(definition.get("body_part_id"))
            eq_ids = safe_parse_ids(definition.get("equipment_id"))
            exercise.muscle_groups = {
                "primary": muscle_names["primary"],
                "secondary": muscle_names["secondary"],
                "zone_groups": zone_groups,
                "target_muscle_ids": sorted(target_ids),
                "synergist_muscle_ids": sorted(synergist_ids),
                "body_part_ids": sorted(bp_ids),
                "equipment_ids": sorted(eq_ids),
                "source": "lyfta_api",
            }

    @classmethod
    def _is_program_workout(cls, workout: Dict[str, Any]) -> bool:
        """
        Detect if a Lyfta entry is a workout PROGRAM (template/future plan)
        rather than a COMPLETED session.
        """
        # Check explicit status flags
        status = (workout.get("status") or "").lower()
        if status in ("program", "template", "planned", "scheduled"):
            return True
        if workout.get("is_template") is True:
            return True
        if workout.get("is_completed") is False:
            return True
        if workout.get("completed_at") is None and workout.get("finished_at") is None:
            # Might be a program if no completion timestamp
            pass  # continue with date checks

        # Check date — future-dated entries are programs
        perform_date_raw = workout.get("perform_date") or workout.get("workout_perform_date")
        if perform_date_raw:
            try:
                if isinstance(perform_date_raw, str):
                    if "T" in perform_date_raw:
                        perform_dt = datetime.fromisoformat(perform_date_raw.replace("Z", "+00:00"))
                    else:
                        perform_dt = datetime.strptime(perform_date_raw, "%Y-%m-%d").replace(tzinfo=timezone.utc)
                    # If perform_date is more than 12 hours in the future, it's a program
                    if perform_dt > datetime.now(timezone.utc) + timedelta(hours=12):
                        return True
            except (ValueError, TypeError):
                pass

        # Check for empty/no sets — programs often have no actual performed data
        exercises = workout.get("exercises", [])
        has_performed_sets = False
        for ex in exercises:
            sets = ex.get("sets", [])
            if sets and any(s.get("reps") or s.get("weight_kg") for s in sets):
                has_performed_sets = True
                break
        if exercises and not has_performed_sets:
            return True

        return False

    @classmethod
    def sync_workouts(cls, user_id: str, api_key: str, db: Session) -> SyncResult:
        """
        Fetch workouts from Lyfta API and import them as WorkoutLogs.

        KEY BEHAVIOR:
        - Skips PROGRAM entries (future workout plans)
        - Only imports COMPLETED sessions
        - Parses full sets/reps/weight data
        - Calculates realistic calories using sport-science formulas
        - Maps exercises to muscle groups for body map visualization
        """
        result = SyncResult()

        # Fetch user's weight for calorie calculation
        user = db.query(User).filter(User.id == user_id).first()
        user_weight_kg = user.weight_kg if user and user.weight_kg else 70.0

        # Fetch exercise library for rich muscle/equipment metadata
        exercise_lookup = cls.fetch_exercise_library(api_key)

        # Fetch workout summaries for real durations
        duration_map = cls.fetch_workout_summaries(api_key)

        # Get last sync time for delta sync
        integration = (
            db.query(LyftaIntegration)
            .filter(LyftaIntegration.user_id == user_id)
            .first()
        )
        last_sync = integration.last_sync_at if integration else None

        # Fetch all workouts via pagination
        all_workouts: List[Dict[str, Any]] = []
        page = 1
        while True:
            data = cls.fetch_workouts(api_key, page=page, limit=50)
            workouts = data.get("data", []) if isinstance(data, dict) else []
            if not workouts or not isinstance(workouts, list):
                break
            all_workouts.extend(workouts)
            pagination = data.get("pagination") if isinstance(data, dict) else None
            if pagination:
                current_page = pagination.get("current_page", page)
                total_pages = pagination.get("total_pages", current_page)
                if current_page >= total_pages:
                    break
            if len(workouts) < 50:
                break
            page += 1

        logger.info("Lyfta API returned %d total workouts", len(all_workouts))
        if not all_workouts:
            return result

        # Count skip reasons for debugging
        skipped_programs = 0
        skipped_duplicates = 0

        # Track seen workout IDs for deduplication within this sync
        seen_ids: set[str] = set()

        for workout in all_workouts:
            # ── SKIP PROGRAMS ──
            if cls._is_program_workout(workout):
                result.programs_skipped += 1
                skipped_programs += 1
                logger.info("Skipping Lyfta program: %s", workout.get("title", "Untitled"))
                continue

            # Parse workout date — try multiple fields and formats
            logged_at = cls._parse_workout_date(workout)

            # Delta sync: skip if we've already synced this workout
            lyfta_workout_id = str(workout.get("id", "")) or None
            if lyfta_workout_id:
                existing_count = db.query(WorkoutLog).filter(
                    WorkoutLog.user_id == user_id,
                    WorkoutLog.lyfta_workout_id == lyfta_workout_id,
                ).count()
                if existing_count > 0:
                    skipped_duplicates += 1
                    logger.info("Skipping duplicate Lyfta workout %s (already in DB)", lyfta_workout_id)
                    continue

            # Parse duration — prefer summary API, fallback to workout object, then 30 min
            raw_wid = workout.get("id")
            duration_minutes = 0
            if raw_wid is not None and raw_wid != "null":
                try:
                    wid_int = int(raw_wid)
                    duration_minutes = duration_map.get(wid_int, 0)
                except (ValueError, TypeError):
                    pass
            if duration_minutes <= 0:
                duration_str = workout.get("duration") or workout.get("workout_duration", "")
                duration_minutes = cls._parse_duration(duration_str)
            if duration_minutes <= 0:
                duration_minutes = 30  # sensible fallback

            # Workout metadata — decode unicode escapes (e.g. \uD83D\uDE41 → 😟)
            raw_title = workout.get("title", "Lyfta Workout") or "Lyfta Workout"
            title = cls._decode_unicode_escapes(raw_title)

            # Process exercises
            exercises = workout.get("exercises", [])
            if not exercises and workout.get("exercise_name"):
                exercises = [{"name": workout.get("exercise_name"), "type": workout.get("exercise_type", "strength")}]

            if not exercises:
                continue

            # Calculate per-exercise duration
            per_exercise_minutes = max(1, round(duration_minutes / len(exercises)))

            # Compute session-level totals
            session_total_volume = 0.0
            session_total_sets = 0
            all_rpes: List[int] = []

            for ex in exercises:
                sets_data = ex.get("sets", [])
                if not sets_data:
                    continue
                for s in sets_data:
                    reps = cls._safe_int(s.get("reps"))
                    weight = cls._safe_float(s.get("weight_kg") or s.get("weight"))
                    session_total_volume += reps * weight
                    session_total_sets += 1
                    rpe_raw = s.get("rpe") or s.get("rir")
                    rpe = cls._safe_float(rpe_raw) if isinstance(rpe_raw, str) else rpe_raw
                    if isinstance(rpe, (int, float)) and rpe > 0:
                        all_rpes.append(int(rpe))

            session_avg_rpe = sum(all_rpes) / len(all_rpes) if all_rpes else None

            for idx, ex in enumerate(exercises):
                ex_name = cls._extract_exercise_name(ex)
                if not ex_name:
                    ex_name = f"{title} — Exercise {idx + 1}"
                    logger.debug("Exercise name fallback for workout '%s' idx %d: %s", title, idx, ex_name)
                ex_type = ex.get("type") or ex.get("exercise_type", "strength")

                # Parse exercise-level sets data
                sets_data = ex.get("sets", [])
                ex_sets = len(sets_data)
                ex_reps = 0
                ex_volume = 0.0
                ex_max_weight = 0.0
                ex_rpes: List[int] = []
                exercise_data = []

                # First pass: collect raw set data
                raw_sets = []
                for s in sets_data:
                    reps = cls._safe_int(s.get("reps"))
                    weight = cls._safe_float(s.get("weight_kg") or s.get("weight"))
                    set_rpe_raw = s.get("rpe") or s.get("rir")
                    set_rpe = cls._safe_float(set_rpe_raw) if isinstance(set_rpe_raw, str) else set_rpe_raw
                    set_type_id = str(s.get("set_type_id", "0"))
                    set_type = SET_TYPE_MAP.get(set_type_id, "Normal")
                    is_drop_set = set_type_id in ("2", "4")
                    is_pr = bool(s.get("record_type"))
                    ex_reps += reps
                    ex_volume += reps * weight
                    ex_max_weight = max(ex_max_weight, weight)
                    if isinstance(set_rpe, (int, float)) and set_rpe > 0:
                        ex_rpes.append(int(set_rpe))
                    raw_sets.append({
                        "reps": reps,
                        "weight_kg": weight,
                        "rpe": set_rpe,
                        "set_type": set_type,
                        "is_drop_set": is_drop_set,
                        "is_pr": is_pr,
                        "record_type": s.get("record_type"),
                        "record_level": s.get("record_level"),
                        "record_value": s.get("record_value"),
                    })

                ex_avg_rpe = sum(ex_rpes) / len(ex_rpes) if ex_rpes else session_avg_rpe

                ex_id = ex.get("exercise_id")
                exercise_definition = exercise_lookup.get(int(ex_id)) if ex_id and str(ex_id).isdigit() else None
                exercise, is_new = cls._find_or_create_exercise(db, ex_name, ex_type, exercise_definition)
                category = exercise.category

                # Realistic calorie calculation
                calories = calculate_workout_calories(
                    category=category,
                    exercise_name=exercise.name,
                    user_weight_kg=user_weight_kg,
                    duration_minutes=per_exercise_minutes,
                    total_volume_kg=ex_volume,
                    num_sets=ex_sets,
                    avg_rpe=ex_avg_rpe,
                )

                # Calculate per-set timing & calorie distribution
                # Perform time: ~5.5s per rep (concentric + eccentric avg); drop sets are faster (~0.7x)
                set_perform_times = []
                for rs in raw_sets:
                    reps = rs["reps"]
                    factor = 0.7 if rs["is_drop_set"] else 1.0
                    perform_sec = reps * 5.5 * factor
                    set_perform_times.append(perform_sec)

                total_perform_sec = sum(set_perform_times)
                # Rest time: assume ~60s rest between normal sets, 30s for drop sets, 90s for failure
                set_rest_times = []
                for rs in raw_sets:
                    if rs["is_drop_set"]:
                        rest_sec = 30.0
                    elif rs["set_type"] == "Failure":
                        rest_sec = 90.0
                    elif rs["set_type"] == "Super Set":
                        rest_sec = 20.0
                    elif rs["set_type"] == "Warm-up":
                        rest_sec = 45.0
                    else:
                        rest_sec = 60.0
                    set_rest_times.append(rest_sec)
                total_rest_sec = sum(set_rest_times)
                session_duration_sec = duration_minutes * 60
                # Clamp rest to not exceed session duration minus perform time
                available_rest_sec = max(0, session_duration_sec - total_perform_sec)
                if total_rest_sec > 0 and available_rest_sec < total_rest_sec:
                    scale = available_rest_sec / total_rest_sec
                    set_rest_times = [r * scale for r in set_rest_times]
                    total_rest_sec = sum(set_rest_times)

                # Per-set calories: distribute exercise calories by volume proportion
                set_data = []
                if ex_volume > 0 and calories > 0:
                    for i, rs in enumerate(raw_sets):
                        set_volume = rs["reps"] * rs["weight_kg"]
                        volume_ratio = set_volume / ex_volume if ex_volume > 0 else (1.0 / len(raw_sets))
                        set_calories = round(calories * volume_ratio, 1)
                        set_data.append({
                            **rs,
                            "perform_time_sec": round(set_perform_times[i], 1),
                            "rest_time_sec": round(set_rest_times[i], 1),
                            "set_calories": set_calories,
                        })
                else:
                    per_set_cals = round(calories / max(1, len(raw_sets)), 1) if calories > 0 else 0.0
                    for i, rs in enumerate(raw_sets):
                        set_data.append({
                            **rs,
                            "perform_time_sec": round(set_perform_times[i], 1),
                            "rest_time_sec": round(set_rest_times[i], 1),
                            "set_calories": per_set_cals,
                        })

                # Body parts from Lyfta exercise definition
                body_parts = []
                if exercise_definition:
                    bp_ids = safe_parse_ids(exercise_definition.get("Body_parts"))
                    body_parts = [BODY_PART_ID_MAP.get(bp_id, f"BodyPart-{bp_id}") for bp_id in bp_ids]

                # Wrap exercise_data with exercise-level metadata
                exercise_data = {
                    "sets": set_data,
                    "time_under_tension_sec": round(total_perform_sec, 1),
                    "total_rest_time_sec": round(total_rest_sec, 1),
                    "body_parts": body_parts,
                }

                notes = f"Lyfta: {title}"
                if ex_volume > 0:
                    notes += f" | Volume: {int(ex_volume)} kg"
                if ex_max_weight > 0:
                    notes += f" | Max: {ex_max_weight:.1f} kg"

                # Check for duplicate (same workout + same exercise + same minute)
                duplicate = None
                if lyfta_workout_id:
                    duplicate = db.query(WorkoutLog).filter(
                        WorkoutLog.user_id == user_id,
                        WorkoutLog.lyfta_workout_id == lyfta_workout_id,
                        WorkoutLog.lyfta_exercise_idx == idx,
                    ).first()
                else:
                    duplicate = db.query(WorkoutLog).filter(
                        WorkoutLog.user_id == user_id,
                        WorkoutLog.exercise_id == exercise.id,
                        WorkoutLog.logged_at >= logged_at.replace(second=0, microsecond=0),
                        WorkoutLog.logged_at < logged_at.replace(second=0, microsecond=0) + timedelta(minutes=1),
                    ).first()

                if duplicate is None:
                    workout_log = WorkoutLog(
                        user_id=user_id,
                        exercise_id=exercise.id,
                        duration_minutes=per_exercise_minutes,
                        calories_burned=calories,
                        logged_at=logged_at,
                        notes=notes,
                        sets=ex_sets if ex_sets > 0 else None,
                        reps=ex_reps if ex_reps > 0 else None,
                        weight_kg=ex_max_weight if ex_max_weight > 0 else None,
                        source=WorkoutSource.LYFTA_COMPLETED,
                        lyfta_workout_id=lyfta_workout_id,
                        lyfta_exercise_idx=idx,
                        session_title=title,
                        session_duration_minutes=duration_minutes,
                        total_volume_kg=ex_volume if ex_volume > 0 else None,
                        session_volume_kg=session_total_volume if session_total_volume > 0 else None,
                        rpe=int(ex_avg_rpe) if ex_avg_rpe else None,
                        exercise_data=exercise_data if set_data else None,
                    )
                    db.add(workout_log)
                    result.exercises_imported += 1
                    result.calories_total += calories

            result.workouts_imported += 1

        db.commit()

        # Update integration record
        if integration:
            integration.last_sync_at = datetime.now(timezone.utc)
            integration.workouts_imported += result.workouts_imported
            integration.exercises_imported += result.exercises_imported
            db.commit()

        logger.info(
            "Lyfta sync complete: %d workouts imported, %d exercises imported, %d programs skipped, %d duplicates skipped, %.0f kcal",
            result.workouts_imported, result.exercises_imported, result.programs_skipped, skipped_duplicates, result.calories_total,
        )
        return result


    @classmethod
    def repair_dates(cls, user_id: str, api_key: str, db: Session) -> Dict[str, int]:
        """
        Re-fetch workout dates from Lyfta API and update existing WorkoutLog entries.
        Returns {"fixed": int, "skipped": int, "failed": int}.
        """
        from app.models.exercise import WorkoutLog, WorkoutSource

        # Find all Lyfta workout IDs in the DB for this user
        rows = (
            db.query(WorkoutLog.lyfta_workout_id)
            .filter(
                WorkoutLog.user_id == user_id,
                WorkoutLog.source == WorkoutSource.LYFTA_COMPLETED,
                WorkoutLog.lyfta_workout_id != None,  # noqa: E711
            )
            .distinct()
            .all()
        )
        workout_ids = [r.lyfta_workout_id for r in rows if r.lyfta_workout_id]
        if not workout_ids:
            return {"fixed": 0, "skipped": 0, "failed": 0}

        logger.info("Repairing dates for %d Lyfta workouts", len(workout_ids))

        # Fetch all workouts from Lyfta API to build an id→date lookup
        id_to_date: Dict[str, datetime] = {}
        try:
            page = 1
            while True:
                data = cls.fetch_workouts(api_key, page=page, limit=50)
                workouts = data.get("data", []) if isinstance(data, dict) else []
                if not workouts or not isinstance(workouts, list):
                    break
                for w in workouts:
                    wid = str(w.get("id", ""))
                    if wid and wid != "null" and wid in workout_ids:
                        parsed = cls._parse_workout_date(w)
                        id_to_date[wid] = parsed
                        logger.info("Repair lookup: workout %s → %s", wid, parsed.isoformat())
                pagination = data.get("pagination") if isinstance(data, dict) else None
                if pagination:
                    current_page = pagination.get("current_page", page)
                    total_pages = pagination.get("total_pages", current_page)
                    if current_page >= total_pages:
                        break
                if len(workouts) < 50:
                    break
                page += 1
        except Exception as e:
            logger.error("Failed to fetch workouts for date repair: %s", e)

        fixed = 0
        skipped = 0
        failed = 0

        for wid in workout_ids:
            correct_date = id_to_date.get(wid)
            if not correct_date:
                skipped += 1
                logger.warning("No date found in Lyfta API for workout %s", wid)
                continue
            try:
                count = (
                    db.query(WorkoutLog)
                    .filter(
                        WorkoutLog.user_id == user_id,
                        WorkoutLog.lyfta_workout_id == wid,
                    )
                    .update({"logged_at": correct_date}, synchronize_session=False)
                )
                db.commit()
                fixed += count
                logger.info("Fixed %d rows for workout %s → %s", count, wid, correct_date.isoformat())
            except Exception as e:
                db.rollback()
                failed += 1
                logger.error("Failed to update workout %s: %s", wid, e)

        logger.info("Date repair complete: %d fixed, %d skipped, %d failed", fixed, skipped, failed)
        return {"fixed": fixed, "skipped": skipped, "failed": failed}


    @classmethod
    def force_full_resync(cls, user_id: str, api_key: str, db: Session) -> SyncResult:
        """
        Delete ALL existing Lyfta workouts for the user and re-import everything from scratch.
        This is the nuclear option when old syncs produced broken data (wrong dates, 30min durations, fallback names).
        """
        from app.models.exercise import WorkoutLog, WorkoutSource

        # 1. Count existing
        existing_count = (
            db.query(WorkoutLog)
            .filter(
                WorkoutLog.user_id == user_id,
                WorkoutLog.source == WorkoutSource.LYFTA_COMPLETED,
            )
            .count()
        )
        logger.warning("FORCE RE-SYNC: deleting %d existing Lyfta workouts for user %s", existing_count, user_id)

        # 2. Delete all Lyfta workout logs for this user
        deleted = (
            db.query(WorkoutLog)
            .filter(
                WorkoutLog.user_id == user_id,
                WorkoutLog.source == WorkoutSource.LYFTA_COMPLETED,
            )
            .delete(synchronize_session=False)
        )
        db.commit()
        logger.info("Deleted %d old Lyfta workout logs", deleted)

        # 3. Reset integration stats
        integration = db.query(LyftaIntegration).filter(
            LyftaIntegration.user_id == user_id,
            LyftaIntegration.is_active == True,  # noqa: E712
        ).first()
        if integration:
            integration.workouts_imported = 0
            integration.exercises_imported = 0
            db.commit()

        # 4. Run a fresh full sync
        result = cls.sync_workouts(user_id, api_key, db)
        logger.info(
            "Force re-sync complete: deleted %d old, imported %d new workouts, %d exercises",
            deleted, result.workouts_imported, result.exercises_imported,
        )
        return result
