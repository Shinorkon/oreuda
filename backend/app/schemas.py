import re
from pydantic import BaseModel, EmailStr, Field, field_validator
from typing import Optional, List, Dict, Any
from datetime import datetime


# ─── User Schemas ───
class UserBase(BaseModel):
    email: EmailStr
    username: str
    display_name: Optional[str] = "Hunter"


class UserCreate(UserBase):
    password: str = Field(..., min_length=8, max_length=128)

    @field_validator("password")
    @classmethod
    def password_strength(cls, v: str) -> str:
        if not re.search(r"[A-Z]", v):
            raise ValueError("Password must contain at least one uppercase letter")
        if not re.search(r"[a-z]", v):
            raise ValueError("Password must contain at least one lowercase letter")
        if not re.search(r"[0-9]", v):
            raise ValueError("Password must contain at least one digit")
        return v


class UserLogin(BaseModel):
    username: str
    password: str


class UserUpdate(BaseModel):
    display_name: Optional[str] = None
    email: Optional[EmailStr] = None


class UserOut(BaseModel):
    id: int
    email: str
    username: str
    display_name: str
    level: int
    xp: int
    rank: str
    gold: int
    essence: int
    streak_days: int
    best_streak: int
    created_at: datetime

    class Config:
        from_attributes = True


# ─── Stats Schemas ───
class PlayerStatsBase(BaseModel):
    str_stat: int = 10
    agi_stat: int = 10
    vit_stat: int = 10
    int_stat: int = 10
    sen_stat: int = 10
    distributable_points: int = 5
    hp: int = 100
    energy: int = 100
    focus_stat: int = 10


class PlayerStatsOut(PlayerStatsBase):
    id: int
    user_id: int

    class Config:
        from_attributes = True


class StatAllocate(BaseModel):
    str_points: int = 0
    agi_points: int = 0
    vit_points: int = 0
    int_points: int = 0
    sen_points: int = 0


# ─── Quest Schemas ───
class QuestBase(BaseModel):
    title: str
    description: Optional[str] = ""
    quest_type: str = "daily"
    difficulty: str = "E"
    xp_reward: int = 0
    gold_reward: int = 0
    stat_rewards: Optional[Dict[str, Any]] = None
    category: Optional[str] = "Physical"
    deadline: Optional[datetime] = None


class QuestCreate(QuestBase):
    pass


class QuestUpdate(BaseModel):
    status: Optional[str] = None
    completed_at: Optional[datetime] = None


class QuestOut(QuestBase):
    id: int
    user_id: int
    status: str
    created_at: datetime
    completed_at: Optional[datetime] = None
    chain_day: Optional[int] = None
    chain_total_days: Optional[int] = None
    dungeon_floor: Optional[int] = None
    # Dynamic quest fields
    target_value: Optional[int] = None
    current_value: int = 0
    metric_type: Optional[str] = None

    class Config:
        from_attributes = True


class QuestCompleteResponse(BaseModel):
    quest_id: int
    xp_earned: int
    gold_earned: int
    leveled_up: bool
    new_level: Optional[int] = None
    message: str


# ─── Inventory Schemas ───
class InventoryItemBase(BaseModel):
    item_name: str
    item_type: str = "consumable"
    rarity: str = "common"
    quantity: int = 1
    equipped: bool = False
    stat_bonuses: Optional[Dict[str, Any]] = None
    description: Optional[str] = ""


class InventoryItemOut(InventoryItemBase):
    id: int
    user_id: int

    class Config:
        from_attributes = True


class LootBoxOpen(BaseModel):
    box_type: str  # blessed or cursed


class LootBoxResult(BaseModel):
    item_name: str
    rarity: str
    description: str
    stat_bonuses: Dict[str, Any]


# ─── Title Schemas ───
class TitleBase(BaseModel):
    title_name: str
    title_key: str
    description: Optional[str] = ""
    buff_effect: Optional[str] = ""
    rarity: str = "common"
    equipped: bool = False


class TitleOut(TitleBase):
    id: int
    user_id: int
    unlocked_at: datetime

    class Config:
        from_attributes = True


# ─── Guild Schemas ───
class GuildBase(BaseModel):
    name: str
    description: Optional[str] = ""


class GuildCreate(GuildBase):
    pass


class GuildOut(GuildBase):
    id: int
    max_members: int
    created_at: datetime
    created_by: int
    member_count: int = 0

    class Config:
        from_attributes = True


class GuildMemberOut(BaseModel):
    id: int
    guild_id: int
    user_id: int
    joined_at: datetime
    role: str
    username: str
    level: int

    class Config:
        from_attributes = True


# ─── Dungeon Schemas ───
class DungeonRunBase(BaseModel):
    dungeon_name: str
    dungeon_type: str = "normal"
    total_days: int = 30


class DungeonRunOut(DungeonRunBase):
    id: int
    user_id: int
    current_day: int
    status: str
    started_at: datetime
    completed_at: Optional[datetime] = None

    class Config:
        from_attributes = True


# ─── Store Schemas ───
class StoreItemOut(BaseModel):
    id: int
    name: str
    description: str
    item_type: str
    rarity: str
    gold_cost: int
    essence_cost: int
    stat_bonuses: Optional[Dict[str, Any]] = None
    effect: Optional[str] = None
    stock: Optional[int] = None

    class Config:
        from_attributes = True


class PurchaseResponse(BaseModel):
    success: bool
    item_name: str
    gold_spent: int
    essence_spent: int
    remaining_gold: int
    remaining_essence: int
    message: str


# ─── Screentime Schemas ───
class ScreentimeSettingBase(BaseModel):
    daily_limit_minutes: int = 300
    category_limits: Optional[Dict[str, Any]] = None
    app_limits: Optional[Dict[str, Any]] = None
    morning_protocol_time: Optional[str] = "08:00"
    evening_protocol_time: Optional[str] = "22:00"
    focus_session_active: bool = False
    focus_session_duration: int = 120


class ScreentimeSettingOut(ScreentimeSettingBase):
    id: int
    user_id: int

    class Config:
        from_attributes = True


# ─── Leaderboard Schemas ───
class StreakInfo(BaseModel):
    streak_days: int
    best_streak: int


class LeaderboardEntry(BaseModel):
    rank: int
    username: str
    level: int
    xp: int
    rank_title: str


# ─── Auth Schemas ───
class Token(BaseModel):
    access_token: str
    token_type: str = "bearer"


class TokenData(BaseModel):
    username: Optional[str] = None


# ─── Full Profile ───
class FullProfile(BaseModel):
    user: UserOut
    stats: PlayerStatsOut
    active_quests: List[QuestOut]
    titles: List[TitleOut]
    inventory_count: int
    guild_id: Optional[int] = None


class UserProfile(UserOut):
    stats: Optional[PlayerStatsOut] = None

    class Config:
        from_attributes = True
