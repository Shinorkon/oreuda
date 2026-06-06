import datetime
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List
from app.database import get_db
from app import models, schemas, crud
from app.auth import get_current_active_user

router = APIRouter(prefix="/stats", tags=["stats"])


@router.get("", response_model=schemas.PlayerStatsOut)
def get_stats(current_user: models.User = Depends(get_current_active_user), db: Session = Depends(get_db)):
    stats = crud.get_player_stats(db, current_user.id)
    if not stats:
        raise HTTPException(status_code=404, detail="Stats not found")
    return stats


@router.post("/decay")
def apply_decay(current_user: models.User = Depends(get_current_active_user), db: Session = Depends(get_db)):
    today = datetime.date.today()
    if current_user.last_decay_date == today:
        raise HTTPException(status_code=429, detail="Stat decay already applied today. Try again tomorrow.")
    decayed = crud.apply_stat_decay(db, current_user)
    return {
        "message": "Stat decay applied.",
        "decayed_stats": decayed,
        "new_rank": current_user.rank,
    }


@router.get("/leaderboard", response_model=List[schemas.LeaderboardEntry])
def get_leaderboard(limit: int = 50, db: Session = Depends(get_db)):
    return crud.get_leaderboard(db, limit)
