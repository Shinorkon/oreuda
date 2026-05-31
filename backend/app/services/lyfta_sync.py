"""
Simplified Lyfta Sync Service for OREUDA.

Validates Lyfta API keys and fetches basic workout data.
Full workout import with sets/reps/weight is available in Shnuk.
"""
import logging
from typing import Dict, Any

import httpx

logger = logging.getLogger(__name__)


class LyftaSyncService:
    BASE_URL = "https://my.lyfta.app"
    REQUEST_TIMEOUT = 30.0

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
            return {"valid": False, "error": f"Cannot reach Lyfta API. Check your connection. ({type(e).__name__})"}

    @classmethod
    def fetch_workouts(cls, api_key: str, page: int = 1, limit: int = 50) -> Dict[str, Any]:
        """Call GET /api/v1/workouts with pagination."""
        try:
            with httpx.Client(timeout=cls.REQUEST_TIMEOUT) as client:
                response = client.get(
                    f"{cls.BASE_URL}/api/v1/workouts",
                    headers=cls._headers(api_key),
                    params={"page": page, "limit": limit},
                )
            response.raise_for_status()
            return response.json()
        except httpx.HTTPStatusError as e:
            logger.error("Lyfta API returned error: %s", e)
            raise
        except httpx.RequestError as e:
            logger.error("Lyfta API request failed: %s", e)
            raise
