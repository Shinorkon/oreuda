from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List
from app.database import get_db
from app import models, schemas, crud
from app.auth import get_current_active_user

router = APIRouter(prefix="/guilds", tags=["guilds"])


@router.get("/", response_model=List[schemas.GuildOut])
def list_guilds(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    guilds = crud.get_guilds(db, skip, limit)
    result = []
    for g in guilds:
        member_count = len(g.members)
        guild_out = schemas.GuildOut.from_orm(g)
        guild_out.member_count = member_count
        result.append(guild_out)
    return result


@router.post("/", response_model=schemas.GuildOut)
def create_guild(guild: schemas.GuildCreate, current_user: models.User = Depends(get_current_active_user), db: Session = Depends(get_db)):
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
    members = crud.get_guild_members(db, guild_id)
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
    members = crud.get_guild_members(db, guild_id)
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
