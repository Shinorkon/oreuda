import math
import random
from datetime import datetime, timedelta
from typing import List, Optional
from sqlalchemy.orm import Session
from app import models, schemas
from app.auth import get_password_hash


# ─── XP & Leveling ───
def xp_required_for_level(level: int) -> int:
    return int(100 * (level ** 1.5))


def total_xp_for_level(level: int) -> int:
    return sum(xp_required_for_level(l) for l in range(1, level + 1))


def check_level_up(user: models.User) -> bool:
    needed = xp_required_for_level(user.level + 1)
    return user.xp >= needed


RANK_THRESHOLDS = {
    "E": 1,
    "D": 5,
    "C": 20,
    "B": 30,
    "A": 50,
    "S": 70,
}


def rank_for_level(level: int) -> str:
    current_rank = "E"
    for rank, threshold in sorted(RANK_THRESHOLDS.items(), key=lambda x: x[1]):
        if level >= threshold:
            current_rank = rank
    return current_rank


# ─── Users ───
def get_user_by_username(db: Session, username: str) -> Optional[models.User]:
    return db.query(models.User).filter(models.User.username == username).first()


def get_user_by_email(db: Session, email: str) -> Optional[models.User]:
    return db.query(models.User).filter(models.User.email == email).first()


def get_user(db: Session, user_id: int) -> Optional[models.User]:
    return db.query(models.User).filter(models.User.id == user_id).first()


def create_user(db: Session, user: schemas.UserCreate) -> models.User:
    hashed = get_password_hash(user.password)
    db_user = models.User(
        email=user.email,
        username=user.username,
        hashed_password=hashed,
        display_name=user.display_name or user.username,
    )
    db.add(db_user)
    db.commit()
    db.refresh(db_user)

    # Create default stats
    stats = models.PlayerStats(
        user_id=db_user.id,
        str_stat=10,
        agi_stat=10,
        vit_stat=10,
        int_stat=10,
        sen_stat=10,
        distributable_points=5,
        hp=100,
        energy=100,
        focus_stat=10,
    )
    db.add(stats)

    # Create default screentime settings
    screentime = models.ScreentimeSetting(user_id=db_user.id)
    db.add(screentime)

    # Give starting items
    starter_items = [
        models.InventoryItem(
            user_id=db_user.id,
            item_name="Novice Potion",
            item_type="consumable",
            rarity="common",
            quantity=3,
            description="Restores a small amount of energy.",
        ),
        models.InventoryItem(
            user_id=db_user.id,
            item_name="Worn Training Gear",
            item_type="equipment",
            rarity="common",
            quantity=1,
            stat_bonuses={"str": 1},
            description="Basic gear for new hunters.",
        ),
    ]
    for item in starter_items:
        db.add(item)

    db.commit()
    return db_user


def update_user(db: Session, user: models.User, updates: schemas.UserUpdate) -> models.User:
    if updates.display_name:
        user.display_name = updates.display_name
    if updates.email:
        user.email = updates.email
    db.commit()
    db.refresh(user)
    return user


# ─── Stats ───
def get_player_stats(db: Session, user_id: int) -> Optional[models.PlayerStats]:
    return db.query(models.PlayerStats).filter(models.PlayerStats.user_id == user_id).first()


def allocate_stats(db: Session, user: models.User, allocation: schemas.StatAllocate) -> models.PlayerStats:
    stats = get_player_stats(db, user.id)
    total = allocation.str_points + allocation.agi_points + allocation.vit_points + allocation.int_points + allocation.sen_points
    if total > stats.distributable_points:
        raise ValueError("Not enough distributable points")

    stats.str_stat += allocation.str_points
    stats.agi_stat += allocation.agi_points
    stats.vit_stat += allocation.vit_points
    stats.int_stat += allocation.int_points
    stats.sen_stat += allocation.sen_points
    stats.distributable_points -= total

    # Recalculate derived stats
    stats.hp = stats.vit_stat * 10
    stats.energy = int((stats.vit_stat + stats.agi_stat) / 2 * 10)
    stats.focus_stat = int((stats.int_stat + stats.sen_stat) / 2)

    db.commit()
    db.refresh(stats)
    return stats


