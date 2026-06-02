from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List
from app.database import get_db
from app import models, schemas, crud
from app.auth import get_current_active_user

router = APIRouter(prefix="/inventory", tags=["inventory"])


@router.get("/", response_model=List[schemas.InventoryItemOut])
def list_inventory(current_user: models.User = Depends(get_current_active_user), db: Session = Depends(get_db)):
    return crud.get_inventory(db, current_user.id)


@router.post("/use/{item_id}")
def use_item(item_id: int, current_user: models.User = Depends(get_current_active_user), db: Session = Depends(get_db)):
    item = crud.get_inventory_item(db, item_id, current_user.id)
    if not item:
        raise HTTPException(status_code=404, detail="Item not found")
    if item.item_type != "consumable":
        raise HTTPException(status_code=400, detail="Item is not consumable")

    item.quantity -= 1
    if item.quantity <= 0:
        db.delete(item)

    # Apply effects
    effects = []
    stats = crud.get_player_stats(db, current_user.id)
    if item.stat_bonuses:
        for stat, val in item.stat_bonuses.items():
            if stat == "all_stats":
                stats.str_stat += val
                stats.agi_stat += val
                stats.vit_stat += val
                stats.int_stat += val
                stats.sen_stat += val
                effects.append(f"All stats +{val}")
            elif stat == "hp_restore":
                stats.hp = min(stats.hp + val, stats.vit_stat * 10)
                effects.append(f"HP restored by {val}")
            elif stat == "energy_restore":
                stats.energy = min(stats.energy + val, int((stats.vit_stat + stats.agi_stat) / 2 * 10))
                effects.append(f"Energy restored by {val}")
            else:
                attr = f"{stat}_stat"
                if hasattr(stats, attr):
                    current = getattr(stats, attr)
                    setattr(stats, attr, current + val)
                    effects.append(f"{stat.upper()} +{val}")

    db.commit()
    return {"message": f"Used {item.item_name}", "effects": effects}


@router.post("/equip/{item_id}")
def equip_item(item_id: int, current_user: models.User = Depends(get_current_active_user), db: Session = Depends(get_db)):
    item = crud.get_inventory_item(db, item_id, current_user.id)
    if not item:
        raise HTTPException(status_code=404, detail="Item not found")
    if item.item_type != "equipment":
        raise HTTPException(status_code=400, detail="Item is not equipment")

    item.equipped = not item.equipped
    db.commit()
    return {"message": f"{'Equipped' if item.equipped else 'Unequipped'} {item.item_name}"}


@router.delete("/{item_id}")
def delete_item(item_id: int, current_user: models.User = Depends(get_current_active_user), db: Session = Depends(get_db)):
    item = crud.get_inventory_item(db, item_id, current_user.id)
    if not item:
        raise HTTPException(status_code=404, detail="Item not found")
    db.delete(item)
    db.commit()
    return {"message": f"Dropped {item.item_name}"}


@router.post("/open-box")
def open_box(box: schemas.LootBoxOpen, current_user: models.User = Depends(get_current_active_user), db: Session = Depends(get_db)):
    try:
        result = crud.open_loot_box(db, current_user, box.box_type)
        return result
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))
