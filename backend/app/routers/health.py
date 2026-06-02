"""
Health data router for OREUDA.
Receives daily health snapshots from the frontend (Health Connect)
and provides aggregated stats/trends.
"""
from datetime import date, timedelta
from typing import List, Optional

from fastapi import APIRouter, Depends, HTTPException
from pydantic import model_validator
from sqlalchemy.orm import Session

from app.database import get_db
from app import models, schemas
from app.auth import get_current_active_user

router = APIRouter(prefix="/health", tags=["health"])


# ─── Pydantic schemas (inline to avoid circular imports) ───

class HealthSnapshotIn(schemas.BaseModel):
    date: date
    steps: int = 0
    calories_burned: int = 0
    sleep_minutes: int = 0
    resting_hr: Optional[int] = None
    workouts_count: int = 0
    workout_volume_kg: float = 0.0
    weight_kg: Optional[float] = None

    @model_validator(mode='after')
    def validate_health_data(self):
        if self.steps < 0:
            raise ValueError('steps cannot be negative')
        if self.calories_burned < 0:
            raise ValueError('calories_burned cannot be negative')
        if self.sleep_minutes < 0:
            raise ValueError('sleep_minutes cannot be negative')
        if self.workouts_count < 0:
            raise ValueError('workouts_count cannot be negative')
        if self.workout_volume_kg < 0:
            raise ValueError('workout_volume_kg cannot be negative')
        if self.resting_hr is not None and (self.resting_hr < 30 or self.resting_hr > 220):
            raise ValueError('resting_hr must be between 30 and 220')
        if self.weight_kg is not None and (self.weight_kg < 20 or self.weight_kg > 300):
            raise ValueError('weight_kg must be between 20 and 300')
        if self.date > date.today():
            raise ValueError('date cannot be in the future')
        return self


class HealthSnapshotOut(schemas.BaseModel):
    id: int
    user_id: int
    date: date
    steps: int
    calories_burned: int
    sleep_minutes: int
    resting_hr: Optional[int]
    workouts_count: int
    workout_volume_kg: float
    weight_kg: Optional[float]

    class Config:
        from_attributes = True


class HealthTrendOut(schemas.BaseModel):
    date: date
    steps: int
    calories_burned: int
    sleep_minutes: int
    workouts_count: int


class StatCalculationOut(schemas.BaseModel):
    str_stat: int
    agi_stat: int
    vit_stat: int
    int_stat: int
    sen_stat: int
    breakdown: dict


# ─── Helpers ───

