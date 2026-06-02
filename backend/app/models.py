import datetime
from sqlalchemy import Column, Integer, String, Float, Boolean, DateTime, ForeignKey, Text, JSON, Date, UniqueConstraint
from sqlalchemy.orm import relationship
from app.database import Base


class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    email = Column(String, unique=True, index=True, nullable=False)
    username = Column(String, unique=True, index=True, nullable=False)
    hashed_password = Column(String, nullable=False)
    display_name = Column(String, default="Hunter")
    level = Column(Integer, default=1)
    xp = Column(Integer, default=0)
    rank = Column(String, default="E")
    gold = Column(Integer, default=0)
    essence = Column(Integer, default=0)
    streak_days = Column(Integer, default=0)
    best_streak = Column(Integer, default=0)
    last_quest_date = Column(DateTime, nullable=True)
    last_decay_date = Column(Date, nullable=True)
    created_at = Column(DateTime, default=datetime.datetime.utcnow)
    is_active = Column(Boolean, default=True)

    stats = relationship("PlayerStats", back_populates="user", uselist=False)
    quests = relationship("Quest", back_populates="user")
    inventory = relationship("InventoryItem", back_populates="user")
    titles = relationship("Title", back_populates="user")
    guild_memberships = relationship("GuildMember", back_populates="user")
    dungeon_runs = relationship("DungeonRun", back_populates="user")
    screentime_settings = relationship("ScreentimeSetting", back_populates="user", uselist=False)
    health_snapshots = relationship("HealthSnapshot", back_populates="user", order_by="HealthSnapshot.date.desc()")
    lyfta_integration = relationship("LyftaIntegration", back_populates="user", uselist=False)


class PlayerStats(Base):
    __tablename__ = "player_stats"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"), unique=True)
    str_stat = Column(Integer, default=10)
    agi_stat = Column(Integer, default=10)
    vit_stat = Column(Integer, default=10)
    int_stat = Column(Integer, default=10)
    sen_stat = Column(Integer, default=10)
    distributable_points = Column(Integer, default=5)
    hp = Column(Integer, default=100)
    energy = Column(Integer, default=100)
    focus_stat = Column(Integer, default=10)

    user = relationship("User", back_populates="stats")


class Quest(Base):
    __tablename__ = "quests"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"))
    title = Column(String, nullable=False)
    description = Column(Text, default="")
    quest_type = Column(String, default="daily")  # daily/weekly/chain/dungeon/main/side/urgent/custom/redemption
    difficulty = Column(String, default="E")  # E/D/C/B/A/S
    status = Column(String, default="pending")  # pending/active/completed/failed
    xp_reward = Column(Integer, default=0)
    gold_reward = Column(Integer, default=0)
    stat_rewards = Column(JSON, default=dict)  # {"str": 1, "vit": 0.5}
    category = Column(String, default="Physical")  # Physical/Mental/Intellectual/Career/Financial/Relationships/etc
    deadline = Column(DateTime, nullable=True)
    created_at = Column(DateTime, default=datetime.datetime.utcnow)
    completed_at = Column(DateTime, nullable=True)
    chain_day = Column(Integer, nullable=True)
    chain_total_days = Column(Integer, nullable=True)
    dungeon_floor = Column(Integer, nullable=True)
    # Dynamic quest fields
    target_value = Column(Integer, nullable=True)  # e.g., 10000 steps
    current_value = Column(Integer, default=0)  # e.g., 7234 steps
    metric_type = Column(String, nullable=True)  # steps/calories/sleep/workouts/weight

    user = relationship("User", back_populates="quests")


class QuestCompletion(Base):
    __tablename__ = "quest_completions"

    id = Column(Integer, primary_key=True, index=True)
    quest_id = Column(Integer, ForeignKey("quests.id", ondelete="CASCADE"))
    user_id = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"))
    completed_at = Column(DateTime, default=datetime.datetime.utcnow)
    verification_method = Column(String, default="manual")
    xp_earned = Column(Integer, default=0)
    gold_earned = Column(Integer, default=0)


class InventoryItem(Base):
    __tablename__ = "inventory_items"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"))
    item_name = Column(String, nullable=False)
    item_type = Column(String, default="consumable")  # consumable/equipment/material/lootbox/questitem
    rarity = Column(String, default="common")  # common/uncommon/rare/epic/legendary
    quantity = Column(Integer, default=1)
    equipped = Column(Boolean, default=False)
    stat_bonuses = Column(JSON, default=dict)
    description = Column(Text, default="")

    user = relationship("User", back_populates="inventory")


