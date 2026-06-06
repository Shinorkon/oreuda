from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List
from app.database import get_db
from app import models, schemas, crud
from app.auth import get_current_active_user

router = APIRouter(prefix="/titles", tags=["titles"])


@router.get("", response_model=List[schemas.TitleOut])
def list_titles(current_user: models.User = Depends(get_current_active_user), db: Session = Depends(get_db)):
    return crud.get_user_titles(db, current_user.id)


@router.post("/{title_id}/equip")
def equip_title(title_id: int, current_user: models.User = Depends(get_current_active_user), db: Session = Depends(get_db)):
    title = db.query(models.Title).filter(
        models.Title.id == title_id,
        models.Title.user_id == current_user.id,
    ).first()
    if not title:
        raise HTTPException(status_code=404, detail="Title not found")

    # Unequip any currently equipped title
    db.query(models.Title).filter(
        models.Title.user_id == current_user.id,
        models.Title.equipped == True,
    ).update({"equipped": False})

    title.equipped = True
    db.commit()
    db.refresh(title)
    return {"message": f"Equipped: {title.title_name}", "title_id": title.id}


@router.post("/{title_id}/unequip")
def unequip_title(title_id: int, current_user: models.User = Depends(get_current_active_user), db: Session = Depends(get_db)):
    title = db.query(models.Title).filter(
        models.Title.id == title_id,
        models.Title.user_id == current_user.id,
    ).first()
    if not title:
        raise HTTPException(status_code=404, detail="Title not found")

    title.equipped = False
    db.commit()
    db.refresh(title)
    return {"message": f"Unequipped: {title.title_name}", "title_id": title.id}
