"""
Dynamic Quest Engine for OREUDA.

Generates quests based on real health data from Health Connect and Lyfta.
Quests auto-complete when their criteria are met.
"""
import random
from datetime import datetime, timedelta, date
from typing import List, Dict, Optional
from sqlalchemy.orm import Session

from app import models, crud


# ═══════════════════════════════════════════════════════════════════════════════
# Quest Templates
# ═══════════════════════════════════════════════════════════════════════════════

DAILY_QUEST_TEMPLATES = [
    {
        "title": "Step Master",
        "description": "Walk {target} steps today.",
        "metric": "steps",
        "target": 10000,
        "xp": 150,
        "gold": 20,
        "stat_reward": {"agi": 1},
        "difficulty": "D",
    },
    {
        "title": "Calorie Furnace",
        "description": "Burn {target} active calories today.",
        "metric": "calories",
        "target": 500,
        "xp": 150,
        "gold": 20,
        "stat_reward": {"vit": 1},
        "difficulty": "D",
    },
    {
        "title": "Deep Rest",
        "description": "Get {target} hours of sleep.",
        "metric": "sleep",
        "target": 480,  # 8 hours in minutes
        "xp": 100,
        "gold": 15,
        "stat_reward": {"int": 1},
        "difficulty": "E",
    },
    {
        "title": "Iron Will",
        "description": "Complete a workout session.",
        "metric": "workouts",
        "target": 1,
        "xp": 200,
        "gold": 30,
        "stat_reward": {"str": 1},
        "difficulty": "C",
    },
    {
        "title": "Morning Ritual",
        "description": "Wake up before 7 AM and log your weight.",
        "metric": "weight",
        "target": 1,
        "xp": 50,
        "gold": 10,
        "stat_reward": {"sen": 1},
        "difficulty": "E",
    },
]

WEEKLY_QUEST_TEMPLATES = [
    {
        "title": "Weekend Warrior",
        "description": "Complete 5 workouts this week.",
        "metric": "workouts",
        "target": 5,
        "xp": 500,
        "gold": 100,
        "stat_reward": {"str": 3},
        "difficulty": "B",
    },
    {
        "title": "Marathon Walker",
        "description": "Walk 70,000 steps this week.",
        "metric": "steps",
        "target": 70000,
        "xp": 400,
        "gold": 80,
        "stat_reward": {"agi": 3},
        "difficulty": "B",
    },
    {
        "title": "Sleep Discipline",
        "description": "Get 8+ hours of sleep for 5 days this week.",
        "metric": "sleep_days",
        "target": 5,
        "xp": 300,
        "gold": 60,
        "stat_reward": {"int": 3},
        "difficulty": "C",
    },
]

DUNGEON_QUEST_TEMPLATES = [
    {
        "title": "The Goblin Cave",
        "description": "A 7-day step challenge. Walk 10,000 steps every day.",
        "metric": "steps_streak",
        "target": 7,
        "daily_target": 10000,
        "xp": 1000,
        "gold": 200,
        "stat_reward": {"agi": 5, "vit": 2},
        "difficulty": "A",
        "days": 7,
    },
    {
        "title": "The Orc Fortress",
        "description": "A 7-day gym streak. Complete a workout every day.",
        "metric": "workout_streak",
        "target": 7,
        "daily_target": 1,
        "xp": 1500,
        "gold": 300,
        "stat_reward": {"str": 5, "vit": 3},
        "difficulty": "S",
        "days": 7,
    },
    {
        "title": "The Demon Castle",
        "description": "A 30-day transformation. Hit all daily goals for 30 days.",
        "metric": "all_goals_streak",
        "target": 30,
        "xp": 5000,
        "gold": 1000,
        "stat_reward": {"str": 5, "agi": 5, "vit": 5, "int": 5, "sen": 5},
        "difficulty": "S",
        "days": 30,
    },
]


# ═══════════════════════════════════════════════════════════════════════════════
# Quest Engine
# ═══════════════════════════════════════════════════════════════════════════════

