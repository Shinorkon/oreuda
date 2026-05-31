from fastapi import APIRouter, Depends, HTTPException, status, Form, Request
from sqlalchemy.orm import Session
from app.database import get_db
from app import models, schemas, crud
from app.auth import create_access_token, verify_password, get_current_active_user
from slowapi import Limiter
from slowapi.util import get_remote_address

router = APIRouter(prefix="/users", tags=["users"])
limiter = Limiter(key_func=get_remote_address)


@router.post("/register", response_model=schemas.UserOut)
@limiter.limit("5/minute")
def register(request: Request, user: schemas.UserCreate, db: Session = Depends(get_db)):
    if crud.get_user_by_email(db, user.email):
        raise HTTPException(status_code=400, detail="Email already registered")
    if crud.get_user_by_username(db, user.username):
        raise HTTPException(status_code=400, detail="Username already taken")
    return crud.create_user(db, user)


@router.post("/login", response_model=schemas.Token)
@limiter.limit("10/minute")
def login(request: Request, credentials: schemas.UserLogin, db: Session = Depends(get_db)):
    user = crud.get_user_by_username(db, credentials.username)
    if not user or not verify_password(credentials.password, user.hashed_password):
        raise HTTPException(status_code=401, detail="Invalid credentials")
    token = create_access_token(data={"sub": user.username})
    return {"access_token": token, "token_type": "bearer"}


# OAuth2-compatible endpoints for Flutter frontend
@router.post("/auth/token", response_model=schemas.Token)
@limiter.limit("10/minute")
def auth_token(
    request: Request,
    username: str = Form(...),
    password: str = Form(...),
    db: Session = Depends(get_db),
):
    """OAuth2 password flow endpoint for mobile clients."""
    user = crud.get_user_by_username(db, username)
    if not user or not verify_password(password, user.hashed_password):
        raise HTTPException(status_code=401, detail="Invalid credentials")
    token = create_access_token(data={"sub": user.username})
    return {"access_token": token, "token_type": "bearer"}


@router.post("/auth/register", response_model=schemas.UserOut)
@limiter.limit("5/minute")
def auth_register(request: Request, user: schemas.UserCreate, db: Session = Depends(get_db)):
    """Registration endpoint matching frontend's /auth/register path."""
    if crud.get_user_by_email(db, user.email):
        raise HTTPException(status_code=400, detail="Email already registered")
    if crud.get_user_by_username(db, user.username):
        raise HTTPException(status_code=400, detail="Username already taken")
    return crud.create_user(db, user)


@router.get("/me", response_model=schemas.FullProfile)
def get_me(current_user: models.User = Depends(get_current_active_user), db: Session = Depends(get_db)):
    stats = crud.get_player_stats(db, current_user.id)
    active_quests = crud.get_user_quests(db, current_user.id, status="active")
    titles = crud.get_user_titles(db, current_user.id)
    inventory_count = len(current_user.inventory)
    guild_id = None
    if current_user.guild_memberships:
        guild_id = current_user.guild_memberships[0].guild_id

    return {
        "user": current_user,
        "stats": stats,
        "active_quests": active_quests,
        "titles": titles,
        "inventory_count": inventory_count,
        "guild_id": guild_id,
    }


@router.put("/me", response_model=schemas.UserOut)
def update_me(updates: schemas.UserUpdate, current_user: models.User = Depends(get_current_active_user), db: Session = Depends(get_db)):
    return crud.update_user(db, current_user, updates)


@router.post("/me/allocate-stats", response_model=schemas.PlayerStatsOut)
def allocate_stats(allocation: schemas.StatAllocate, current_user: models.User = Depends(get_current_active_user), db: Session = Depends(get_db)):
    try:
        return crud.allocate_stats(db, current_user, allocation)
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))
