# ARISE — Implementation Plan
## Solo Leveling Life Gamification System
### Flutter × FastAPI · Android Only

> Version 2.0 — June 2026
> Based on extensive research: 150+ searches, 10 research dimensions, 5,000+ lines of analysis

---

## Table of Contents

1. [Executive Summary](#executive-summary)
2. [Product Vision & Philosophy](#1-product-vision--philosophy)
3. [The Solo Leveling Authenticity Framework](#2-the-solo-leveling-authenticity-framework)
4. [Core Game Loop & RPG Mechanics](#3-core-game-loop--rpg-mechanics)
5. [Goal Taxonomy & Decomposition Engine](#4-goal-taxonomy--decomposition-engine)
6. [Quest System](#5-quest-system)
7. [Notification & Alarm System](#6-notification--alarm-system)
8. [Health & Fitness Integrations](#7-health--fitness-integrations)
   8.1. [Screentime Monitoring System](#77-screentime-monitoring-system)
9. [Penalty & Consequence System](#8-penalty--consequence-system)
10. [Social & Guild System](#9-social--guild-system)
11. [User Onboarding](#10-user-onboarding)
12. [Monetization Strategy](#11-monetization-strategy)
13. [Data Model](#12-data-model)
14. [Technical Architecture](#13-technical-architecture)
15. [API Contract](#14-api-contract)
16. [Development Phases](#15-development-phases)
17. [Risk Assessment & Mitigation](#16-risk-assessment--mitigation)
18. [Competitive Positioning](#17-competitive-positioning)
19. [Appendices](#18-appendices)

---

## Executive Summary

ARISE is a mobile life-gamification application that transforms daily self-improvement into a Solo Leveling RPG experience. Built with Flutter for the Android frontend and FastAPI for the Python backend, ARISE targets an underserved demographic — men aged 18–35 who are inspired by power-progression narratives but lack habit-building tools designed for them. While existing habit trackers (Fabulous, Headway, Finch) predominantly target women aged 25–45 with soft, wellness-oriented aesthetics, ARISE delivers a dark-fantasy, systems-heavy alternative grounded in the most popular anime/manhwa aesthetic of the decade.

The app wraps evidence-based behavioral science inside an immersive Solo Leveling fiction. Users begin as E-Rank Hunters with a holographic System interface that assigns daily quests, tracks five core stats (STR, AGI, VIT, INT, SEN), and progresses through a rank hierarchy from E to National Level. A novel stat-decay mechanic ensures that skills require real-world maintenance, while a recovery-first penalty system transforms failure from a shame spiral into a comeback narrative. The System speaks with clinical authority — cold, precise, slightly ominous, but ultimately invested in the player's growth.

**Key Differentiators:**
- **Solo Leveling IP aesthetic** — The first habit tracker built around the most popular manhwa aesthetic, targeting an underserved male 18–35 demographic
- **Stat Decay mechanic** — A novel RPG system where stats gradually decrease without maintenance; no existing habit app uses this [^384^][^386^]
- **Recovery-first penalty architecture** — Inspired by Hollow Knight's Shade and Dark Souls' bloodstains: consequences are real but recoverable through skill and effort [^492^][^524^]
- **Battle Pass for habits** — The first lifestyle app to implement a seasonal Dungeon Pass, a proven gaming monetization mechanic achieving 8–20% conversion [^253^]
- **AI-powered goal decomposition** — LLM-driven engine that breaks vague life goals into structured quest trees using frameworks matched to goal type (SMART, PACT, WOOP, Backward Design)
- **Screentime monitoring as gameplay** — Integrates Android's UsageStatsManager to transform device usage data into quests, stats, and penalties; no habit app has deeply integrated objective screentime data with RPG mechanics [^772^][^773^]
- **Un-ignorable notification system** — Native Kotlin alarm service with full-screen takeovers, escalation matrices, and OEM-specific reliability workarounds
- **Privacy-first social system** — Guilds of 2–10 members with anonymous global leaderboards; no public profiles, no failure broadcasting, no toxicity vectors

**Target Market:** Men aged 18–35, underserved by current habit apps which predominantly target women 25–45. This demographic represents 46.29% of mobile game revenue and shows strong affinity for power-progression narratives [^734^][^725^].

**Market Size:** The global habit tracking app market was valued at $1.7B in 2024 and is projected to reach $5.5B by 2033, growing at a 14.2% CAGR [^231^][^237^]. Within this, gamified self-improvement and battle pass monetization represent the highest-growth subsegments — battle passes achieve 8–20% conversion versus 1–5% for traditional in-app purchases [^253^].

---

## 1. Product Vision & Philosophy

### 1.1 Core Concept

ARISE answers a single question: *What if your life were a Solo Leveling RPG?*

Every real-world action — every workout, every hour of deep work, every meditation session, every dollar saved — becomes a quest completed. Every quest grants XP, stat points, and gold. Every level-up makes you visibly stronger. Every missed day triggers consequences delivered with the System's cold gravitas. And every comeback from failure earns you the title *Phoenix* — because in ARISE, failure is not the opposite of success; it is part of the progression.

The product exists at the intersection of three forces:
- **Narrative power**: Solo Leveling is the most-watched anime of 2024 and the best-selling manhwa of its generation. Its System interface — holographic blue panels, clinical notifications, brutal honesty wrapped in beauty — is instantly recognizable to tens of millions of fans.
- **Behavioral science**: BJ Fogg's MAP model, Csikszentmihalyi's Flow Theory, Self-Determination Theory, loss aversion, variable rewards, and the overjustification effect inform every mechanic [^634^][^300^][^167^].
- **Market gap**: No habit app combines deep RPG mechanics with a dark-fantasy aesthetic targeting men. Habitica comes closest but uses 8-bit pixel art and lacks modern mobile UX. ARISE fills the void.

### 1.2 Design Pillars (5 Pillars)

| Pillar | Principle | Implementation |
|--------|-----------|----------------|
| **Severity with Beauty** | The System is clinical and authoritative but visually stunning | Dark UI with luminous cyan accents; beauty offsets harshness, creating addictive visual tension [^340^][^383^] |
| **The System Doesn't Ask — It Informs** | Declarative statements, not questions | "The daily quest has arrived." Not "Would you like to complete a quest?" [^23^] |
| **Every Pixel Earns Its Place** | Dark UI avoids clutter; breathing room is as important as content | Generous whitespace; each glow, particle, and animation serves a purpose [^383^] |
| **Data is Alive** | Numbers animate on change; HP bars deplete with urgency; progress fills with momentum | StatIncrement animation: translateY bounce + color flash (white to gold to white) [^23^] |
| **Accessibility is Non-Negotiable** | The System is for everyone | WCAG AA minimum (4.5:1 contrast); AAA preferred (7:1); high-contrast mode available; reduced-motion support [^343^][^346^] |

### 1.3 The Tone — "The System Speaks"

The System's voice is the product's soul. It is:
- **Formal and direct**: "The daily quest has arrived. Complete it before midnight."
- **Slightly ominous but ultimately supportive**: "Your performance has declined 34% over the past 7 days. This is not acceptable. This is not permanent."
- **Clinically precise**: Uses game-mechanical terms (stats, XP, ranks, protocols) mixed with epic framing
- **Never cruel**: The System wants the player to succeed. It intervenes when the player struggles.
- **Never cheesy**: No "You're amazing! Crush it!" No forced positivity. Cold precision with subtle warmth.

**Notification Copy Examples:**

| Context | Copy |
|---------|------|
| Daily quest assigned | "[NOTIFICATION] The daily quest has arrived. Your VIT has shown steady improvement over the past 14 days. Today's quest is calibrated to your demonstrated capability. Execute." |
| Streak at risk | "Your chain weakens. 3 hours remain. The System believes in your capacity. It is time you believed too." |
| Level up | "[LEVEL UP] You have grown stronger. The path to S-Rank remains immeasurable. But immeasurable is not impossible." |
| Penalty warning | "[WARNING] Penalty Protocol engaged. The path darkens. But you have walked this way before." |
| Slump recovery | "The System does not abandon Players who struggle. The System intervenes." |

### 1.4 Target User Personas

**Persona 1: The Struggling Starter (Age 18–22)**
- University student or early career, watches anime, has tried habit apps but abandoned them
- Motivated by power fantasies, struggles with consistency
- Needs: small starting quests, recovery-first design, identity transformation
- Behavioral cue: Skips onboarding questions → System enables "easy mode" quests

**Persona 2: The Growth-Oriented Professional (Age 23–30)**
- Works in tech/finance/creative fields, consumes self-improvement content, exercises irregularly
- Wants to optimize body, mind, and career simultaneously
- Needs: goal decomposition, calendar integration, multi-domain tracking
- Behavioral cue: Completes all onboarding + signs Pact immediately → standard difficulty

**Persona 3: The Discipline Seeker (Age 26–35)**
- Has experienced success in one domain (e.g., career) but neglected others (health, relationships)
- Responds to structured challenge, enjoys competitive elements
- Needs: difficulty calibration, guild system, dungeon challenges
- Behavioral cue: Creates habits but doesn't log stats → shifts focus to streaks

**Persona 4: The Solo Leveling Superfan (Age 16–28)**
- Deep familiarity with the IP, has played Solo Leveling: ARISE game, active in fandom communities
- Will evangelize the product if it respects the source material
- Needs: authentic System experience, accurate lore implementation, Shadow Army features
- Behavioral cue: Explores all features immediately → unlocks advanced features early

### 1.5 Success Metrics

| Metric | Target | Benchmark Source |
|--------|--------|-----------------|
| D1 Retention | 40% | Top-quartile H&F: 40–45% [^644^] |
| D7 Retention | 20% | Gamified apps: 25–40% above category [^264^] |
| D30 Retention | 10% | Top 10% apps: 10.9% [^264^] |
| D90 Retention | 7% | Social features boost 3–5x [^677^] |
| Onboarding completion | >80% | Industry: 33% activation [^703^] |
| Free-to-paid conversion | 5–8% | Habit tracker category: 7.3% [^671^] |
| Dungeon Pass purchase rate | 12–15% | Gaming BP: 8–20% [^253^] |
| Target LTV | $80–120 | Blended across segments |
| LTV:CAC ratio | 3:1 | Industry healthy benchmark [^665^] |
| Avg Revenue Per User (Year 3) | $22/year | Comparable to Strava/Fabulous |

---

## 2. The Solo Leveling Authenticity Framework

### 2.1 Visual Language

#### Color Palette with Hex Codes

**Core Background Colors:**

| Color Name | Hex | Usage |
|------------|-----|-------|
| System Black | `#000000` | Deepest background, void space behind System panels |
| Void Navy | `#030712` | Primary app background — Penalty Zone "sky like black ink" [^103^] |
| Deep Abyss | `#0B1426` | Secondary background, card surfaces, System panel base |
| Slate Surface | `#111827` | Elevated surfaces, modals, inventory grid cells |
| Panel Fill | `#162032` | Active states, selected items, hover backgrounds |

**Holographic Blue/Cyan Spectrum (Primary Accent):**

| Color Name | Hex | Usage |
|------------|-----|-------|
| Holographic Cyan | `#00E5FF` | Primary accent — neon borders, active buttons, scan lines [^1^][^6^] |
| System Blue | `#2196F3` | Secondary accent — links, interactive elements |
| Deep Cyan | `#0097A7` | Tertiary accent — dividers, subtle highlights |
| Aether Blue | `#4FC3F7` | Glow effects, particle accents, soft highlights |
| Frost Edge | `#80DEEA` | Border highlights, hover glows, edge illumination |

**Status & Accent Colors:**

| Color Name | Hex | Usage |
|------------|-----|-------|
| Arise Gold | `#FFD700` | Premium elements, S-Rank badges, legendary items, level-ups [^287^] |
| Shadow Gold | `#FFB300` | Secondary gold — progress bars, achievements |
| HP Crimson | `#FF1744` | Health bars, danger warnings, penalty alerts |
| Alert Red | `#FF3D00` | Critical notifications, failure states, emergency takeover [^399^] |
| Success Green | `#00E676` | Quest completion, stat increases, positive feedback |
| MP Azure | `#2979FF` | Mana/energy bars, magic-related UI elements |

**Gate Color System:**

| Color Name | Hex | Usage |
|------------|-----|-------|
| Gate Blue | `#00B0FF` | Normal gates, standard dungeon portals, B-C rank content |
| Gate Red | `#FF1744` | Red Gates, danger warnings, trapped-state alerts [^399^] |
| Gate Purple | `#E040FB` | S-Rank gates, endgame content, Monarch-related events |
| Gate Amber | `#FFC400` | A-Rank gates, high-tier warnings |

**Text Colors:**

| Color Name | Hex | Usage |
|------------|-----|-------|
| Pure White | `#FFFFFF` | Primary headings, critical data, HP/MP values |
| System Silver | `#B0BEC5` | Secondary text, descriptions, stat labels |
| Muted Ash | `#78909C` | Tertiary text, timestamps, disabled states |
| Bracket Cyan | `#00E5FF` | `[Notification]` brackets, system command text |

#### Typography System

| Font Family | Usage | Fallback Stack | Weight |
|-------------|-------|----------------|--------|
| JetBrains Mono | Stat values, HP/MP numbers, countdown timers, data displays | `'JetBrains Mono', 'Fira Code', monospace` | 400, 700 |
| Share Tech Mono | System notifications, bracketed `[Notification]` text, command prompts | `'Share Tech Mono', 'IBM Plex Mono', monospace` | 400 |
| Inter | Body text, descriptions, quest details, readable content | `'Inter', 'Roboto', sans-serif` | 400, 500, 600 |
| Orbitron | Section headers, rank displays, dramatic titles (sparingly) | `'Orbitron', 'Rajdhani', sans-serif` | 500, 700, 900 |

**Type Scale:**

| Token | Size | Weight | Font | Usage |
|-------|------|--------|------|-------|
| Display | 36–48sp | 700/900 | Orbitron | Level-up announcements, rank titles, "ARISE" command |
| Header | 24–28sp | 600 | Inter | Screen titles, quest names, section headers |
| Subheader | 18–20sp | 500 | Inter | Panel titles, category labels |
| Body | 16sp | 400 | Inter | Descriptions, quest text, general content |
| Data | 16–20sp | 700 | JetBrains Mono | Stat values (STR: 97), HP/MP numbers, timers |
| Caption | 12–14sp | 400 | JetBrains Mono | Labels, timestamps, small data |
| System | 14sp | 400 | Share Tech Mono | `[Notification]` brackets, system messages |
| Button | 14–16sp | 600 | Inter | CTA text, action buttons |

#### Animation Specifications

| Animation | Duration | Easing | Description |
|-----------|----------|--------|-------------|
| GlitchAppear | 300–400ms | steps(5) | clip-path flicker + translateX + opacity for System materialization [^378^][^385^] |
| HologramFlicker | 2–3s loop | ease-in-out | Opacity oscillation (0.85 to 1.0 to 0.9) + subtle brightness filter [^382^] |
| ScanLineReveal | 400–600ms | cubic-bezier(0.4, 0, 0.2, 1) | translateY wipe with scanline overlay pattern [^378^] |
| DataStream | 6–8s loop | ease-in-out | Background-position shift on oversized gradient layer [^378^] |
| TypewriterText | 30ms/char | linear | Terminal typewriter effect for System messages |
| PanelMaterialize | 250ms | cubic-bezier(0.4, 0, 0.2, 1) | scale 0.95 to 1.0 + opacity 0 to 1 + border-glow pulse |
| StatIncrement | 200ms | ease-out | translateY bounce + color flash (white to gold to white) |
| QuestPopup | 350ms | spring(damping: 15) | slideIn from top + opacity + border-glow pulse [^6^] |
| WarningPulse | 1.5s loop | ease-in-out | scale 1.0 to 1.02 to 1.0 + red glow oscillation [^102^] |
| ShadowExtract | 500–800ms | ease-out | Particle burst for "Arise" shadow extraction moment [^101^][^106^] |

#### Layout Grid System

| Screen Type | Layout | Key Elements |
|-------------|--------|--------------|
| Status Window | Centered modal, ~85% width, holographic border, dark translucent background | HP/MP bars, stat grid (STR/AGI/VIT/INT/SEN), level display, rank badge [^4^] |
| Notification Popup | Centered dialog, ~75% width, bracketed header `[Notification]`, Yes/No buttons | Warning icon, clinical message, countdown timer, accept/decline actions [^6^] |
| Quest Panel | Slide-in from top, full-width header with `[Quest]` label, expandable details | Quest title, goal checklist (0/100), reward preview, penalty warning [^7^] |
| Inventory Grid | Scrollable grid, 3–4 columns, item slots with cyan borders, category tabs | Equipment/Consumables/Materials tabs, item cards, gold display [^5^] |
| Rank Badge | Floating chip, hexagonal shield shape, letter grade centered | E/D/C/B/A/S letter, color-coded border, subtle glow matching rank tier [^24^] |

**Layout Rules:**
- All System panels have holographic cyan borders (1–2px solid with outer glow: `box-shadow: 0 0 20px rgba(0,229,255,0.3)`) [^378^]
- Padding: 16dp (mobile), 24dp (tablet) [^339^]
- Border radius: 8–12dp panels, 4dp buttons, 50% circular elements
- Spacing: 12dp between stat rows, 24dp between sections

#### Iconography Standards

| Icon Category | Style | Size | Color Treatment |
|---------------|-------|------|-----------------|
| Rank Badges | Hexagonal shield with letter (E-S), geometric angular edges | 32–48dp | E: #78909C, D: #4CAF50, C: #2196F3, B: #9C27B0, A: #FF9800, S: #FFD700 with glow [^24^] |
| Gate/Dungeon | Circular swirling portal with energy tendrils, concentric rings | 48–64dp | Normal: Gate Blue, Red Gate: Gate Red with crack overlay, S-Rank: Gate Purple [^2^][^399^] |
| Stats | Minimal line icons — dumbbell (STR), wing (AGI), heart (VIT), brain (INT), eye (SEN) | 20–24dp | Holographic Cyan active, System Silver inactive [^4^] |
| Items | Flat + subtle glow, silhouette-based with cyan accent for magical items | 40–48dp | Grayscale base + Aether Blue glow for magical, Arise Gold for legendary |
| Status Effects | Small circular badges with symbolic icons | 16–20dp | Red negative, green positive, gold special |

**Icon Rules:** 2px consistent stroke width [^339^]; active states include cyan glow (`box-shadow: 0 0 8px rgba(0,229,255,0.4)`) [^378^]; S-Rank items use pulsing gold glow; 48dp minimum touch targets [^46^].

### 2.2 System Mechanics from the Manhwa

#### Quest Types (Authentic to Solo Leveling)

| Quest Type | Source Reference | ARISE Adaptation | Frequency |
|------------|-----------------|------------------|-----------|
| Daily Quests | Jin-woo's daily: push-ups, sit-ups, squats, running [^348^][^340^] | 3 physical/mental training tasks assigned every 24h | Every day at 6:00 AM local |
| Penalty Quests | Survival penalty in desert with centipedes [^31^][^25^][^103^] | Recovery quest after missed daily — harder but achievable within 24h | Triggered on miss |
| Main Quests | Story-driven objectives (e.g., Job Change Quest) [^25^] | Long-term goals (30+ day projects) derived from user's declared objectives | 1 active at a time |
| Urgent Quests | Emergency Quests triggered by external events [^31^] | Pattern-detected emergencies: slump, burnout, sedentary alert, deadline threat | 0–1 per week |
| Job Change Quest | Special dungeon to unlock new class [^406^][^407^] | Domain mastery challenge to unlock advanced skill trees | At rank thresholds |
| Side Quests | Optional exploration challenges | Optional challenges, experiments, curiosity-driven tasks | 0–2 per day |

#### Stat System (5 Core Stats)

Solo Leveling's original five-stat framework (STR/AGI/VIT/INT/SEN) [^23^][^26^] is preserved with real-life domain mappings. All stats begin at 10, matching Jin-woo's Day 1: "Everything was at 10, with HP being the standard 100" [^298^].

| Stat | Name | Real-Life Domain | Starting Value |
|------|------|-----------------|---------------|
| STR | Strength | Physical Fitness — weightlifting, sprinting, high-intensity training | 10 |
| AGI | Agility | Movement & Flexibility — running, yoga, sports, mobility | 10 |
| VIT | Vitality | Health & Wellness — endurance, sleep, nutrition, recovery | 10 |
| INT | Intelligence | Knowledge & Skills — learning, reading, professional development | 10 |
| SEN | Sense | Mindfulness & Awareness — meditation, journaling, emotional regulation | 10 |

#### Rank System (E to S + National Level)

The Japanese F-to-S rank system used in Solo Leveling [^291^][^292^]:

| Rank | Color | Level Required | Quest Requirement | Ceremony |
|------|-------|---------------|-------------------|----------|
| E | Gray | 1 | Complete tutorial | Starting rank |
| D | Green | 5 | Complete 5 daily quests | "Awakening" — System acknowledges potential |
| C | Blue | 20 | 30-day streak in one domain | "Recognition" — Visual aura unlocked |
| B | Purple | 30 | Complete Rank B trial quest | "Ascension" — Title slot expansion, new dungeon tier |
| A | Gold | 50 | Master all 5 stats to 50+ | "Radiance" — Golden profile border, legendary access |
| S | Red | 70 | Complete Demon Castle Floor 50 | "Monarch" — Custom title creation, S-rank aura |
| National Level | ??? | 100 (Ascension) | Hidden condition | Hidden |

**Per-Domain Ranks:** Each stat domain has its own sub-rank (e.g., "B-rank Strength, C-rank Intelligence"). Overall rank = lowest of five sub-ranks, preventing hyper-specialization.

#### Penalty Zone Mechanic

In the manhwa, missing daily quests teleports Jin-woo to a desert "where endless fields of sand stretch to the horizon" with "Poison-fanged Giant Sand Centipedes" for 4 hours [^103^]. In ARISE, this becomes:

| Consecutive Misses | Consequence |
|-------------------|-------------|
| 1st miss | Warning notification; quest remains available for 24h |
| 2nd miss | "Weak Penalty Zone" — 2x stat decay for 1 week |
| 3rd miss | "Penalty Zone" — 3x stat decay + lose 5% of accumulated gold |
| 4th+ miss | "Deep Penalty Zone" — 4x decay + reduced quest rewards (50%) for 1 week |

#### Dungeon Types

| Dungeon Type | Access | Duration | Description |
|-------------|--------|----------|-------------|
| Normal Dungeon | Daily | 1-day quest | Standard daily challenge; scales to level |
| Red Gate | Weekly | 3–7 day quest | Sealed until boss objective complete; high stakes |
| Double Dungeon | Bi-weekly | Variable | Two-phase challenge with twist at midpoint |
| Instant Dungeon | Triggered | 1–4 hours | Urgent quest; context-triggered opportunity |
| Demon Castle | Rank S | 100 floors | Ultimate endgame; each floor = 1 day of excellence [^64^] |

#### Title/Buff System

Titles function as passive bonuses earned through specific achievements [^26^]:

| Title | Unlock Condition | Buff Effect | Rarity |
|-------|-----------------|-------------|--------|
| Early Bird | Complete 10 quests before 7 AM | +10% XP on morning quests | Common |
| Iron Will | Maintain 30-day streak | Streak freeze charges: +1/week | Uncommon |
| Wolf Slayer | Complete 50 strength quests | +5% STR effectiveness | Uncommon |
| Phoenix | Return after 14-day absence and complete 7 quests | +10% XP for 7 days after comeback | Rare |
| Dungeon Crawler | Clear 10 dungeons | Dungeon XP +15% | Uncommon |
| The Unbroken | 365-day streak | All decay reduced by 50% | Legendary |
| True Awakening | Reach Level 100 | All stats +5%, aura unlock | Mythic |

#### Store & Inventory

- **Blessed Random Box (200 Gold):** Gives the player an item they *want* (based on equipped build)
- **Cursed Random Box (200 Gold):** Gives the player an item they *need* (based on lowest stats) [^26^]
- **Item Categories:** Consumables (one-time use), Equipment (passive bonuses), Materials (crafting), Loot Boxes, Quest Items
- **Rarity Tiers:** Common (60%) to Uncommon (25%) to Rare (10%) to Epic (4%) to Legendary (1%)
- **Pity System:** Every 10 opens guarantees Rare; every 50 guarantees Epic; every 100 guarantees Legendary [^379^][^381^]

### 2.3 Key Phrases & Tone of Voice

#### How the System Communicates

**Core Communication Rules:**
1. Always use declarative statements, never questions
2. Reference player data (stats, trends, history) for personalization
3. Cold precision mixed with subtle warmth
4. Epic framing: the player is on a heroic journey
5. Never cruel; never cheesy

**Notification Copy Examples by Category:**

| Category | Example |
|----------|---------|
| Daily Quest | "[DAILY QUEST ASSIGNED] Quest: Zone 3 Threshold Run. Difficulty: C-Rank. Your HRV (72 ms) indicates adequate recovery. This quest is within your capacity. Execute." |
| Level Up | "[LEVEL UP] You have grown stronger. +1 all base stats. +5 distributable points. The gap between you and S-Rank... has narrowed." |
| Penalty Warning | "[WARNING] Penalty Protocol engaged. Your streak has paused. Life happens. Your neural pathways are still there — ready when you are." |
| Rank Up | "[RANK UP] D-Rank achieved. The System acknowledges your potential. You are no longer the weakest Player. But the gap between D and S... is still immeasurable." |
| Urgent Quest | "[URGENT QUEST] The System has detected an anomaly. Your performance has declined 34% over 7 days. This is not acceptable. This is not permanent. The System intervenes." |

#### Escalation Language Patterns

| Urgency Level | Tone | Example Opening |
|---------------|------|-----------------|
| Calm (routine) | Informative, neutral | "[NOTIFICATION] Your daily quest has arrived." |
| Firm (warning) | Direct, consequence-named | "[WARNING] 3 hours remain. Your daily quest is incomplete." |
| Urgent (deadline) | Command, time-critical | "[URGENT] 1 minute. Execute or face consequences." |
| Nuclear (missed) | Loss-aversion, recovery-framed | "[QUEST FAILED] Your streak has paused. The path to recovery is one tap away." |

---

## 3. Core Game Loop & RPG Mechanics

### 3.1 The 5 Core Stats

Each stat: name, description, real-life domain mapping, starting value, growth formula, decay rules.

| Stat | Name | Description | Domain | Start | Growth | Decay |
|------|------|-------------|--------|-------|--------|-------|
| **STR** | Strength | Raw physical power | Weightlifting, sprinting, HIIT | 10 | +1 per level-up + quest rewards | -1 point per 7 days inactivity (floor: Level + 5) |
| **AGI** | Agility | Speed, coordination, mobility | Running, yoga, sports | 10 | +1 per level-up + quest rewards | -1 point per 7 days inactivity (floor: Level + 5) |
| **VIT** | Vitality | Endurance, recovery, health | Sleep, nutrition, wellness | 10 | +1 per level-up + quest rewards | -1 point per 7 days inactivity (floor: Level + 5) |
| **INT** | Intelligence | Learning, reasoning, skill acquisition | Reading, courses, deep work | 10 | +1 per level-up + quest rewards | -1 point per 7 days inactivity (floor: Level + 5) |
| **SEN** | Sense | Mindfulness, awareness, emotional regulation | Meditation, journaling, relationships | 10 | +1 per level-up + quest rewards | -1 point per 7 days inactivity (floor: Level + 5) |

**Growth on Level-Up:**
- +1 to ALL five base stats (automatic) [^26^]
- +5 distributable stat points (player choice) [^23^][^25^]

**Soft Cap Pattern** (prevents game-breaking stat stacking [^290^]):

| Stat Range | Multiplier | Description |
|-----------|-----------|-------------|
| 1–50 | 1.0x (full value) | Linear growth |
| 51–80 | 0.7x (reduced) | Diminishing returns begin |
| 81–100 | 0.4x (significantly reduced) | Specialization requires heavy investment |
| 101–150 | 0.1x (minimal) | Soft cap; prestige investment only |

**Stat Scaling Formula:**
```
effectiveness(stat) = base_value * (1 + ln(stat/10) * 0.3)
```
This logarithmic curve starts with large early gains but tapers off — "easy to learn, hard to master" [^294^].

### 3.2 Derived Stats

| Derived Stat | Formula | Description |
|-------------|---------|-------------|
| HP (Health Points) | VIT x 10 | Overall life balance; damage taken when neglecting wellness |
| Energy | (VIT + AGI) / 2 x 10 | Daily action pool for completing quests |
| Focus | (INT + SEN) / 2 | Affects quality of work/study session rewards |
| Carry Weight | STR x 5 + 50 | Inventory capacity in units |

### 3.3 XP & Leveling System

**Exponential Curve Formula:**
```
XP_required(level) = 100 * (level ^ 1.5)
```
Level cap: 100 (matching Solo Leveling's level cap) [^26^][^298^].

**XP Table (Key Milestones):**

| Level | XP Required | Total XP | Key Reward |
|-------|------------|----------|------------|
| 1 | 100 | 100 | Starting character, 5 stat points |
| 2 | 283 | 383 | +1 all stats, +5 points, 1st skill slot |
| 5 | 1,118 | 3,215 | **Rank D unlock** |
| 10 | 3,162 | 14,337 | Skill tree branch unlock, title slot +1 |
| 20 | 8,944 | 62,439 | **Rank C unlock**, dungeon access tier 2 |
| 30 | 16,432 | 159,548 | **Rank B unlock**, title slot +1 |
| 50 | 35,355 | 557,721 | **Rank A unlock**, mastery quest |
| 70 | 58,583 | 1,225,197 | **Rank S quest eligibility** |
| 90 | 85,317 | 2,184,374 | **Rank S unlock**, legendary title |
| 100 | 100,000 | 2,783,333 | **Level cap — Ascension unlock** |

**XP Sources:**

| Source | Base XP | Notes |
|--------|--------|-------|
| Daily Quest (easy) | 50 | Low-difficulty habit quest |
| Daily Quest (medium) | 100 | Standard daily quest |
| Daily Quest (hard) | 200 | Challenging daily quest |
| Weekly Quest completion | 500 | Sustained effort reward |
| Boss Battle milestone | 250–2,000 | Scales with boss difficulty |
| Dungeon clear | 100–1,000 | Based on tier and clear time |
| Skill first activation | 25 | One-time per new skill |
| Title earned | 100–500 | Scales with title rarity |
| Streak milestone (7d) | 150 | Weekly streak bonus |
| Streak milestone (30d) | 500 | Monthly streak bonus |
| Streak milestone (66d) | 1,000 | Habit formation bonus [^84^][^361^] |
| Rank-up | 1,000–5,000 | Scales with rank tier |

**Anti-Grinding Measures:**
- Daily XP Cap: 500 XP/day from quests (excess grants 10% XP)
- Same quest type repeated >3x/day: 50% less XP each time
- Weekly Soft Cap: After 2,000 XP/week, all sources grant 50% less
- New quest types/locations: 1.5x XP first-time bonus

**Level-Up Rewards:**
- +1 to all 5 base stats (automatic)
- +5 distributable stat points
- Gold reward: 50 x level
- Visual: Gold flash fills screen → "LEVEL UP" in Orbitron → stat window materializes

### 3.4 Rank Progression System

**Rank-Up Criteria:**

| Rank | Level Required | Quest Requirement | Stat Minimum | Ceremony |
|------|---------------|-------------------|--------------|----------|
| E | 1 | Complete tutorial | None | Starting rank |
| D | 5 | Complete 5 daily quests | None | "Awakening" — System acknowledges potential |
| C | 20 | 30-day streak in one domain | All stats >= 15 | "Recognition" — Visual aura unlocked |
| B | 30 | Complete Rank B trial quest | All stats >= 25 | "Ascension" — Title slot expansion |
| A | 50 | Master all 5 stats to 50+ | All stats >= 50 | "Radiance" — Golden profile border |
| S | 70 | Complete Demon Castle Floor 50 | All stats >= 65 | "Monarch" — Custom title creation |

**Rank Benefits:**

| Rank | Daily Quests | Stat Points/Lvl | Gold Multiplier | Dungeon Tiers | Title Slots |
|------|-------------|----------------|----------------|---------------|-------------|
| E | 2 | 5 | 1.0x | 1 | 1 |
| D | 3 | 5 | 1.2x | 1 | 1 |
| C | 3 | 6 | 1.5x | 2 | 2 |
| B | 4 | 6 | 2.0x | 2 | 2 |
| A | 4 | 7 | 2.5x | 3 | 3 |
| S | 5 | 8 | 3.0x | 4 | 4 |

**Rank Loss Mechanics:**
- Can drop divisions (e.g., Gold I to Gold II) but never below highest tier achieved [^440^]
- Tier protection: Once a tier is reached, it is permanent for the season
- Demotion after 3 losses at 0 division points OR 7 days inactivity at lowest division
- Rank Shields: 2 shields upon promoting to new tier — losses consume shields instead of demoting [^449^]
- "Anchor Stone": Earned item preventing one demotion; max 1 held; earned by maintaining tier for 30 days

**Rank-Up Ceremonies:**
- Visual: Profile border color changes to match new rank
- System Message: Personalized congratulatory message referencing specific achievements
- Reward: Rank-appropriate stat points, currency, and unlocks
- Social: Optional share to social media (leveraging social proof)

### 3.5 Title System

**Title Categories:**

| Category | Description | Example |
|----------|-------------|---------|
| Combat | Fitness and physical achievement | "Wolf Slayer" — +5% STR against endurance challenges |
| Knowledge | Learning and intellectual | "Scholar" — +5% XP from study quests |
| Discipline | Consistency and habit | "Unbroken" — Streak decay resistance +20% |
| Exploration | Trying new things | "Pathfinder" — New quest types give 1.5x XP |
| Social | Community and accountability | "Mentor" — Both parties gain bonus when questing together |
| Legendary | Extreme achievements | "Dragon Slayer" — All stats +3% |

**Sample Titles (Full Catalog):**

| Title | Unlock Condition | Buff Effect | Rarity |
|-------|-----------------|-------------|--------|
| Early Bird | 10 quests before 7 AM | +10% XP on morning quests | Common |
| Iron Will | 30-day streak | Streak freeze: +1/week | Uncommon |
| Wolf Slayer | 50 strength quests | +5% STR effectiveness | Uncommon |
| Scholar | Read 20 books via reading quests | +5% INT XP gain | Uncommon |
| Night Owl | 10 quests after 10 PM | +10% XP on evening quests | Common |
| Jack of All Trades | All stats reach 25 | +2% all stat XP gain | Rare |
| Phoenix | Return after 14-day absence, complete 7 quests | +10% XP for 7 days post-comeback | Rare |
| Dungeon Crawler | Clear 10 dungeons | Dungeon XP +15% | Uncommon |
| Monarch's Heir | Reach S-Rank | Custom title creation unlocked | Legendary |
| The Unbroken | 365-day streak | All decay reduced by 50% | Legendary |
| True Awakening | Reach Level 100 | All stats +5%, aura unlock | Mythic |

**Title Mechanics:**
- Equip Limit: 1 title per title slot (unlocked via rank progression)
- Passive Always Active: Titles provide passive buffs when equipped
- Title Collection: All earned titles visible in collection interface (Core Drive 4: Ownership) [^300^]
- Hidden Titles: Some titles have secret unlock conditions for discovery moments

### 3.6 Currency & Economy

**Dual-Currency System:**

| Currency | Name | Type | Description |
|----------|------|------|-------------|
| Gold | Aria's Gold | Soft (earned) | Standard gameplay currency |
| Essence | Essence Crystals | Hard (premium) | Premium currency for cosmetics/convenience |

**Gold Sources (Faucets):**

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

**Gold Sinks:**

| Sink | Cost Range | Purpose |
|------|-----------|---------|
| Store items (consumables) | 100–500 | Remove currency from economy |
| Equipment purchase | 500–10,000 | Major currency drain |
| Loot boxes (Random Box) | 200 | Variable reward spending |
| Skill respec | 1,000 | Allow build changes |
| Cosmetic customization | 500–5,000 | Vanity spending |
| Streak recovery | 300 | Convenience sink |
| Dungeon retry (after failure) | 100 | Anti-grinding sink |

**Essence Crystal Economy (Premium):**

| Source | Essence | Context |
|--------|---------|---------|
| Perfect quest week (7/7) | 5 | Weekly excellence |
| Rank-up | 10–50 | Milestone reward |
| First-time dungeon clear | 5 | Discovery reward |
| Achievement completion | 2–10 | Trophy hunting |
| Referral (friend joins) | 10 | Viral growth |

**Inflation Control:**
- 5% transaction fee on all Store purchases (hard sink) [^301^]
- Target inflation: 2–5% monthly (healthy MMO range) [^301^]

### 3.7 Inventory System

**Item Categories:**

| Category | Description | Examples |
|----------|-------------|----------|
| Consumables | One-time use items | XP Boost Potion, Streak Freeze Charge, Energy Restore |
| Equipment | Equipped for passive bonuses | Running Shoes (+AGI quests), Study Lamp (+INT quests) |
| Materials | Crafting components | Monster Essence, Dungeon Shards |
| Loot Boxes | Random reward containers | Blessed Box (want), Cursed Box (need) [^26^] |
| Quest Items | Special drops for quests | Boss Tokens, Achievement Badges |

**Item Rarity Tiers:**

| Tier | Color | Drop Rate | Power Level |
|------|-------|----------|-------------|
| Common | White | 60% | +1–3% stat effectiveness |
| Uncommon | Green | 25% | +4–7% stat effectiveness |
| Rare | Blue | 10% | +8–12% stat effectiveness, bonus effect |
| Epic | Purple | 4% | +13–18% stat effectiveness, 2 bonus effects |
| Legendary | Gold | 1% | +20–25% stat effectiveness, unique ability |

**Inventory Capacity:**
- Base: 50 slots
- +5 per 10 STR points (Carry Weight = STR x 5 + 50)
- Can expand via Store purchases: +10 slots for 500 Gold (max 200)

### 3.8 Skill Tree

**5 Branches Mapping to Stats:**

| Branch | Primary Stat | Real-Life Mapping | Playstyle |
|--------|-------------|-------------------|-----------|
| Berserker | STR | High-intensity fitness, powerlifting | Bursty, high reward, higher risk |
| Acrobat | AGI | Running, yoga, sports, movement | Consistent daily gains, flexibility |
| Fortress | VIT | Health optimization, sleep, nutrition | Defensive, reduced decay, sustainability |
| Sage | INT | Deep work, learning, skill acquisition | Late-game scaling, compound returns |
| Empath | SEN | Meditation, journaling, relationships | Support bonuses, group synergy |

**Skill Tree Architecture:**
```
Level 1–10: Core Foundation (linear — all players unlock same base skills)
Level 11–30: Branching Specialization (choose 2 of 5 branches)
Level 31–60: Advanced Mastery (deepen chosen branches)
Level 61–100: Legendary Capstones (unique powerful abilities)
```

**Sample Skills:**

**Passive Skills (always active):**
- "Iron Body" (+10% VIT quest effectiveness) — Fortress branch
- "Quick Learner" (+15% INT XP from first quest of the day) — Sage branch
- "Endurance Runner" (AGI quests cost 10% less Energy) — Acrobat branch

**Active Skills (activated for temporary boost):**
- "Overclock" (2x XP for next quest, 2x Energy cost) — Berserker branch
- "Focus Mind" (Skip cooldown on next dungeon attempt) — Sage branch
- "Second Wind" (Restore 50% HP when below 20%) — Fortress branch

**Real-Life Skill Mapping:**

| RPG Skill | Real-Life Equivalent | Implementation |
|-----------|---------------------|----------------|
| Pomodoro | Time-boxed work sessions | 25-minute focus timer quest |
| Progressive Overload | Strength training principle | Increasing difficulty weekly |
| Habit Stacking | James Clear method | Chain linked quests for bonus |
| Intermittent Fasting | Health protocol | VIT quest variant |
| Active Recall | Learning technique | Quiz-style INT quest |
| Box Breathing | Stress management | 4-minute SEN quest |

### 3.9 Streak Mechanics (Recovery-First Design)

**Three Streak Types:**

| Type | Name | Description |
|------|------|-------------|
| Hard Streak | "Streak Fire" | Consecutive days with >=1 quest completed; displayed prominently; drives loss aversion |
| Record | "Best Streak" | Highest streak ever achieved; never decreases; aspirational target |
| Soft Streak | "Weekly Perfection" | Weeks with 7/7 daily completions; separate from daily streak |

**Grace & Recovery Mechanics:**

| Mechanic | Description | Availability |
|----------|-------------|--------------|
| Grace Day | Skip a day without breaking streak | 1 per week (free), accumulates to max 3 [^168^][^430^] |
| Streak Freeze | Auto-activates on first miss; preserves streak for 24h | 1 charge per week (free), +1 per rank |
| Earn Back | Complete 2x daily quests next day to restore broken streak | Once per month [^430^][^435^] |
| Recovery Mode | 3-day "rebuild" quest chain restores bonuses after break | Unlimited |
| Revival Potion | Earned item preventing streak loss; reduces anxiety by existing | Earned (never purchased) [^168^] |

**Key Data:** Apps with freeze/recovery average **17.19 days** on streak past the 7-day mark vs. **11.62 days** without — a 48% improvement [^303^]. Only 0.90% of users who lose a 2–3 day streak return without recovery mechanics [^303^].

**Capped Streak Display:**
- Streaks display as "365+" after 1 year
- Milestone markers replace raw count (1y, 2y, 3y)

**Streak Wager System:**
- Wager currency on maintaining a 7-day streak
- Success: 2x currency return + bonus XP
- Failure: Wagered currency lost
- Inspired by Duolingo: 14% boost in D14 retention [^49^]

**Psychological Safeguards:**
- Never frame a break as failure: "Your streak took a rest day" not "You broke your streak"
- Welcome back rewards: Returning players receive bonus XP (Phoenix title eligibility)
- Progress preservation: Stats, rank, and titles never decay; only raw streak number changes
- Multiple streak types: If Fire breaks, Weekly may still be intact

### 3.10 Stat Decay (Novel Mechanic)

ARISE introduces **stat decay** — no existing life gamification app uses this [^384^][^386^].

**Decay Rules:**
- Each stat decays by 1 point per 7 days of inactivity in that domain
- Decay only applies to stats above: `Level x 1 + 5`
- Decay cannot reduce stats below the level floor
- Decay is calculated weekly, not daily, to reduce user anxiety

**Example:** A Level 20 player with STR 45 skips all fitness quests for 2 weeks:
- Level floor: 20 + 5 = 25
- After 2 weeks: 45 - 2 = 43 (no floor cap hit)
- After 20 weeks: max(45 - 20, 25) = 25

**Psychological Rationale:**
- Creates ongoing engagement without punishing short breaks [^361^]
- Mirrors real life: skills and fitness genuinely decay without maintenance
- Level floor ensures progress is never fully lost — "progress persistence"
- Encourages rotation across life domains rather than hyper-specialization

**Decay Prevention:**
- Completing >=1 quest per week in a stat's domain prevents all decay for that stat
- Weekly "maintenance quests" are lighter versions (50% effort)
- Titles provide decay resistance (e.g., "Iron Will" reduces decay rate by 50%)

### 3.11 Anti-Abuse Measures

**Exploit Categories & Mitigations:**

| Exploit | Mitigation | Implementation |
|---------|-----------|----------------|
| Fake GPS check-ins | Multi-factor verification | Photo proof + timestamp + GPS + activity detection |
| Bot/automation | Behavioral analysis | Detect inhuman completion patterns; randomized CAPTCHA |
| Manual false logging | Peer review system | Random audit: flagged logs require evidence |
| XP farming (same quest) | Diminishing returns | Same quest type yields 50% less XP after 3rd completion/day |
| Account sharing | Device fingerprinting | Flag multiple devices on same account within short window |
| Time zone exploitation | Fixed reset time | All daily resets at 5 AM local time |
| Streak gaming (min effort) | Minimum effort threshold | Quests must meet minimum duration/intensity |

**Trust Tiers:**

| Tier | Data Source | XP | Leaderboard |
|------|------------|-----|-------------|
| Tier 1 (Verified) | Health Connect authenticated source | Full | Eligible |
| Tier 2 (Photo Verified) | Manual entry + photo proof | Full | Eligible |
| Tier 3 (Self-Reported) | Manual entry without proof | 50% | Not eligible |
| Tier 4 (Honor System) | Simple checkboxes | No XP | Progress tracking only |

**Penalty System (Abuse):**

| Offense | First Strike | Second Strike | Third Strike |
|---------|-------------|--------------|-------------|
| Minor (questionable logging) | Warning + 7-day audit | 50% XP reduction for 7 days | 7-day temporary ban |
| Major (automation/faking) | 7-day ban + rank freeze | 30-day ban + stat reset | Permanent ban |

**Verification Methods:**
- Photo Evidence: Timestamped photo for location-based quests
- Timer Verification: Minimum active time in app
- Accelerometer: Motion detection for fitness quests
- Periodic Audit: Random 5% of completions require additional verification
- Community Reporting: Players can flag suspicious activity

---

## 4. Goal Taxonomy & Decomposition Engine

### 4.1 The 12 Life Domains

The taxonomy integrates Pinquart's lifespan goal domains [^7^] and Emmons' WIST taxonomy [^195^] into 12 operational domains:

| # | Domain | Subcategories | Primary Stats | Secondary Stats | Recommended Framework |
|---|--------|---------------|---------------|-----------------|----------------------|
| 1 | **Physical Health** | Cardiovascular fitness, strength, flexibility, sleep, nutrition, weight management, injury rehab | STR, VIT | SEN | SMART + PACT + Fogg MAP |
| 2 | **Mental Health** | Stress management, anxiety reduction, behavioral activation, mindfulness, emotional regulation | SEN, VIT | INT | WOOP + CBT Activation + SUDS |
| 3 | **Intellectual Growth** | Skill acquisition, formal education, reading, critical thinking, language learning | INT | SEN | Backward Design + 12 Week Year |
| 4 | **Career/Work** | Job performance, promotion, career change, side business, productivity, leadership | STR, INT | SEN | OKR + 12 Week Year |
| 5 | **Financial** | Emergency fund, debt payoff, saving, investing, retirement, major purchases | INT | STR | SMART Milestones + PACT |
| 6 | **Relationships** | Romantic partnership, family, friendships, social skills, community, networking | SEN | VIT | HARD + WOOP |
| 7 | **Spirituality** | Religious practice, meditation, meaning-making, values alignment, nature connection | SEN | VIT | HARD + PACT |
| 8 | **Transcendence/Contribution** | Volunteering, mentorship, legacy, generativity, social impact, environmental action | SEN, VIT | INT | HARD + OKR |
| 9 | **Leisure/Recreation** | Hobbies, travel, entertainment, sports, creative play | AGI, VIT | STR | PACT + Temptation Bundling |
| 10 | **Creative Expression** | Writing, music, visual arts, crafting, content creation, performance | INT, SEN | AGI | PACT + Habit Stacking |
| 11 | **Environment/Organization** | Home organization, decluttering, digital organization, workspace optimization | VIT | INT | SMART + Fogg MAP |
| 12 | **Discipline/Willpower** | Habit building, routine adherence, procrastination, focus training, impulse control | SEN, INT | VIT | WOOP + PACT + Fogg MAP |
| 13 | **Digital Wellness** | Screentime reduction, app time limits, focus sessions, morning/evening screen protocols, digital sabbath, social media boundaries, notification hygiene | SEN (primary), INT (secondary), VIT (tertiary) | AGI | PACT + SMART |

**Cross-Domain Goals:** Goals spanning multiple domains receive a "primary" domain and "secondary" stat contributions. Example: "run a marathon for charity" → Physical Health (STR/VIT, 60%) + Transcendence (SEN, 30%) + Financial (INT, 10%).

### 4.2 Goal Decomposition Patterns

**Pattern 1: Achievement/Milestone (e.g., "Save $10,000")**
- Level 1: Define target number and deadline → calculate weekly/monthly rate
- Level 2: Identify milestone checkpoints (25%, 50%, 75%, 100%)
- Level 3: Generate weekly tactics (automated transfers, expense reviews)
- Level 4: Daily micro-action (log expenses, review spending)
- Framework: SMART + 12 Week Year execution scoring [^89^][^314^]

**Pattern 2: Habit/Process (e.g., "Exercise regularly")**
- Level 1: Define purpose (why) → connect to core value
- Level 2: Make it tiny (Fogg: <30 seconds initial version) [^290^][^297^]
- Level 3: Anchor to existing routine (habit stacking) [^352^][^353^]
- Level 4: Binary daily tracking (yes/no) + weekly review
- Framework: PACT + BJ Fogg MAP [^301^][^185^]

**Pattern 3: Behavioral Change (e.g., "Reduce social media use")**
- Level 1: Identify trigger situations (when, where, emotional state)
- Level 2: Design obstacle-response pairs (WOOP: if-then plans) [^113^][^300^]
- Level 3: Reduce friction for desired behavior / increase friction for undesired
- Level 4: Daily trigger tracking + implementation intention review
- Framework: WOOP + Fogg MAP [^119^]

**Pattern 4: Stretch/Aspirational (e.g., "Write a novel")**
- Level 1: Create vivid outcome visualization (HARD: animated) [^321^]
- Level 2: Set 12-week milestone with execution scoring
- Level 3: Decompose into weekly output targets (words, scenes, chapters)
- Level 4: Daily minimum viable action (e.g., "write 50 words")
- Framework: HARD + 12 Week Year + PACT [^314^][^315^]

**Pattern 5: Learning/Skill (e.g., "Learn Spanish to conversational level")**
- Level 1: Define desired end-state performance (Backward Design) [^293^][^299^]
- Level 2: Identify prerequisite knowledge/skills
- Level 3: Create spaced practice schedule (4-6 week mesocycles) [^302^]
- Level 4: Daily micro-learning session
- Framework: Backward Design + PACT + periodization

**Pattern 6: Social/Relationship (e.g., "Have deeper friendships")**
- Level 1: Identify specific relationship(s) to invest in
- Level 2: Define observable proxy behaviors (text frequency, meetups)
- Level 3: Schedule recurring connection rituals
- Level 4: Daily micro-action (send one message, express gratitude)
- Framework: HARD + WOOP [^300^]

**Pattern 7: Mental Health/Fear Hierarchy (e.g., "Overcome fear of public speaking")**
- Level 1: Build fear ladder using SUDS 0-100 scale [^360^][^364^]
- Level 2: Order situations from lowest to highest distress
- Level 3: Progressive exposure: start at SUDS 20–30, advance when habituated 50%
- Level 4: Daily micro-exposure or behavioral activation scheduling [^151^][^369^]
- Framework: CBT Behavioral Activation + WOOP + SUDS tracking

**Pattern 8: Financial Stage (e.g., "Achieve financial independence")**
- Level 1: Identify current financial stage [^367^]
- Level 2: Define next milestone (emergency fund → debt freedom → retirement)
- Level 3: Calculate monthly savings rate needed
- Level 4: Daily spending awareness / weekly budget review
- Framework: SMART milestones + PACT

### 4.3 Framework Selection Logic

**Framework Selection Matrix:**

| Goal Characteristic | Primary Framework | Secondary | Rationale |
|--------------------|--------------------|-----------|-----------|
| Vague aspiration → needs clarity | SMART | — | Translates fuzzy intent into specific target [^362^][^361^] |
| Long-term stretch goal | HARD | — | Emotional connection + vivid visualization [^321^] |
| Process/habit building | PACT | Fogg MAP | Focuses on controllable actions, not outcomes [^301^][^185^] |
| Follow-through / procrastination | WOOP | Implementation intentions | Mental contrasting + if-then plans beat visualization [^300^][^119^] |
| Team/organizational alignment | OKR | — | Vertical and horizontal goal alignment [^390^][^391^] |
| Learning/educational | Backward Design | — | Starts from desired end-state performance [^293^][^299^] |
| High motivation, low ability | Fogg MAP | Facilitator prompts | Reduce behavior complexity below action line [^290^][^295^] |
| Low motivation, high ability | Fogg MAP | Spark prompts | Add emotional resonance / urgency [^294^] |
| Competing priorities | Approach-Avoidance analysis | WOOP obstacle step | Resolve Lewin-style motivational conflict [^305^][^306^] |
| Fear/anxiety-based | CBT + SUDS ladder | WOOP | Graduated exposure prevents overwhelm [^360^][^364^] |
| Burnout / overtraining | Periodization/deload | PACT (gentle) | Strategic recovery produces supercompensation [^302^][^304^] |

**Key Research Insight:** WOOP nearly tripled study hours in a randomized trial (4.3 vs. 1.5 hours, p=.021) [^300^]. Implementation intentions show a medium-to-large effect (d=0.65) on goal achievement across 94 studies [^300^].

### 4.4 Proxy Indicator Library

Abstract goals require translation into measurable proxy behaviors:

| Abstract Goal | Measurable Proxy | Validation |
|--------------|-----------------|-----------|
| "Be more present" | Log 3 mindful moments per day (timestamp + 1-word note) | CBT activity monitoring [^151^] |
| "Be happier" | Daily 0–10 life satisfaction rating + track positive events | OECD well-being guidelines [^408^] |
| "Be more confident" | Log one "mastery moment" daily + weekly SUDS rating | SUDS scale [^360^] |
| "Have better relationships" | Weekly count of initiated meaningful conversations | Pinquart social goals [^7^] |
| "Be more productive" | Track "deep work" hours via time-blocking + daily quest completion | 12 Week Year execution score [^314^] |
| "Reduce stress" | Daily SUDS rating 0–100 + count of completed pleasant activities | Behavioral Activation [^151^] |
| "Be healthier" | Weekly count of vegetable servings + workouts + sleep hours | Pinquart health goals [^7^] |
| "Find meaning" | Weekly log of activities aligned with WIST values [^195^] | Emmons meaning research |
| "Be more creative" | Daily "creative minutes" logged + weekly output count | PACT continuous framework [^301^] |
| "Improve focus" | Daily count of uninterrupted 25-minute blocks (Pomodoro) | Attention measurement research |
| "Be more grateful" | Write 3 specific gratitudes daily (prompted at set time) | Positive psychology intervention research |
| "Build discipline" | Weekly execution score (% of planned tactics completed) | 12 Week Year: 85% threshold [^314^] |

### 4.5 Metric Type Catalog

| Metric Type | Data Collection | Verification | Examples |
|------------|----------------|-------------|----------|
| Boolean | Manual toggle/check-in | Self-report; streak counting | "Did I meditate today?" [^301^] |
| Numeric (count) | Manual entry or sensor | Range validation; trend analysis | Push-ups completed, pages read |
| Numeric (scale) | Slider input (0–10 or 0–100) | Within-session consistency | SUDS anxiety rating [^360^], mood rating |
| Time-based | Timer/stopwatch integration | Session duration validation | Deep work hours, meditation minutes |
| GPS-based | Location services | Geofence entry/exit detection | Gym visits, outdoor runs |
| Heart-rate-based | Wearable integration (HRM) | HR zone duration calculation | Cardio minutes in target zone |
| Photo-proof | Camera capture with timestamp | Image classification (optional) | Meal logging, gym attendance proof |
| Execution score | Tactic completion / planned | Weekly auto-calculation | 12 Week Year % completion [^314^] |
| Streak | Consecutive daily completions | Anti-cheat: max 1 per day | Habit chain length [^352^] |
| Milestone | Achievement unlock on threshold | Automated on reaching threshold | Emergency fund complete, debt free |
| Leading indicator | Tracked input metric | Correlation with lag outcome | Workouts/week → weight loss [^355^][^359^] |
| Lagging indicator | Outcome measurement | Validated assessment | Weight, body fat, life satisfaction [^404^] |

### 4.6 Goal Conflict Resolution

**Three Conflict Types (Lewin's Framework):**

**Type 1: Approach-Approach (Two desirable but mutually exclusive)**
- Example: "Bulk for muscle" vs. "Cut for fat loss"
- Resolution: Sequential phasing — commit to one for 12 weeks, then switch
- System: "Both goals serve your health. Which aligns better with your current season?"

**Type 2: Avoidance-Avoidance (Must choose between two undesirable)**
- Example: "Pay off high-interest debt" vs. "Build emergency fund"
- Resolution: Hybrid approach — 70/30 split until threshold, then reallocate
- System: "The optimal path may be a balanced attack. Set your allocation ratio."

**Type 3: Approach-Avoidance (Single goal has both appealing and unappealing aspects)**
- Example: Desire promotion + fear of increased responsibility
- Resolution: WOOP obstacle confrontation + graduated exposure [^300^]
- System: "The avoidance gradient steepens as you approach the goal. What's the specific fear?"

**Domain-Specific Conflict Rules:**
- **Bulk vs. Cut:** Use body composition data; bulk if <15% body fat, cut if >20%
- **Save vs. Spend:** Apply 50/30/20 rule as default; allow user override
- **Rest vs. Train:** Use HRV + subjective readiness; auto-suggest deload if 2+ recovery metrics decline
- **Work vs. Relationships:** Weekly time audit; alert if work exceeds self-defined threshold

**Deload/Recovery Scheduling:**

| Domain | Standard Cycle | Deload Frequency | Deload Intensity |
|--------|---------------|-----------------|-----------------|
| Physical Fitness | 3–4 weeks loading | Every 4th week | -40% volume, maintain frequency [^304^] |
| Strength Training | Progressive overload | Every 4–6 weeks | -50% volume, -10% intensity [^304^] |
| Intellectual/Learning | 4–6 week study blocks | Every 5th week | -50% new material, increase review |
| Work/Productivity | 12-week execution cycles | 13th week [^314^] | Planning + reflection only |
| Creative Work | Project sprints | Between sprints | Input mode (consumption, inspiration) |
| Social/Relationships | Ongoing | Monthly "solo day" | Reduced social obligations |
| Mental Health Exposure | SUDS ladder climbing | After each 10-point advance | Return to previous comfort zone [^360^] |
| Financial | Monthly savings discipline | Quarterly "spend day" | Controlled discretionary spending |

### 4.7 AI Decomposition Engine

**7-Component Prompt Architecture:**

```
User Input → Classification → Framework Selection → 
Decomposition → Proxy Assignment → Time Structuring → 
Conflict Check → Recovery Integration → Final Quest Tree
```

| Component | Function | Prompt Strategy |
|-----------|----------|-----------------|
| **1. Goal Classification** | Domain assignment + goal type + recommended framework | Multi-class classification with few-shot examples [^350^] |
| **2. Framework Application** | Structure goal using selected framework | Template instantiation with domain-specific knowledge [^350^] |
| **3. Subgoal Decomposition** | Hierarchical quest tree (goal → milestones → quests → daily actions) | Recursive decomposition with dependency graph [^357^] |
| **4. Proxy Indicator Generator** | Abstract goal → measurable behavior | Abstract-to-behavioral translation using validated proxy library [^299^] |
| **5. Time Structure Assignment** | Time-anchored plan with review checkpoints | Rule-based cadence matching with calendar awareness [^314^] |
| **6. Conflict Detection** | Identify competing objectives across goal portfolio | Goal portfolio analysis for competing priorities [^305^] |
| **7. Recovery Integration** | Auto-scheduled deload weeks + adjusted difficulty | Fatigue-aware scheduling with deload prediction [^302^] |

**User Override:** Each stage feeds into the next, with user override at any checkpoint (supporting autonomy per Self-Determination Theory [^413^][^414^]).

---

## 5. Quest System

### 5.1 Quest Types (9 Types)

| # | Quest Type | Frequency | Description | Penalty |
|---|-----------|-----------|-------------|---------|
| 1 | **Daily Quests** | 3 per day (reset 6:00 AM) | Routine physical/mental training tasks | Penalty Zone quest if missed |
| 2 | **Weekly Quests** | 1 per week | Larger objectives requiring sustained effort | Partial reward reduction |
| 3 | **Chain Quests** | User-initiated | Multi-day escalating sequences (7/14/30-day) | Chain resets; Recovery quest offered |
| 4 | **Dungeons** | User-initiated | Major 30/60/90-day challenges with boss floors | Progress lost on abandon (permadeath) |
| 5 | **Main Quests** | 1 active at a time | Long-term goals (30+ day projects) from user objectives | No penalty; Reflection Quest on abandon |
| 6 | **Side Quests** | 0–2 per day (random) | Optional exploration challenges, experiments | None — entirely optional |
| 7 | **Urgent Quests** | 0–1 per week (triggered) | Pattern-detected emergencies (slump, burnout) | Escalation if ignored |
| 8 | **Custom Quests** | User-created | Full parameter control; System validates | User-defined |
| 9 | **Redemption Quests** | Post-failure | Recovery quests to restore standing after failure | This IS the recovery |

#### 5.1.1 Screentime Quest Category

Screentime quests are a unique quest category powered by Android's `UsageStatsManager`. They auto-complete when the system detects the user has stayed within their self-defined limits — no manual check-in required. These quests are categorized under the **Digital Wellness** domain (Domain 13) and primarily reward **SEN (Sense)** points, with secondary INT (focus sessions) and VIT (evening protocol) rewards.

Unlike manually logged quests, screentime quests are validated against objective device usage data. The System reads from `UsageStatsManager` at midnight to evaluate daily quests, and in real-time during focus sessions to detect breaches. This objectivity makes them some of the most meaningful quests in ARISE — the data does not lie.

**10 Screentime Quest Types:**

| # | Quest Type | Description | Example | Reward | Difficulty |
|---|-----------|-------------|---------|--------|------------|
| 1 | **Daily Screentime Limit** | Stay under total daily screen time | "Keep total screentime under 5 hours today" | +100 XP, +2 SEN | C-Rank |
| 2 | **App Category Limit** | Stay under time for a specific category | "Social media: max 45 minutes today" | +80 XP, +2 SEN | C-Rank |
| 3 | **App-Specific Limit** | Stay under time for one specific app | "Instagram: max 15 minutes today" | +60 XP, +1 SEN | D-Rank |
| 4 | **Focus Session** | Complete a distraction-free time block | "2-hour focus: no social/entertainment apps" | +150 XP, +3 SEN, +2 INT | B-Rank |
| 5 | **Morning Protocol** | No recreational screen time for first X minutes | "No entertainment apps before 8:00 AM" | +120 XP, +3 SEN | B-Rank |
| 6 | **Evening Protocol** | No recreational screen time after X time | "No entertainment apps after 10:00 PM" | +100 XP, +2 SEN, +2 VIT | B-Rank |
| 7 | **Digital Sabbath** | Zero recreational screen time for full day | "One full day: no social/entertainment/games" | +500 XP, +10 SEN | S-Rank |
| 8 | **App Lockout** | Voluntarily lock a specific app | "Lock Instagram for 24 hours" | +50 XP per locked app | D-Rank |
| 9 | **Unlock Count** | Stay under daily unlock limit | "Unlock your phone fewer than 30 times today" | +100 XP, +2 SEN | C-Rank |
| 10 | **Pickup Count** | Stay under daily pickup limit | "Pick up your phone fewer than 40 times" | +80 XP, +2 SEN | C-Rank |

**Auto-Completion Logic:** Screentime quests auto-complete when `UsageStatsManager` data shows the condition was met. Validation runs at midnight for daily quests, and in real-time for focus sessions. Manual completion is NOT available — the data is the data. If `PACKAGE_USAGE_STATS` permission is revoked, all active screentime quests are suspended until re-granted.

**Rank Availability:** Focus Session, Morning Protocol, Evening Protocol unlock at C-Rank; Digital Sabbath unlocks at A-Rank; App-Specific Limit and App Lockout available from D-Rank.

### 5.2 Quest Generation Algorithm

**10-Factor Weighted Algorithm:**

| Factor | Weight | Description | Data Source |
|--------|--------|-------------|-------------|
| User-defined goals | 20% | Quests aligned with user's stated priorities | Onboarding + monthly goal review |
| Performance history | 18% | 30-day rolling completion rate, effort scores | Internal analytics |
| Current stats | 15% | Level, stat distribution, recent gains | Player profile |
| Schedule context | 12% | Calendar density, upcoming deadlines | Calendar integration (opt-in) |
| Biometric state | 10% | Sleep quality (HRV), stress indicators, recovery | Wearable integration [^319^][^322^] |
| Past preferences | 8% | Quest types frequently accepted/completed | Interaction history |
| Flow calibration | 7% | Real-time challenge-skill balance score | Flow state estimator |
| Social context | 5% | Party/team activities, collaborative goals | Social graph |
| Temporal context | 3% | Time of day, day of week, season | System clock + preferences |
| Exploration factor | 2% | Novel quest types to prevent staleness | Randomness seeded by user entropy |

**Generation Pipeline:**
```
STAGE 1: Context Assembly → Fetch user profile, biometric data, calendar, compute Flow Score
STAGE 2: Template Selection → Filter by goal categories, apply difficulty constraints, inject 10–20% novel templates
STAGE 3: Personalization → LLM enriches template, calibrates difficulty, writes in System tone
STAGE 4: Validation → Difficulty Validator, Reward Validator, Conflict Checker → Package output
```

### 5.3 Difficulty Calibration Engine

**Flow Theory-Based Dynamic Difficulty Adjustment (DDA) [^300^][^304^]:**

| Zone | Challenge vs Skill | Experience | System Action |
|------|-------------------|------------|---------------|
| Apathy | Low + Low | Disengagement | Increase both challenge and support |
| Boredom | High skill, Low challenge | Mindless | Increase challenge significantly |
| Relaxation | High skill, Low challenge | Therapeutic | Slight challenge increase |
| Worry | Low skill, Med challenge | Apprehension | Increase support, decrease difficulty |
| Anxiety | Low skill, High challenge | Overwhelm | Decrease challenge, add scaffolding |
| Arousal | Med-High skill, High challenge | Exciting | **Maintain — target zone edge** |
| Control | High skill, Med-High challenge | Confident | Slight challenge increase |
| **Flow** | **High skill, High challenge (balanced)** | **Peak absorption** | **Maintain — THE TARGET ZONE** |

**Player Skill Index (PSI):**
```
PSI = (0.40 x Recent_Performance) + (0.25 x Historical_Average) + 
      (0.20 x Completion_Rate_Trend) + (0.10 x Effort_Score_Average) +
      (0.05 x Self_Reported_Confidence)
```

**Flow Score & Adjustment:**
```
Flow_Score = QDR / PSI

< 0.5   → Boredom    → Increase QDR 25%
0.5–0.7 → Relaxation → Increase QDR 15%
0.7–0.85 → Control   → Increase QDR 5%
0.85–1.15 → Flow    → MAINTAIN (optimal zone)
1.15–1.4 → Arousal  → Decrease QDR 5%
1.4–1.8 → Worry     → Decrease QDR 15%, add scaffolding
> 1.8   → Anxiety    → Decrease QDR 30%, mandatory recovery quest
```

**Real-Time Adjustment Triggers:**

| Trigger Signal | Source | Adjustment |
|---------------|--------|------------|
| Heart rate variability (HRV) drop >15% | Wearable | Reduce physical quest intensity 20% |
| Sleep score <50 (poor sleep) | Wearable | Lower all difficulty 10%, add grace period |
| Completion time >150% of estimate | App telemetry | Reduce similar future quests 15% |
| 3 consecutive early completions <50% time | App telemetry | Increase difficulty 20% |
| User rates "too easy" | User feedback | Increase next quest 25% |
| User rates "too hard" | User feedback | Decrease next quest 25%, add support |
| Calendar shows back-to-back meetings | Calendar API | Reduce quest count, lower intensity |
| Weekend detected | System clock | Allow 20% harder optional quests |

**Difficulty Tiers:**

| Tier | QDR Range | Description | Frequency |
|------|-----------|-------------|-----------|
| E-Rank | 1–20 | Trivial effort; recovery days, beginners, high stress | Recovery mode, new players |
| D-Rank | 21–40 | Light effort; comfortable, no strain | Maintenance phase |
| C-Rank | 41–60 | Moderate effort; requires focus but achievable | Standard daily quests |
| B-Rank | 61–75 | Hard effort; pushes boundaries; requires willpower | 2–3x per week for growth |
| A-Rank | 76–90 | Very hard; near limits; significant demand | Weekly quests, chain climax |
| S-Rank | 91–100 | Extreme; maximum capacity | Dungeon bosses only |

**User Override Mechanisms:**
- Difficulty Override: Manually adjust any quest +/-30% (once per quest; affects rewards proportionally)
- Quest Reroll: Spend currency to generate new quest (max 2/day; cost escalates)
- Vacation Mode: Pause all daily/weekly quests for up to 14 days (dungeons cannot be paused)
- Recovery Mode: All quests at E/D-Rank (auto-suggested when HRV low; user can activate anytime)
- Challenge Mode: All quests minimum B-Rank (no rewards bonus — intrinsic motivation preservation)

### 5.4 Quest Templates Library

**200+ templates across 8 domains:**

| Domain | Template Count | Example Templates |
|--------|---------------|-------------------|
| Physical Fitness | 45+ | Zone 2/3/4 cardio, progressive overload strength, HIIT, mobility, recovery |
| Mental Fitness | 30+ | Meditation (body scan, loving-kindness, breath focus), stress management, focus training |
| Learning & Growth | 40+ | Deliberate practice sessions, reading targets, course modules, skill drills, spaced repetition |
| Productivity | 35+ | Deep work sprints, Pomodoro sessions, time-blocking, project milestones, inbox zero |
| Social & Relationships | 25+ | Initiated conversations, gratitude expressions, active listening, quality time scheduling |
| Creative | 20+ | Writing sprints, drawing exercises, music practice, brainstorming sessions |
| Financial | 15+ | Expense logging, budget review, savings transfers, investment research |
| Recovery & Rest | 15+ | Active recovery walks, sleep hygiene, relaxation protocols, deload weeks |

**Template JSON Example (Progressive Cardio):**
```json
{
  "template_id": "FIT-CARDIO-001",
  "category": "Fitness",
  "subcategory": "Cardio",
  "name": "Zone {zone} Endurance Run",
  "description_template": "Maintain zone {zone} heart rate for {duration} minutes. Target HR: {min_hr}-{max_hr} bpm.",
  "base_difficulty": 45,
  "variables": {"zone": "[2,3,4]", "duration": "20-60"},
  "reward_base": {"xp": 150, "vit": 2, "agi": 1},
  "prerequisites": {"vit": 10}
}
```

### 5.5 Chain Quest Design

**3 Archetypes with Day-by-Day Structure:**

**The Ascension Chain (7 Days):**

| Day | Focus | Difficulty | Story Beat | Reward |
|-----|-------|------------|------------|--------|
| 1 | Foundation — light introduction | D-Rank | "The System has detected your potential. Prove you're worth its attention." | 100 XP |
| 2 | Building — volume increase | C-Rank | "Your body adapts. The System increases the load." | 120 XP |
| 3 | Challenge — first real test | C-Rank | "Doubt creeps in. Push through." | 150 XP |
| 4 | Recovery — active rest | D-Rank | "Even the strongest need recovery. The System knows this." | 80 XP |
| 5 | Intensity — pushing limits | B-Rank | "The real training begins now." | 200 XP |
| 6 | Endurance — sustained effort | B-Rank | "Your will is being forged. Hold on." | 250 XP |
| 7 | Climax — ultimate test | A-Rank | "The final gate stands before you. Break through." | 500 XP + Title + Buff |

**The Marathon Chain (30 Days):**

| Week | Theme | Boss | Reward |
|------|-------|------|--------|
| 1 | Foundation | "The Gatekeeper" — first major milestone | Bronze badge + 500 XP |
| 2 | Building | "The Wall" — midpoint psychological challenge | Silver badge + 750 XP |
| 3 | Intensification | "The Reckoning" — hardest sustained period | Gold badge + 1,000 XP |
| 4 | The Climax | "The Final Boss" — ultimate cumulative test | Legendary reward + Title + 2,000 XP |

**The Gauntlet Chain (14 Days — Intensive):**
Days 1–3 (C-Rank ramp) → Days 4–7 (B-Rank sustained) → Days 8–11 (A-Rank intensity) → Days 12–14 (S-Rank finale)

**Recovery-First Chain Mechanics:**
- Streak Freeze: One per chain — pause for 24h without breaking progress [^346^]
- Boss Fights: Cumulative milestones testing total progress
- Party Chains: Multiplayer chains where party members contribute to shared progress
- Chain Abandonment: Quitting triggers Redemption Quest. No other penalty.
- Completion Bonus: Permanent stat bonus (one-time per chain type)

### 5.6 Dungeon Design

**30/60/90-Day Templates with Boss Floors:**

**"The Forge" — 30-Day Fitness Dungeon:**

| Phase | Days | Name | Boss | Description |
|-------|------|------|------|-------------|
| Entry | 1–10 | The Gate | Gatekeeper Grust | Build baseline fitness habit. Boss: Complete 5 workouts in Week 2. |
| Depths | 11–20 | The Crucible | Iron Warden Kaos | Progressive overload. Boss: Hit personal best in primary lift/cardio. |
| Abyss | 21–30 | The Inferno | The Final Form | Peak training block. Boss: 1,000 total reps across all exercises. |

**"The Archive" — 60-Day Learning Dungeon:**

| Phase | Days | Name | Boss | Description |
|-------|------|------|------|-------------|
| Entry | 1–20 | The Library | Librarian Vel | Establish study routine. Boss: Complete first major course module. |
| Depths | 21–40 | The Laboratory | Alchemist Krix | Applied practice. Boss: Ship first substantive deliverable. |
| Abyss | 41–60 | The Observatory | Archon Toth | Mastery demonstration. Boss: Capstone project or certification exam. |

**"The Spire" — 90-Day Productivity Dungeon:**

| Phase | Days | Name | Boss | Description |
|-------|------|------|------|-------------|
| Entry | 1–30 | The Foundation | Taskmaster Zol | Build productivity system. Boss: 30 consecutive days of 4+ hours deep work. |
| Depths | 31–60 | The Construction | Efficiency Demon Kraal | Optimize and scale. Boss: Complete a major project milestone. |
| Abyss | 61–90 | The Summit | Apex Procrastination Dragon | Sustained excellence. Boss: Deliver major project + maintain system. |

**Dungeon Mechanics:**
- Permadeath: Abandoning forfeits ALL dungeon-specific progress [^338^]
- Meta-Progression: Keep permanent stat gains from completed floors, learned patterns
- Boss Scaling: Difficulty scales to demonstrated capability
- Checkpoints: Every 10 days; fail → restart from last checkpoint (once per dungeon)
- Party Mode: Can attempt with a party — shared progress, shared rewards
- Milestone Rewards: Day 10/20/30 — escalating rewards at each boss

### 5.7 Urgent Quest Triggers

**Pattern Detection for Emergency Quests:**

| Trigger | Detection Method | Threshold | Urgent Quest |
|---------|-----------------|-----------|-------------|
| Streak Collapse | Completion tracking | 3+ consecutive missed dailies | "Recovery Protocol: 3 Small Wins" |
| Slump Detection | Performance trend | 7-day rolling avg drops >30% from 30-day baseline | "The Slump Buster: Momentum Reset" |
| Sedentary Alert | Phone/wearable sensors | >6 hours sedentary before 6 PM | "Mobility Alert: Move Now" |
| Burnout Pattern | Biometric + self-report | HRV declining 5+ days + high stress | "Burnout Prevention: Mandatory Recovery" |
| Deadline Threat | Calendar integration | Deadline <48h with <50% completion | "Deadline Defense: Emergency Sprint" |
| Sleep Crisis | Wearable data | <5 hours sleep 3+ nights | "Sleep Recovery Protocol" |
| Social Isolation | Self-report + social graph | 7+ days without social activity | "Connection Quest: Reach Out" |
| Overtraining | Biometric data | HRV down 20%+ for 3+ days post-intense quest | "Forced Recovery: Active Rest" |

**Severity Levels:**

| Severity | Color | Response Time |
|----------|-------|--------------|
| Warning | Yellow | Within 24h |
| Alert | Orange | Within 4 hours |
| Critical | Red | Immediate |

### 5.8 Reward Balancing Matrix

**XP by Quest Type x Difficulty:**

| Quest Type | E-Rank | D-Rank | C-Rank | B-Rank | A-Rank | S-Rank |
|-----------|--------|--------|--------|--------|--------|--------|
| Daily | 50 | 75 | 150 | 250 | 400 | — |
| Weekly | — | 300 | 600 | 1,000 | 1,500 | — |
| Main (milestone) | — | 500 | 1,000 | 2,000 | 5,000 | 10,000 |
| Side | 25 | 50 | 100 | 150 | 250 | — |
| Chain (daily) | — | 100 | 200 | 350 | 500 | — |
| Chain (completion) | — | 500 | 1,500 | 3,000 | 8,000 | — |
| Dungeon (per floor) | — | 100 | 200 | 400 | 800 | 1,500 |
| Dungeon (boss) | — | — | 1,000 | 2,500 | 5,000 | 15,000 |
| Urgent | — | 200 | 300 | 450 | — | — |
| Redemption | — | 200 | 300 | 500 | — | — |

**Stat Gains per Quest:**

| Quest Type | E-Rank | D-Rank | C-Rank | B-Rank | A-Rank | S-Rank |
|-----------|--------|--------|--------|--------|--------|--------|
| Daily | +0.1 | +0.2 | +0.5 | +1.0 | +1.5 | — |
| Weekly | — | +0.5 | +1.0 | +2.0 | +3.0 | — |
| Chain | — | +0.3 | +0.5 | +1.0 | +2.0 | — |
| Dungeon | — | +0.5 | +1.0 | +2.0 | +4.0 | +8.0 |
| Main | — | +1.0 | +2.0 | +3.0 | +5.0 | +10.0 |

Per-day stat gains capped at +5 total across all stats.

**Gold Currency Rewards:**

| Quest Type | E-Rank | D-Rank | C-Rank | B-Rank | A-Rank |
|-----------|--------|--------|--------|--------|--------|
| Daily | 10 | 20 | 40 | 80 | 150 |
| Weekly | — | 100 | 200 | 400 | 800 |
| Side | 5 | 10 | 20 | 40 | 75 |
| Chain (daily) | — | 30 | 60 | 120 | 250 |
| Dungeon | — | 50 | 100 | 200 | 500 |
| Urgent | — | 40 | 80 | 150 | — |

### 5.9 Narrative Generation

**System Voice Specifications:**

| Attribute | Specification |
|-----------|--------------|
| Persona | "The System" — ancient, omniscient AI overseeing player growth |
| Tone | Formal, direct, slightly ominous but ultimately encouraging |
| Perspective | Second person ("You have been assigned...", "The Player must...") |
| Language | Precise, clinical, game-mechanical terms mixed with epic framing |
| Emotional Register | Cold authority that occasionally reveals warmth |

**Dynamic Quest Description Example (Daily Quest, C-Rank):**
```
SYSTEM NOTIFICATION
06:00 AM — Tuesday, March 18
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
DAILY QUEST ASSIGNED
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Quest: Zone 3 Threshold Run
Difficulty: C-Rank
Reward: 150 XP | VIT +0.5, AGI +0.3 | 40 G
Time Limit: 11:59 PM today

The System has analyzed your current state.
Your cardiovascular base has shown steady improvement over 14 days.
Today's quest is calibrated to your demonstrated capability — 
this is 15% above your comfortable pace.

Objective:
Complete a 25-minute run maintaining Zone 3 heart rate 
(142-158 bpm based on your max HR of 187).

Your HRV (72 ms) indicates adequate recovery.
This quest is within your capacity. Execute.

[ACCEPT] [REJECT (2 remaining)]
```

---

## 6. Notification & Alarm System

### 6.1 Alarm Delivery Architecture

| Component | Technology | Reliability | Notes |
|-----------|-----------|-------------|-------|
| Primary Alarm Engine | `AlarmManager.setAlarmClock()` + `RTC_WAKEUP` | 9.5/10 | Most reliable; system exits Doze before firing [^47^][^509^] |
| Fallback Exact Alarm | `AlarmManager.setExactAndAllowWhileIdle()` | 7/10 | Requires `SCHEDULE_EXACT_ALARM`; denied default on Android 14+ [^419^][^425^] |
| Periodic Checks | `WorkManager` (15-min flex intervals) | 6/10 | For non-critical sync; batched by Doze [^419^] |
| Flutter Bridge | `MethodChannel` (Native Kotlin Service) | 9/10 | Kotlin service handles alarms; broadcasts to Flutter |
| Background Execution | Foreground Service (`alarmClock` type) | 8.5/10 | Android 14+ requires declared `foregroundServiceType` [^482^] |
| Permission Model | `USE_EXACT_ALARM` (Play Store reviewed) | 9/10 | Auto-granted at install for alarm apps [^419^][^426^] |
| Boot Rescheduling | `BOOT_COMPLETED` + `QUICKBOOT_POWERON` | 8/10 | Both events needed; alarms cleared on reboot [^478^] |

**ARISE Strategy:** Declare as alarm app in Play Console → qualify for `USE_EXACT_ALARM` (auto-granted) and `USE_FULL_SCREEN_INTENT` (auto-granted) [^424^]. This avoids the permission gate that kills `SCHEDULE_EXACT_ALARM` by default on Android 14+ [^419^].

**Native Service Flow:**
```
[Kotlin AlarmService] → AlarmManager.setAlarmClock() → BroadcastReceiver →
WakeLock.acquire() → MethodChannel.invokeMethod("alarmFired") →
Flutter layer decides notification type → flutter_local_notifications.show()
→ WakeLock.release()
```

### 6.2 Notification Types (8 Types)

| # | Type | Trigger | UI Style | Sound | Priority |
|---|------|---------|----------|-------|----------|
| 1 | **Morning Briefing** | User wake time + 5 min | BigText with quest summary | Custom ascending chime (10s crescendo) | IMPORTANCE_HIGH (heads-up) |
| 2 | **Quest Countdown** | T-minus 30 min before deadline | BigText + progress bar | Subtle ticking alert | IMPORTANCE_DEFAULT |
| 3 | **Quest Warning** | T-minus 10 min before deadline | BigText + action buttons | Firm two-tone alert | IMPORTANCE_HIGH |
| 4 | **Penalty Notice** | Quest deadline missed | Full-screen intent | Harsh descending tone + long vibration | IMPORTANCE_HIGH + bypass DND |
| 5 | **Streak Alert** | Daily streak at risk | BigPicture (flame) + BigText | Victory chime or loss warning | IMPORTANCE_HIGH |
| 6 | **Milestone Celebration** | Achievement unlocked | BigPicture (confetti) | Celebration sound (unique per tier) | IMPORTANCE_DEFAULT |
| 7 | **Nuclear Option** | Multiple missed quests + streak break | Full-screen alarm UI + persistent sound | Alarm clock sound (non-stop until acknowledged) | IMPORTANCE_MAX + bypass DND |
| 8 | **Companion Nudge** | Predicted low-motivation window | Messaging-style (companion avatar) | Soft spoken phrase (TTS) | IMPORTANCE_LOW |

### 6.3 Escalation Matrix

| Time Before Deadline | Style | Message Tone | Sound Profile | Vibration |
|---------------------|-------|-------------|---------------|-----------|
| > 2 hours | Silent in-app countdown only | Neutral | None | None |
| 30 minutes | Heads-up notification, dismissible | Helpful: "Your quest begins in 30 minutes. Prepare." | Soft single chime | Short double-tap |
| 10 minutes | Heads-up with action buttons | Firm: "10 minutes. Start now or begin your descent." | Firm two-tone pulse | Medium burst (3 pulses) |
| 5 minutes | Non-dismissible heads-up | Urgent: "5 minutes. The clock is not your friend." | Escalating alert (volume rises) | Long pattern (5 pulses) |
| 1 minute | Full-screen intent | Command: "1 minute. Execute or face consequences." | Aggressive alarm tone | Intense vibration + sound |
| Deadline reached | Full-screen takeover + persistent alarm | Final: "QUEST FAILED. Penalty applied." | Continuous alarm (must acknowledge) | Non-stop vibration until tap |
| Post-deadline | Penalty summary notification | Loss-aversion: "3-day streak lost. 50 XP deducted." | Harsh descending tone | Heavy double-buzz |

**Escalation Principles:** Limit to 4 escalation levels max [^459^]; progressive acknowledgment required; multi-channel redundancy (visual + sound + vibration); timeout-based escalation [^455^].

### 6.4 Full-Screen Takeover Design

| Element | Specification |
|---------|--------------|
| Background | Pure black `#000000` with subtle animated particle field (cyan dots, opacity 0.1–0.3) [^103^] |
| Container | 90% width, centered, holographic cyan border with outer glow, dark translucent fill [^6^] |
| Header | `[NOTIFICATION]` or `[WARNING]` in bracketed cyan text, Share Tech Mono font [^6^] |
| Message | Centered, large text (20–24sp), clinical authoritative tone, white on dark |
| Countdown | Prominent timer (JetBrains Mono, 48sp+), pulsing red under 10s |
| Actions | Binary choices: "Yes" / "No" — minimal buttons with cyan border glow [^6^] |
| Vibration | Haptic feedback on appearance, escalating pattern for warnings |
| Audio | Subtle system chime — clinical, not musical |

**Full-Screen Rules:**
- Bypass do-not-disturb for critical daily quest deadlines [^46^]
- Require explicit user action to dismiss — no tap-outside-to-close for penalty warnings [^46^]
- On Android 14+, use Full-Screen Intent notifications with alarm category [^46^]
- Display over lock screen with `FLAG_SHOW_WHEN_LOCKED` and `FLAG_KEEP_SCREEN_ON` [^11^]

### 6.5 Timing Intelligence

| Factor | Weight | Data Source |
|--------|--------|-------------|
| Historical quest start time | 30% | Local SQLite: average completion time over last 30 days |
| Morning wake pattern | 20% | First phone unlock (UsageStatsManager) or Health Connect sleep data |
| Notification open time | 15% | Which notifications user historically taps (time histogram) |
| Day-of-week pattern | 15% | Quest completion rates by day (weekends vs. weekdays differ) |
| Current app usage context | 10% | Is user actively using phone? (UsageStatsManager last 5 min) |
| Battery level | 5% | Avoid notifications below 5% battery (defer to charge) |
| DND status | 5% | Respect unless nuclear tier |

**ML Model:** Lightweight on-device decision tree or TensorFlow Lite; retrained weekly; predicts optimal notification time within 30-minute window; based on Send Time Optimization: personalized best time outperforms generic by 52% match rate [^514^].

### 6.6 Sound & Vibration Design

| Tier | Sound Design | Vibration Pattern |
|------|-------------|-------------------|
| Morning Briefing | Custom ascending chime (C4→C5, 10s crescendo) | Gentle wave: `{0, 200, 100, 200, 100, 400}` [^479^] |
| Countdown | Single subtle blip | Short tap: 50ms |
| Warning | Two-tone alert (A4→E5) | Medium burst: 3 pulses of 200ms |
| Critical/Penalty | Harsh descending tone (D5→A3) | Heavy 5-pulse pattern [^479^] |
| Nuclear | Continuous alarm (must acknowledge) | Non-stop repeating pattern until tap |
| Milestone | Unique celebration sound per tier | Fireworks-style escalating pattern |
| Companion | Text-to-Speech (whisper voice) | Gentle single pulse |

### 6.7 Snooze Mechanics

| Snooze Count | Cost | Delay | Sound on Re-trigger |
|-------------|------|-------|-------------------|
| 1st | Free | 5 minutes | Same as original |
| 2nd | -5 XP | 3 minutes | Slightly more urgent |
| 3rd | -15 XP | 2 minutes | Escalated tone |
| 4th | -30 XP + streak warning | 1 minute | Critical alert |
| 5th+ | Penalty applied (quest failed) | N/A | Penalty notification |

**Design:** Free first snooze reduces friction; escalating XP cost leverages loss aversion [^461^]; streak warning at 4th snooze is emotionally powerful; hard cap at 4 before auto-fail prevents procrastination loops.

### 6.8 Notification Fatigue Prevention

| Strategy | Implementation |
|----------|---------------|
| Frequency cap | Max 5 push notifications per week (non-urgent only) — 64% of users may stop using an app that sends more than 5/week [^458^] |
| Event-based > Scheduled | Trigger based on user actions rather than fixed times [^78^][^85^] |
| Smart batching | Morning briefing consolidates all daily quest info into ONE notification |
| Companion mode toggle | "Frequent" → "Minimal" → "System Only" frequency options |
| Cool-down period | After nuclear alert, suppress non-critical notifications for 30 minutes |
| Notification value audit | Every notification must contain ACTIONABLE value |
| Disable detection | If user disables channel, show in-app dialog explaining what they'll miss |
| Weekend reduction | 50% fewer notifications on weekends (unless streak at risk) |

**Android 15 Notification Cooldown:** [^502^][^504^][^505^]
- Space notifications > 2 minutes apart to avoid cooldown suppression
- Use `NotificationCategory.Alarm` for critical notifications (exempt from cooldown)

---

## 7. Health & Fitness Integrations

### 7.1 Health Connect Integration

**14 Data Types Mapped to Quests:**

| Data Type | Quest Mapping | Auto-Complete Rule | Permission |
|-----------|--------------|-------------------|------------|
| `StepsRecord` | Daily Step Quests | COUNT_TOTAL >= quest threshold | `READ_STEPS` |
| `DistanceRecord` | Running/Cycling Distance | DISTANCE_TOTAL >= target (meters) | `READ_DISTANCE` |
| `ExerciseSessionRecord` | Workout Completion | Session exists with matching type | `READ_EXERCISE` |
| `ActiveCaloriesBurnedRecord` | Calorie Burn Goals | ACTIVE_CALORIES_TOTAL >= target | `READ_ACTIVE_CALORIES_BURNED` |
| `TotalCaloriesBurnedRecord` | Daily Energy Quests | ENERGY_TOTAL >= target | `READ_TOTAL_CALORIES_BURNED` |
| `HeartRateRecord` | Cardio Intensity | BPM_AVG in target zone during exercise | `READ_HEART_RATE` |
| `HydrationRecord` | Water Intake | VOLUME_TOTAL >= target (ml) | `READ_HYDRATION` |
| `NutritionRecord` | Nutrition/Macro Tracking | PROTEIN_TOTAL, ENERGY_TOTAL hit goals | `READ_NUTRITION` |
| `SleepSessionRecord` | Sleep Quality | SLEEP_DURATION_TOTAL >= target hours | `READ_SLEEP` |
| `FloorsClimbedRecord` | Stair Climbing | FLOORS_CLIMBED_TOTAL >= target | `READ_FLOORS_CLIMBED` |
| `ElevationGainedRecord` | Hiking/Elevation | ELEVATION_GAINED_TOTAL >= target (meters) | `READ_ELEVATION_GAINED` |
| `MindfulnessSessionRecord` | Meditation/Mindfulness | MINDFULNESS_DURATION_TOTAL >= target | `READ_MINDFULNESS` |
| `WeightRecord` | Body Composition | WEIGHT_AVG logged (any value) | `READ_WEIGHT` |
| `Vo2MaxRecord` | Cardio Fitness | VO2 value logged above threshold | `READ_VO2_MAX` |

**Architecture:** Health Connect is the single integration point [^33^][^36^]. ARISE reads only (does not write health data). Uses `AggregateRequest` for daily totals rather than raw records [^527^][^34^].

### 7.2 Lyfta Integration

| Integration Method | Data Flow | Fallback |
|-------------------|-----------|----------|
| Health Connect + Lyfta REST API | Lyfta writes `ExerciseSessionRecord` + sets to HC; ARISE reads from HC via `READ_EXERCISE` permission. Alternative: Direct API key sync via `my.lyfta.app/api/v1/workouts` [^441^] | Manual workout entry; CSV import; photo proof |

### 7.3 Nutrition Integration

| Partner | Integration Method | Data Flow | Fallback |
|---------|-------------------|-----------|----------|
| **MyFitnessPal** | Health Connect (primary) + MFP API v2 | MFP writes `NutritionRecord` to HC; ARISE reads aggregated nutrition data | Manual food logging; barcode scan; photo meal log |
| **Cronometer** | Health Connect + Terra API bridge | Cronometer syncs nutrition data to HC via Terra webhooks [^440^] | Manual macro entry; food photo logging |

**Schnucks/Shnuk Note:** Schnucks Rewards has NO public developer API for nutrition tracking data [^582^][^598^]. ARISE provides manual recipe logging and directs users to connect MyFitnessPal or Cronometer for automated nutrition tracking.

### 7.4 Google Calendar Integration

- Free-time slot detection for quest scheduling
- Quest scheduling around calendar events
- Back-to-back meeting detection → reduce quest count, lower intensity
- Deadline detection → trigger "Deadline Defense" urgent quest

### 7.5 Wearable Support

| Device Type | Capabilities | Complication Options |
|-------------|-------------|---------------------|
| **Wear OS 5+** | Full Health Services API: steps, HR, GPS, calories, sleep, SpO2, ECG [^597^][^571^] | GOAL_PROGRESS for quest progress; RANGED_VALUE for steps/HR; Tiles for quick workout start [^535^][^596^] |
| **Samsung Galaxy Watch** | Samsung Health + Health Connect dual path | Samsung Health tiles; Health Connect data sync [^485^] |
| **Fitbit (Pixel Watch)** | Fitbit app + Health Connect bridge | Fitbit exercise tiles; data flows to HC [^599^] |

**Wear OS Complication Data Types:**
- `GOAL_PROGRESS`: Quest completion percentage (e.g., "7,234/10,000 steps")
- `RANGED_VALUE`: Metric in a range (e.g., heart rate zone)
- `SHORT_TEXT`: Quick stat display (e.g., "+250 XP today")
- Update period: Minimum 300 seconds (5 minutes) [^535^]

**Always-On Display (AOD):** Wear OS supports AOD showing time + complications in low-power state; ARISE complications visible in AOD mode for quest progress at a glance [^571^].

### 7.6 Manual Entry & Photo Proof

| Method | Use Case | Verification | Consequences for Fraud |
|--------|----------|-------------|----------------------|
| Manual Entry | No wearable, no partner app | Honor system + random audit | Unrealistic values trigger "Needs Verification" flag |
| Photo Proof | Workout completion, meal logging | Timestamped photo; optional AI verification | Verified photo = 1.2x XP bonus; unverified = base XP |
| Timer-Based | Meditation, reading, stretching | In-app timer with screen-on requirement | Cannot be gamed without keeping app open |
| GPS Track Upload | Running, cycling, hiking | GPX/TCX file import with route validation | Fake routes detected via impossible speed/elevation |
| Community Verification | Photo-based quests | Other users vote on completion photos | Crowd-sourced fraud detection |
| Honor System | Simple habits (drank water, stretched) | Self-reported checkbox | No XP for leaderboard; personal progress only |

**Trust Tiers:**
- **Tier 1 (Verified):** Health Connect authenticated source → Full XP, leaderboard eligible
- **Tier 2 (Photo Verified):** Manual entry + photo proof → Full XP, leaderboard eligible
- **Tier 3 (Self-Reported):** Manual entry without proof → 50% XP, NOT leaderboard eligible
- **Tier 4 (Honor System):** Simple checkboxes → No XP (progress tracking only)


---

## 7.7 Screentime Monitoring System

### Blue Ocean Feature: Digital Discipline as Gameplay

**No existing habit or life-RPG application has deeply integrated screentime monitoring with quests, stats, and penalties.** Google's Digital Wellbeing provides raw data but no gamification. Habitica, LifeUp, MainQuest, and Finch track manually logged habits but cannot observe actual device usage. ARISE closes this gap: the System monitors the System. Screentime becomes a first-class gameplay mechanic — a unique competitive moat that deepens engagement while delivering genuine user value.

**Research Foundation:** The average person spends 7 hours and 14 minutes per day on screens, with 45% of that on mobile devices. Among men aged 18–35 (ARISE's core demographic), mobile gaming and social media are the two largest time sinks. By integrating Android's `UsageStatsManager` (API 21+) into the quest and stat systems, ARISE transforms passive consumption data into active discipline mechanics.

**ARISE Philosophy:** *"Your phone is both your System interface AND your greatest distraction. The System monitors itself."*

This is not about shame. It is about awareness, voluntary discipline, and the gamification of attention itself. The System does not judge — it observes, quantifies, and offers the Player tools to reclaim their cognitive sovereignty.

---

### 7.7.1 Overview & Philosophy

The Screentime Monitoring System is a five-layer Android-native architecture that transforms device usage data into actionable gameplay: quests to limit consumption, stats that reward discipline, penalties for excess, and analytics that build awareness. It operates entirely on-device for privacy, using Android's `UsageStatsManager` as the primary data source, supplemented by a foreground service for real-time screen-state tracking.

**Core Design Principles:**

| Principle | Implementation |
|-----------|---------------|
| **Voluntary Discipline** | All limits are self-imposed. The System suggests; the Player decides. No lock is mandatory. |
| **Privacy-First by Design** | Zero screentime data leaves the device. All processing is local. |
| **Gamification Over Shame** | Excessive screentime triggers quest opportunities, not lectures. The frame is growth, not guilt. |
| **Escalating Intervention** | Gentle awareness → soft nudges → firm warnings → app lock. The Player controls where they want the boundary. |
| **Stat Integration** | Screentime discipline directly impacts SEN (Sense), making digital wellness a core progression path. |

**The Diegetic Framing:**

The System treats device usage as "environmental mana consumption" — a resource the Player expends simply by existing in the digital realm. Just as mana must be managed in any RPG, attention must be managed in ARISE. The phone is the System's vessel; its overuse weakens the Player. Digital discipline is therefore not external to the game — it IS the game.

---

### 7.7.2 The Android Screentime Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                    SCREENTIME ARCHITECTURE                       │
│                      (5-Layer Stack)                             │
├─────────────────────────────────────────────────────────────────┤
│  LAYER 1: Permission & Access                                   │
│  ├── AndroidManifest: android.permission.PACKAGE_USAGE_STATS    │
│  ├── AppOpsManager.checkOpNoThrow(OPSTR_GET_USAGE_STATS)        │
│  └── Settings.ACTION_USAGE_ACCESS_SETTINGS redirect             │
├─────────────────────────────────────────────────────────────────┤
│  LAYER 2: UsageStatsManager Data Collection                     │
│  ├── queryAndAggregateUsageStats(beginTime, endTime)            │
│  ├── queryUsageStats(INTERVAL_DAILY, begin, end)                │
│  ├── queryEvents(begin, end) for session-level detail           │
│  └── WorkManager: every 15 min + SCREEN_ON trigger              │
├─────────────────────────────────────────────────────────────────┤
│  LAYER 3: Real-Time Screen State Tracking                       │
│  ├── ScreentimeMonitorService (ForegroundService)               │
│  ├── ScreenStateReceiver: ACTION_SCREEN_ON / ACTION_SCREEN_OFF  │
│  └── Independent screen-on counter (validation layer)           │
├─────────────────────────────────────────────────────────────────┤
│  LAYER 4: App Categorization Engine                             │
│  ├── Heuristic mapping (package name → category)                │
│  ├── On-device ML: learns from usage patterns over time         │
│  └── User override: any app can be recategorized                │
├─────────────────────────────────────────────────────────────────┤
│  LAYER 5: Gamification Bridge                                   │
│  ├── Quest generation from screentime data                      │
│  ├── Limit enforcement + notification escalation                │
│  ├── App lock overlay (full-screen intervention)                │
│  └── SEN stat integration + analytics dashboard                 │
└─────────────────────────────────────────────────────────────────┘
```

#### Layer 1: Permission & Access

The `PACKAGE_USAGE_STATS` permission is a **system-level permission** that cannot be granted through normal runtime permission dialogs. The user must explicitly enable it in Settings.

**Manifest Declaration:**
```xml
<uses-permission android:name="android.permission.PACKAGE_USAGE_STATS"
    tools:ignore="ProtectedPermissions" />
```

**Permission Check Flow:**
```
[App Launch or Screentime Feature Access]
    → AppOpsManager.checkOpNoThrow(AppOpsManager.OPSTR_GET_USAGE_STATS,
                                     Process.myUid(), getPackageName())
    → MODE_ALLOWED? Proceed to Layer 2
    → MODE_DEFAULT or MODE_IGNORED? Show diegetic permission request
        → Launch Intent(Settings.ACTION_USAGE_ACCESS_SETTINGS)
        → Diegetic copy: "Grant the System access to monitor your digital environment."
        → MODE_ALLOWED on return? Proceed. Still denied? Feature remains locked.
```

**Diegetic Permission Screen:**

| Element | Content |
|---------|---------|
| Header | `[SYSTEM REQUEST] Digital Environment Scan Access` |
| Body | "The System requires visibility into your device's usage patterns to detect mana drain, calculate environmental consumption, and assign appropriate Digital Discipline quests. Without this access, the System cannot monitor your digital environment." |
| Primary CTA | "Grant Access" → redirects to Settings |
| Secondary CTA | "Not Now" → feature locked, gentle reminder after 3 days |

#### Layer 2: UsageStatsManager Data Collection

The `UsageStatsManager` is the core Android API for retrieving app usage history. Introduced in API 21 (Android 5.0), it provides aggregated usage statistics for any time range [^772^][^773^].

**Key API Methods:**

| Method | Data Returned | Use Case |
|--------|--------------|----------|
| `queryAndAggregateUsageStats(beginTime, endTime)` | Map<packageName, UsageStats> with total foreground time | Daily totals per app; primary data source |
| `queryUsageStats(INTERVAL_DAILY, begin, end)` | List<UsageStats> per day | Day-by-day trend analysis |
| `queryEvents(begin, end)` | UsageEvents with timestamps | Session-level detail; focus session validation |
| `isAppInactive(packageName)` | Boolean | Detecting unused apps for cleanup quests |

**UsageStats Object Fields:**

| Field | Type | Description |
|-------|------|-------------|
| `getPackageName()` | String | App package identifier (e.g., `com.instagram.android`) |
| `getTotalTimeInForeground()` | Long | Total time in foreground (ms) for the queried period |
| `getLastTimeUsed()` | Long | Timestamp of last foreground entry |
| `getFirstTimeStamp()` | Long | Start of the aggregation period |
| `getAppLaunchCount()` | Int | Number of times the app was launched (Android 12+) |

**Collection Schedule:**

| Trigger | Action | Frequency |
|---------|--------|-----------|
| WorkManager periodic | Full usage sync via `queryAndAggregateUsageStats()` | Every 15 minutes |
| SCREEN_ON broadcast | Incremental sync of current session | Real-time |
| SCREEN_OFF broadcast | Finalize current session, save to DB | Real-time |
| Midnight (00:00) | Daily summary generation, quest evaluation | Once daily |
| App foreground | Quick refresh of today's totals | On-demand |

**Interval Types:**
- `INTERVAL_DAILY` — 24-hour buckets for day-by-day comparison
- `INTERVAL_WEEKLY` — 7-day buckets for weekly trends
- `INTERVAL_MONTHLY` — 30-day buckets for monthly analysis
- `INTERVAL_BEST` — Automatically selects optimal interval for the query range [^776^]

#### Layer 3: Real-Time Screen State Tracking

A `ForegroundService` with a dynamically registered `BroadcastReceiver` captures `ACTION_SCREEN_ON` and `ACTION_SCREEN_OFF` events for real-time screen-on time tracking, independent of UsageStatsManager [^770^][^771^].

**Architecture:**
```kotlin
class ScreentimeMonitorService : Service() {
    private lateinit var screenReceiver: BroadcastReceiver
    private var screenOnStartTime: Long = 0

    override fun onCreate() {
        super.onCreate()
        screenReceiver = object : BroadcastReceiver() {
            override fun onReceive(context: Context?, intent: Intent?) {
                when (intent?.action) {
                    Intent.ACTION_SCREEN_ON -> {
                        screenOnStartTime = System.currentTimeMillis()
                        // Trigger incremental sync
                    }
                    Intent.ACTION_SCREEN_OFF -> {
                        val duration = System.currentTimeMillis() - screenOnStartTime
                        saveScreenOnSession(duration)
                        // Trigger final sync for current app session
                    }
                }
            }
        }
        val filter = IntentFilter().apply {
            addAction(Intent.ACTION_SCREEN_ON)
            addAction(Intent.ACTION_SCREEN_OFF)
        }
        registerReceiver(screenReceiver, filter)

        // Foreground notification (required for Android O+)
        val notification = createLowPriorityNotification("System Monitoring Active")
        startForeground(NOTIFICATION_ID, notification)
    }
}
```

**Validation Role:** The screen-on counter serves as a validation layer. If `UsageStatsManager` data + screen-on counter diverge by >5%, the System flags a potential data inconsistency and falls back to the screen-on counter (more reliable, less granular).

#### Layer 4: App Categorization Engine

Apps are automatically categorized using a 3-tier approach:

**Tier 1: Heuristic Mapping (Immediate)**

| Category | Package Name Patterns | Default Stance |
|----------|---------------------|----------------|
| Social | `com.instagram.*`, `com.zhiliaoapp.*` (TikTok), `com.twitter.*`, `com.snapchat.*`, `com.facebook.*` | Context-dependent |
| Entertainment | `com.youtube.*`, `com.netflix.*`, `com.spotify.*`, `com.discord*`, `com.twitch.android` | Negative if excessive |
| Gaming | `com.supercell.*`, `com.riotgames.*`, `com.king.*`, `com.ea.game.*` | Negative if excessive |
| Productivity | `com.notion.*`, `com.microsoft.office.*`, `com.google.android.apps.docs*` | Positive |
| Communication | `com.whatsapp*`, `com.google.android.apps.messaging*`, `com.slack*` | Neutral |
| Education | `com.duolingo*`, `com.khanacademy.*`, `org.khanacademy.*` | Positive |
| Fitness/Health | `com.lyfta.*`, `com.myfitnesspal.*`, `com.sec.android.app.shealth*` | Positive |
| Finance | `com.coinbase.*`, `com.paypal.*`, `com.bank*` | Neutral |
| News | `com.bbc.*`, `com.reddit.*`, `com.flipboard.*` | Neutral |
| System | `com.android.*`, `com.google.android.launcher*`, `com.samsung.*` (system) | Excluded |
| **ARISE** | `com.arise.app*` | Excluded (don't count the System against the Player) |

**Tier 2: On-Device ML (Week 2+)**
- Simple classification model runs locally using `tflite`
- Learns from user behavior: if the user consistently uses an app during work hours with no negative outcomes, the model may recategorize it
- Model is retrained weekly on-device using the past 14 days of usage data
- No data leaves the device; model is pure local inference

**Tier 3: User Override**
- User can manually recategorize any app from the screentime dashboard
- Override persists until the user changes it again
- System notes the override but does not second-guess the user (autonomy principle)

#### Layer 5: Gamification Bridge

The gamification bridge connects raw usage data to the core game systems:

```
UsageStatsManager data
    → AppCategorizationEngine (categorize each app)
    → DailyAggregator (sum by category, compute totals)
    → QuestValidator (check screentime quests against actuals)
    → LimitEnforcer (check per-app/category limits)
    → NotificationDispatcher (send alerts if thresholds breached)
    → StatUpdater (award SEN points for discipline)
    → AnalyticsStore (save to local DB for dashboard)
```

---

### 7.7.3 Screentime Quests

Screentime quests are a unique quest category powered by Android's UsageStatsManager. They auto-complete when the system detects the user has stayed within their self-defined limits. These quests are categorized under the **Digital Wellness** domain and primarily reward **SEN (Sense)** points.

**10 Screentime Quest Types:**

| # | Quest Type | Description | Example | Reward | Difficulty |
|---|-----------|-------------|---------|--------|------------|
| 1 | **Daily Screentime Limit** | Stay under total daily screen time | "Keep total screentime under 5 hours today" | +100 XP, +2 SEN | C |
| 2 | **App Category Limit** | Stay under time for a specific category | "Social media: max 45 minutes today" | +80 XP, +2 SEN | C |
| 3 | **App-Specific Limit** | Stay under time for one specific app | "Instagram: max 15 minutes today" | +60 XP, +1 SEN | D |
| 4 | **Focus Session** | Complete a distraction-free time block | "2-hour focus: no social/entertainment apps" | +150 XP, +3 SEN, +2 INT | B |
| 5 | **Morning Protocol** | No recreational screen time for first X minutes | "No entertainment apps before 8:00 AM" | +120 XP, +3 SEN | B |
| 6 | **Evening Protocol** | No recreational screen time after X time | "No entertainment apps after 10:00 PM" | +100 XP, +2 SEN, +2 VIT | B |
| 7 | **Digital Sabbath** | Zero recreational screen time for full day | "One full day: no social/entertainment/games" | +500 XP, +10 SEN | S |
| 8 | **App Lockout** | Voluntarily lock a specific app | "Lock Instagram for 24 hours" | +50 XP per locked app | D |
| 9 | **Unlock Count** | Stay under daily unlock limit | "Unlock your phone fewer than 30 times today" | +100 XP, +2 SEN | C |
| 10 | **Pickup Count** | Stay under daily pickup limit | "Pick up your phone fewer than 40 times" | +80 XP, +2 SEN | C |

**Auto-Completion Logic:**
- Screentime quests auto-complete when `UsageStatsManager` data shows the condition was met
- Validation runs at midnight for daily quests, at the end of a focus session for session quests
- Manual completion is NOT available (prevents gaming the system — the data is the data)
- If `UsageStatsManager` permission is revoked, all active screentime quests are suspended

**Rank Availability:**

| Quest Type | E-Rank | D-Rank | C-Rank | B-Rank | A-Rank | S-Rank |
|-----------|--------|--------|--------|--------|--------|--------|
| Daily Screentime Limit | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| App Category Limit | — | ✓ | ✓ | ✓ | ✓ | ✓ |
| App-Specific Limit | — | ✓ | ✓ | ✓ | ✓ | ✓ |
| Focus Session | — | — | ✓ | ✓ | ✓ | ✓ |
| Morning Protocol | — | — | ✓ | ✓ | ✓ | ✓ |
| Evening Protocol | — | — | ✓ | ✓ | ✓ | ✓ |
| Digital Sabbath | — | — | — | ✓ | ✓ | ✓ |
| App Lockout | — | ✓ | ✓ | ✓ | ✓ | ✓ |
| Unlock Count | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| Pickup Count | — | ✓ | ✓ | ✓ | ✓ | ✓ |

---

### 7.7.4 The SEN (Sense) Stat Connection

Screentime discipline is the primary gameplay pathway for the **SEN (Sense)** stat. SEN represents awareness, mindfulness, and self-regulation — the ability to observe one's own behavior and course-correct. Digital discipline is the purest expression of SEN.

**SEN Point Flow from Screentime:**

| Action | SEN Impact | Rationale |
|--------|-----------|-----------|
| Complete daily screentime limit quest | +2 SEN | Awareness demonstrated |
| Complete focus session quest | +3 SEN | Sustained attention |
| Complete digital sabbath | +10 SEN | Peak digital discipline |
| Stay under 50% of daily limit | +1 SEN bonus | Exceptional restraint |
| Exceed daily limit by 2× | -2 SEN (capped at -2/day) | "Digital Gluttony" penalty |
| Override an app lock | -10 SEN | Discipline breach |
| Break a focus session | -3 SEN | Attention fragmentation |
| Violate morning protocol | -2 SEN | Protocol breach |
| Violate evening protocol | -2 SEN | Protocol breach |
| 7 consecutive days under limit | +5 SEN (weekly bonus) | Consistency reward |

**SEN Unlock Thresholds for Screentime Features:**

| SEN Level | Feature Unlocked | Description |
|-----------|-----------------|-------------|
| SEN 15 | Basic screentime dashboard | Daily/weekly reports, category breakdown |
| SEN 20 | App lock (manual) | Lock any single app for 24 hours |
| SEN 25 | Focus mode | Block categories during focus sessions |
| SEN 30 | Per-app time limits | Set daily limits for individual apps |
| SEN 35 | Morning/Evening protocol | Automated time-based app restrictions |
| SEN 40 | Scheduled app locks | Recurring daily locks (e.g., 10PM-8AM) |
| SEN 50 | Digital sabbath quest | Unlock the S-Rank Digital Sabbath quest |
| SEN 60 | "Digital Monk" title | Passive: +1 SEN/day, immunity to 1 screentime penalty/week |

**"Digital Gluttony" Debuff:**
- Triggered when total daily screentime exceeds 2× the self-defined limit
- Effect: -2 SEN per day until the player completes 3 consecutive days under their limit
- Visual: Purple-black border on the SEN stat bar; "[DEBUFF] Digital Gluttony" appears in status
- Lore: "Your mana consumption has exceeded safe parameters. The System recommends immediate disengagement."
- Cure: Complete 3 consecutive days under the daily screentime limit

---

### 7.7.5 Notification & Intervention System

When screentime limits are approached or breached, the System uses the same 4-tier escalation matrix (calm → firm → urgent → nuclear) as the core notification system, adapted for digital discipline.

**9 Intervention Triggers:**

| # | Trigger | Notification Style | Copy (System Voice) |
|---|---------|-------------------|---------------------|
| 1 | 75% of daily limit reached | Gentle System message (banner) | "Your daily screen allocation is at 75%. 1h 15m remains. The System observes. You decide." |
| 2 | 90% of daily limit reached | Heads-up notification + soft sound | "[WARNING] You are approaching your daily limit. 15 minutes remain. The System recommends disengaging." |
| 3 | 100% of daily limit reached | Full-screen takeover + vibration | "[SYSTEM ALERT] Your daily screen allocation has been exhausted. The System recommends disengaging. Quest penalty may apply." |
| 4 | Focus session broken (opened blocked app) | Immediate notification | "Your Focus Session has been disrupted at [TIME]. [APP] was accessed. Your INT stat will not receive today's focus bonus." |
| 5 | Morning protocol violated | Immediate notification | "The Morning Protocol has been breached at 07:23. 37 minutes early. Today's SEN bonus is reduced." |
| 6 | Evening protocol approaching | 15-minute warning | "Evening Protocol activates in 15 minutes. Complete your entertainment now or forego it until tomorrow." |
| 7 | Evening protocol violated | Immediate notification | "The Evening Protocol has been breached. Entertainment app [APP] accessed at 22:17. SEN bonus reduced. Sleep quality may be impacted." |
| 8 | App limit reached (per-app lock) | Full-screen overlay | "[APP LOCK] Instagram's daily allocation: EXHAUSTED. Override available with consequence." |
| 9 | Unlock count threshold reached | Gentle notification | "30 unlocks today. The average successful Player unlocks 22 times. Consider whether each unlock was necessary." |

**App Lock Overlay UI:**

When an app reaches its daily limit, ARISE displays a full-screen overlay when the user attempts to open it:

| Element | Specification |
|---------|--------------|
| Background | 80% black overlay with subtle red glow |
| Header | `[APP LOCK]` in Share Tech Mono, Alert Red color |
| App Name | Large Inter font: "[APP NAME]'s daily allocation: EXHAUSTED" |
| Visual | App icon in grayscale with red "X" overlay |
| Stats Row | Time used today / Limit / Overage |
| Override Button | "Override Lock" — triggers 30-second countdown |
| Override Cost | "Cost: -10 SEN, -50 XP, quest marked FAILED" |
| Close Button | "Return to ARISE" — returns user to the app |
| Sound | Low-pitched System denial tone |
| Vibration | Triple short pulse |

**Override Protocol:**
1. User taps "Override Lock"
2. 30-second countdown begins: "Override initiating in 30... 29... 28..."
3. During countdown, user can cancel (no penalty)
4. If countdown completes, app unlocks for 10 minutes
5. After 10 minutes, lock re-engages
6. SEN penalty: -10 SEN points
7. XP penalty: -50 XP
8. Any active screentime quest for that app is marked FAILED
9. Override count tracked per day; 3+ overrides in one day triggers "Impulse Control" urgent quest

---

### 7.7.6 Dashboard & Analytics

**Daily Screentime Report (generated at midnight, visible on dashboard):**

| Field | Description | Format |
|-------|-------------|--------|
| Total Screen Time | Sum of all foreground time | Hh Mm (e.g., "5h 23m") |
| Screen-On Time | Independent counter from screen state service | Hh Mm |
| Day-over-Day | Percentage change vs. yesterday | "+12%" or "-8%" with arrow |
| Category Breakdown | Pie chart (holographic ring) | Social: 2h 10m, Entertainment: 1h 45m, etc. |
| Top 5 Apps | Ranked by time spent | Instagram: 1h 23m, YouTube: 58m, etc. |
| Unlock Count | Total phone unlocks | 34 unlocks |
| Pickup Count | Total pickups (accelerometer) | 41 pickups |
| Avg Session Length | Average time between unlock and lock | 8.3 minutes |
| Longest Session | Longest continuous app usage | Instagram: 42 minutes (continuous) |
| Quest Status | Which screentime quests completed/pending | 3/5 completed |
| SEN Impact | Net SEN earned/lost today | +4 SEN (green) or -2 SEN (red) |
| 7-Day Average | Personal rolling average | "6h 12m avg (you: 5h 23m — below average ✓)" |

**Weekly Screentime Report:**

| Field | Description |
|-------|-------------|
| 7-Day Trend | Line graph: daily totals for past 7 days |
| Best Day | Day with lowest screen time + quest completion |
| Worst Day | Day with highest screen time |
| Week-over-Week | Percentage change vs. previous week |
| Category Trends | Which categories increased/decreased |
| Quest Completion | X/10 screentime quests completed |
| SEN Points | Net SEN earned from screentime behavior |
| Projected Monthly | If current trend continues: "Projected: 182h this month" |

**Visual Design:**
- Uses the same holographic cyan (`#00E5FF`) UI system as the rest of ARISE
- Ring/arc chart with color coding: **green** (under limit), **gold** (approaching 75%), **red** (exceeded)
- Animated transitions between time periods (day ↔ week ↔ month)
- Numbers use JetBrains Mono; labels use Inter; section headers use Orbitron
- Scanline overlay at 5% opacity for atmospheric texture

---

### 7.7.7 Privacy & Data Handling

**On-Device-Only Architecture:**

| Principle | Implementation |
|-----------|---------------|
| **No cloud sync** | Screentime data is stored exclusively in local SQLite (via Drift). Never transmitted to the FastAPI backend. |
| **No server processing** | All aggregation, categorization, and quest validation runs on-device. |
| **No third-party sharing** | Data is not shared with any analytics provider, advertising network, or external service. |
| **User purge** | One-tap purge: "Delete All Screentime Data" in Settings → System Config → Privacy. Immediate deletion, no confirmation delay. |
| **Retention** | Raw session data retained for 90 days; daily summaries retained indefinitely (user can export or delete). |
| **GDPR compliance** | Screentime data is personal data under GDPR Article 9. Explicit opt-in consent collected during onboarding. Consent can be withdrawn at any time, which immediately stops collection and offers data deletion. |
| **ARISE exclusion** | Time spent in the ARISE app itself is excluded from all screentime calculations. The System does not count itself. |

---

### 7.7.8 Technical Implementation

**Native Kotlin Service Architecture:**

```
ScreentimeMonitorService (ForegroundService)
├── ScreenStateReceiver (BroadcastReceiver)
│   ├── ACTION_SCREEN_ON → record start time
│   └── ACTION_SCREEN_OFF → calculate duration, save session
├── UsageStatsCollector (WorkManager-driven)
│   ├── queryAndAggregateUsageStats() every 15 minutes
│   ├── queryEvents() for session-level detail
│   └── validate against screen-on counter
├── AppCategorizationEngine
│   ├── HeuristicMapper (package name → category)
│   ├── LocalMLClassifier (tflite, on-device)
│   └── UserOverrideStore (SQLite)
├── LimitEnforcer
│   ├── checkDailyLimit() → trigger if exceeded
│   ├── checkAppLimit() → trigger app lock overlay
│   ├── checkCategoryLimit() → notify if approaching
│   └── checkFocusSession() → detect focus breach
└── DataStore (Drift/SQLite)
    ├── AppUsageSession table
    ├── DailyScreentimeSummary table
    ├── AppLimit table
    └── AppCategoryMapping table
```

**Flutter MethodChannel API (`screentime`):**

| Method | Parameters | Returns | Purpose |
|--------|-----------|---------|---------|
| `requestPermission()` | None | `bool` (granted) | Check/request PACKAGE_USAGE_STATS |
| `getDailyStats(date)` | ISO date string | `DailyScreentimeSummary` JSON | Full daily report |
| `getAppBreakdown(date, category?)` | Date, optional category filter | `List<AppUsage>` JSON | Per-app usage details |
| `setAppLimit(packageName, limitMs, activeDays)` | Package, milliseconds, days array | `bool` (success) | Create/update app limit |
| `removeAppLimit(packageName)` | Package name | `bool` (success) | Remove app limit |
| `lockApp(packageName, durationMs)` | Package, milliseconds | `bool` (success) | Immediate app lock |
| `unlockApp(packageName)` | Package name | `bool` (success) | Remove active lock |
| `isAppLocked(packageName)` | Package name | `bool` | Check lock status |
| `setCategoryLimit(category, limitMs)` | Category enum, milliseconds | `bool` | Set category-level limit |
| `startFocusSession(durationMs, blockedCategories)` | Duration, categories to block | `String` (sessionId) | Begin focus mode |
| `endFocusSession(sessionId)` | Session ID | `FocusResult` JSON | End and evaluate focus session |
| `isMonitoringActive()` | None | `bool` | Whether all services are running |
| `purgeAllData()` | None | `bool` | Delete all screentime data |

**Flutter EventChannel (`screentime_events`):**

| Event | Payload | Trigger |
|-------|---------|---------|
| `limit.approaching` | `{category, currentMs, limitMs, percent}` | 75% of any limit reached |
| `limit.exceeded` | `{category, currentMs, limitMs, overageMs}` | 100% of any limit reached |
| `focus.breached` | `{sessionId, packageName, timestamp}` | Blocked app opened during focus |
| `app.locked` | `{packageName, lockExpiry}` | App lock enforced |
| `app.unlocked` | `{packageName, overrideUsed}` | App lock removed (natural or override) |
| `screen.on` | `{timestamp}` | Screen turned on |
| `screen.off` | `{timestamp, sessionDurationMs}` | Screen turned off |
| `daily.summary.ready` | `{date, summaryJson}` | Midnight daily aggregation complete |
| `protocol.breached` | `{protocolType, timestamp, packageName}` | Morning/evening protocol violated |
| `sen.changed` | `{delta, reason, newTotal}` | SEN points earned or lost |
| `quest.completed` | `{questId, questType, rewards}` | Screentime quest auto-completed |
| `quest.failed` | `{questId, questType, reason}` | Screentime quest failed (limit exceeded) |

**WorkManager Schedule:**
```kotlin
val screentimeWork = PeriodicWorkRequestBuilder<ScreentimeCollectorWorker>(
    repeatInterval = 15, 
    repeatIntervalTimeUnit = TimeUnit.MINUTES
)
    .setConstraints(
        Constraints.Builder()
            .setRequiresBatteryNotLow(true)
            .build()
    )
    .build()

WorkManager.getInstance(context)
    .enqueueUniquePeriodicWork(
        "screentime_collection",
        ExistingPeriodicWorkPolicy.KEEP,
        screentimeWork
    )
```

---

### 7.7.9 Integration with Existing ARISE Systems

**Quest System Integration:**
- Screentime quests appear alongside regular daily quests in the quest feed
- Auto-complete via UsageStatsManager data (no manual check-in required)
- Can be rejected like other quests (up to 2 per day)
- Count toward daily quest completion total
- Reward primarily SEN, with secondary INT (focus) and VIT (evening protocol)

**Penalty System Integration:**
- Failing screentime quests triggers same penalty tiers as other quests
- Excessive screentime (2× limit) → "Digital Gluttony" debuff: -2 SEN/day until 3 consecutive compliant days
- App lock override → Minor penalty: -10 SEN, -50 XP
- 3+ app lock overrides in one day → Moderate penalty + "Impulse Control" urgent quest
- "Digital Monk" title (SEN 60) → Immunity to 1 screentime penalty per week

**Notification System Integration:**
- Uses the same escalation matrix (calm → firm → urgent → nuclear)
- App lock full-screen takeovers use the same native Kotlin alarm architecture
- Focus session breach notifications sent via `awesome_notifications` with immediate priority
- Evening protocol warnings use the same timing intelligence algorithm

**Stats Integration:**
- **SEN (primary):** All screentime quests reward SEN; SEN decay prevented by daily screentime compliance
- **INT (secondary):** Focus session quests reward INT (sustained attention → cognitive enhancement)
- **VIT (tertiary):** Evening protocol quests reward VIT (better sleep hygiene → vitality)

**Skill Tree Integration:**
- "Digital Awareness" skill branch (SEN tree) unlocks at SEN 20
- Skills: Focus Lock (SEN 20), App Domination (SEN 30), Protocol Master (SEN 40), Digital Ascension (SEN 60)
- Each skill provides passive benefits to screentime features

**Leaderboard Integration:**
- "Digital Discipline" sub-leaderboard: ranked by SEN points earned from screentime quests
- Anonymous; no specific app usage data visible to other players
- Weekly reset with "Digital Disciplinarian" title for top 10%

---

### 7.7.10 API Reference Summary

| API | Class | Min API | Purpose |
|-----|-------|---------|---------|
| `UsageStatsManager` | `android.app.usage.UsageStatsManager` | 21 | Core usage data retrieval |
| `UsageStats` | `android.app.usage.UsageStats` | 21 | Per-app usage statistics object |
| `UsageEvents` | `android.app.usage.UsageEvents` | 21 | Session-level event stream |
| `AppOpsManager` | `android.app.AppOpsManager` | 19 | Permission status checking |
| `Settings.ACTION_USAGE_ACCESS_SETTINGS` | `android.provider.Settings` | 21 | Redirect to usage access settings |
| `ACTION_SCREEN_ON` | `android.content.Intent` | 1 | Screen turned on |
| `ACTION_SCREEN_OFF` | `android.content.Intent` | 1 | Screen turned off |
| `ForegroundService` | `android.app.Service` | 26 | Background screen state tracking |
| `WorkManager` | `androidx.work.WorkManager` | 14 | Periodic usage data collection |
| `BroadcastReceiver` | `android.content.BroadcastReceiver` | 1 | Screen state event capture |
| `DeviceStateManager` | `android.hardware.devicestate.DeviceStateManager` | 34 | Android 14+ device state API |
| `NotificationManager` | `android.app.NotificationManager` | 14 | App lock overlay notifications |
| `PackageManager` | `android.content.pm.PackageManager` | 1 | Installed app enumeration |

---

## 8. Penalty & Consequence System

### 8.1 Design Philosophy

> **Core Axiom:** "Failure must be treated with dignity — consequences with gravitas, then a path forward."

The penalty system is built on research-backed psychological principles:

- **Loss Aversion (2x Motivator):** Losses feel roughly twice as powerful as equivalent gains [^431^][^540^]. A 90-day streak feels like an asset worth protecting.
- **Abstinence Violation Effect (AVE):** A single lapse triggers guilt, shame, and perceived failure, leading users to conclude "the streak is ruined, I might as well give up" [^463^][^305^]. Only 0.90% of users who lose a 2–3 day streak return to build a new one [^303^].
- **Recovery-First Design:** Assuming all users will miss days, building Grace Periods from day one, making Recovery Quests compelling alternatives to perfection [^168^].
- **The Dignity Principle:** Apps that treat a break as definitive convert a retention risk into a churn event — at the moment when a user who is already struggling is most vulnerable [^303^].
- **Framing Is Everything:** World of Warcraft's "Rested XP" system used identical math to the original XP degradation but opposite player reactions — framing transforms punishment into reward [^545^].
- **Self-Determination Theory:** All penalty systems must preserve Autonomy, Competence, and Relatedness [^54^][^525^].

### 8.2 Penalty Tiers

| Tier | Trigger | Stat Impact | XP Impact | Duration |
|------|---------|-------------|-----------|----------|
| **Minor (Lapse)** | Missed 1 daily quest | No stat decay; soft reminder | No XP loss | Immediate recovery |
| **Minor (Gap)** | Missed 2 consecutive dailies | -2% to primary quest stat | -5% session XP → Recovery Pool | 24h or Redemption Quest |
| **Moderate (Slip)** | Missed 3+ consecutive dailies OR 1 weekly | -5% all stats, decay begins | -10% level progress → Recovery Pool | 72h or Redemption Quest chain |
| **Moderate (Abandon)** | Dungeon abandoned mid-run | -8% primary dungeon stat; "Weakened" debuff | -15% dungeon XP → Recovery Pool | Until dungeon re-completed OR 48h |
| **Major (Collapse)** | 7+ days inactive | -10% all stats; "Cursed" debuff; rank vulnerability | -20% level progress → Recovery Pool | Until Major Redemption Quest |
| **Major (Exile)** | 14+ days inactive OR voluntary quit | -15% all stats; rank freeze | -25% level progress → Recovery Pool | Until Epic Redemption Quest |

**Design Notes:**
- No permanent XP loss — all "lost" XP goes into a **Recovery Pool** earned back at 1.5x rate [^468^]
- Stat decay caps at floor values — stats never decay below 50% of base value
- The Recovery Pool mechanic: inspired by Dark Souls' bloodstain system [^524^] and Hollow Knight's Shade [^492^]
- Grace Periods built in from day one: 1 "Revival Potion" per week (earned, not purchased) [^168^]

### 8.3 Stat Decay Mechanics

**Decay Formula (Weekly):**
- Each stat decays by 1 point per 7 days of inactivity in that domain
- Decay only applies to stats above: `Level x 1 + 5`
- Decay is calculated weekly, not daily, to reduce anxiety
- During Redemption Quest: stat decay pauses — the system acknowledges the player is taking action

**Visual Feedback:** Decayed stats show a dimmed/grayed indicator with subtle pulsing animation — noticeable but not alarming.

### 8.4 Debuff System (7 Debuffs)

| Debuff | Effect | Duration | Cure Method |
|--------|--------|----------|-------------|
| **Weakened** | -10% to primary quest stat; quests feel harder | 24h or 3 quests completed | Complete any 3 daily quests |
| **Cursed** | -15% to all stats; reduced XP gain (0.8x) | 48h or Redemption Quest completed | Complete Redemption Quest |
| **Distracted** | -20% to Focus stat; cannot start deep-work quests | 12h or meditation/breathing exercise | Complete 1 focus exercise |
| **Drained** | -25% to VIT; physical quests cost more energy | Until next sleep logged OR rest day | Log a rest day or sleep session |
| **Isolated** | -15% to CHR; social quests disabled | Until social quest completed OR ally check-in | Complete 1 social quest |
| **Overwhelmed** | All stats -5%; quest descriptions feel heavier | Until "Break It Down" mini-quest completed | Complete a 2-minute micro-task |
| **Lost** | Cannot see full quest map; only nearest quest visible | Until any quest completed | Complete any single quest |

**Debuff Design Rules:**
- Never stack more than 2 debuffs — prevents compounding despair
- All debuffs have cure methods that teach — curing "Distracted" requires a focus exercise
- All debuffs expire naturally — worst (Cursed) expires in 48h even without action
- Narratively framed as "The Shadow's influence" or "The Abyss encroaching" — part of the world's story, not personal failure

### 8.5 Redemption Quests (6 Tiers)

| Failure Type | Redemption Quest | Structure | Duration | Reward |
|-------------|-----------------|-----------|----------|--------|
| **Missed 2 dailies** | "The Return Path" | Complete 3 dailies in 24h (any category) | 1 day | Full stat recovery + 1.2x XP for 24h + Streak restored |
| **Missed 3+ dailies** | "Reforging" | Complete 1 quest from each of 4 stat categories in 48h | 2 days | Full stat recovery + 1.5x XP for 48h + Recovery Pool accelerated |
| **Dungeon abandoned** | "The Second Attempt" | Re-enter same dungeon; enemies slightly weaker | Variable | 100% lost XP from Recovery Pool + "Resilience" badge + debuff cleared |
| **7+ day inactivity** | "The Awakening" | 5 personalized quests across 3 days tailored to historical strengths | 3 days | 75% Recovery Pool returned + "Phoenix" badge + all debuffs cleared + 2x XP for 72h |
| **14+ day inactivity** | "The Return of the Hero" | 8-quest epic chain over 5 days, culminating in boss fight vs. historical best day | 5 days | 100% Recovery Pool + exclusive "Unbroken" cosmetic + permanent +5 to one stat + 2x XP for 1 week |
| **Rank demotion** | "Reclamation" | Earn back lost rank through compressed progression (50% faster) | Variable | Rank restored + "Reclaimed" title + demotion protection for 30 days |

**Redemption Quest Principles:**
- Always harder than normal, never impossible
- Narrative framing: each is part of the world's story
- Time-limited but generous (48–72 hour windows)
- Social option: can complete with ally for +10% effectiveness [^521^]
- Post-traumatic growth inspired: SuperBetter research shows overcoming challenges builds resilience [^537^][^538^]

### 8.6 Recovery Mechanics

| Mechanic | Description | Psychological Rationale |
|----------|-------------|------------------------|
| **Recovery Pool** | All "lost" XP in visible pool; earn back at 1.5x rate | Transforms loss anxiety into productive behavior [^468^] |
| **Grace Days** | 1 free skip day per week, accumulates to max 3 | Removes catastrophic failure state [^431^] |
| **Earn Back** | 48h window after streak break to restore via harder quest | Turns loss into opportunity; Duolingo's masterclass mechanic [^430^][^435^] |
| **Soft Landing** | Partial streak preservation with "Best Streak" badge | Preserves identity investment [^305^] |
| **Stat Decay (vs. Binary Loss)** | Gradual -1% per day instead of sudden -50% | Gives warning signals and time to act [^463^] |
| **Revival Potions** | Earned items preventing streak loss | "Just knowing the potion exists changes how users feel" [^168^] |
| **Welcome Back Flow** | Personalized return sequence without guilt | Headspace's approach: break as recoverable interruption [^303^] |
| **Comeback Bonus** | 2x XP for returning players for first 3 days | Creates "return honeymoon" |
| **Degradation Pause** | Stat decay pauses while Redemption Quest active | Acknowledges effort; prevents fighting a ticking clock |
| **The Shade / Bloodstain Model** | Recoverable loss requiring a "corpse run" | Dark Souls and Hollow Knight: consequence is real but recovery is skill-based [^492^][^524^] |
| **Rank Floor Protection** | Can never drop below highest tier achieved | Apex Legends model: bad performances knock down divisions but never below highest rank tier [^440^] |

**The Five Pillars of Penalty Safety:**
1. **Predictability:** Users always know what will happen if they miss
2. **Proportionality:** Consequence matches the failure
3. **Recoverability:** Every penalty has a clear, achievable path to recovery
4. **Dignity in Delivery:** "Your streak has paused" not "You lost your streak!"
5. **Agency Preservation:** Users always have choices

---

## 9. Social & Guild System

### 9.1 Guild System

**Guild Structure:**

| Feature | Description | Privacy |
|---------|-------------|---------|
| **Guild Creation** | Any Hunter Rank E+ can create; max 1 guild per user; names must be unique | Guild name visible; creator identity private |
| **Guild Size** | 2–10 members (hard cap) — intimacy produces higher contribution rates [^470^] | Member count visible; member list private |
| **Guild Roles** | Guild Master (1), Officer (1–2), Soldier (remaining) | Visible to members only |
| **Guild Tiers** | Bronze → Silver → Gold → Platinum → Diamond (based on collective weekly completion) | Tier badge visible publicly |
| **Guild Hall** | Shared visual space showing all member shadows in formation; customizable banner | Members only |

**Membership Mechanics:**
- Join Methods: Direct invite, join link (24h expiry), guild code (6-character alphanumeric)
- No open/public guild discovery — all guilds invite-only or code-access [^605^]
- No "guild kick" feature — toxicity prevention through exit, not exclusion
- Guild Master auto-transfers to most active member after 14 days of GM inactivity
- Users can belong to exactly 1 guild at a time

**Shared Guild Leaderboard:**
- Intra-guild weekly board: ranks members by completion rate
- Sorting: Primary by weekly completion %, secondary by total XP
- No punishment for misses: ranks by positive completion, not penalizing failures [^494^]

### 9.2 Guild Raids

| Raid Type | Duration | Requirement | Reward |
|-----------|----------|-------------|--------|
| **Daily Skirmish** | 24 hours | 100% member completion of all Dailies | +10% XP bonus; +1 Essence shard per member |
| **Weekly Campaign** | 7 days | 70%+ guild average completion | Tiered: 70–79% Bronze, 80–89% Silver, 90–99% Gold, 100% Legendary chest |
| **Boss Assault** | 72 hours | Collective 500+ habits across all members | Boss Slayer badge; highest contributor gets named Shadow |
| **Solo Leveling Marathon** | 30 days | 85%+ average completion for full month | Exclusive Shadow Army skin; guild name on Seasonal Monument |

**70% Threshold Design:** Raids succeed at 70%+ completion to avoid "one member fails, everyone suffers" dynamic. Research shows cooperative structures where individual failure doesn't collapse group rewards produce higher motivation [^464^].

### 9.3 Leaderboards

**Anonymous Global Leaderboard:**

| Board Type | Sorting | Visibility |
|------------|---------|------------|
| Global Hunter Rank | By Hunter Rank tier, then XP within tier | Username only (chosen pseudonym); no photos, no guild names, no flags |
| Weekly XP Gainers | Most XP earned this week | Username + rank change arrow |
| Shadow Army Strength | Total shadow power score | Username + rank only |
| Streak Legends | Longest active daily streak | Username + streak count |

**Design Principles:**
- Username-Only Policy: pseudonyms only (e.g., "ShadowHunter_7", "IgrisFan") — no avatars, no guild affiliation [^604^][^605^]
- No Click-Through: usernames NOT clickable — cannot view profiles from board
- Opt-IN at onboarding (not opt-out); toggle off anytime with immediate effect [^530^]

**Guild vs. Global:**

| Dimension | Guild Leaderboard | Global Leaderboard |
|-----------|-------------------|-------------------|
| Identity | Real guild names + member pseudonyms | Anonymous pseudonyms only |
| Scope | Within guild | Entire server |
| Metric | Weekly completion % | Hunter Rank / XP / Shadow Power |
| Clickable | Yes | No (static display only) |

### 9.4 Accountability Partners

**1:1 Body Doubling System:**
- Matching: Invite friend via link/code OR be matched by app based on similar Hunter Rank and active hours
- Partnership Structure:
  - Partners see daily habit completion status (completed/not completed, NOT content)
  - 3 pre-written check-in prompts per day: "How's today going?", "Don't forget your habits!", "You've got this!"
  - No free-text messaging — structured prompts only to prevent social obligation creep [^591^]
- Check-in Windows: Partners agree on shared check-in time (e.g., 9 AM and 9 PM)
- Partnership Streak: Consecutive days both completed all Dailies; breaking it resets both
- Max 1 partnership at a time; either partner can end without approval or notification

**Research Basis:** Having a specific accountability appointment increases goal completion to 95% (vs. 65% for just telling someone) [^165^]. Focusmate users report 161% productivity increases from virtual body doubling [^165^].

### 9.5 Toxicity Prevention (10 Mechanics)

| # | Prevention Mechanic | Description |
|---|--------------------|-------------|
| 1 | No Public Profiles | Users cannot view any profile beyond their guild. No followers, no public achievement galleries. [^605^] |
| 2 | No Free-Text Messaging | All social communication uses structured prompts. No guild chat, no DMs, no comments. [^494^] |
| 3 | No Failure Broadcasting | Failed habits and missed days are NEVER visible. Only completions shared. |
| 4 | No Rank Shaming | Global leaderboard: pseudonyms only, no click-through. No way to identify top/bottom players. |
| 5 | No Guild Kick | Members can leave but cannot be kicked. Prevents bullying through exclusion. |
| 6 | Guild Size Cap (10) | Small groups create accountability; large groups create anonymity for toxic behavior [^615^]. |
| 7 | Anonymous Global Only | Only public social signal is anonymous leaderboard. No identity, no guild affiliation. [^602^][^604^] |
| 8 | No Competitive Penalties | Losing a raid = no bonus (not damage, not lost items, not public defeat). |
| 9 | Positive Framing Only | All feed messages frame progress positively. No "X missed their habits." |
| 10 | Emotion-Neutral Design | Status indicators use color-coded bars, not emojis forcing emotional expressions. [^494^] |

**Shame Avoidance:** No "Perfect Day" shaming; no visible failure chains; realistic affirmations: "You're building consistency, one day at a time" not "You're amazing! Crush it!" [^494^]

### 9.6 Shadow Army Social Metaphor

**Shadow Grades & Guild Contribution:**

| Shadow Grade | Solo Leveling Equivalent [^62^] | Unlock Condition | Visual in Guild Hall |
|-------------|-------------------------------|------------------|---------------------|
| Normal | Weakest foot soldiers | Default on joining guild | Basic shadow silhouette |
| Elite | B-Rank Hunter strength | Complete 7-day streak | Shadow with weapon |
| Knight | A-Rank Hunter strength | Complete 30-day streak | Shadow with armor + nameplate |
| Elite Knight | Basic S-Rank strength | Complete 60-day streak | Shadow with aura effect |
| General | Advanced S-Rank strength | Complete 100-day streak | Shadow with speech bubble, unique animation |
| Marshal | Highest attainable rank | Complete 180-day streak | Massive shadow with particle effects |
| Grand Marshal | Lieutenant to Shadow Monarch | Complete 365-day streak | Unique legendary shadow, one per guild max |

**Guild Hall Visual:** All member shadows displayed in military formation. More active members have larger, more impressive shadows at the front. Less active members still appear but with smaller silhouettes — belonging is unconditional.

---

## 10. User Onboarding

### 10.1 Cinematic Onboarding Flow (7 Phases)

#### Phase 1: The Approach (App Store Presence)

| Element | Design |
|---------|--------|
| App Store Screenshots | Dark-themed; System interface shown; no cartoon graphics |
| Store Copy | "The System has chosen you. Everyone else is locked at their awakening rank. Only you can level up." |
| App Icon | Glowing blue holographic hexagon with faint glitch effects |
| App Name | "ARISE: The System" |

#### Phase 2: The Double Dungeon (First Launch)

| Step | Screen Design | Duration |
|------|--------------|----------|
| 2.1 The Black Screen | Pure black for 3 seconds. Then: "You feel something watching you." | 5 sec |
| 2.2 System Awakens | Blue holographic UI materializes (particle animation, scan lines). "Initializing... Player candidate detected." | 8 sec |
| 2.3 The Scan | Holographic rings rotate around user silhouette. "Scanning physical attributes... Analyzing behavioral patterns..." | 10 sec |
| 2.4 Scan Complete | Status window materializes. "Scan complete. You have been assigned the lowest possible rank. E-Rank." [^728^][^732^] | 5 sec |
| 2.5 The Paradox | "However... an anomaly detected. You possess growth potential of [LEVELING_PROTOCOL_DETECTED]. No other Player has shown this pattern." [^26^][^124^] | 8 sec |

#### Phase 3: The Assessment (6 Scan Questions)

| # | Scan Question | Options | Data Used For |
|---|--------------|---------|---------------|
| 1 | "Scanning daily movement patterns..." | Sedentary / Light / Moderate / Active | STR/VIT starting modifiers; exercise quest difficulty |
| 2 | "Analyzing recovery cycles..." | <5h / 5–6h / 7–8h / 9+h still tired | VIT/INT modifiers; recovery quest recommendations [^229^] |
| 3 | "Measuring cognitive endurance..." | Easily distracted / Focus with effort / Deep focus natural | INT/SEN modifiers; learning quest complexity [^689^] |
| 4 | "Identifying your domain of struggle..." | Physical body / Mental clarity / Emotional regulation / Energy management | Which stat gets emphasis; quest prioritization |
| 5 | "Assessing previous behavioral adaptation attempts..." | Never tried / Used apps but abandoned / Maintained 1–2 habits / Systematic builder | WIS modifier; tutorial depth [^75^] |
| 6 | "What has defeated you before?" | I start strong but quit / I forget / No results fast enough / Life gets in the way / Never tried | Coaching tone; anti-failure systems prioritized |

#### Phase 4: Starting Stats Calculation

| Assessment Answer | Stat Modifier |
|-------------------|---------------|
| Sedentary lifestyle | VIT -2 |
| <5 hours sleep | VIT -1, INT -1 |
| Easily distracted | SEN -1 |
| Never tried habit tracking | All stats baseline (E-Rank) |
| Used apps but abandoned | SEN +1 (failed attempts teach) |
| Physical body as domain | STR emphasis |
| Mental clarity as domain | INT emphasis |
| Completed onboarding without skipping | +1 to all stats (tests motivation) |

**Final stat range:** 5–10 per stat. All users see "E-Rank" regardless.

#### Phase 5: The Pact Ceremony (Commitment Device)

| Element | Description | Psychological Purpose |
|---------|-------------|----------------------|
| The Warning | "The System does not tolerate Players who accept its power without accepting its rules. This is not an app. This is a binding protocol." | Sets seriousness; filters out unmotivated users [^689^] |
| Three Laws of the System | 1. "Complete your Daily Quests. Ignoring them has consequences." 2. "Log your progress honestly." 3. "Never break the Pact voluntarily." | Structured commitment; mirrors Cartenon Temple Commandments [^702^] |
| The Choice | Two buttons: "I accept the Pact" (glows blue) / "I am not ready" (dim gray) | Active consent required; "not ready" builds trust |
| The Signature | User draws a symbol on screen (fingerprint scan animation) | Kinesthetic commitment increases psychological binding [^687^] |
| Consequence Warning | "If you fail your Daily Quests, you will be sent to the Penalty Zone. It is not pleasant. But it is necessary." | References Penalty Zone [^336^]; loss aversion per prospect theory [^690^] |

#### Phase 6: The ARISE Moment (Climactic Activation)

| Step | Design | Duration |
|------|--------|----------|
| 6.1 Blackout | Screen goes completely black. 3 seconds of silence. | 3 sec |
| 6.2 The Pulse | Single blue pulse of light expands from center. Low-frequency sub-bass sound. | 2 sec |
| 6.3 ARISE | "ARISE" fills the screen in massive holographic text. Particles coalesce. Silhouette backlit in blue. | 3 sec |
| 6.4 Status Window Materializes | Full System interface appears — stats, quests, inventory tabs. "Your interface is now active. Only you can see it." [^26^][^124^] | 5 sec |
| 6.5 First Quest Assignment | "[DAILY QUEST] Complete your first action as a Player." | 5 sec |

**Why This Works:** Pattern interrupt (blackout breaks expected UI); Peak-End Rule (the ARISE moment is the peak emotional memory); Identity transformation (ordinary person discovers they are special) [^703^].

#### Phase 7: First Quest Assignment

| Quest | Purpose | Duration |
|-------|---------|----------|
| "Log Your First Stat" | Teach stat tracking mechanic | 2 min |
| "Set Your First Habit" | Teach habit creation | 3 min |
| "Complete the First Action" | Teach completion + rewards (immediate XP, particle effects) | 1 min |
| "Enable System Notifications" | Diegetic permission request | 30 sec |
| "Set Your Wake Time" | Diegetic alarm permission | 30 sec |

Total time: under 5 minutes — matching Duolingo's sub-4-minute onboarding [^663^].

### 10.2 Permission Request Flow (Diegetic Framing)

| Permission | Diegetic Framing | When Requested | Opt-Out |
|------------|-----------------|---------------|---------|
| Push Notifications | "The System requires a communication channel to deliver quest assignments." | After first quest completion (value delivered) | "Not now" always present |
| Health Data | "The System can sync with your body's data stream for more accurate stat tracking." | When user first tries to auto-import a stat | Manual entry always available |
| Alarm/Reminders | "The System monitors your recovery cycles. Grant access to alarm management?" | During evening check-in setup | Manual reminders always available |
| Camera | "The System can verify certain physical quests through visual confirmation." | Only if user opts into photo-proof quests | Never required for core flow |
| Location | "The System can detect your environment to suggest location-appropriate quests." | Only if user opts into location features | Never required |
| Microphone | "The System supports voice-logging for faster quest completion." | When user first attempts voice input | Text input always available |

### 10.3 First Week Retention Plan

| Day | Feature Unlocked | Retention Hook | Behavioral Science |
|-----|-----------------|----------------|-------------------|
| **Day 1** | Status Window, First Quests, First XP | Immediate value + narrative immersion | Aha moment in <5 min [^703^] |
| **Day 2** | Daily Quest reset (first cycle) | "Your quests have been assigned, Player." | First completion loop [^634^] |
| **Day 3** | Stat trend graph (first 3 days) | Visual feedback: "Your STR has increased" | Progress visibility = motivation [^707^] |
| **Day 4** | Side Quest unlocked | "A Side Quest has appeared. Bonus XP available." | Novelty drives engagement [^707^] |
| **Day 5** | Level 2 reached (with consistent completion) | First level-up ceremony: stat points to distribute | Meaningful choice [^23^] |
| **Day 6** | First System check-in message | "You are still E-Rank. But your trajectory has changed." | Narrative progression; identity reinforcement |
| **Day 7** | **Week 1 Assessment** + "D-Rank Trial" quest | Full stat review + D-Rank trial creates forward commitment | Milestone moment [^654^][^656^] |

### 10.4 Progressive Disclosure

| Timeframe | Features Visible | Features Hidden |
|-----------|-----------------|-----------------|
| Onboarding (Hour 0–1) | Status Window, 1 stat, 1 habit, Daily Quests | Everything else |
| Days 1–3 | All 6 stats, up to 3 habits, basic quest system | Inventory, Store, Skills, Main Quests, Side Quests |
| Days 4–7 | Side Quests, stat trends, level-up system | Inventory, Store, Skills, Main Quests |
| Week 2 (D-Rank) | Inventory, Store preview, first Skill unlock | Advanced Skills, Guild system, Leaderboards |
| Week 3–4 | Main Quests, full Store, multiple Skills | Guild system, Leaderboards, Advanced features |
| Month 2+ | Everything unlocked progressively | Nothing permanently hidden |

---

## 11. Monetization Strategy

### 11.1 Freemium Structure

| Feature | Free Tier | Premium Tier |
|---------|-----------|--------------|
| Core habit tracking | Unlimited daily quests, XP, gold, leveling [^199^] | Same — core loop never paywalled |
| Avatar customization | Basic (gender, hair, skin tone) | Premium cosmetics, animated skins, aura effects |
| Quest slots | 5 active custom quests | Unlimited custom quests |
| Habit analytics | Basic streak + completion rate | Advanced analytics (trend analysis, correlation insights) |
| Guilds/Parties | Join guilds, participate | Create guilds, guild leader tools, custom guild banners |
| AI Goal Decomposition | 3 uses/month | Unlimited AI coaching |
| Themes/UI Skins | 1 default ("Shadow Lair") | 10+ unlockable themes |
| Dungeon Pass track | Free track with basic rewards | Premium track with exclusive cosmetics + functional rewards |
| Ads | Banner ads (non-intrusive) | Ad-free experience |
| Storage/History | 30-day history | Unlimited data export + advanced analytics |

**Conversion Benchmarks:** Freemium conversion rates range from 1.7% (industry average) [^633^] to 7.3% (habit tracker average) [^671^]. ARISE targets 5–8% given gamified engagement advantage.

### 11.2 Subscription Tiers

| Tier | Name | Price | Features | Target Segment |
|------|------|-------|----------|---------------|
| **Bronze** | "Apprentice" | $3.99/mo or $29.99/yr | Ad-free, 10 custom quest slots, basic analytics (7-day trends), 2 Dungeon Pass seasons/year, 1 premium skin | Casual users; ~60% of subscribers |
| **Silver** | "Veteran" | $8.99/mo or $59.99/yr | Everything in Bronze + unlimited quests, full advanced analytics, all 4 Dungeon Pass seasons, 5 premium skins + 2 weapon/armor sets, guild creation, priority AI decomposition | Core users; ~30% of subscribers |
| **Gold** | "Elite" | $14.99/mo or $99.99/yr | Everything in Silver + lifetime cosmetic unlocks, exclusive "Shadow Monarch" rank border + aura, personalized AI coaching with weekly check-ins, early access to new features, founder badge (first 10K) | Superfans; ~10% of subscribers |

**Pricing Psychology:** Annual subscriptions show significantly better retention — top quartile retains 2x bottom quartile at first renewal [^633^]. ARISE at $59.99/yr for Silver sits competitively against Fabulous ($49.99) and Strava ($59.99).

### 11.3 Dungeon Pass (Battle Pass)

**The Blue Ocean Opportunity:** No lifestyle, habit, or productivity app has implemented a battle pass. Battle passes in gaming achieve 8–20% conversion (vs. 1–5% for traditional IAP) [^253^][^624^]. Battle pass holders log in 30–60% more frequently [^253^].

**Season Structure:**

| Parameter | Specification |
|-----------|--------------|
| Season duration | 8 weeks (aligned with 66-day habit formation research) [^231^] |
| Total tiers | 50 tiers |
| Daily XP cap | ~3 tiers/day maximum pace |
| Completion time | Active: 4–5 weeks; Casual: full 8 weeks |
| FOMO | Exclusive season rewards never return |

**Free vs. Premium Tracks:**

| Aspect | Free Track | Premium Track ($8.99/season) |
|--------|-----------|------------------------------|
| Tiers | 50 | 50 (same progression) |
| Rewards | Basic: gold, consumables, common avatar pieces | All free rewards + 3 legendary skins + 2 weapon/armor sets + premium currency + 2x XP boost |
| Tier 50 reward | Lower-quality epic cosmetic | Premium legendary skin |

**Pricing Options:**

| Option | Price | Notes |
|--------|-------|-------|
| Standard Pass | $8.99/season | Entry point; ~70% of BP purchasers |
| Premium Pass | $14.99/season | +10 tier skips + exclusive loading screen |
| Annual Bundle | $29.99/year | All 4 seasons (25% discount) |

### 11.4 Cosmetic Monetization

| Category | Examples | Price Range |
|----------|----------|-------------|
| Avatar skins | Hunter outfits (Sung Jin-Woo style), guild uniforms, seasonal costumes | $4.99–$14.99 |
| Weapon/armor cosmetics | Shadow extraction visual effects, sword skins, dagger trails | $2.99–$9.99 |
| Rank border effects | Animated borders, particle effects, glowing auras | $1.99–$4.99 |
| UI themes | "A-Rank Dungeon", "Shadow Monarch", "Guild Hall", "Double Dungeon" | $0.99–$2.99 |
| Profile backgrounds | Epic scene art, animated landscapes, guild logos | $0.99–$3.99 |

### 11.5 Rewarded Video Ads

| Format | Retention Impact | eCPM (US) | User Sentiment |
|--------|-----------------|-----------|----------------|
| Banner ads | Negative | $0.50–$2.00 | Disliked |
| Interstitial | Moderate negative | $14.32 | Tolerated |
| Rewarded video | **Positive (+3.5x retention)** | **$19.63** | **Preferred 4:1** [^696^] |

**ARISE Implementation (Free Tier Only):**
- Small banner on home screen (bottom, non-intrusive)
- Optional rewarded video: "Watch 30s to recover a broken streak" (1/day)
- Optional rewarded video: "Watch to double today's XP gain" (1/day)
- Premium subscribers: Zero ads

**Key Insight:** Rewarded ad users are **4x more likely to make IAP** than non-ad users [^696^], making ads a conversion funnel, not just ad revenue.

### 11.6 Retention Funnel Targets

| Day | ARISE Target | Intervention |
|-----|-------------|-------------|
| D1 | 40% | Onboarding quest completion + avatar creation + party invitation |
| D7 | 20% | Streak establishment + first guild join + push personalization |
| D14 | 14% | First Dungeon Pass tier reward + social feature unlock |
| D30 | 10% | Mid-season Dungeon Pass push + guild raid participation |
| D60 | 8% | Season finale + next season preview + annual sub offer |
| D90 | 6% | Community events + leaderboard reset + new content drop |

### 11.7 LTV Optimization

**LTV Formula:** `LTV = (ARPU x Average Customer Lifetime) + Viral Coefficient Value`

| Segment | Monthly Churn | Avg Monthly Revenue | Customer Lifetime | LTV |
|---------|--------------|---------------------|-------------------|-----|
| Free user (ad monetized) | 25% | $0.50 | 4 months | $2.00 |
| Bronze subscriber | 8% | $3.33 | 12.5 months | $41.63 |
| Silver subscriber | 5% | $5.00 | 20 months | $100.00 |
| Gold subscriber | 3% | $8.33 | 33 months | $274.89 |
| Battle Pass purchaser (non-sub) | 15% | $3.00/season | 6.7 months | $20.00 |

**Target:** Blended LTV of $80–120; LTV:CAC ratio of 3:1 [^665^].

---

## 12. Data Model

### 12.1 Core Entities

**User & Player Entities:**

| Entity | Key Fields | Description |
|--------|-----------|-------------|
| `User` | id, email, pseudonym, password_hash, created_at, last_login, gdpr_consent_version | Authentication and identity |
| `Player` | user_id, level, total_xp, recovery_pool_xp, rank, title_slots, active_title_id, guild_id | Core game progression |
| `Stats` | player_id, str, agi, vit, int, sen, str_decay_at, agi_decay_at, vit_decay_at, int_decay_at, sen_decay_at | Five core stats with decay tracking |
| `XP_Log` | player_id, amount, source_type, source_id, timestamp, is_recovery_pool | Audit trail for all XP transactions |

**Quest Entities:**

| Entity | Key Fields | Description |
|--------|-----------|-------------|
| `Quest` | id, player_id, template_id, type, name, description, difficulty_rank, status, due_date, completed_at, xp_reward, stat_rewards, gold_reward | Individual quest instance |
| `Quest_Template` | id, category, subcategory, name_template, description_template, base_difficulty, variables_json, reward_base, prerequisites_json | Reusable quest patterns |
| `Chain` | id, player_id, template_id, name, current_day, total_days, status, started_at, completed_at | Multi-day chain quest state |
| `Dungeon` | id, player_id, template_id, name, duration_days, current_floor, status, started_at, last_checkpoint_floor | Dungeon run state |

**Progression Entities:**

| Entity | Key Fields | Description |
|--------|-----------|-------------|
| `Title` | id, name, description, unlock_condition, buff_effect_json, rarity, category | Title catalog |
| `Player_Title` | player_id, title_id, unlocked_at, equipped_slot | Player's title collection |
| `Item` | id, name, description, category, rarity, effect_json, icon_url | Item catalog |
| `Inventory` | player_id, item_id, quantity, acquired_at | Player's inventory state |
| `Currency` | player_id, gold, essence | Player's currency balances |
| `Transaction` | id, player_id, currency_type, amount, source_type, source_id, timestamp | Economy audit trail |

**Social Entities:**

| Entity | Key Fields | Description |
|--------|-----------|-------------|
| `Guild` | id, name, code, tier, master_player_id, member_count, created_at | Guild definition |
| `Guild_Member` | guild_id, player_id, role, joined_at, weekly_completion_rate | Guild membership state |
| `Leaderboard_Entry` | player_id, board_type, score, rank, period_start, period_end | Cached leaderboard data |
| `Accountability_Partner` | player1_id, player2_id, status, partnership_streak, created_at | 1:1 partnership |

**System Entities:**

| Entity | Key Fields | Description |
|--------|-----------|-------------|
| `Notification` | id, player_id, type, title, body, scheduled_at, delivered_at, read_at, priority | Notification log |
| `Alarm` | id, player_id, trigger_time, quest_id, escalation_level, status, recurrence | Alarm scheduling |
| `Health_Data` | player_id, data_type, value, source_app, recorded_at, synced_at | Aggregated health data |
| `Integration` | player_id, provider, access_token_encrypted, refresh_token_encrypted, status, last_synced_at | External service connections |

**Screentime Monitoring Entities (On-Device Only):**

| Entity | Key Fields | Description |
|--------|-----------|-------------|
| `AppUsageSession` | id, package_name, app_category, start_time, end_time, duration_ms, date | Individual app foreground session; 90-day retention |
| `DailyScreentimeSummary` | date, total_screen_time_ms, screen_on_time_ms, unlock_count, pickup_count, category_breakdown_json, top_apps_json, quest_completion_json, sen_earned | Daily aggregated screentime report; primary dashboard data source |
| `AppLimit` | id, package_name, daily_limit_ms, active_days_json, is_active, override_count_today, created_at | User-defined per-app time limits with enforcement rules |
| `AppCategoryMapping` | package_name, category, confidence_score, is_user_override, last_updated | App-to-category mapping; heuristic + ML + user override |
| `FocusSession` | id, start_time, end_time, duration_ms, blocked_categories_json, status (active/completed/breached/cancelled), breach_app_package, breach_time | Focus mode session tracking with breach detection |
| `ScreenOnLog` | timestamp, action (on/off), session_duration_ms | Raw screen state events from ForegroundService; validation layer |

**Privacy Note:** All screentime entities are stored exclusively in the on-device SQLite database (via Drift). They are NOT synced to the PostgreSQL backend. This is a hard architectural boundary — screentime data never leaves the device.

### 12.2 Entity Relationship Diagram

```
User (1) ————< Player (1) ————< Stats (1)
                    |
                    |———< XP_Log (N)
                    |———< Quest (N) ————> Quest_Template (N)
                    |———< Chain (N)
                    |———< Dungeon (N)
                    |———< Player_Title (N) ————> Title (N)
                    |———< Inventory (N) ————> Item (N)
                    |———< Currency (1)
                    |———< Transaction (N)
                    |———< Notification (N)
                    |———< Alarm (N)
                    |———< Health_Data (N)
                    |———< Integration (N)
                    |———> Guild (N) via Guild_Member
                    |———< Leaderboard_Entry (N)
                    |———< Accountability_Partner (N)

[ON-DEVICE ONLY — NOT SYNCED TO BACKEND]
                    |———< AppUsageSession (N) ————> AppCategoryMapping (N)
                    |———< DailyScreentimeSummary (N)
                    |———< AppLimit (N)
                    |———< FocusSession (N)
                    |———< ScreenOnLog (N)

Guild (1) ————< Guild_Member (N) ————> Player (N)
```

**Key Relationships:**
- `User` → `Player`: One-to-one; user account maps to exactly one game character
- `Player` → `Stats`: One-to-one; stats record always exists alongside player
- `Player` → `Quest`: One-to-many; player has many quest instances
- `Quest` → `Quest_Template`: Many-to-one; quests are created from templates
- `Player` → `Guild`: Many-to-one via `Guild_Member`; player belongs to 0–1 guilds
- `Player` → `Player_Title` → `Title`: Many-to-many through join table; player collects many titles
- `Player` → `Inventory` → `Item`: Many-to-many through join table; player holds many items

### 12.3 Key Data Flows

**Daily Quest Generation Flow:**
```
[Scheduled Job: 6:00 AM] → Fetch Player Profile (stats, goals, history)
  → Fetch Biometric Data (if connected) → Fetch Calendar Context
  → Compute PSI (Player Skill Index) → Query Template Library
  → Apply Difficulty Filter (Flow Score ± tolerance) → Apply Temporal Filter
  → Inject 10–20% Novel Templates → LLM Personalization Layer
  → Difficulty Validator → Reward Validator → Conflict Checker
  → Create Quest Records → Schedule Alarms → Send Morning Briefing
```

**Quest Completion Flow:**
```
[User Marks Complete] → Validate Quest Status
  → Check Auto-Completion Rules (Health Connect data if available)
  → Award XP → Update Stats → Award Gold → Check Level-Up
  → Check Rank-Up → Check Title Unlocks → Check Streak Milestones
  → Award Milestone XP → Update Leaderboards (async)
  → Send Celebration Notification → Trigger Confetti Animation
```

**Health Data Sync Flow:**
```
[WorkManager: Every 15 min] → Read Health Connect Aggregates
  → Compare Against Active Quest Thresholds
  → Auto-Complete Eligible Quests → Update Stat Decay Clocks
  → Push Quest Completion Notifications → Sync to Backend
```

---

## 13. Technical Architecture

### 13.1 Flutter App Architecture

**State Management: Riverpod**
- All app state managed via Riverpod providers
- Player state: `playerProvider` (Player + Stats + Currency)
- Quest state: `activeQuestsProvider`, `dailyQuestsProvider`
- UI state: `themeProvider`, `notificationProvider`
- Async state: `AsyncValue` pattern for API calls

**Local Database: Drift (SQLite)**
- Full offline support: all quest data, player stats, inventory cached locally
- Sync strategy: Write-through cache (local write + background server sync)
- Tables: Players, Stats, Quests, Items, Inventory, Transactions, Alarms, Notifications
- Migrations: Versioned migration scripts

**Background Processing:**
- WorkManager via pigeon: periodic health sync (15-min intervals)
- Custom Kotlin AlarmService: exact alarm delivery for quest deadlines
- `MethodChannel` bridge: Kotlin service ↔ Dart callbacks
- Foreground Service (`alarmClock` type): persistent alarm scheduling

**Notification System:**
- `flutter_local_notifications`: primary notification display
- `android_alarm_manager_plus`: exact alarm scheduling
- `permission_handler`: runtime permissions
- Custom Kotlin service handles alarm firing, WakeLock acquisition, MethodChannel communication

**Key pubspec.yaml dependencies:**
```yaml
dependencies:
  flutter_riverpod: ^2.5.0
  drift: ^2.15.0
  sqlite3_flutter_libs: ^0.5.20
  flutter_local_notifications: ^18.0.0
  android_alarm_manager_plus: ^4.0.0
  permission_handler: ^11.0.0
  timezone: ^0.10.0
  health: ^11.0.0
```

### 13.2 FastAPI Backend Architecture

**API Layer:**

| Module | Endpoints | Purpose |
|--------|-----------|---------|
| `auth.py` | `/auth/*` | JWT authentication, token refresh, logout |
| `player.py` | `/player/*` | Player profile, stats, progression |
| `quests.py` | `/quests/*` | Quest CRUD, generation, completion |
| `dungeons.py` | `/dungeons/*` | Dungeon lifecycle, boss encounters |
| `social.py` | `/social/*` | Guilds, leaderboards, accountability |
| `health.py` | `/health/*` | Health data ingestion, auto-completion |
| `notifications.py` | `/notifications/*` | Notification scheduling, delivery logs |
| `store.py` | `/store/*` | Item catalog, purchases, inventory |
| `ai.py` | `/ai/*` | Goal decomposition, narrative generation |

**Database: PostgreSQL**
- Primary data store for all user, quest, social, and economy data
- JSONB columns for flexible stat modifiers, quest variables, buff effects
- Partitioning: `XP_Log` and `Transaction` tables partitioned by month
- Read replicas for leaderboard queries and analytics

**Redis Caching:**
- Player sessions and auth tokens
- Leaderboard snapshots (refreshed hourly)
- Quest template library (rarely changes)
- Rate limiting counters

**Celery Background Tasks:**
- Daily quest generation (scheduled 5 AM per timezone)
- Weekly leaderboard recalculation
- Stat decay batch processing (weekly)
- Streak milestone checks
- Inactive player detection and re-engagement triggers

**AI Service Integration:**
- Primary: OpenAI GPT-4o for goal decomposition, narrative generation, quest personalization
- Fallback: Claude API for redundancy
- Prompt templates versioned and stored in database
- Response caching: 1-hour TTL for identical requests
- Rate limiting: 100 AI calls/minute per user on free tier, unlimited on premium

### 13.3 Health Data Pipeline

```
[Partner App: Lyfta/MFP/Strava] → writes to → [Health Connect]
                                             ↑
[ARISE Android App] → reads from → [Health Connect via Jetpack SDK]
        ↓
[Local Drift DB] → caches aggregates → [Quest Completion Engine]
        ↓
[FastAPI Backend] → syncs daily → [PostgreSQL] → [Celery: decay processing]
```

**Key Decisions:**
- Health Connect as single integration point — no pairwise app integrations [^33^][^36^]
- Read-only model: ARISE reads from HC but does not write health data back
- Aggregation-first: `AggregateRequest` for daily totals, not raw records [^527^]
- Data origin filtering: `dataOriginFilter` to attribute XP to correct source [^527^]

### 13.4 Security & Privacy

**GDPR Compliance for Health Data:**

| Requirement | Implementation |
|-------------|---------------|
| Explicit Consent | Separate consent flow for health data, distinct from general T&Cs [^467^] |
| Granular Permissions | Per-data-type consent toggles, not blanket approval |
| Two-Step Confirmation | Select data types → Summary review → Confirm [^467^] |
| Right to Erasure | Account deletion triggers full data purge within 30 days (GDPR Article 17) [^521^][^528^] |
| Data Minimization | ARISE reads only aggregated totals; raw health data stays in Health Connect |
| Consent Versioning | All consent records timestamped with version, scope, IP, user agent [^467^] |
| One-Tap Withdrawal | Health permissions revocable from ARISE settings, triggering immediate data deletion |
| DPIA | Data Protection Impact Assessment mandatory for health data processing [^475^] |

**Encryption:**
- At rest: AES-256 encryption for PostgreSQL (via pgcrypto), encrypted backups
- In transit: TLS 1.3 for all API communications
- Sensitive fields: Health tokens encrypted at application level before storage
- Key management: AWS KMS or HashiCorp Vault for key rotation

---

## 14. API Contract (Key Endpoints)

### 14.1 Authentication

| Endpoint | Method | Body | Response | Description |
|----------|--------|------|----------|-------------|
| `/auth/register` | POST | `{email, password, pseudonym}` | `{access_token, refresh_token, player}` | Create account |
| `/auth/login` | POST | `{email, password}` | `{access_token, refresh_token, player}` | Login |
| `/auth/refresh` | POST | `{refresh_token}` | `{access_token}` | Refresh JWT |
| `/auth/logout` | POST | — | `{success}` | Invalidate tokens |
| `/auth/me` | GET | — | `{user, player}` | Get current user |

### 14.2 Player/Stats

| Endpoint | Method | Body | Response | Description |
|----------|--------|------|----------|-------------|
| `/player/profile` | GET | — | `{player, stats, rank, titles}` | Full player profile |
| `/player/stats` | GET | — | `{str, agi, vit, int, sen, derived}` | Current stats + derived |
| `/player/allocate` | POST | `{stat, points}` | `{updated_stats}` | Allocate stat points |
| `/player/xp-history` | GET | `?days=30` | `{entries[]}` | XP log with pagination |
| `/player/rank-up` | POST | — | `{new_rank, rewards}` | Trigger rank-up ceremony |

### 14.3 Quests

| Endpoint | Method | Body | Response | Description |
|----------|--------|------|----------|-------------|
| `/quests/daily` | GET | — | `{quests[]}` | Today's daily quests |
| `/quests/generate` | POST | `{date}` | `{quests[]}` | Generate quests for date |
| `/quests/{id}/accept` | POST | — | `{quest}` | Accept a quest |
| `/quests/{id}/complete` | POST | `{proof?}` | `{rewards, level_up?}` | Complete a quest |
| `/quests/{id}/abandon` | POST | — | `{penalty?}` | Abandon a quest |
| `/quests/custom` | POST | `{name, description, difficulty, rewards}` | `{quest}` | Create custom quest |
| `/quests/active` | GET | — | `{quests[]}` | All active quests |

### 14.4 Dungeon/Chain

| Endpoint | Method | Body | Response | Description |
|----------|--------|------|----------|-------------|
| `/dungeons/available` | GET | — | `{dungeons[]}` | Available dungeons for player |
| `/dungeons/{id}/start` | POST | — | `{dungeon_run}` | Begin dungeon |
| `/dungeons/{id}/progress` | GET | — | `{current_floor, progress_pct}` | Get dungeon progress |
| `/dungeons/{id}/boss` | POST | `{result}` | `{rewards, next_floor?}` | Report boss result |
| `/chains/available` | GET | — | `{chains[]}` | Available chain quests |
| `/chains/{id}/start` | POST | — | `{chain}` | Begin chain quest |
| `/chains/{id}/advance` | POST | `{day_completed}` | `{next_day_quest}` | Advance chain |

### 14.5 Social/Guild

| Endpoint | Method | Body | Response | Description |
|----------|--------|------|----------|-------------|
| `/social/guilds` | GET | `?code=` | `{guilds[]}` | Search guilds by code |
| `/social/guilds` | POST | `{name}` | `{guild}` | Create guild (premium) |
| `/social/guilds/{id}/join` | POST | — | `{membership}` | Join guild |
| `/social/guilds/{id}/leave` | POST | — | `{success}` | Leave guild |
| `/social/guilds/{id}/members` | GET | — | `{members[]}` | List guild members |
| `/social/guilds/{id}/raid/start` | POST | `{raid_type}` | `{raid}` | Start guild raid |
| `/social/leaderboard/global` | GET | `?board_type=` | `{entries[]}` | Global leaderboard |
| `/social/leaderboard/guild` | GET | — | `{entries[]}` | Guild leaderboard |
| `/social/partner` | POST | `{partner_id}` | `{partnership}` | Create accountability partnership |
| `/social/partner/check-in` | POST | `{status}` | `{partnership}` | Partner check-in |

### 14.6 Health Data

| Endpoint | Method | Body | Response | Description |
|----------|--------|------|----------|-------------|
| `/health/sync` | POST | `{data_type, value, timestamp}` | `{synced}` | Submit health data |
| `/health/auto-complete` | GET | — | `{auto_completed_quests[]}` | Check auto-completion |
| `/health/integrations` | GET | — | `{integrations[]}` | List connected health apps |
| `/health/integrations` | POST | `{provider, token}` | `{integration}` | Connect health app |

### 14.7 Notifications

| Endpoint | Method | Body | Response | Description |
|----------|--------|------|----------|-------------|
| `/notifications` | GET | `?unread_only=` | `{notifications[]}` | List notifications |
| `/notifications/{id}/read` | POST | — | `{success}` | Mark as read |
| `/notifications/preferences` | GET | — | `{preferences}` | Get notification settings |
| `/notifications/preferences` | PUT | `{preferences}` | `{updated}` | Update settings |
| `/notifications/schedule` | POST | `{type, time, quest_id}` | `{alarm}` | Schedule notification |

### 14.8 Store/Items

| Endpoint | Method | Body | Response | Description |
|----------|--------|------|----------|-------------|
| `/store/items` | GET | `?category=` | `{items[]}` | List store items |
| `/store/purchase` | POST | `{item_id, currency}` | `{inventory_update}` | Purchase item |
| `/store/lootbox` | POST | `{type: blessed|cursed}` | `{item_won}` | Open loot box |
| `/inventory` | GET | — | `{items[]}` | List inventory |
| `/inventory/equip` | POST | `{item_id}` | `{equipped}` | Equip item |

---

## 15. Development Phases

### Phase 1: Foundation (Months 1–3)

**Objective:** Core loop functional — onboarding, daily quests, stats, XP, notifications, local database, basic UI.

| Milestone | Deliverable | Success Criteria |
|-----------|------------|-----------------|
| M1.1 | Cinematic onboarding flow (7 phases) | >80% completion rate in user testing |
| M1.2 | 5-stat system with starting calculation | Stats personalized from 6 assessment questions |
| M1.3 | Daily quest generation (rule-based) | 3 quests/day, 4 domains supported |
| M1.4 | XP/Leveling system (levels 1–100) | XP curve: `100 * (level ^ 1.5)` functional |
| M1.5 | Local database (Drift/SQLite) | Full offline support; sync to backend |
| M1.6 | Basic System UI (dark theme, cyan accents) | All screens match visual design system |
| M1.7 | Notification system (basic) | Morning briefing + quest deadline alerts |
| M1.8 | Penalty Zone v1 (basic consequence) | Missed quest triggers harder recovery quest |
| M1.9 | **Screentime monitoring (basic)** | `UsageStatsManager` integration; daily/weekly screentime reports; heuristic app categorization; daily screentime limit quest |

**4 Domains Supported:** Body (Physical Health), Mind (Mental Health), Nutrition, Discipline.

**Team:** 2 Flutter developers, 1 FastAPI backend developer, 1 UI/UX designer.

---

### Phase 2: Ranking Engine (Months 3–5)

**Objective:** Full progression system — ranks, chains, dungeons, titles, difficulty calibration.

| Milestone | Deliverable | Success Criteria |
|-----------|------------|-----------------|
| M2.1 | Full rank system (E→S + National Level) | Rank-up ceremonies implemented with visual effects |
| M2.2 | Chain quests (7/14/30-day) | 3 archetypes with day-by-day progression |
| M2.3 | Dungeon system (30/60/90-day) | 3 dungeon templates with boss floors |
| M2.4 | Title system (30+ titles) | Titles grant passive buffs; collection interface |
| M2.5 | Penalty system v2 (full recovery-first) | Recovery Pool, Grace Days, Streak Freeze, Earn Back |
| M2.6 | Difficulty calibration engine | Flow-based DDA with 6 difficulty tiers |
| M2.7 | Skill tree (5 branches, 25+ skills) | Branching specialization from Level 11 |
| M2.8 | Health Connect integration | Steps, workouts, sleep auto-sync |
| M2.9 | **Screentime limits v2** | Per-app time limits; app lock overlay with override friction; focus session quests; category-level quests; SEN stat integration for digital discipline |

**Deliverables:** All core RPG mechanics functional. App feels like a complete game.

**Team:** 3 Flutter developers, 2 FastAPI backend developers, 1 ML engineer (difficulty calibration), 1 designer.

---

### Phase 3: Intelligence Layer (Months 5–7)

**Objective:** AI features, full domain support, calendar integration, advanced personalization.

| Milestone | Deliverable | Success Criteria |
|-----------|------------|-----------------|
| M3.1 | AI quest generation (LLM-powered) | Personalized narrative quest descriptions |
| M3.2 | Goal decomposition engine | 7-component pipeline breaks goals into quest trees |
| M3.3 | Full 12-domain support | All life domains with appropriate frameworks |
| M3.4 | Calendar integration (Google Calendar) | Free-time slot detection; quest scheduling around events |
| M3.5 | Narrative generation engine | System voice consistent across all quest types |
| M3.6 | Advanced analytics dashboard | Trend analysis, correlation insights, predictive warnings |
| M3.7 | Manual entry & photo proof system | 4 trust tiers implemented |
| M3.8 | Full notification system v2 | Escalation matrix, ML timing, OEM workarounds |
| M3.9 | **Advanced digital wellness** | Morning/evening protocol quests; digital sabbath quest; unlock/pickup count quests; on-device ML app categorization; advanced screentime analytics dashboard; custom app categorization; scheduled app locks |

**Team:** 3 Flutter developers, 2 FastAPI backend, 2 ML engineers, 1 designer, 1 QA engineer.

---

### Phase 4: Social Layer (Months 7–9)

**Objective:** Guild system, leaderboards, accountability partners, social features.

| Milestone | Deliverable | Success Criteria |
|-----------|------------|-----------------|
| M4.1 | Guild system (create, join, manage) | 2–10 member guilds with roles |
| M4.2 | Guild raids (4 types) | 70% threshold cooperative mechanics |
| M4.3 | Anonymous global leaderboards | Username-only; no click-through; opt-in |
| M4.4 | Accountability partner system | 1:1 body doubling with structured prompts |
| M4.5 | Shadow Army social metaphor | 7 shadow grades with Guild Hall visuals |
| M4.6 | Server-wide events (4 types) | World Boss, Seasonal Rift, Hunter Examination, Guild Tournament |
| M4.7 | Invite & referral system | Deferred deep linking; double-sided rewards |
| M4.8 | Toxicity prevention (10 mechanics) | No public profiles, no free-text messaging, no failure broadcasting |

**Team:** 3 Flutter developers, 2 FastAPI backend, 1 DevOps engineer (scaling), 1 designer, 2 QA engineers.

---

### Phase 5: Polish & Monetization (Months 9–12)

**Objective:** Revenue features, performance optimization, platform expansion, launch preparation.

| Milestone | Deliverable | Success Criteria |
|-----------|------------|-----------------|
| M5.1 | Subscription tiers (Bronze/Silver/Gold) | 3 tiers with appropriate feature gating |
| M5.2 | Dungeon Pass (Battle Pass) | 50 tiers, 8-week seasons, $8.99/season |
| M5.3 | Cosmetic store | Avatar skins, weapon/armor cosmetics, UI themes, rank borders |
| M5.4 | Rewarded video ads | Opt-in only; 3.5x retention positive impact |
| M5.5 | Advanced analytics (premium) | Habit correlation, predictive insights, AI coaching |
| M5.6 | Android widget + Wear OS support | Quick quest completion from widget; complications |
| M5.7 | Performance optimization | <2s cold start; 60fps animations; <100MB APK |
| M5.8 | Closed beta (1,000–5,000 users) | D1 >35%, D7 >15%, D30 >5% |

**Team:** 4 Flutter developers, 3 FastAPI backend, 2 ML engineers, 1 DevOps, 2 QA, 1 product manager, 1 growth/marketing.

---

## 16. Risk Assessment & Mitigation

### 16.1 Technical Risks

| Risk | Severity | Likelihood | Mitigation |
|------|----------|-----------|------------|
| **Android alarm reliability on OEM devices** | Critical | High | Declare as alarm app for `USE_EXACT_ALARM` auto-grant [^424^]; Samsung/Xiaomi/OPPO-specific onboarding with device-specific battery exemption guidance [^471^]; `setAlarmClock()` as primary mechanism (exits Doze) [^47^] |
| **Health Connect data availability/quality** | High | Medium | Graceful degradation: show quests not needing denied data; manual entry always available; photo proof as verification tier |
| **LLM API costs and latency at scale** | High | Medium | Response caching (1-hour TTL); prompt optimization; rate limiting per user tier; fallback to Claude API; rule-based templates for simple quests |
| **Flutter background execution limitations** | Medium | High | Custom Kotlin service via MethodChannel; foreground service with `alarmClock` type; WorkManager for non-critical sync |
| **Data sync conflicts (offline → online)** | Medium | Medium | Last-write-wins with timestamp resolution; conflict detection UI for manual resolution; upsert via `clientRecordId` [^557^] |
| **Android version fragmentation** | Medium | High | Target Android 10+ (API 29); use compatibility libraries; test on Samsung, Xiaomi, OnePlus, Pixel devices |

### 16.2 Market Risks

| Risk | Severity | Likelihood | Mitigation |
|------|----------|-----------|------------|
| **Solo Leveling IP holders enforce trademark** | Critical | Low | No direct use of "Solo Leveling" branding in app name; "ARISE" is generic; System UI concept is not copyrightable; prepare for potential licensing discussions; maintain clean legal separation from official IP |
| **Target demographic (male 18–35) doesn't convert to habit apps** | High | Medium | Strong onboarding that delivers value in <5 minutes; recovery-first design reduces intimidation; social features provide extrinsic motivation; free tier is genuinely usable |
| **Competitors copy battle pass mechanic** | Medium | Medium | First-mover advantage; deep System IP aesthetic harder to replicate; community and Shadow Army features create stickiness; continuous content updates |
| **User acquisition costs exceed projections** | High | Medium | Organic growth via referral program; content marketing (Solo Leveling communities); influencer partnerships in anime/gaming space; rewarded ads as lower-cost acquisition channel |
| **Retention below targets** | High | Medium | Recovery-first design targets 48% longer streaks [^303^]; guild features increase retention 3–5x [^677^]; battle pass holders log in 30–60% more frequently [^253^] |

### 16.3 Regulatory Risks

| Risk | Severity | Likelihood | Mitigation |
|------|----------|-----------|------------|
| **GDPR health data violations** | Critical | Low | Explicit consent flow; granular per-type permissions; DPIA completed; data minimization; right to erasure within 30 days; consent versioning [^475^][^467^] |
| **Google Play alarm app policy changes** | High | Medium | Monitor policy updates quarterly; maintain alternative notification strategy (heads-up + wake screen); diversify beyond alarm-dependent features |
| **Health data breach** | Critical | Low | AES-256 at rest; TLS 1.3 in transit; encrypted tokens; AWS KMS/HashiCorp Vault; regular security audits; penetration testing before launch |
| **COPPA compliance if under-13 users access** | Medium | Low | Age verification at onboarding; flag accounts with suspicious patterns; content appropriate for all ages; parental controls documentation |

### 16.4 Mitigation Strategies Summary

| Strategy | Implementation |
|----------|---------------|
| **Graceful Degradation** | Every feature that depends on external data (health, calendar) has manual entry fallback |
| **Offline-First Architecture** | Local SQLite database ensures core functionality works without internet |
| **Multi-Provider AI** | GPT-4o primary, Claude fallback, rule-based templates for simple cases |
| **Legal Review** | Trademark search completed; IP separation maintained; licensing options explored |
| **Security Audit** | Third-party penetration testing before public beta; ongoing quarterly audits |
| **Regulatory Compliance** | GDPR Article 9 explicit consent; COPPA age verification; data minimization by design |

---

## 17. Competitive Positioning

### 17.1 Feature Comparison Matrix

| Feature | ARISE | Habitica | MainQuest | LifeUp | Finch |
|---------|-------|----------|-----------|--------|-------|
| **RPG stat system (5+ stats)** | Yes Deep (STR/AGI/VIT/INT/SEN) | Yes Basic (STR/INT/CON/PER) | Yes Moderate | Yes Moderate | No No stats |
| **Stat decay mechanic** | Yes Novel — no app has this | No No decay | No No decay | No No decay | No No decay |
| **Anime/manga IP aesthetic** | Yes Solo Leveling System UI | No 8-bit pixel art | No Generic fantasy | No Generic RPG | No Cute bird |
| **Battle Pass / Dungeon Pass** | Yes First in category | No No BP | No No BP | No No BP | No No BP |
| **AI goal decomposition** | Yes LLM-powered, 7 frameworks | No Manual only | No Templates only | No Templates only | No Pre-set goals |
| **Full-screen alarm notifications** | Yes Native Kotlin + FSI | No Basic push | No Basic push | No Basic push | No Basic push |
| **Health Connect integration** | Yes 14 data types | No No health data | No No health data | No No health data | No No health data |
| **Guild system (2–10 members)** | Yes With raids | Yes Larger parties | No No guilds | No No guilds | No No guilds |
| **Anonymous leaderboards** | Yes Pseudonym-only | No Username visible | No No leaderboards | No No leaderboards | No No leaderboards |
| **Recovery-first penalties** | Yes Inspired by Hollow Knight/Dark Souls | No Death mechanic (punitive) | No Basic penalties | No Basic penalties | No No penalties |
| **Wear OS support** | Yes Complications + AOD | No No wearable | No No wearable | No No wearable | No No wearable |
| **Subscription price** | $29.99–$99.99/yr | $47.99/yr | Free | $4.99 one-time | $39.99/yr |
| **Target demographic** | Male 18–35 | Mixed/all ages | Mixed | Mixed | Female-skewed |

### 17.2 Key Differentiators

1. **Solo Leveling IP Authenticity:** The first habit tracker built around the most popular manhwa aesthetic. Dark holographic UI, clinical System voice, rank progression from E to National Level — all authentic to the source material.
2. **Stat Decay (Market First):** No existing app uses stat decay. It creates a powerful engagement loop — skills require maintenance, mirroring real life, but the level floor ensures progress is never fully lost.
3. **Dungeon Pass (Category Innovation):** The first lifestyle app to implement a battle pass. 8–20% conversion rates vs. 1–5% for traditional IAP [^253^]. Creates predictable recurring revenue and strong retention.
4. **Un-ignorable Notifications:** Native Kotlin alarm service with full-screen takeovers, escalation matrices, and OEM-specific workarounds. Designed for users who need aggressive accountability.
5. **Recovery-First Architecture:** Inspired by Hollow Knight's Shade and Dark Souls' bloodstains — consequence is real but recovery is skill-based and satisfying. Targets 48% longer streaks vs. apps without recovery mechanics [^303^].

### 17.3 Blue Ocean Opportunities

| Opportunity | Market Gap | ARISE Advantage |
|-------------|-----------|-----------------|
| **Male self-improvement apps** | Current market 80%+ female-skewed | Solo Leveling aesthetic naturally appeals to men 18–35; 46.29% of mobile game revenue from this demographic [^734^] |
| **Battle pass in lifestyle apps** | Zero competitors have implemented | First-mover advantage; 8–20% conversion rates [^253^]; 30–60% more frequent logins |
| **Dark-fantasy wellness** | All wellness apps use bright/cute aesthetics | Unique positioning: "severity with beauty" — clinical authority wrapped in stunning visuals |
| **Stat decay as engagement** | No app uses RPG stat degradation | Novel mechanic that differentiates from all competitors; creates "maintenance mode" engagement |
| **Anime IP lifestyle products** | Minimal overlap between anime fandom and productivity apps | Solo Leveling has 100M+ readers/viewers; massive untapped crossover audience |

---

## 18. Appendices

### Appendix A: Solo Leveling Reference Glossary

| Term | Solo Leveling Meaning | ARISE Adaptation |
|------|----------------------|-----------------|
| **The System** | Mysterious RPG interface that grants Sung Jin-woo the ability to level up | The AI-powered app interface that gamifies the user's life |
| **Hunter** | Person who enters dungeons/gates to fight monsters | The user — a "Player" who completes real-life quests |
| **Rank (E–S)** | Classification of Hunter power level | User's progression tier based on stats and quest completion |
| **National Level** | Rank above S — the absolute pinnacle | Hidden prestige tier for Level 100+ ascended players |
| **Daily Quest** | Mandatory daily tasks assigned by the System (push-ups, running, etc.) | Daily real-life quests for physical and mental training |
| **Penalty Zone** | Desert survival punishment for missing daily quests | Consequence system with recovery quests for missed objectives |
| **Dungeon** | Dangerous space inside a Gate with monsters and loot | Multi-day challenge (30/60/90 days) with boss milestones |
| **Red Gate** | Sealed dungeon with high stakes and no escape until cleared | High-intensity weekly challenge with permadeath on abandon |
| **Shadow Extraction** | Jin-woo's ability to extract shadows from defeated enemies | Guild member visualization in Guild Hall; shadow grades represent contribution |
| **Shadow Army** | Jin-woo's army of extracted shadow soldiers | Social metaphor for guild members and their collective strength |
| **Job Change Quest** | Special dungeon to unlock a new class | Domain mastery challenge to unlock advanced skill tree branches |
| **Store / Shop** | System shop selling items, potions, and equipment | In-app store for consumables, equipment, and loot boxes |
| **Blessed Box** | Gives the player an item they *want* | Loot box based on equipped build and preferences |
| **Cursed Box** | Gives the player an item they *need* | Loot box based on lowest stats and neglected areas |
| **ARISE** | Command word for Shadow Extraction | The climactic onboarding moment; brand name of the app |

### Appendix B: Stat Decay Calculation Examples

**Example 1: Active Player (No Decay)**
- Level: 15, STR: 35
- Completes 2 strength quests this week
- Result: No decay. STR remains 35.

**Example 2: Casual Player (Minimal Decay)**
- Level: 15, STR: 35
- No strength quests for 1 week
- Level floor: 15 + 5 = 20
- After 1 week: STR 35 → 34 (1 point decay). Still well above floor.

**Example 3: Inactive Player (Floor Protection)**
- Level: 15, STR: 22
- No strength quests for 4 weeks
- Level floor: 15 + 5 = 20
- Week 1: 22 → 21
- Week 2: 21 → 20
- Week 3: At floor (20). No further decay.
- Week 4: Still 20. Floor protection active.

**Example 4: Return After Long Absence**
- Level: 15, STR was 45 before 10-week absence
- Level floor: 20
- After 10 weeks of decay: max(45 - 10, 20) = 35
- Player returns, completes 3 strength quests in first week
- Recovery: 35 + (3 x 2) = 41 (2x recovery rate)
- Second week: 41 + (2 x 2) = 45 (back to original)

### Appendix C: Quest Template Examples (10 Templates)

**Template 1: Zone 2 Cardio (Fitness)**
```json
{
  "template_id": "FIT-CARDIO-001",
  "category": "Physical Health",
  "subcategory": "Cardio",
  "name": "Zone 2 Endurance Base",
  "description": "Maintain Zone 2 heart rate (60-70% max HR) for {duration} minutes. Keep HR between {min_hr}-{max_hr} bpm.",
  "base_difficulty": 35,
  "variables": {"zone": 2, "duration": "30-45", "min_hr": "114", "max_hr": "133"},
  "reward_base": {"xp": 100, "vit": 1, "agi": 1},
  "prerequisites": {"vit": 8}
}
```

**Template 2: Deep Work Sprint (Productivity)**
```json
{
  "template_id": "PROD-DEEP-001",
  "category": "Career/Work",
  "subcategory": "Deep Work",
  "name": "Deep Work Sprint: {project}",
  "description": "Complete {pomodoros} Pomodoro sessions on {project}. Rules: phone in another room, no email, no Slack. Produce {deliverable}.",
  "base_difficulty": 55,
  "variables": {"project": "active_project", "pomodoros": "2-8", "deliverable": "specific_output"},
  "reward_base": {"xp": 180, "int": 1, "sen": 2},
  "prerequisites": {"int": 8}
}
```

**Template 3: Body Scan Meditation (Mental Health)**
```json
{
  "template_id": "MEN-MED-001",
  "category": "Mental Health",
  "subcategory": "Meditation",
  "name": "Body Scan Meditation",
  "description": "Complete a guided body scan meditation. Lie down or sit comfortably. Scan attention from toes to head, noticing sensations without judgment.",
  "base_difficulty": 15,
  "variables": {"duration": "10-20"},
  "reward_base": {"xp": 75, "sen": 2, "vit": 1},
  "prerequisites": {}
}
```

**Template 4: Progressive Overload (Strength)**
```json
{
  "template_id": "FIT-STR-001",
  "category": "Physical Health",
  "subcategory": "Strength",
  "name": "Progressive Overload: {exercise}",
  "description": "Complete {sets} sets of {reps} reps of {exercise} at {weight} lbs. Log your sets. Aim to increase weight or reps from last session.",
  "base_difficulty": 50,
  "variables": {"exercise": "bench_press|squat|deadlift|overhead_press", "sets": "3-5", "reps": "5-12", "weight": "based_on_history"},
  "reward_base": {"xp": 150, "str": 2, "vit": 1},
  "prerequisites": {"str": 10}
}
```

**Template 5: Hydration Goal (Health)**
```json
{
  "template_id": "HEA-HYD-001",
  "category": "Physical Health",
  "subcategory": "Hydration",
  "name": "Hydration Protocol",
  "description": "Drink {target_ml} ml of water today. Log each glass. Target: {glasses} glasses of {glass_size} ml.",
  "base_difficulty": 10,
  "variables": {"target_ml": "2500", "glasses": "10", "glass_size": "250"},
  "reward_base": {"xp": 50, "vit": 1},
  "prerequisites": {},
  "auto_complete": {"data_type": "HydrationRecord", "threshold": "target_ml"}
}
```

**Template 6: Anki Review Session (Learning)**
```json
{
  "template_id": "LRN-ANKI-001",
  "category": "Intellectual Growth",
  "subcategory": "Spaced Repetition",
  "name": "Anki Review: {deck}",
  "description": "Complete your Anki review for {deck}. Target: {card_count} cards. Focus on accuracy, not speed.",
  "base_difficulty": 30,
  "variables": {"deck": "active_deck", "card_count": "20-100"},
  "reward_base": {"xp": 100, "int": 2},
  "prerequisites": {"int": 5}
}
```

**Template 7: Gratitude Journaling (Relationships)**
```json
{
  "template_id": "REL-GRAT-001",
  "category": "Relationships",
  "subcategory": "Gratitude",
  "name": "Three Gratitudes",
  "description": "Write down three specific things you're grateful for today. Be specific (not 'family' but 'the text my sister sent').",
  "base_difficulty": 10,
  "variables": {},
  "reward_base": {"xp": 50, "sen": 1},
  "prerequisites": {}
}
```

**Template 8: Budget Review (Financial)**
```json
{
  "template_id": "FIN-BUD-001",
  "category": "Financial",
  "subcategory": "Budgeting",
  "name": "Weekly Budget Review",
  "description": "Review this week's spending. Categorize transactions. Check: Are you within budget? Any unexpected expenses to account for?",
  "base_difficulty": 25,
  "variables": {},
  "reward_base": {"xp": 75, "int": 1},
  "prerequisites": {"int": 5}
}
```

**Template 9: Digital Declutter (Organization)**
```json
{
  "template_id": "ORG-DIG-001",
  "category": "Environment/Organization",
  "subcategory": "Digital",
  "name": "Digital Declutter: {area}",
  "description": "Spend {duration} minutes organizing your {area}. Delete unnecessary files, unsubscribe from unread newsletters, clear downloads folder.",
  "base_difficulty": 15,
  "variables": {"area": "desktop|downloads|email|photos", "duration": "15-30"},
  "reward_base": {"xp": 60, "vit": 1, "int": 1},
  "prerequisites": {}
}
```

**Template 10: Sleep Hygiene (Recovery)**
```json
{
  "template_id": "REC-SLP-001",
  "category": "Physical Health",
  "subcategory": "Sleep",
  "name": "Sleep Protocol",
  "description": "Tonight: No screens 1 hour before bed. Set alarm for consistent wake time. Bedroom temperature: 65-68F (18-20C). Log sleep duration.",
  "base_difficulty": 20,
  "variables": {},
  "reward_base": {"xp": 75, "vit": 2},
  "prerequisites": {},
  "auto_complete": {"data_type": "SleepSessionRecord", "threshold": "7_hours"}
}
```

### Appendix D: Notification Copy Examples

**Morning Briefing:**
```
[NOTIFICATION] — 06:05 AM
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
GOOD MORNING, PLAYER
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Today is Day 12 of your current streak.
Your STR has shown steady improvement over 14 days.

Today's Quests:
  1. Zone 2 Endurance Run (C-Rank) — 30 min
  2. Deep Work Sprint (B-Rank) — 4 Pomodoros
  3. Body Scan Meditation (D-Rank) — 10 min

Streak Status: ████████░░ 8-day streak
Daily Cutoff: 11:59 PM

The System awaits your execution.
```

**Countdown Warning (30 min):**
```
[QUEST WARNING] — 11:30 PM
Your quest "Zone 2 Endurance Run" expires in 30 minutes.

Current status: NOT STARTED
Streak at risk if not completed.

[START QUEST] [I'VE ALREADY DONE IT]
```

**Streak Preservation Alert:**
```
[STREAK ALERT] — 10:00 PM
Your 8-day streak expires in 2 hours.

1 of 3 quests completed today.
Remaining: Zone 2 Run, Meditation

The chain weakens. Time remains. Execute.

[VIEW QUESTS]
```

**Level Up Celebration:**
```
[LEVEL UP] — Congratulations, Player.

You have reached Level 15.
Rank: E-Rank → D-Rank trial available.

Rewards:
  +1 all base stats
  +5 distributable points
  +750 Gold
  +New title slot unlocked

You are no longer the weakest Player.
But the gap between D and S... is still immeasurable.

[ALLOCATE POINTS] [CONTINUE]
```

**Recovery Quest (Post-Failure):**
```
[REDEMPTION QUEST]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
THE RETURN PATH
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Your streak has paused. Life happens.
Your neural pathways are still there — ready when you are.

The System offers you a path back:

Complete 3 daily quests in the next 24 hours.
Any category. Any difficulty. Just execute.

Reward: Full stat recovery + 1.2x XP for 24h + streak restored

The System does not abandon Players who struggle.
The System intervenes.

[ACCEPT REDEMPTION QUEST] [NOT NOW]
```

### Appendix E: Research Sources Summary

**Research Dimensions Consulted:**

| Dimension | Topic | Searches | File |
|-----------|-------|----------|------|
| dim01 | Visual Design System (colors, fonts, animations, layout) | 19 | `arise_dim01.md` |
| dim02 | Core Game Loop (stats, XP, ranks, economy, streaks, skills) | 20+ | `arise_dim02.md` |
| dim03 | Goal Taxonomy (12 domains, decomposition, frameworks) | 18+ | `arise_dim03.md` |
| dim04 | Quest System (9 types, 200+ templates, difficulty calibration) | 20+ | `arise_dim04.md` |
| dim05 | Notification Architecture (alarms, escalation, OEM reliability) | 20+ | `arise_dim05.md` |
| dim06 | Health Integrations (Health Connect, Lyfta, wearables) | 25+ | `arise_dim06.md` |
| dim07 | Penalty System (recovery-first, debuffs, redemption quests) | 20+ | `arise_dim07.md` |
| dim08 | Social/Guild System (guilds, raids, leaderboards, toxicity prevention) | 25+ | `arise_dim08.md` |
| dim09 | Monetization & Retention (freemium, battle pass, LTV optimization) | 40+ | `arise_dim09.md` |
| dim10 | Onboarding Flow (cinematic experience, progressive disclosure) | 16+ | `arise_dim10.md` |

| dim11 | Screentime Monitoring (UsageStatsManager, digital wellness, app categorization) | 10+ | `screentime_section.md` |

**Total: 160+ searches, 11 research dimensions, 6,000+ lines of analysis**

**Key Research Domains:**
- Behavioral science: BJ Fogg MAP model, Self-Determination Theory, Flow Theory, loss aversion, habit formation (66-day research)
- Game design: RPG stat systems, XP curves, difficulty calibration, loot box ethics, battle pass mechanics
- Mobile development: Android alarm reliability, Health Connect APIs, Flutter architecture, notification systems
- Monetization: Freemium conversion, subscription pricing, battle pass design, rewarded video ads
- Psychology: Abstinence violation effect, recovery-first design, commitment devices, dignity in failure

---

*This document represents the complete implementation plan for ARISE — Solo Leveling Life System. All specifications are research-backed and cross-referenced across 10 dimensions of analysis. The plan covers every aspect from visual design to technical architecture, from behavioral science to monetization strategy, and is designed to be executed by a team of 6–10 engineers over 12 months.*

*ARISE: Because your life deserves to be leveled up — including the time you spend on this screen right now.*