class QuestEngine:
    """Generates and checks dynamic quests based on health data."""

    @classmethod
    def generate_daily_quests(cls, db: Session, user: models.User) -> List[models.Quest]:
        """Generate 3 daily quests based on user's health data."""
        # Get today's health snapshot
        today = date.today()
        snapshot = (
            db.query(models.HealthSnapshot)
            .filter(
                models.HealthSnapshot.user_id == user.id,
                models.HealthSnapshot.date == today,
            )
            .first()
        )

        # If no health data, generate default quests with lower targets
        has_health_data = snapshot is not None

        # Pick 3 random templates
        templates = random.sample(DAILY_QUEST_TEMPLATES, min(3, len(DAILY_QUEST_TEMPLATES)))

        quests = []
        for template in templates:
            # Adjust target based on user's current activity level
            target = template["target"]
            if has_health_data and template["metric"] == "steps":
                # Set target slightly above current average
                target = max(5000, min(15000, snapshot.steps + 2000))
            elif has_health_data and template["metric"] == "calories":
                target = max(300, min(800, snapshot.calories_burned + 100))

            quest = models.Quest(
                user_id=user.id,
                title=template["title"],
                description=template["description"].format(target=target),
                quest_type="daily",
                difficulty=template["difficulty"],
                status="active",
                xp_reward=template["xp"],
                gold_reward=template["gold"],
                stat_rewards=template["stat_reward"],
                category="Physical",
                deadline=datetime.utcnow() + timedelta(days=1),
                target_value=target,
                current_value=0,
                metric_type=template["metric"],
            )
            db.add(quest)
            quests.append(quest)

        db.commit()
        return quests

    @classmethod
    def generate_weekly_quests(cls, db: Session, user: models.User) -> List[models.Quest]:
        """Generate 1-2 weekly quests."""
        templates = random.sample(WEEKLY_QUEST_TEMPLATES, min(2, len(WEEKLY_QUEST_TEMPLATES)))

        quests = []
        for template in templates:
            quest = models.Quest(
                user_id=user.id,
                title=template["title"],
                description=template["description"],
                quest_type="weekly",
                difficulty=template["difficulty"],
                status="active",
                xp_reward=template["xp"],
                gold_reward=template["gold"],
                stat_rewards=template["stat_reward"],
                category="Physical",
                deadline=datetime.utcnow() + timedelta(days=7),
                target_value=template["target"],
                current_value=0,
                metric_type=template["metric"],
            )
            db.add(quest)
            quests.append(quest)

        db.commit()
        return quests

    @classmethod
    def generate_dungeon_quest(cls, db: Session, user: models.User) -> Optional[models.Quest]:
        """Generate a dungeon (multi-day) quest if user doesn't have an active one."""
        # Check if user already has an active dungeon
        active_dungeon = (
            db.query(models.Quest)
            .filter(
                models.Quest.user_id == user.id,
                models.Quest.quest_type == "dungeon",
                models.Quest.status == "active",
            )
            .first()
        )
        if active_dungeon:
            return None

        template = random.choice(DUNGEON_QUEST_TEMPLATES)

        quest = models.Quest(
            user_id=user.id,
            title=template["title"],
            description=template["description"],
            quest_type="dungeon",
            difficulty=template["difficulty"],
            status="active",
            xp_reward=template["xp"],
            gold_reward=template["gold"],
            stat_rewards=template["stat_reward"],
            category="Dungeon",
            deadline=datetime.utcnow() + timedelta(days=template["days"]),
            target_value=template["target"],
            current_value=0,
            metric_type=template["metric"],
            chain_total_days=template["days"],
            chain_day=1,
        )
        db.add(quest)
        db.commit()
        return quest

    @classmethod
    def check_quest_completion(cls, db: Session, user: models.User) -> List[models.Quest]:
        """Check all active quests against latest health data and auto-complete."""
        today = date.today()
        snapshot = (
            db.query(models.HealthSnapshot)
            .filter(
                models.HealthSnapshot.user_id == user.id,
                models.HealthSnapshot.date == today,
            )
            .first()
        )

        if not snapshot:
            return []

        active_quests = (
            db.query(models.Quest)
            .filter(
                models.Quest.user_id == user.id,
                models.Quest.status == "active",
            )
            .all()
        )

        completed = []
        for quest in active_quests:
            if cls._is_quest_complete(quest, snapshot):
                quest.status = "completed"
                quest.completed_at = datetime.utcnow()
                quest.current_value = quest.target_value

                # Award XP and gold
                user.xp += quest.xp_reward
                user.gold += quest.gold_reward

                # Award stat bonuses
                for stat, bonus in (quest.stat_rewards or {}).items():
                    player_stats = crud.get_player_stats(db, user.id)
                    if player_stats:
                        current = getattr(player_stats, f"{stat}_stat", 10)
                        setattr(player_stats, f"{stat}_stat", min(100, current + int(bonus)))

                # Check level up
                if crud.check_level_up(user):
                    user.level += 1
                    user.rank = crud.rank_for_level(user.level)
                    # Grant distributable points on level up
                    player_stats = crud.get_player_stats(db, user.id)
                    if player_stats:
                        player_stats.distributable_points += 3

                completed.append(quest)
            else:
                # Update progress
                quest.current_value = cls._get_current_progress(quest, snapshot)

        db.commit()
        return completed

    @classmethod
    def _is_quest_complete(cls, quest: models.Quest, snapshot: models.HealthSnapshot) -> bool:
        """Check if a quest's criteria are met."""
        metric = quest.metric_type
        target = quest.target_value or 0

        if metric == "steps":
            return snapshot.steps >= target
        elif metric == "calories":
            return snapshot.calories_burned >= target
        elif metric == "sleep":
            return snapshot.sleep_minutes >= target
        elif metric == "workouts":
            return snapshot.workouts_count >= target
        elif metric == "weight":
            return snapshot.weight_kg is not None
        return False

    @classmethod
    def _get_current_progress(cls, quest: models.Quest, snapshot: models.HealthSnapshot) -> int:
        """Get current progress value for a quest."""
        metric = quest.metric_type

        if metric == "steps":
            return snapshot.steps
        elif metric == "calories":
            return snapshot.calories_burned
        elif metric == "sleep":
            return snapshot.sleep_minutes
        elif metric == "workouts":
            return snapshot.workouts_count
        elif metric == "weight":
            return 1 if snapshot.weight_kg is not None else 0
        return 0

    @classmethod
    def get_or_create_daily_quests(cls, db: Session, user: models.User) -> List[models.Quest]:
        """Get today's daily quests, creating them if they don't exist."""
        today_start = datetime.utcnow().replace(hour=0, minute=0, second=0, microsecond=0)
        today_end = today_start + timedelta(days=1)

        daily_quests = (
            db.query(models.Quest)
            .filter(
                models.Quest.user_id == user.id,
                models.Quest.quest_type == "daily",
                models.Quest.created_at >= today_start,
                models.Quest.created_at < today_end,
            )
            .all()
        )

        if not daily_quests:
            daily_quests = cls.generate_daily_quests(db, user)

        return daily_quests