def apply_stat_decay(db: Session, user: models.User) -> dict:
    """Apply weekly stat decay. Stats above level+5 decay by 1 per week of inactivity."""
    stats = get_player_stats(db, user.id)
    floor = user.level + 5
    decayed = {}

    for stat_name in ["str_stat", "agi_stat", "vit_stat", "int_stat", "sen_stat"]:
        current = getattr(stats, stat_name)
        if current > floor:
            new_val = max(current - 1, floor)
            setattr(stats, stat_name, new_val)
            decayed[stat_name] = {"before": current, "after": new_val}

    # Recalculate derived
    stats.hp = stats.vit_stat * 10
    stats.energy = int((stats.vit_stat + stats.agi_stat) / 2 * 10)
    stats.focus_stat = int((stats.int_stat + stats.sen_stat) / 2)

    user.last_decay_date = datetime.date.today()
    db.commit()
    db.refresh(stats)
    return decayed


# ─── Quests ───
def get_quest(db: Session, quest_id: int) -> Optional[models.Quest]:
    return db.query(models.Quest).filter(models.Quest.id == quest_id).first()


def get_user_quests(db: Session, user_id: int, quest_type: Optional[str] = None, status: Optional[str] = None) -> List[models.Quest]:
    q = db.query(models.Quest).filter(models.Quest.user_id == user_id)
    if quest_type:
        q = q.filter(models.Quest.quest_type == quest_type)
    if status:
        q = q.filter(models.Quest.status == status)
    return q.order_by(models.Quest.created_at.desc()).all()


def create_quest(db: Session, user_id: int, quest: schemas.QuestCreate) -> models.Quest:
    db_quest = models.Quest(
        user_id=user_id,
        title=quest.title,
        description=quest.description,
        quest_type=quest.quest_type,
        difficulty=quest.difficulty,
        xp_reward=quest.xp_reward,
        gold_reward=quest.gold_reward,
        stat_rewards=quest.stat_rewards or {},
        category=quest.category,
        deadline=quest.deadline,
        status="active",
    )
    db.add(db_quest)
    db.commit()
    db.refresh(db_quest)
    return db_quest


QUEST_TEMPLATES = {
    "Physical": [
        ("Zone 2 Endurance Run", "Run for 20 minutes at zone 2 heart rate.", "C", 150, 40, {"vit": 1, "agi": 1}),
        ("Push-up Protocol", "Complete 3 sets of push-ups to failure.", "D", 100, 30, {"str": 1}),
        ("HIIT Blast", "20-minute high-intensity interval training.", "B", 250, 80, {"str": 1, "vit": 1}),
        ("Morning Stretch", "10-minute full-body stretching routine.", "E", 50, 10, {"agi": 1}),
    ],
    "Mental": [
        ("Meditation Session", "10-minute mindfulness meditation.", "D", 100, 30, {"sen": 1}),
        ("Box Breathing", "5 minutes of 4-4-4-4 box breathing.", "E", 50, 10, {"sen": 1}),
        ("Gratitude Journal", "Write 3 specific things you're grateful for.", "D", 100, 20, {"sen": 1}),
    ],
    "Intellectual": [
        ("Deep Work Sprint", "90-minute uninterrupted focus session.", "B", 250, 80, {"int": 1}),
        ("Reading Session", "Read 20 pages of a non-fiction book.", "C", 150, 40, {"int": 1}),
        ("Skill Practice", "30 minutes of deliberate practice on a skill.", "C", 150, 40, {"int": 1}),
    ],
    "Discipline": [
        ("Digital Sabbath", "No recreational screen time for 1 hour.", "D", 100, 30, {"sen": 1}),
        ("Early Rise", "Wake up before your alarm.", "D", 100, 20, {"vit": 1}),
    ],
}


