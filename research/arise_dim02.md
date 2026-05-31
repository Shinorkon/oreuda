# Dimension 02: Core Game Loop & RPG Mechanics

## Executive Summary

This document specifies the complete core game loop and RPG mechanics for **ARISE**, a life gamification app drawing from *Solo Leveling*'s System mechanics and grounded in behavioral psychology research. The design centers on a stat decay mechanic (novel to the market), a five-stat system mapping to real-life domains, an exponential XP curve with level cap 100, and a comprehensive E→S rank progression system. All mechanics are designed to balance extrinsic motivation with intrinsic drive, navigating the overjustification effect while leveraging loss aversion, variable rewards, and flow state theory.

**Key Design Pillars:**
1. **Stat Decay as Maintenance** — A novel mechanic requiring ongoing investment to maintain stats [^384^][^386^]
2. **Flow-State Calibration** — Dynamic difficulty adjustment per Csikszentmihalyi's challenge-skill balance [^300^][^304^]
3. **Ethical Streak Design** — Soft streaks with recovery mechanics to prevent abstinence violation effect [^303^][^305^]
4. **White-Hat Motivation** — Informational rewards and competence feedback over controlling extrinsic incentives [^167^][^360^]

---

## Section 1: Stat System Specification

### 1.1 Core Stats (5-Stat Framework)

Following *Solo Leveling*'s model and RPG best practices recommending 3–6 core attributes [^290^], ARISE uses five stats that map directly to real-life domains:

| Stat | Name | Real-Life Domain | Starting Value | Description |
|------|------|-----------------|---------------|-------------|
| STR | Strength | Physical Fitness | 10 | Raw physical power: weightlifting, sprinting, high-intensity training |
| AGI | Agility | Movement & Flexibility | 10 | Speed, coordination, mobility work, yoga, sports |
| VIT | Vitality | Health & Wellness | 10 | Endurance, sleep quality, nutrition, recovery |
| INT | Intelligence | Knowledge & Skills | 10 | Learning, reading, professional development, language study |
| SEN | Sense | Mindfulness & Awareness | 10 | Meditation, journaling, social awareness, emotional regulation |

**Rationale for 5 stats:** Research indicates 3–6 core attributes is the optimal range for RPGs — below 3 feels shallow, above 6 becomes untrackable [^290^]. Each stat has a clear primary effect and at least one secondary effect, satisfying the dual-criteria rule for attribute design. This mirrors *Solo Leveling*'s original five-stat framework (Strength, Agility, Vitality, Intelligence, Perception) [^26^].

**Starting values:** All stats begin at 10, matching *Solo Leveling*'s Day 1 presentation where "Everything was at 10, with HP being the standard 100" [^298^]. This creates intuitive percentage-based calculations where 10 = baseline 100% effectiveness.

### 1.2 Derived Stats

Derived stats are calculated from core attributes and provide concrete gameplay effects:

| Derived Stat | Formula | Description |
|-------------|---------|-------------|
| HP (Health Points) | VIT x 10 | Represents overall life balance; damage taken when neglecting wellness |
| Energy | (VIT + AGI) / 2 x 10 | Daily action pool for completing quests |
| Focus | (INT + SEN) / 2 | Affects quality of work/study session rewards |
| Carry Weight | STR x 5 + 50 | Inventory capacity in units |

### 1.3 Stat Growth

**Level-Up Growth:** Each level-up grants:
- +1 to ALL five base stats (automatic) [^26^]
- +5 distributable stat points (player choice) [^23^][^25^]

**Quest Rewards:** Daily quest completion grants +3 stat points total (typically +1 to primary stat per quest, +1 bonus for perfect completion) [^23^][^25^].

**Soft Cap Pattern:** To prevent extreme min-maxing and encourage diverse builds, diminishing returns apply after stat thresholds [^290^]:

| Stat Range | Multiplier | Description |
|-----------|-----------|-------------|
| 1–50 | 1.0x (full value) | Linear growth, each point = full benefit |
| 51–80 | 0.7x (reduced) | Diminishing returns begin |
| 81–100 | 0.4x (significantly reduced) | Specialization requires heavy investment |
| 101–150 | 0.1x (minimal) | Soft cap territory; prestige investment only |

This soft cap pattern "lets players specialize enough to feel their build matters while preventing game-breaking stat stacking" [^290^].

### 1.4 Stat Decay Mechanic (NOVEL — Market Differentiator)

ARISE introduces **stat decay** as a core mechanic — no existing life gamification app currently uses this. Research shows that while RPG stat degradation is conceptually rare, the idea of stats requiring maintenance creates a powerful engagement loop [^384^][^386^].

**Decay Rules:**
- Each stat decays by 1 point per 7 days of inactivity in that domain
- Decay only applies to stats above the level-based minimum (Level x 1 + 5)
- Decay cannot reduce stats below the level floor
- Decay is calculated weekly, not daily, to reduce user anxiety

**Example:** A Level 20 player with STR 45 who skips all fitness quests for 2 weeks:
- Level floor: 20 + 5 = 25
- Current STR: 45
- After 2 weeks: 45 - 2 = 43 (no floor cap hit)
- After 20 weeks of inactivity: max(45 - 20, 25) = 25

**Psychological Rationale:**
- Creates ongoing engagement without punishing short breaks [^361^]
- Mirrors real life: skills and fitness genuinely decay without maintenance
- The level floor ensures progress is never fully lost — "progress persistence"
- Encourages rotation across life domains rather than hyper-specialization

