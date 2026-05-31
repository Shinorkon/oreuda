from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List
from app.database import get_db
from app import models, schemas, crud
from app.auth import get_current_active_user

router = APIRouter(prefix="/store", tags=["store"])


@router.get("/items", response_model=List[schemas.StoreItemOut])
def list_items(db: Session = Depends(get_db)):
    crud.seed_store_items(db)
    return crud.get_store_items(db)


@router.post("/buy/{item_id}", response_model=schemas.PurchaseResponse)
def buy_item(item_id: int, current_user: models.User = Depends(get_current_active_user), db: Session = Depends(get_db)):
    crud.seed_store_items(db)
    store_item = crud.get_store_item(db, item_id)
    if not store_item:
        raise HTTPException(status_code=404, detail="Item not found")
    try:
        result = crud.purchase_item(db, current_user, store_item)
        return schemas.PurchaseResponse(**result)
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))