def generate_daily_quests(db: Session, user: models.User) -> List[models.Quest]:
    # Check if already generated today
    today_start = datetime.utcnow().replace(hour=0, minute=0, second=0, microsecond=0)
    existing = db.query(models.Quest).filter(
        models.Quest.user_id == user.id,
        models.Quest.quest_type == "daily",
        models.Quest.created_at >= today_start,
    ).all()
    if existing:
        return existing

    # Generate 3 quests based on level
    categories = list(QUEST_TEMPLATES.keys())
    random.shuffle(categories)
    quests = []

    for i, cat in enumerate(categories[:3]):
        templates = QUEST_TEMPLATES[cat]
        template = random.choice(templates)
        name, desc, diff, xp, gold, stat_rewards = template

        # Scale by level
        level_mult = 1 + (user.level - 1) * 0.05
        scaled_xp = int(xp * level_mult)
        scaled_gold = int(gold * level_mult)

        quest = models.Quest(
            user_id=user.id,
            title=name,
            description=desc,
            quest_type="daily",
            difficulty=diff,
            xp_reward=scaled_xp,
            gold_reward=scaled_gold,
            stat_rewards=stat_rewards,
            category=cat,
            deadline=datetime.utcnow().replace(hour=23, minute=59, second=59),
            status="active",
        )
        db.add(quest)
        quests.append(quest)

    db.commit()
    for q in quests:
        db.refresh(q)
    return quests


def complete_quest(db: Session, quest: models.Quest, user: models.User) -> dict:
    if quest.status == "completed":
        raise ValueError("Quest already completed")

    quest.status = "completed"
    quest.completed_at = datetime.utcnow()

    # Award XP and check level up
    user.xp += quest.xp_reward
    user.gold += quest.gold_reward

    leveled_up = False
    new_level = None
    while check_level_up(user):
        user.level += 1
        leveled_up = True
        new_level = user.level
        # Level up rewards
        stats = get_player_stats(db, user.id)
        stats.str_stat += 1
        stats.agi_stat += 1
        stats.vit_stat += 1
        stats.int_stat += 1
        stats.sen_stat += 1
        stats.distributable_points += 5
        user.gold += 50 * user.level

    # Update rank
    user.rank = rank_for_level(user.level)

    # Apply stat rewards from quest
    stats = get_player_stats(db, user.id)
    if quest.stat_rewards:
        for stat_name, value in quest.stat_rewards.items():
            attr = f"{stat_name}_stat"
            if hasattr(stats, attr):
                current = getattr(stats, attr)
                setattr(stats, attr, current + value)

    # Recalculate derived stats
    stats.hp = stats.vit_stat * 10
    stats.energy = int((stats.vit_stat + stats.agi_stat) / 2 * 10)
    stats.focus_stat = int((stats.int_stat + stats.sen_stat) / 2)

    # Update streak
    today = datetime.utcnow().date()
    if user.last_quest_date:
        last_date = user.last_quest_date.date()
        if last_date == today:
            pass  # Already counted today
        elif (today - last_date).days == 1:
            user.streak_days += 1
        else:
            user.streak_days = 1
    else:
        user.streak_days = 1

    if user.streak_days > user.best_streak:
        user.best_streak = user.streak_days
    user.last_quest_date = datetime.utcnow()

    # Record completion
    completion = models.QuestCompletion(
        quest_id=quest.id,
        user_id=user.id,
        xp_earned=quest.xp_reward,
        gold_earned=quest.gold_reward,
    )
    db.add(completion)

    db.commit()
    return {
        "quest_id": quest.id,
        "xp_earned": quest.xp_reward,
        "gold_earned": quest.gold_reward,
        "leveled_up": leveled_up,
        "new_level": new_level,
        "message": "Quest completed. The System acknowledges your effort." if not leveled_up else f"LEVEL UP! You have reached level {new_level}.",
    }


