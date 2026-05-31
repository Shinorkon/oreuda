from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import Optional, List
from app.database import get_db
from app import models, schemas, crud
from app.auth import get_current_active_user
from app.quest_engine import QuestEngine
from slowapi import Limiter
from slowapi.util import get_remote_address

router = APIRouter(prefix="/quests", tags=["quests"])
limiter = Limiter(key_func=get_remote_address)


@router.get("/", response_model=List[schemas.QuestOut])
def list_quests(
    quest_type: Optional[str] = None,
    status: Optional[str] = None,
    current_user: models.User = Depends(get_current_active_user),
    db: Session = Depends(get_db),
):
    return crud.get_user_quests(db, current_user.id, quest_type, status)


@router.post("/", response_model=schemas.QuestOut)
def create_quest(quest: schemas.QuestCreate, current_user: models.User = Depends(get_current_active_user), db: Session = Depends(get_db)):
    return crud.create_quest(db, current_user.id, quest)


@router.get("/daily", response_model=List[schemas.QuestOut])
def get_daily_quests(current_user: models.User = Depends(get_current_active_user), db: Session = Depends(get_db)):
    """Get or generate today's daily quests."""
    # First, check for quest completions based on health data
    QuestEngine.check_quest_completion(db, current_user)
    # Then get or create daily quests
    return QuestEngine.get_or_create_daily_quests(db, current_user)


@router.post("/generate-daily", response_model=List[schemas.QuestOut])
@limiter.limit("3/hour")
def generate_daily(current_user: models.User = Depends(get_current_active_user), db: Session = Depends(get_db)):
    """Force regenerate daily quests (rate limited to 3/hour)."""
    return QuestEngine.generate_daily_quests(db, current_user)


@router.post("/check-completion")
def check_quest_completion(current_user: models.User = Depends(get_current_active_user), db: Session = Depends(get_db)):
    """Check all active quests against health data and auto-complete."""
    completed = QuestEngine.check_quest_completion(db, current_user)
    return {
        "completed_count": len(completed),
        "completed_quests": [
            {
                "id": q.id,
                "title": q.title,
                "xp_reward": q.xp_reward,
                "gold_reward": q.gold_reward,
            }
            for q in completed
        ],
    }


@router.post("/{quest_id}/complete", response_model=schemas.QuestCompleteResponse)
def complete_quest(quest_id: int, current_user: models.User = Depends(get_current_active_user), db: Session = Depends(get_db)):
    quest = crud.get_quest(db, quest_id)
    if not quest or quest.user_id != current_user.id:
        raise HTTPException(status_code=404, detail="Quest not found")
    try:
        result = crud.complete_quest(db, quest, current_user)
        return result
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))


@router.post("/{quest_id}/fail")
def fail_quest(quest_id: int, current_user: models.User = Depends(get_current_active_user), db: Session = Depends(get_db)):
    quest = crud.get_quest(db, quest_id)
    if not quest or quest.user_id != current_user.id:
        raise HTTPException(status_code=404, detail="Quest not found")
    return crud.fail_quest(db, quest, current_user)


@router.get("/streak")
def get_streak(current_user: models.User = Depends(get_current_active_user)):
    return {
        "streak_days": current_user.streak_days,
        "best_streak": current_user.best_streak,
        "last_quest_date": current_user.last_quest_date,
    }
