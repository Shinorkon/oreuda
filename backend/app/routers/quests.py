from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import Optional, List
from app.database import get_db
from app import models, schemas, crud
from app.auth import get_current_active_user

router = APIRouter(prefix="/quests", tags=["quests"])


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
    return crud.generate_daily_quests(db, current_user)


@router.post("/generate-daily", response_model=List[schemas.QuestOut])
def generate_daily(current_user: models.User = Depends(get_current_active_user), db: Session = Depends(get_db)):
    return crud.generate_daily_quests(db, current_user)


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