def fail_quest(db: Session, quest: models.Quest, user: models.User) -> dict:
    quest.status = "failed"
    quest.completed_at = datetime.utcnow()
    # Penalty: break streak, small gold loss
    user.streak_days = 0
    penalty_gold = min(user.gold, 10)
    user.gold -= penalty_gold
    db.commit()
    return {
        "quest_id": quest.id,
        "message": "Quest failed. The path darkens, but you have walked this way before.",
        "penalty": {
            "streak_reset": True,
            "gold_lost": penalty_gold,
        },
    }


# ─── Inventory ───
def get_inventory(db: Session, user_id: int) -> List[models.InventoryItem]:
    return db.query(models.InventoryItem).filter(models.InventoryItem.user_id == user_id).all()


def get_inventory_item(db: Session, item_id: int, user_id: int) -> Optional[models.InventoryItem]:
    return db.query(models.InventoryItem).filter(
        models.InventoryItem.id == item_id,
        models.InventoryItem.user_id == user_id,
    ).first()


def add_item(db: Session, user_id: int, item_name: str, item_type: str, rarity: str, quantity: int = 1,
             stat_bonuses: dict = None, description: str = "") -> models.InventoryItem:
    """Add an item to inventory. Caller must commit the transaction."""
    item = models.InventoryItem(
        user_id=user_id,
        item_name=item_name,
        item_type=item_type,
        rarity=rarity,
        quantity=quantity,
        stat_bonuses=stat_bonuses or {},
        description=description,
    )
    db.add(item)
    db.flush()
    db.refresh(item)
    return item


LOOT_TABLE = {
    "blessed": [
        ("Common", 0.60), ("Uncommon", 0.25), ("Rare", 0.10), ("Epic", 0.04), ("Legendary", 0.01),
    ],
    "cursed": [
        ("Common", 0.50), ("Uncommon", 0.30), ("Rare", 0.15), ("Epic", 0.04), ("Legendary", 0.01),
    ],
}

ITEM_POOL = {
    "Common": [
        ("Small XP Potion", "consumable", {"xp_boost": 10}, "Slight XP boost for next quest."),
        ("Bandage", "consumable", {"hp": 10}, "Restores a small amount of HP."),
        ("Rusty Dagger", "equipment", {"str": 1}, "Better than nothing."),
    ],
    "Uncommon": [
        ("Energy Drink", "consumable", {"energy": 20}, "Restores energy."),
        ("Training Weights", "equipment", {"str": 2, "agi": 1}, "Increases strength training effectiveness."),
    ],
    "Rare": [
        ("Focus Elixir", "consumable", {"focus": 20}, "Boosts focus for deep work sessions."),
        ("Hunter's Boots", "equipment", {"agi": 3}, "Lightweight boots for agile movement."),
    ],
    "Epic": [
        ("Shadow Essence", "material", {}, "A fragment of shadow power."),
        ("Monarch's Ring", "equipment", {"str": 3, "int": 3, "sen": 3}, "A ring imbued with ancient power."),
    ],
    "Legendary": [
        ("Demon King's Crown", "equipment", {"str": 5, "agi": 5, "vit": 5, "int": 5, "sen": 5}, "The crown of the defeated Demon King."),
        ("True Awakening Stone", "consumable", {"str": 2, "agi": 2, "vit": 2, "int": 2, "sen": 2}, "Permanently increases all stats."),
    ],
}


