"""
Lyfta Muscle & Equipment Mappings

Maps Lyfta's numeric IDs to human-readable names.
Derived from the Lyfta API exercise library.
"""
from typing import Any, Set

# ═══════════════════════════════════════════════════════════════════════════════
# Muscle ID Map (47 muscles)
# ═══════════════════════════════════════════════════════════════════════════════

MUSCLE_ID_MAP: dict[int, str] = {
    1: "Soleus",
    2: "Gluteus Maximus",
    3: "Vastus Lateralis (Quadriceps)",
    4: "Biceps Brachii",
    5: "Brachialis",
    6: "Brachioradialis",
    7: "Iliopsoas (Hip Flexors)",
    8: "Anterior Deltoid",
    9: "Lateral Deltoid",
    10: "Posterior Deltoid",
    11: "Erector Spinae",
    12: "Gastrocnemius",
    13: "Vastus Medialis (Quadriceps)",
    14: "Vastus Intermedius (Quadriceps)",
    16: "Sartorius",
    17: "Biceps Femoris (Hamstrings)",
    18: "Semitendinosus (Hamstrings)",
    19: "Rhomboids",
    20: "Latissimus Dorsi",
    21: "Teres Major",
    22: "Serratus Anterior",
    23: "Levator Scapulae",
    24: "Pectoralis Major (Upper/Clavicular)",
    25: "Pectoralis Major (Lower/Sternal)",
    26: "Obliques",
    27: "Rectus Femoris (Quadriceps)",
    28: "Rectus Abdominis",
    29: "Soleus",
    30: "Adductor Longus",
    31: "Upper Trapezius",
    32: "Tibialis Anterior",
    33: "Adductor Magnus",
    34: "Gracilis",
    35: "Pectineus",
    36: "Transverse Abdominis",
    37: "Middle Trapezius",
    38: "Lower Trapezius",
    39: "Hip Adductors",
    40: "Subscapularis",
    41: "Infraspinatus (Rotator Cuff)",
    42: "Teres Minor (Rotator Cuff)",
    43: "Trapezius (Overall)",
    44: "Triceps Brachii",
    45: "Supraspinatus (Rotator Cuff)",
    46: "Wrist Flexors",
    47: "Wrist Extensors",
}

# ═══════════════════════════════════════════════════════════════════════════════
# Body Part ID Map
# ═══════════════════════════════════════════════════════════════════════════════

BODY_PART_ID_MAP: dict[int, str] = {
    1: "Quadriceps",
    2: "Hamstrings",
    3: "Calves",
    4: "Back",
    5: "Upper Arms",
    6: "Shoulders",
    7: "Forearms",
    8: "Abdominals",
    9: "Chest",
    10: "Glutes",
    12: "Hip Flexors",
    13: "Adductors",
    17: "Upper Arms (Biceps)",
    18: "Lower Back",
    19: "Hips",
    20: "Cardio",
}

# ═══════════════════════════════════════════════════════════════════════════════
# Equipment ID Map
# ═══════════════════════════════════════════════════════════════════════════════

EQUIPMENT_ID_MAP: dict[int, str] = {
    1: "Barbell",
    2: "SZ-Bar",
    3: "Cable",
    4: "Dumbbell",
    5: "Bodyweight",
    6: "Lever/Plate-Loaded Machine",
    7: "Kettlebell",
    8: "Smith Machine",
    9: "Resistance Band",
    10: "TRX/Suspension",
    11: "Medicine Ball",
    16: "Bosu Ball",
    22: "Foam Roller",
    23: "Trap Bar",
    28: "Recumbent Bike",
}

# ═══════════════════════════════════════════════════════════════════════════════
# Set Type Map
# ═══════════════════════════════════════════════════════════════════════════════

SET_TYPE_MAP: dict[str, str] = {
    "0": "Normal",
    "1": "Warm-up",
    "2": "Drop Set",
    "3": "Failure",
    "4": "Drop Set",
    "5": "Super Set",
    "11": "Special",
}

# ═══════════════════════════════════════════════════════════════════════════════
# Muscle Name → Shnuk Muscle Zone Group
# ═══════════════════════════════════════════════════════════════════════════════

