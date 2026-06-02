from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session, joinedload
from typing import List
from app.database import get_db
from app import models, schemas, crud
from app.auth import get_current_active_user
from app.sanitization import sanitize_guild_input

router = APIRouter(prefix="/guilds", tags=["guilds"])


@router.get("/", response_model=List[schemas.GuildOut])
def list_guilds(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    # Eager-load members to avoid N+1
    guilds = db.query(models.Guild).options(joinedload(models.Guild.members)).offset(skip).limit(limit).all()
    result = []
    for g in guilds:
        member_count = len(g.members)
        guild_out = schemas.GuildOut.model_validate(g)
        guild_out.member_count = member_count
        result.append(guild_out)
    return result


@router.post("/", response_model=schemas.GuildOut)
def create_guild(guild: schemas.GuildCreate, current_user: models.User = Depends(get_current_active_user), db: Session = Depends(get_db)):
    guild.name, guild.description = sanitize_guild_input(guild.name, guild.description)
    if len(guild.name) < 2 or len(guild.name) > 50:
        raise HTTPException(status_code=400, detail="Guild name must be 2–50 characters")
    if crud.get_guild_by_name(db, guild.name):
        raise HTTPException(status_code=400, detail="Guild name already taken")
    return crud.create_guild(db, guild, current_user.id)


@router.post("/{guild_id}/join")
def join_guild(guild_id: int, current_user: models.User = Depends(get_current_active_user), db: Session = Depends(get_db)):
    guild = crud.get_guild(db, guild_id)
    if not guild:
        raise HTTPException(status_code=404, detail="Guild not found")
    try:
        member = crud.join_guild(db, guild_id, current_user.id)
        return {"message": f"Joined {guild.name}", "guild_id": guild_id}
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))


@router.get("/{guild_id}/members", response_model=List[schemas.GuildMemberOut])
def get_members(guild_id: int, db: Session = Depends(get_db)):
    # Eager-load user to avoid N+1
    members = (
        db.query(models.GuildMember)
        .options(joinedload(models.GuildMember.user))
        .filter(models.GuildMember.guild_id == guild_id)
        .all()
    )
    result = []
    for m in members:
        result.append({
            "id": m.id,
            "guild_id": m.guild_id,
            "user_id": m.user_id,
            "username": m.user.username,
            "role": m.role,
            "joined_at": m.joined_at,
            "level": m.user.level,
        })
    return result


@router.get("/{guild_id}/leaderboard")
def guild_leaderboard(guild_id: int, db: Session = Depends(get_db)):
    # Eager-load user to avoid N+1
    members = (
        db.query(models.GuildMember)
        .options(joinedload(models.GuildMember.user))
        .filter(models.GuildMember.guild_id == guild_id)
        .all()
    )
    result = []
    for m in sorted(members, key=lambda x: (x.user.level, x.user.xp), reverse=True):
        result.append({
            "username": m.user.username,
            "display_name": m.user.display_name,
            "level": m.user.level,
            "xp": m.user.xp,
            "rank": m.user.rank,
            "role": m.role,
        })
    return result