**Decay Prevention:**
- Completing at least 1 quest per week in a stat's domain prevents all decay for that stat
- Weekly "maintenance quests" are lighter versions of regular quests (50% effort)
- Titles can provide decay resistance (e.g., "Iron Will" reduces decay rate by 50%)

### 1.5 Stat Scaling Formula

Using logarithmic diminishing returns recommended for balanced RPG systems [^294^][^290^]:

```
effectiveness(stat) = base_value * (1 + ln(stat/10) * scaling_factor)
```

Where:
- `base_value` = the base effectiveness at stat 10
- `ln(stat/10)` = natural logarithm of stat relative to baseline
- `scaling_factor` = 0.3 (calibrated so stat 100 = ~3.5x effectiveness)

This logarithmic curve "starts with large gains early on, but then tapers off over time" — exactly matching the desired "easy to learn, hard to master" progression feel [^294^].

---

## Section 2: XP & Leveling System

### 2.1 XP Curve Design

ARISE uses an **exponential XP curve** with exponent 1.5 — the recommended starting point for RPG progression systems [^290^]. This creates fast early progression (dopamine-rich onboarding) and increasingly challenging late-game advancement.

```
XP_required(level) = 100 * (level ^ 1.5)
```

**Level Cap:** 100 (matching *Solo Leveling*'s level cap) [^26^][^298^]

### 2.2 XP Table (Key Milestones)

| Level | XP Required | Total XP | Rewards |
|-------|------------|----------|---------|
| 1 | 100 | 100 | Starting character, 5 stat points |
| 2 | 283 | 383 | +1 all stats, +5 points, 1st skill slot |
| 3 | 520 | 903 | +1 all stats, +5 points |
| 5 | 1,118 | 3,215 | **Rank D unlock**, +1 all stats, +5 points |
| 10 | 3,162 | 14,337 | **Skill tree branch unlock**, title slot +1 |
| 15 | 5,809 | 33,970 | Rank C quest eligibility |
| 20 | 8,944 | 62,439 | **Rank C unlock**, dungeon access tier 2 |
| 25 | 12,500 | 103,752 | Skill tree advanced branch |
| 30 | 16,432 | 159,548 | **Rank B unlock**, title slot +1 |
| 40 | 25,298 | 325,706 | Dungeon access tier 3 |
| 50 | 35,355 | 557,721 | **Rank A unlock**, mastery quest unlocked |
| 60 | 46,476 | 856,849 | Skill tree mastery branch |
| 70 | 58,583 | 1,225,197 | **Rank S quest eligibility** |
| 80 | 71,554 | 1,666,553 | Dungeon access tier 4 |
| 90 | 85,317 | 2,184,374 | **Rank S unlock**, legendary title |
| 100 | 100,000 | 2,783,333 | **Level cap — Ascension unlock** |

### 2.3 XP Sources

| Source | Base XP | Notes |
|--------|--------|-------|
| Daily Quest (easy) | 50 | Low-difficulty habit quest |
| Daily Quest (medium) | 100 | Standard daily quest |
| Daily Quest (hard) | 200 | Challenging daily quest |
| Weekly Quest completion | 500 | Requires sustained effort |
| Boss Battle milestone | 250–2,000 | Scales with boss difficulty |
| Dungeon clear | 100–1,000 | Based on dungeon tier and clear time |
| Skill first activation | 25 | One-time XP per new skill |
| Title earned | 100–500 | Scales with title rarity |
| Streak milestone (7d) | 150 | Weekly streak bonus |
| Streak milestone (30d) | 500 | Monthly streak bonus |
| Streak milestone (66d) | 1,000 | Habit formation bonus [^84^][^361^] |
| Streak milestone (100d) | 2,000 | Century achievement |
| Rank-up | 1,000–5,000 | Scales with rank tier |

### 2.4 Anti-Grinding Measures

- **Daily XP Cap:** 500 XP per day from quest completion (excess quests grant reduced 10% XP)
- **Diminishing Returns:** Same quest type repeated multiple times per day yields 50% less XP each time
- **Weekly Soft Cap:** After 2,000 XP in a week, all sources grant 50% less XP
- **XP Boost Freshness:** New quest types and locations grant 1.5x XP (first-time bonus)

These measures are designed following Final Fantasy's model where "grinding is expected but the level cap extends beyond what most players would feel compelled to reach" [^302^], combined with anti-grinding caps to prevent exploit behavior.

---

## Section 3: Daily Quest Generation Algorithm

### 3.1 Quest Types

Drawing from *Solo Leveling*'s four quest types [^26^], ARISE implements:

| Quest Type | Frequency | Description | Failure Consequence |
|-----------|-----------|-------------|-------------------|
| Daily Quests | 3 per day (reset 5 AM local) | Physical training, habits, routines | Stat decay acceleration |
| Main Quests | 1 active at a time | Long-term goals (30+ day projects) | No penalty; persists until completed |
| Side Quests | 0–2 per day (random) | Optional challenges, experiments | No penalty |
| Urgent Quests | 0–1 per week (context-triggered) | Time-limited opportunities | Expires (no penalty) |
| Weekly Quests | 1 per week | Larger undertakings | Reduced weekly bonus |

### 3.2 Quest Generation Algorithm

Daily quests are auto-generated based on weighted factors:

| Factor | Weight | Description |
|--------|--------|-------------|
| User-defined goals | 30% | Quests aligned with user's stated priorities |
| Stat balance | 25% | Prefers quests targeting lowest/neglected stats |
| Historical completion | 15% | Favors quest types with high past success rate |
| Time of week | 10% | Weekend quests are longer; weekday quests are shorter |
| Current rank | 10% | Higher ranks get more complex multi-step quests |
| Variety freshness | 5% | Prevents same quest from appearing >2 days in a row |
| Contextual triggers | 5% | Weather, season, location-based suggestions |

**Example generation:** A player with STR 45, AGI 20 (lowest), VIT 35, INT 30, SEN 25:
1. AGI quest selected (lowest stat, 25% weight)
2. User goal: "Run 5K" detected (30% weight) → AGI running quest
3. Pattern: Player completes running quests at 85% rate (15% weight confirms)
4. Tuesday weekday → 20-minute quest window (10% weight)
5. Result: "Complete a 20-minute interval run. Reward: +1 AGI, +100 XP"

### 3.3 Penalty Zone (Solo Leveling Adaptation)

Missing daily quests triggers escalating consequences (adapted from *Solo Leveling*'s Penalty Zone desert survival mechanic [^103^][^336^]):

| Consecutive Misses | Consequence |
|-------------------|-------------|
| 1st miss | Warning notification; quest remains available for 24h |
| 2nd miss | "Weak Penalty Zone" — 2x stat decay for 1 week |
| 3rd miss | "Penalty Zone" — 3x stat decay + lose 5% of accumulated gold |
| 4th+ miss | "Deep Penalty Zone" — 4x decay + reduced quest rewards (50%) for 1 week |

The Penalty Zone concept in *Solo Leveling* teleports the player to a desert "where endless fields of sand stretch to the horizon" with "Poison-fanged Giant Sand Centipedes" for 4 hours [^103^]. In ARISE, this is translated to an in-app "challenge mode" requiring completion of difficult catch-up quests to exit the penalty state.

---

## Section 4: Rank Progression System

### 4.1 Rank Hierarchy

ARISE adopts the Japanese F-to-S rank system used in *Solo Leveling* and popularized across RPGs [^291^][^292^]:

| Rank | Color | Level Required | Quest Requirement | Ceremony |
|------|-------|---------------|-------------------|----------|
| E | Gray | 1 | Complete tutorial | None (starting rank) |
| D | Green | 5 | Complete 5 daily quests | "Awakening" — System acknowledges your potential |
| C | Blue | 20 | 30-day streak in one domain | "Recognition" — Visual aura unlocked |
| B | Purple | 30 | Complete Rank B trial quest | "Ascension" — Title slot expansion, new dungeon tier |
| A | Gold | 50 | Master all 5 stats to 50+ | "Radiance" — Golden profile border, legendary access |
| S | Red | 70 | Complete Demon Castle Floor 50 | "Monarch" — Custom title creation, S-rank aura |
| EX | ??? | 100 (Ascension) | ??? | Hidden |

**Per-Domain vs Overall Rank:** Each of the five stat domains has its own sub-rank (e.g., "B-rank Strength, C-rank Intelligence"). The **overall rank** is the lowest of the five sub-ranks. This prevents hyper-specialization and encourages balanced development.

### 4.2 Rank-Up Ceremonies

Each rank-up includes a personalized ceremony adapted from RPG progression milestones [^300^]:
- **Visual Transformation:** Profile border color changes to match new rank
- **System Message:** Personalized congratulatory message referencing specific achievements
- **Reward Package:** Rank-appropriate stat points, currency, and unlocks
- **Optional Share:** Ability to share rank-up to social media (leveraging social proof)

### 4.3 Rank Benefits

| Rank | Daily Quests | Stat Points/Lvl | Gold Multiplier | Dungeon Tiers | Title Slots |
|------|-------------|----------------|----------------|---------------|-------------|
| E | 2 | 5 | 1.0x | 1 | 1 |
| D | 3 | 5 | 1.2x | 1 | 1 |
| C | 3 | 6 | 1.5x | 2 | 2 |
| B | 4 | 6 | 2.0x | 2 | 2 |
| A | 4 | 7 | 2.5x | 3 | 3 |
| S | 5 | 8 | 3.0x | 4 | 4 |

---

## Section 5: Title System

### 5.1 Title Categories

Titles in ARISE function like *Solo Leveling*'s title buffs — passive bonuses earned through specific achievements [^26^]. Titles are organized into categories:

| Category | Description | Example |
|----------|-------------|---------|
| Combat | Fitness and physical achievement titles | "Wolf Slayer" — +5% STR against endurance challenges |
| Knowledge | Learning and intellectual titles | "Scholar" — +5% XP from study quests |
| Discipline | Consistency and habit titles | "Unbroken" — Streak decay resistance +20% |
| Exploration | Trying new things | "Pathfinder" — New quest types give 1.5x XP |
| Social | Community and accountability | "Mentor" — Both parties gain bonus when questing together |
| Legendary | Extreme achievements | "Dragon Slayer" — All stats +3% |

### 5.2 Title Catalog (Sample)

| Title | Unlock Condition | Buff Effect | Rarity |
|-------|-----------------|-------------|--------|
| Early Bird | Complete 10 quests before 7 AM | +10% XP on morning quests | Common |
| Iron Will | Maintain 30-day streak | Streak freeze charges: +1/week | Uncommon |
| Wolf Slayer | Complete 50 strength quests | +5% STR effectiveness | Uncommon |
| Scholar | Read 20 books via reading quests | +5% INT XP gain | Uncommon |
| Night Owl | Complete 10 quests after 10 PM | +10% XP on evening quests | Common |
| Jack of All Trades | All stats reach 25 | +2% all stat XP gain | Rare |
| Phoenix | Return after 14-day absence and complete 7 quests | +10% XP for 7 days after comeback | Rare |
| Dungeon Crawler | Clear 10 dungeons | Dungeon XP +15% | Uncommon |
| Monarch's Heir | Reach S-Rank | Custom title creation unlocked | Legendary |
| The Unbroken | 365-day streak | All decay reduced by 50% | Legendary |
| True Awakening | Reach Level 100 | All stats +5%, aura unlock | Mythic |

### 5.3 Title Mechanics

- **Equip Limit:** Players can equip 1 title per title slot (unlocked via rank progression)
- **Passive Always Active:** Titles provide passive buffs when equipped; no activation needed
- **Title Collection:** All earned titles are visible in a collection interface (Core Drive 4: Ownership) [^300^]
- **Hidden Titles:** Some titles have secret unlock conditions, creating discovery moments

---

## Section 6: Streak Mechanics Design

### 6.1 Core Streak System

ARISE implements a **soft streak system** designed to avoid the "abstinence violation effect" where rigid streak resets cause rage-quitting [^305^].

**Streak Fire (hard streak):** Consecutive days with at least 1 quest completed. Displayed prominently. Drives loss aversion motivation.

**Best Streak (record):** Highest streak ever achieved. Never decreases. Provides aspirational target.

**Weekly Perfection (soft streak):** Weeks with 7/7 daily completions. Separate from daily streak. Provides alternative consistency metric.

### 6.2 Grace Period & Recovery

Learning from Headspace's design where "post-break tone deserves as much design attention as the active streak" [^303^], and Duolingo's Streak Freeze mechanic [^400^][^403^]:

| Mechanic | Description | Availability |
|----------|-------------|--------------|
| Streak Freeze | Auto-activates on first miss; preserves streak for 24h | 1 charge per week (free), +1 per rank |
| Earn Back | Complete 2x daily quests the next day to restore broken streak | Once per month |
| Grace Day | Every 30 days, player can mark 1 day as "planned rest" | 1 charge per 30 days |
| Recovery Mode | After streak break: 3-day "rebuild" quest chain restores bonuses | Unlimited |

**Key data point:** Apps with freeze or recovery functionality average **17.19 days** on streak past the 7-day mark, compared to **11.62 days** for those without [^303^]. This is a 48% improvement in streak longevity.

### 6.3 Capped Streak Display

To reduce anxiety for extremely long streaks (some Duolingo users have 3,000+ day streaks [^401^]):
- Streaks display as "365+" after 1 year
- Milestone markers replace raw count (1y, 2y, 3y)
- The exact number is still visible in profile stats but not emphasized

### 6.4 Streak Wager System

Inspired by Duolingo's streak wager that "sees a 14% boost in day 14 user retention" [^49^]:
- Players can "wager" currency on maintaining a 7-day streak
- Success: 2x currency return + bonus XP
- Failure: Wagered currency lost
- Creates additional commitment device without being punitive

### 6.5 Psychological Safeguards

Following research showing that "only 0.90% of users who lose a two-to-three-day streak return to build a new one" [^303^]:

- **Never frame a break as failure** — use language like "Your streak took a rest day" not "You broke your streak"
- **Welcome back rewards** — Players returning after absence receive bonus XP (Phoenix title eligibility)
- **Progress preservation** — Stats, rank, and titles never decay; only raw streak number changes
- **Multiple streak types** — If Fire streak breaks, Weekly streak may still be intact

---

## Section 7: Currency Economy

### 7.1 Currency Types

ARISE uses a dual-currency system common in successful mobile RPGs [^306^][^311^]:

| Currency | Name | Type | Description |
|----------|------|------|-------------|
| Gold | Aria's Gold | Soft (earned) | Standard gameplay currency |
| Gems | Essence Crystals | Hard (premium) | Premium currency for cosmetics/convenience |

### 7.2 Gold Sources (Faucets)

| Source | Amount | Type |
|--------|--------|------|
| Daily quest completion | 50–200 | Active |
| Weekly quest completion | 500 | Active |
| Dungeon clear | 100–1,000 | Active |
| Boss battle milestone | 250–2,000 | Active |
| Streak milestone | 100–500 | Active |
| Title earned | 50–250 | One-time |
| Rank-up reward | 500–5,000 | One-time |
| Daily login (consecutive) | 10–100 | Semi-active |

### 7.3 Gold Sinks

| Sink | Cost | Purpose |
|------|------|---------|
| Store items (consumables) | 100–500 | Remove currency from economy |
| Equipment purchase | 500–10,000 | Major currency drain |
| Loot boxes (Random Box) | 200 | Variable reward spending |
| Skill respec | 1,000 | Allow build changes |
| Cosmetic customization | 500–5,000 | Vanity spending |
| Streak recovery (premium) | 300 | Convenience sink |
| Dungeon retry (after failure) | 100 | Anti-grinding sink |

### 7.4 Inflation Control

Following EVE Online's economic model where "sinks should scale with player wealth" [^301^]:

- **Percentage-based costs:** High-level items cost percentage of wealth, not fixed amounts
- **Currency destruction:** 5% transaction fee on all Store purchases (hard sink) [^301^]
- **Dynamic pricing:** Store prices adjust based on server-wide currency supply
- **Target inflation:** 2–5% monthly (healthy range per MMO economics) [^301^]

### 7.5 Gem (Essence Crystal) Economy

Gems are earned through exceptional performance, not purchased with real money (to avoid pay-to-win):

| Source | Gems | Context |
|--------|------|---------|
| Perfect quest week (7/7) | 5 | Weekly excellence |
| Rank-up | 10–50 | Milestone reward |
| First-time dungeon clear | 5 | Discovery reward |
| Achievement completion | 2–10 | Trophy hunting |
| Referral (friend joins) | 10 | Viral growth |

---

## Section 8: Inventory & Items

### 8.1 Item Categories

Drawing from standard RPG inventory systems with consumables, equipment, and materials [^326^][^328^]:

| Category | Description | Examples |
|----------|-------------|----------|
| Consumables | One-time use items | XP Boost Potion, Streak Freeze Charge, Energy Restore |
| Equipment | Equipped for passive bonuses | Running Shoes (+AGI quests), Study Lamp (+INT quests) |
| Materials | Crafting components | Monster Essence, Dungeon Shards |
| Loot Boxes | Random reward containers | Blessed Box (want), Cursed Box (need) [^26^] |
| Quest Items | Special drops for quests | Boss Tokens, Achievement Badges |

### 8.2 Item Rarity Tiers

| Tier | Color | Drop Rate | Power Level |
|------|-------|----------|-------------|
| Common | White | 60% | +1–3% stat effectiveness |
| Uncommon | Green | 25% | +4–7% stat effectiveness |
| Rare | Blue | 10% | +8–12% stat effectiveness, bonus effect |
| Epic | Purple | 4% | +13–18% stat effectiveness, 2 bonus effects |
| Legendary | Gold | 1% | +20–25% stat effectiveness, unique ability |

### 8.3 Blessed vs Cursed Box System

Adapted directly from *Solo Leveling*'s Store mechanic [^26^]:

- **Blessed Random Box (200 Gold):** Gives the player an item they *want* (based on equipped build and stated preferences)
- **Cursed Random Box (200 Gold):** Gives the player an item they *need* (based on lowest stats and neglected areas)

This creates a meaningful choice: players can chase optimization (Blessed) or be pushed toward balance (Cursed). The System in *Solo Leveling* "does not always reward what Jin-woo is looking for. Sometimes it provides what the succession plan requires, not what Jin-woo has chosen" [^26^].

### 8.4 Pity System

Following ethical gacha design principles [^379^][^381^]:
- Every 10 box opens guarantees at least Rare quality
- Every 50 box opens guarantees at least Epic quality
- Every 100 box opens guarantees Legendary quality
- Bad luck protection: 5% increasing bonus after each non-Rare pull

This "ensures that even the unluckiest players will eventually get a desirable reward, providing a sense of progression and preventing total frustration" [^379^].

---

## Section 9: Skill Tree

### 9.1 Skill Tree Architecture

ARISE uses a **hybrid skill tree** design combining branching specialization with level-gated progression [^302^][^308^]:

```
Level 1–10: Core Foundation (linear — all players unlock same base skills)
Level 11–30: Branching Specialization (choose 2 of 5 branches)
Level 31–60: Advanced Mastery (deepen chosen branches)
Level 61–100: Legendary Capstones (unique powerful abilities)
```

### 9.2 Skill Branches

| Branch | Primary Stat | Real-Life Mapping | Playstyle |
|--------|-------------|-------------------|-----------|
| Berserker | STR | High-intensity fitness, powerlifting | Bursty, high reward, higher risk |
| Acrobat | AGI | Running, yoga, sports, movement | Consistent daily gains, flexibility |
| Fortress | VIT | Health optimization, sleep, nutrition | Defensive, reduced decay, sustainability |
| Sage | INT | Deep work, learning, skill acquisition | Late-game scaling, compound returns |
| Empath | SEN | Meditation, journaling, relationships | Support bonuses, group synergy |

### 9.3 Skill Types

**Passive Skills** (always active):
- "Iron Body": +10% VIT quest effectiveness (Fortress branch)
- "Quick Learner": +15% INT XP from first quest of the day (Sage branch)
- "Endurance Runner": AGI quests cost 10% less Energy (Acrobat branch)

**Active Skills** (activated for temporary boost):
- "Overclock": 2x XP for next quest, 2x Energy cost (Berserker branch)
- "Focus Mind": Skip cooldown on next dungeon attempt (Sage branch)
- "Second Wind": Restore 50% HP when below 20% (Fortress branch)

### 9.4 Real-Life Skill Mapping

Each RPG skill maps to a real-life technique or methodology:

| RPG Skill | Real-Life Equivalent | Implementation |
|-----------|---------------------|----------------|
| Pomodoro | Time-boxed work sessions | 25-minute focus timer quest |
| Progressive Overload | Strength training principle | Increasing difficulty weekly |
| Habit Stacking | James Clear method | Chain linked quests for bonus |
| Intermittent Fasting | Health protocol | VIT quest variant |
| Active Recall | Learning technique | Quiz-style INT quest |
| Box Breathing | Stress management | 4-minute SEN quest |

---

## Section 10: Dungeon System

### 10.1 Dungeon Types

Adapted from *Solo Leveling*'s dungeon hierarchy [^26^]:

| Dungeon Type | Access | Duration | Description |
|-------------|--------|----------|-------------|
| Normal Dungeon | Daily | 1-day quest | Standard daily challenge; scales to level |
| Red Gate | Weekly | 3–7 day quest | Sealed until boss objective is complete; high stakes |
| Double Dungeon | Bi-weekly | Variable | Two-phase challenge with twist at midpoint |
| Instant Dungeon | Triggered | 1–4 hours | Urgent quest; context-triggered opportunity |
| Demon Castle | Rank S only | 100 floors | Ultimate endgame; each floor = 1 day of excellence |

### 10.2 Dungeon Mechanics

- **Scaling:** Dungeons dynamically scale to player level [^301^]
- **Floor System:** Each "floor" represents one quest or challenge within the dungeon
- **Boss Battles:** Final floor always features a boss requiring peak performance
- **Party System:** Some dungeons allow inviting 1–2 friends for collaborative completion (social obligation driver)
- **Leaderboards:** Dungeon clear times ranked against similar-level players

### 10.3 Boss Battle Design

Bosses represent major real-life milestones (marathon, exam, project launch):

| Element | Game Equivalent | Real-Life Mapping |
|---------|----------------|-------------------|
| Boss HP | Total milestone effort | Hours/days of work required |
| Attacks | Obstacles | Setbacks, procrastination triggers |
| Weakness | Optimal strategy | Player's strongest stat |
| Defeat reward | Milestone celebration | Achievement + major rewards |

---

## Section 11: Anti-Abuse Mechanics

### 11.1 Exploit Categories & Mitigations

| Exploit | Mitigation | Implementation |
|---------|-----------|----------------|
| Fake GPS check-ins | Multi-factor verification | Require photo proof + timestamp + GPS + activity detection |
| Bot/automation | Behavioral analysis | Detect inhuman completion patterns; require randomized CAPTCHA |
| Manual false logging | Peer review system | Random audit: flagged logs require evidence |
| XP farming (same quest) | Diminishing returns | Same quest type yields 50% less XP after 3rd completion/day |
| Account sharing | Device fingerprinting | Flag multiple devices on same account within short window |
| Time zone exploitation | Fixed reset time | All daily resets at 5 AM local time; prevents double-dipping |
| Streak gaming (min effort) | Minimum effort threshold | Quests must meet minimum duration/intensity to count |

### 11.2 Verification Methods

- **Photo Evidence:** Timestamped photo for location-based quests
- **Timer Verification:** Minimum active time in app for quest types
- **Accelerometer:** Motion detection for fitness quests
- **Periodic Audit:** Random 5% of completions require additional verification
- **Community Reporting:** Players can flag suspicious activity on leaderboards

### 11.3 Penalty System

| Offense | First Strike | Second Strike | Third Strike |
|---------|-------------|--------------|-------------|
| Minor abuse (questionable logging) | Warning + quest audit for 7 days | 50% XP reduction for 7 days | Temporary ban (7 days) |
| Major abuse (clear automation/faking) | 7-day ban + rank freeze | 30-day ban + stat reset | Permanent ban |

---

## Section 12: Flow State Calibration

### 12.1 Challenge-Skill Balance

ARISE implements dynamic difficulty adjustment following Csikszentmihalyi's Flow Theory [^300^][^307^]:

```
Flow Zone = Challenge Level matches Skill Level
Anxiety Zone = Challenge > Skill (reduce difficulty)
Boredom Zone = Skill > Challenge (increase difficulty)
```

The Eight-Zone Emotional Map [^300^] guides calibration:

| Zone | Skill | Challenge | ARISE Response |
|------|-------|-----------|---------------|
| Apathy | Low | Low | Increase quest significance, add meaning |
| Boredom | High | Low | Increase quest difficulty, add optional challenges |
| Relaxation | High | Low (comfortable) | Maintain; this is recovery mode |
| Worry | Low | Medium-High | Reduce difficulty, add scaffolding |
| Anxiety | Low | High | Emergency reduction; offer support resources |
| Arousal | Medium-High | High (slightly higher) | **Optimal** — maintain current difficulty |
| Control | High | High (skill slightly higher) | **Optimal** — offer optional hard mode |
| Flow | High | High (balanced) | **Peak state** — preserve exact conditions |

### 12.2 Difficulty Calibration Algorithm

The system tracks quest completion patterns:
- Completion rate >90% for 5+ quests → increase difficulty by 10%
- Completion rate <50% for 3+ quests → decrease difficulty by 15%
- Completion rate 60–80% → maintain current difficulty (flow zone)

### 12.3 Flow-Facilitating Features

Per Csikszentmihalyi's nine components of flow [^300^][^309^]:

| Component | ARISE Implementation |
|-----------|---------------------|
| Challenge-skill balance | Dynamic difficulty adjustment |
| Complete focus possible | Do Not Disturb integration during quests |
| Clear goals | Every quest has specific, measurable objective |
| Immediate feedback | Real-time XP/stats updates on completion |
| Effortless despite difficulty | Autonomous quest tracking where possible |
| Sense of autonomy | Player chooses which quests to accept |
| Self-consciousness disappears | Full-screen immersive quest mode |
| Time distorts | Lose track of time in flow — timer optional |
| Intrinsically rewarding | Quest design emphasizes meaning, not just points |

---

## Section 13: Retention Mechanics

### 13.1 Retention Benchmarks by Genre

RPG retention benchmarks from industry data [^322^][^323^]:

| Metric | RPG Average | ARISE Target | Rationale |
|--------|------------|-------------|-----------|
| D1 Retention | 40–60% | 55% | Strong gamified FTUE + Solo Leveling IP appeal |
| D7 Retention | 25–40% | 35% | Streak mechanics + daily quest habit formation |
| D30 Retention | 15–25% | 22% | Deep skill trees + rank progression + social features |

Note: Top 10% games achieve ~40% D1, ~12% D7, ~4% D30 globally [^331^]. ARISE targets exceed top-quartile performance by leveraging RPG-specific depth.

### 13.2 D1 Retention Drivers

- **Streamlined Onboarding:** Get to first quest within 60 seconds [^323^]
- **Early "Wow" Moment:** Show projected Level 100 character potential at start
- **Meaningful First Reward:** Complete first quest → immediate level-up (Level 1→2)
- **First Streak Easy:** Day 1 quest designed for guaranteed completion
- **Try Before Commit:** No account required for first 3 quests (Duolingo model [^403^])

### 13.3 D7 Retention Drivers

- **Staggered Feature Unlocks:** Day 3 = skill tree, Day 5 = first dungeon, Day 7 = title system [^323^]
- **10-Day Streak Threshold:** Research shows reaching a 10-day streak "reduces chances of dropping off substantially" [^403^]
- **Meta-Progression:** Skill trees and rank advancement create long-term goals beyond daily quests
- **Mid-Week Surprises:** Wednesday "lucky drop" events for bonus rewards

### 13.4 D30+ Retention Drivers

- **LiveOps & Events:** Weekly themed events, monthly rank tournaments
- **Social Obligations:** Guild/party system where absence affects teammates [^323^]
- **Demon Castle:** 100-floor endgame providing long-term progression path
- **Milestone Psychology:** 66-day habit formation bonus — research shows "automaticity plateaus on average around 66 days" [^361^][^84^]
- **Collection Completion:** Title collection, skill completion, achievement hunting (CD4: Ownership)

### 13.5 Retention Mechanics That Backfire (Avoided)

Per research on streak dark patterns [^305^][^303^]:

| Dangerous Mechanic | Why It Backfires | ARISE Alternative |
|-------------------|-----------------|-------------------|
| Hard streak reset to zero | Triggers abstinence violation effect; 0.90% return rate | Soft streak with recovery mechanics |
| Shame-based notifications | Creates anxiety, contradicts wellness goals | Duo-style mascot nudges [^49^] |
| Pay-to-recover streak | Undermines intrinsic motivation | Earn-back through extra effort |
| Infinite streak anxiety | Creates compulsion not commitment | Streak display cap at 365+ |

---

## Section 14: Psychological Foundation Summary

### 14.1 Motivation Architecture

| Theory | Application in ARISE | Key Citation |
|--------|---------------------|--------------|
| **Loss Aversion** | Streak mechanics, stat decay prevention | Losses motivate 2x more than equivalent gains [^332^] |
| **Flow Theory** | Dynamic difficulty, clear goals, immediate feedback | Csikszentmihalyi's challenge-skill balance [^300^] |
| **Variable Rewards** | Loot boxes, title drops, random bonus quests | Variable ratio = highest response rates [^363^] |
| **Overjustification Effect** | Informational feedback > controlling rewards | Tangible rewards undermine intrinsic motivation (d=-0.34) [^360^][^167^] |
| **Habit Formation** | 66-day milestone, daily quest loops | Average habit formation = 66 days (range 18–254) [^361^][^83^] |
| **Self-Determination Theory** | Autonomy (choice), Competence (progress), Relatedness (social) | Ryan & Deci's three psychological needs [^167^] |

### 14.2 White Hat vs Black Hat Balance

Per the Octalysis Framework [^300^][^363^]:

**White Hat Core Drives (positive, long-term):**
- CD1: Epic Meaning — "Becoming the best version of yourself"
- CD2: Development — Level-ups, stat growth, skill trees
- CD3: Creativity — Flexible quest design, build customization

**Black Hat Core Drives (urgent, potentially negative):**
- CD6: Scarcity — Limited-time events, rare titles
- CD7: Unpredictability — Loot boxes, random rewards
- CD8: Loss — Streak mechanics, stat decay

**Design Principle:** "Ethical use of operant conditioning is to fire it up early and taper it out fast. Reinforcement schedules are an onboarding and habit-formation tool, not a retention strategy. Systems that try to run on Skinner alone past the first few weeks produce addicts, not fans." [^363^]

---

## Section 15: Implementation Priority

### Phase 1 (MVP): Core Loop
- 5-stat system with decay mechanic
- XP/Leveling to 100
- 3 daily quests with generation algorithm
- E→C rank progression
- Basic title system (10 titles)
- Soft streak with freeze mechanic
- Gold currency + basic store

### Phase 2: Depth
- Full skill tree with 5 branches
- Dungeon system (Normal + Red Gate)
- Boss battle system
- Equipment and inventory
- Blessed/Cursed loot boxes
- Social features (party dungeons)

### Phase 3: Endgame
- Demon Castle (100 floors)
- B→S rank progression
- Legendary titles and capstone skills
- Guild system
- LiveOps and seasonal events
- Full anti-abuse system

---

## References

[^23^]: Solo Leveling System — Daily quest stat point rewards (3 points per daily quest)
[^25^]: Solo Leveling System — Level-up grants +1 all stats + 5 distributable points
[^26^]: "What Is The System in Solo Leveling?" — System components: Stats, Quests, Inventory, Store, Skills; daily quest mechanics; Blessed/Cursed Box system
[^30^]: Solo Leveling Daily Quest Guide — XP values: +10 XP per quest, 40 XP daily max, 100 XP = level up
[^49^]: "Duolingo gamification explained" — Streak wager 14% boost to D14 retention; churn reduced from 47% to 28%
[^83^]: UCL News — "How long does it take to form a habit?" — Average 66 days (Lally et al., 2009)
[^84^]: University of Surrey — "Does it really take 66 days to form a habit?" — Expert interview with Dr. Pippa Lally
[^103^]: Solo Leveling Wiki — Penalty Zone — 4-hour survival in desert with centipedes
[^13^]: Duolingo retention research — 55% Y1 retention via streak + XP mechanics
[^77^]: Trophy.so data — 0.90% return after streak loss without recovery mechanics
[^158^]: Deci, Koestner & Ryan (1999) meta-analysis — Tangible rewards undermine intrinsic motivation
[^167^]: "The Overjustification Effect" — d=-0.34 effect size for tangible rewards on intrinsic motivation
[^290^]: "RPG Stat Systems Explained" — 3-6 stats optimal; soft cap patterns; leveling curves
[^291^]: Royal Road Forums — Tier ranking systems (F-SS) for fantasy
[^292^]: Quora — Origin of F-S ranking system from Japanese grading and video games
[^293^]: RPG Maker Forums — Best practices for level progression
[^294^]: "How do you balance an RPG?" — Linear, quadratic, logarithmic curve design
[^296^]: n8n workflow — Daily habit RPG quest generation by day of week
[^298^]: Reddit r/sololeveling — Level 100 stats page: "Everything was at 10"
[^300^]: "Flow Theory: Csikszentmihalyi's 9 Components" + IntechOpen player progression taxonomy
[^301^]: "Designing Game Economies" — Faucets, sinks, inflation control, EVE Online case study
[^302^]: "Graphs for Player Progression Part II" — Final Fantasy XP curves
[^303^]: "Headspace Gamification Case Study" — 17.19 vs 11.62 days with recovery; 0.90% return rate
[^304^]: "Mihaly Csikszentmihalyi's Flow Theory — Game Design ideas"
[^305^]: "Why streaks backfire and what works" — Professor Game podcast; abstinence violation effect
[^306^]: "Game Economy: Sustainable Resource and Progression System"
[^307^]: "The Flow Theory Applied to Game Design"
[^308^]: RPG Maker Forums — "Skill Tree Theory and Design"
[^309^]: "Designing a Game's Flow"
[^310^]: "The Psychology of Hot Streak Game Design" — UX Magazine
[^311^]: "Game Economy as a Competitive Advantage"
[^312^]: Google Android Developers — "Virtual currency: Sources and Sinks"
[^322^]: "Retention by Game Genre" — RPG D1: 40-60%, D7: 25-40%, D30: 15-25%
[^323^]: "Game Retention Strategies" — Feature unlock staggering; liveOps
[^324^]: "The Psychology of Gamification" — Loss aversion applications
[^325^]: "The True Drivers Of D1, D7, And D30 Retention" — D30 predicts long-term health
[^326^]: StackExchange — RPG inventory implementation patterns
[^327^]: "The Psychology Behind Gamification" — 11 psychological themes
[^328^]: Unreal Engine Forums — RPG inventory system design
[^330^]: RPG Maker Forums — Inventory design variations
[^331^]: "Mobile retention benchmarks 2026" — Top 10%: ~40% D1, ~12% D7, ~4% D30
[^332^]: Wikipedia — Loss aversion (Kahneman & Tversky, 1979)
[^333^]: "The D30+ playbook: 4 ways to boost long-term retention"
[^335^]: Reddit r/sololeveling — Penalty Zone farming discussion
[^336^]: Fiction Horizon — "Solo Leveling: The Penalty Zone Explained"
[^360^]: Deci, Koestner & Ryan (1999) — Meta-analysis: 128 studies, tangible rewards d=-0.40 for free-choice motivation
[^361^]: "Making health habitual" — Automaticity plateau at 66 days; missing occasional opportunities doesn't impair habit formation
[^363^]: "Operant Conditioning & Gamification" — Variable ratio reinforcement; ethical design principles
[^379^]: "The Science of Gacha" — Pity timers, probability mechanics, fairness
[^381^]: "The Psychology of Mystery Box Rewards" — Dopamine anticipation > reward; pity floor as ethical floor
[^382^]: "The User Experience of Gacha Games" — Variable ratio reinforcement; FOMO; sunk cost
[^384^]: GameDev StackExchange — "RPG stats degrading by level" — Math for stat degradation over levels
[^386^]: RPG Maker Forums — "Simpler way to implement stat attrition mechanic" — Mentality deterioration in combat
[^387^]: TV Tropes — "No Stat Atrophy" — Exceptions including D&D age categories, GURPS, BattleTech
[^398^]: "How to Build a Dungeon Crawl" — D&D 4E dungeon design principles
[^400^]: "How Duolingo's Streak Feature Became a $14 Billion Growth Engine" — 600+ experiments; Earn Back mechanic
[^401^]: "Keeping the Streak Alive: The Story of Duolingo" — 10M users with 1+ year streaks; DAU/MAU 37.3%
[^403^]: "How Duolingo reignited user growth" — 10-day streak threshold; 600+ streak experiments