def _calculate_stats_from_snapshot(snap: models.HealthSnapshot) -> dict:
    """Convert health snapshot to RPG stats."""
    base = 10
    max_stat = 100

    # STR: workouts + calories
    str_bonus = (snap.workouts_count * 3) + min(snap.calories_burned // 100, 20)
    str_stat = min(base + str_bonus, max_stat)

    # AGI: steps
    agi_bonus = snap.steps // 1000
    agi_stat = min(base + agi_bonus, max_stat)

    # VIT: calories + resting HR
    vit_cal_bonus = snap.calories_burned // 50
    vit_hr_bonus = (80 - snap.resting_hr) if snap.resting_hr and snap.resting_hr > 0 else 0
    vit_stat = min(base + vit_cal_bonus + vit_hr_bonus, max_stat)

    # INT: sleep
    sleep_hours = snap.sleep_minutes / 60
    int_bonus = int(sleep_hours * 2)
    int_stat = min(base + int_bonus, max_stat)

    # SEN: weight tracking awareness
    sen_bonus = 5 if snap.weight_kg else 0
    sen_bonus += snap.workouts_count * 2
    sen_stat = min(base + sen_bonus, max_stat)

    return {
        "str_stat": str_stat,
        "agi_stat": agi_stat,
        "vit_stat": vit_stat,
        "int_stat": int_stat,
        "sen_stat": sen_stat,
        "breakdown": {
            "str": f"{snap.workouts_count} workouts, {snap.calories_burned} cal",
            "agi": f"{snap.steps:,} steps",
            "vit": f"{snap.calories_burned} cal, RHR {snap.resting_hr or '--'}",
            "int": f"{sleep_hours:.1f}h sleep",
            "sen": f"Weight: {'tracked' if snap.weight_kg else 'not tracked'}",
        },
    }


# ─── Endpoints ───

@router.post("/sync", response_model=HealthSnapshotOut)
def sync_health(
    data: HealthSnapshotIn,
    current_user: models.User = Depends(get_current_active_user),
    db: Session = Depends(get_db),
):
    """Store or update a daily health snapshot."""
    existing = (
        db.query(models.HealthSnapshot)
        .filter(
            models.HealthSnapshot.user_id == current_user.id,
            models.HealthSnapshot.date == data.date,
        )
        .first()
    )

    if existing:
        existing.steps = data.steps
        existing.calories_burned = data.calories_burned
        existing.sleep_minutes = data.sleep_minutes
        existing.resting_hr = data.resting_hr
        existing.workouts_count = data.workouts_count
        existing.workout_volume_kg = data.workout_volume_kg
        existing.weight_kg = data.weight_kg
        db.commit()
        db.refresh(existing)
        return existing
    else:
        snapshot = models.HealthSnapshot(
            user_id=current_user.id,
            date=data.date,
            steps=data.steps,
            calories_burned=data.calories_burned,
            sleep_minutes=data.sleep_minutes,
            resting_hr=data.resting_hr,
            workouts_count=data.workouts_count,
            workout_volume_kg=data.workout_volume_kg,
            weight_kg=data.weight_kg,
        )
        db.add(snapshot)
        db.commit()
        db.refresh(snapshot)
        return snapshot


@router.get("/today", response_model=HealthSnapshotOut)
def get_today(
    current_user: models.User = Depends(get_current_active_user),
    db: Session = Depends(get_db),
):
    """Get today's health snapshot."""
    today = date.today()
    snapshot = (
        db.query(models.HealthSnapshot)
        .filter(
            models.HealthSnapshot.user_id == current_user.id,
            models.HealthSnapshot.date == today,
        )
        .first()
    )
    if not snapshot:
        raise HTTPException(status_code=404, detail="No health data for today")
    return snapshot


@router.get("/trend", response_model=List[HealthTrendOut])
def get_trend(
    days: int = 7,
    current_user: models.User = Depends(get_current_active_user),
    db: Session = Depends(get_db),
):
    """Get health trend for the last N days."""
    end = date.today()
    start = end - timedelta(days=days - 1)

    snapshots = (
        db.query(models.HealthSnapshot)
        .filter(
            models.HealthSnapshot.user_id == current_user.id,
            models.HealthSnapshot.date >= start,
            models.HealthSnapshot.date <= end,
        )
        .order_by(models.HealthSnapshot.date.asc())
        .all()
    )

    return [
        HealthTrendOut(
            date=s.date,
            steps=s.steps,
            calories_burned=s.calories_burned,
            sleep_minutes=s.sleep_minutes,
            workouts_count=s.workouts_count,
        )
        for s in snapshots
    ]


@router.get("/stats", response_model=StatCalculationOut)
def get_calculated_stats(
    current_user: models.User = Depends(get_current_active_user),
    db: Session = Depends(get_db),
):
    """Get RPG stats calculated from today's health data."""
    today = date.today()
    snapshot = (
        db.query(models.HealthSnapshot)
        .filter(
            models.HealthSnapshot.user_id == current_user.id,
            models.HealthSnapshot.date == today,
        )
        .first()
    )

    if not snapshot:
        # Return base stats if no health data
        return StatCalculationOut(
            str_stat=10,
            agi_stat=10,
            vit_stat=10,
            int_stat=10,
            sen_stat=10,
            breakdown={
                "str": "No health data — connect Health Connect",
                "agi": "No health data — connect Health Connect",
                "vit": "No health data — connect Health Connect",
                "int": "No health data — connect Health Connect",
                "sen": "No health data — connect Health Connect",
            },
        )

    stats = _calculate_stats_from_snapshot(snapshot)
    return StatCalculationOut(**stats)