def open_loot_box(db: Session, user: models.User, box_type: str, deduct_gold: bool = True) -> dict:
    """Open a loot box. If deduct_gold=True, charges 200 gold (for direct use)."""
    if deduct_gold:
        if user.gold < 200:
            raise ValueError("Not enough gold")
        user.gold -= 200

    # Determine rarity
    roll = random.random()
    cumulative = 0
    rarity = "Common"
    for r, prob in LOOT_TABLE.get(box_type, LOOT_TABLE["blessed"]):
        cumulative += prob
        if roll <= cumulative:
            rarity = r
            break

    # Select item
    pool = ITEM_POOL.get(rarity, ITEM_POOL["Common"])
    item_data = random.choice(pool)
    name, item_type, stat_bonuses, description = item_data

    item = add_item(db, user.id, name, item_type, rarity, 1, stat_bonuses, description)

    db.commit()
    return {
        "item_name": name,
        "rarity": rarity,
        "description": description,
        "stat_bonuses": stat_bonuses,
        "remaining_gold": user.gold,
    }


# ─── Titles ───
def get_user_titles(db: Session, user_id: int) -> List[models.Title]:
    return db.query(models.Title).filter(models.Title.user_id == user_id).all()


def unlock_title(db: Session, user_id: int, title_key: str, title_name: str, description: str,
                 buff_effect: str, rarity: str = "common") -> models.Title:
    existing = db.query(models.Title).filter(
        models.Title.user_id == user_id,
        models.Title.title_key == title_key,
    ).first()
    if existing:
        return existing

    title = models.Title(
        user_id=user_id,
        title_name=title_name,
        title_key=title_key,
        description=description,
        buff_effect=buff_effect,
        rarity=rarity,
    )
    db.add(title)
    db.commit()
    db.refresh(title)
    return title


# ─── Guilds ───
def get_guild(db: Session, guild_id: int) -> Optional[models.Guild]:
    return db.query(models.Guild).filter(models.Guild.id == guild_id).first()


def get_guild_by_name(db: Session, name: str) -> Optional[models.Guild]:
    return db.query(models.Guild).filter(models.Guild.name == name).first()


def get_guilds(db: Session, skip: int = 0, limit: int = 100) -> List[models.Guild]:
    return db.query(models.Guild).offset(skip).limit(limit).all()


def create_guild(db: Session, guild: schemas.GuildCreate, creator_id: int) -> models.Guild:
    db_guild = models.Guild(
        name=guild.name,
        description=guild.description,
        created_by=creator_id,
    )
    db.add(db_guild)
    db.commit()
    db.refresh(db_guild)

    # Add creator as leader
    member = models.GuildMember(guild_id=db_guild.id, user_id=creator_id, role="leader")
    db.add(member)
    db.commit()
    return db_guild


def join_guild(db: Session, guild_id: int, user_id: int) -> models.GuildMember:
    existing = db.query(models.GuildMember).filter(
        models.GuildMember.guild_id == guild_id,
        models.GuildMember.user_id == user_id,
    ).first()
    if existing:
        return existing

    member_count = db.query(models.GuildMember).filter(models.GuildMember.guild_id == guild_id).count()
    guild = get_guild(db, guild_id)
    if member_count >= guild.max_members:
        raise ValueError("Guild is full")

    member = models.GuildMember(guild_id=guild_id, user_id=user_id, role="member")
    db.add(member)
    db.commit()
    db.refresh(member)
    return member


def get_guild_members(db: Session, guild_id: int) -> List[models.GuildMember]:
    return db.query(models.GuildMember).filter(models.GuildMember.guild_id == guild_id).all()


# ─── Store ───
def get_store_items(db: Session) -> List[models.StoreItem]:
    return db.query(models.StoreItem).all()


def get_store_item(db: Session, item_id: int) -> Optional[models.StoreItem]:
    return db.query(models.StoreItem).filter(models.StoreItem.id == item_id).first()