class Title(Base):
    __tablename__ = "titles"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"))
    title_name = Column(String, nullable=False)
    title_key = Column(String, nullable=False)
    description = Column(Text, default="")
    buff_effect = Column(String, default="")
    rarity = Column(String, default="common")
    unlocked_at = Column(DateTime, default=datetime.datetime.utcnow)
    equipped = Column(Boolean, default=False)

    user = relationship("User", back_populates="titles")


class Guild(Base):
    __tablename__ = "guilds"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, unique=True, nullable=False)
    description = Column(Text, default="")
    max_members = Column(Integer, default=10)
    created_at = Column(DateTime, default=datetime.datetime.utcnow)
    created_by = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"))

    members = relationship("GuildMember", back_populates="guild")


class GuildMember(Base):
    __tablename__ = "guild_members"

    id = Column(Integer, primary_key=True, index=True)
    guild_id = Column(Integer, ForeignKey("guilds.id", ondelete="CASCADE"))
    user_id = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"))
    joined_at = Column(DateTime, default=datetime.datetime.utcnow)
    role = Column(String, default="member")  # leader/officer/member

    guild = relationship("Guild", back_populates="members")
    user = relationship("User", back_populates="guild_memberships")


class DungeonRun(Base):
    __tablename__ = "dungeon_runs"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"))
    dungeon_name = Column(String, nullable=False)
    dungeon_type = Column(String, default="normal")  # normal/red/double/instant/demon_castle
    total_days = Column(Integer, default=30)
    current_day = Column(Integer, default=1)
    status = Column(String, default="active")  # active/completed/abandoned
    started_at = Column(DateTime, default=datetime.datetime.utcnow)
    completed_at = Column(DateTime, nullable=True)

    user = relationship("User", back_populates="dungeon_runs")


class ScreentimeSetting(Base):
    __tablename__ = "screentime_settings"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"), unique=True)
    daily_limit_minutes = Column(Integer, default=300)
    category_limits = Column(JSON, default=dict)
    app_limits = Column(JSON, default=dict)
    morning_protocol_time = Column(String, default="08:00")
    evening_protocol_time = Column(String, default="22:00")
    focus_session_active = Column(Boolean, default=False)
    focus_session_duration = Column(Integer, default=120)

    user = relationship("User", back_populates="screentime_settings")


class StoreItem(Base):
    __tablename__ = "store_items"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, nullable=False)
    description = Column(Text, default="")
    item_type = Column(String, default="consumable")
    rarity = Column(String, default="common")
    gold_cost = Column(Integer, default=0)
    essence_cost = Column(Integer, default=0)
    stat_bonuses = Column(JSON, default=dict)
    effect = Column(String, default="")
    stock = Column(Integer, nullable=True)


# ═══════════════════════════════════════════════════════════════════════════════
# NEW: Health & Lyfta Integration Models
# ═══════════════════════════════════════════════════════════════════════════════

class HealthSnapshot(Base):
    """Daily aggregated health data from Health Connect."""
    __tablename__ = "health_snapshots"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"), nullable=False, index=True)
    date = Column(Date, nullable=False, index=True)
    steps = Column(Integer, default=0)
    calories_burned = Column(Integer, default=0)
    sleep_minutes = Column(Integer, default=0)
    resting_hr = Column(Integer, nullable=True)
    workouts_count = Column(Integer, default=0)
    workout_volume_kg = Column(Float, default=0.0)
    weight_kg = Column(Float, nullable=True)
    created_at = Column(DateTime, default=datetime.datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.datetime.utcnow, onupdate=datetime.datetime.utcnow)

    user = relationship("User", back_populates="health_snapshots")

    __table_args__ = (
        # One snapshot per user per day
        UniqueConstraint("user_id", "date", name="uq_health_snapshot_user_date"),
    )


class LyftaIntegration(Base):
    """Lyfta gym workout tracker integration."""
    __tablename__ = "lyfta_integrations"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"), unique=True, nullable=False)
    api_key_hash = Column(String(255), nullable=False)  # encrypted API key
    is_active = Column(Boolean, default=True)
    last_sync_at = Column(DateTime, nullable=True)
    workouts_imported = Column(Integer, default=0)
    exercises_imported = Column(Integer, default=0)
    created_at = Column(DateTime, default=datetime.datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.datetime.utcnow, onupdate=datetime.datetime.utcnow)

    user = relationship("User", back_populates="lyfta_integration")