MUSCLE_TO_ZONE_GROUP: dict[str, str] = {
    # Chest
    "Pectoralis Major (Upper/Clavicular)": "chest",
    "Pectoralis Major (Lower/Sternal)": "chest",
    # Back
    "Latissimus Dorsi": "back",
    "Rhomboids": "back",
    "Middle Trapezius": "back",
    "Lower Trapezius": "back",
    "Upper Trapezius": "back",
    "Trapezius (Overall)": "back",
    "Teres Major": "back",
    "Erector Spinae": "back",
    # Shoulders
    "Anterior Deltoid": "shoulders",
    "Lateral Deltoid": "shoulders",
    "Posterior Deltoid": "shoulders",
    # Arms
    "Biceps Brachii": "biceps",
    "Brachialis": "biceps",
    "Brachioradialis": "arms",
    "Triceps Brachii": "triceps",
    "Wrist Flexors": "arms",
    "Wrist Extensors": "arms",
    # Legs
    "Vastus Lateralis (Quadriceps)": "legs",
    "Vastus Medialis (Quadriceps)": "legs",
    "Vastus Intermedius (Quadriceps)": "legs",
    "Rectus Femoris (Quadriceps)": "legs",
    "Biceps Femoris (Hamstrings)": "legs",
    "Semitendinosus (Hamstrings)": "legs",
    "Gluteus Maximus": "glutes",
    "Gastrocnemius": "legs",
    "Soleus": "legs",
    "Tibialis Anterior": "legs",
    "Adductor Longus": "legs",
    "Adductor Magnus": "legs",
    "Gracilis": "legs",
    "Pectineus": "legs",
    "Hip Adductors": "legs",
    "Iliopsoas (Hip Flexors)": "legs",
    # Core
    "Rectus Abdominis": "core",
    "Obliques": "core",
    "Transverse Abdominis": "core",
    "Serratus Anterior": "core",
    # Rotator Cuff
    "Infraspinatus (Rotator Cuff)": "shoulders",
    "Teres Minor (Rotator Cuff)": "shoulders",
    "Supraspinatus (Rotator Cuff)": "shoulders",
    "Subscapularis": "shoulders",
    "Levator Scapulae": "shoulders",
    # Short names (identities)
    "chest": "chest",
    "back": "back",
    "shoulders": "shoulders",
    "biceps": "biceps",
    "triceps": "triceps",
    "legs": "legs",
    "glutes": "glutes",
    "core": "core",
    "arms": "arms",
    "traps": "back",
    "forearms": "arms",
    "lower_back": "back",
    "hamstrings": "legs",
    "calves": "legs",
    "quads": "legs",
    "abs": "core",
}


# ═══════════════════════════════════════════════════════════════════════════════
# Helpers
# ═══════════════════════════════════════════════════════════════════════════════

def safe_parse_ids(id_str: Any) -> Set[int]:
    """Safely parse muscle/equipment/body_part ID strings from Lyfta API.

    Handles:
        - None / "null" / "" → empty set
        - "[20]" → {20}
        - "[4, 5, 6]" → {4, 5, 6}
        - malformed → empty set (graceful)
    """
    if id_str is None:
        return set()
    if isinstance(id_str, str):
        cleaned = id_str.strip()
        if cleaned.lower() in ("", "null", "none"):
            return set()
        if cleaned.startswith("[") and cleaned.endswith("]"):
            try:
                import ast
                parsed = ast.literal_eval(cleaned)
                if isinstance(parsed, list):
                    return {int(x) for x in parsed if str(x).isdigit() or (isinstance(x, int) and x > 0)}
            except (ValueError, SyntaxError, TypeError):
                pass
    if isinstance(id_str, (list, tuple)):
        return {int(x) for x in id_str if str(x).isdigit() or (isinstance(x, int) and x > 0)}
    if isinstance(id_str, int) and id_str > 0:
        return {id_str}
    return set()


def resolve_muscles_from_ids(target_ids: Set[int], synergist_ids: Set[int]) -> dict[str, list[str]]:
    """Resolve muscle IDs to Shnuk-compatible muscle group dict."""
    primary = [MUSCLE_ID_MAP.get(m_id, f"Muscle_{m_id}") for m_id in sorted(target_ids)]
    secondary = [MUSCLE_ID_MAP.get(m_id, f"Muscle_{m_id}") for m_id in sorted(synergist_ids)]
    return {"primary": primary, "secondary": secondary}


def resolve_zone_groups(muscle_names: list[str]) -> Set[str]:
    """Map Lyfta muscle names to Shnuk muscle zone group IDs."""
    groups: Set[str] = set()
    for name in muscle_names:
        group = MUSCLE_TO_ZONE_GROUP.get(name)
        if group:
            groups.add(group)
    return groups