def seed_store_items(db: Session):
    existing = db.query(models.StoreItem).first()
    if existing:
        return

    items = [
        models.StoreItem(name="XP Boost Potion", description="+20% XP for next 3 quests", item_type="consumable", rarity="uncommon", gold_cost=300, effect="xp_boost_20"),
        models.StoreItem(name="Streak Freeze", description="Preserve your streak for one day", item_type="consumable", rarity="rare", gold_cost=500, effect="streak_freeze"),
        models.StoreItem(name="Blessed Random Box", description="Contains an item you want", item_type="lootbox", rarity="rare", gold_cost=200, effect="blessed_box"),
        models.StoreItem(name="Cursed Random Box", description="Contains an item you need", item_type="lootbox", rarity="rare", gold_cost=200, effect="cursed_box"),
        models.StoreItem(name="Energy Restore", description="Restores 50% energy", item_type="consumable", rarity="common", gold_cost=150, effect="energy_restore"),
        models.StoreItem(name="Skill Respec Token", description="Reset and reallocate all stat points", item_type="consumable", rarity="epic", gold_cost=1000, effect="respec"),
    ]
    for item in items:
        db.add(item)
    db.commit()


def purchase_item(db: Session, user: models.User, store_item: models.StoreItem) -> dict:
    if store_item.stock is not None and store_item.stock <= 0:
        raise ValueError("Item out of stock")
    if user.gold < store_item.gold_cost:
        raise ValueError("Not enough gold")
    if user.essence < store_item.essence_cost:
        raise ValueError("Not enough essence")

    user.gold -= store_item.gold_cost
    user.essence -= store_item.essence_cost
    if store_item.stock is not None:
        store_item.stock -= 1

    if store_item.item_type == "lootbox":
        box_type = "blessed" if "blessed" in store_item.effect else "cursed"
        result = open_loot_box(db, user, box_type, deduct_gold=False)
        return {
            "success": True,
            "item_name": result["item_name"],
            "gold_spent": store_item.gold_cost,
            "essence_spent": store_item.essence_cost,
            "remaining_gold": user.gold,
            "remaining_essence": user.essence,
            "message": f"You received: {result['item_name']} ({result['rarity']})",
        }
    else:
        item = add_item(
            db, user.id, store_item.name, store_item.item_type,
            store_item.rarity, 1, store_item.stat_bonuses or {}, store_item.description
        )
        db.commit()
        return {
            "success": True,
            "item_name": store_item.name,
            "gold_spent": store_item.gold_cost,
            "essence_spent": store_item.essence_cost,
            "remaining_gold": user.gold,
            "remaining_essence": user.essence,
            "message": f"Purchased: {store_item.name}",
        }


# ─── Leaderboard ───
def get_leaderboard(db: Session, limit: int = 50) -> List[dict]:
    users = db.query(models.User).filter(models.User.is_active == True).order_by(
        models.User.level.desc(), models.User.xp.desc()
    ).limit(limit).all()

    result = []
    for i, u in enumerate(users, 1):
        result.append({
            "rank": i,
            "username": u.username,
            "level": u.level,
            "xp": u.xp,
            "rank_title": u.rank,
        })
    return result


# ─── Screentime ───
def get_screentime_settings(db: Session, user_id: int) -> Optional[models.ScreentimeSetting]:
    return db.query(models.ScreentimeSetting).filter(models.ScreentimeSetting.user_id == user_id).first()


def update_screentime_settings(db: Session, user_id: int, settings: schemas.ScreentimeSettingBase) -> models.ScreentimeSetting:
    db_settings = get_screentime_settings(db, user_id)
    if not db_settings:
        db_settings = models.ScreentimeSetting(user_id=user_id)
        db.add(db_settings)

    db_settings.daily_limit_minutes = settings.daily_limit_minutes
    db_settings.category_limits = settings.category_limits or {}
    db_settings.app_limits = settings.app_limits or {}
    db_settings.morning_protocol_time = settings.morning_protocol_time
    db_settings.evening_protocol_time = settings.evening_protocol_time
    db_settings.focus_session_active = settings.focus_session_active
    db_settings.focus_session_duration = settings.focus_session_duration

    db.commit()
    db.refresh(db_settings)
    return db_settings
