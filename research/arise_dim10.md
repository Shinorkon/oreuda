# Dimension 10: User Onboarding & First-Time Experience

## A Cinematic Onboarding Flow Inspired by Solo Leveling

---

## Executive Summary

The ARISE app onboarding is designed as an immersive, cinematic experience modeled after Sung Jin-woo's awakening in Solo Leveling. The user doesn't "sign up" -- they are *scanned*, *assessed*, and *awakened* by the System. Every interaction reinforces the narrative: the user is a weak E-Rank Hunter who has been chosen by the System -- the only being in existence capable of true growth through effort. The onboarding cannot be rushed; it is the first gate through which all Players must pass [^1^][^26^].

This document draws from behavioral science (BJ Fogg's MAP model [^634^], Phillippa Lally's habit formation research [^83^][^75^]), best-in-class onboarding flows (Duolingo [^663^][^665^], Fabulous [^229^][^689^]), commitment device research (StickK [^687^][^688^]), game design principles (FromSoftware's show-don't-tell approach [^673^], interactive tutorials [^705^][^707^]), and progressive disclosure UX patterns [^638^][^640^].

---

## Core Design Principles

1. **Onboarding IS the product** -- not a tutorial, but an activation sequence [^654^]
2. **The user must consciously opt into the punishment system** -- the Pact is a commitment device, not fine print [^687^]
3. **Time-to-first-value under 5 minutes** -- Duolingo achieves this in under 4 minutes [^663^][^665^]
4. **Every screen between install and first value is a tax** -- minimize cognitive load [^634^][^654^]
5. **Habit formation median: 66 days** -- design for the long arc, not the first session [^75^][^76^]
6. **Missing one day has negligible impact** -- design grace into the system [^75^][^672^]
7. **Behavior = Motivation x Ability x Prompt** -- all three must converge [^634^][^639^]
8. **Progressive disclosure** -- reveal capabilities as the user demonstrates readiness [^638^][^640^]

---

## Onboarding Flow (Step-by-Step)

### Phase 1: The Approach (Pre-Download Context)

| Step | Description | Screen Design | Duration |
|------|-------------|---------------|----------|
| 1.1 | **App Store Presence** | Dark-themed screenshots showing the System interface; no cartoon graphics. The store description reads: "The System has chosen you. Everyone else is locked at their awakening rank. Only you can level up." | -- |
| 1.2 | **Download** | App icon: a glowing blue holographic hexagon with faint glitch effects. App name: "ARISE: The System" | -- |

### Phase 2: The Double Dungeon (First Launch)

| Step | Description | Screen Design | Duration |
|------|-------------|---------------|----------|
| 2.1 | **The Black Screen** | Pure black screen for 3 seconds. No logo, no text. Then: a single line of white text fades in: "You feel something watching you." | 5 sec |
| 2.2 | **The System Interface Awakens** | A blue holographic UI materializes (particle animation, scan lines). A "glitch" effect runs across the screen. Text types out: "Initializing... Player candidate detected." | 8 sec |
| 2.3 | **The Scan** | Holographic rings rotate around a silhouette representing the user. Text: "Scanning physical attributes... Analyzing behavioral patterns... Assessing growth potential..." This is a loading screen disguised as narrative. | 10 sec |
| 2.4 | **Scan Complete** | The rings collapse. A status window materializes with the user's starting stats. Text: "Scan complete. You have been assigned the lowest possible rank." Dramatic pause. "E-Rank." [^728^][^732^] | 5 sec |
| 2.5 | **The Paradox** | Text continues: "However... an anomaly has been detected. You possess a growth potential reading of [LEVELING_PROTOCOL_DETECTED]. No other Player in recorded history has shown this pattern." [^26^][^124^] | 8 sec |

**Design Rationale**: The black screen creates anticipation (Core Drive 7: Unpredictability per Octalysis [^707^]). The scan uses the loading time productively -- research shows users tolerate longer loading screens if the wait is narratively justified [^707^]. The E-Rank assignment mirrors Jin-woo's "weakest hunter of all mankind" status, making the eventual growth feel earned [^1^][^728^].

### Phase 3: The Assessment (Questions Disguised as Scans)

| Step | Description | Screen Design | Duration |
|------|-------------|---------------|----------|
| 3.1 | **Scan Prompt 1: Physical Baseline** | "Scanning daily movement patterns..." Options: "Sedentary (mostly seated)", "Light activity (walking, some stairs)", "Moderate (regular exercise 2-3x/week)", "Active (4+ structured sessions/week)" | 30 sec |
| 3.2 | **Scan Prompt 2: Sleep Architecture** | "Analyzing recovery cycles..." Options: "<5 hours", "5-6 hours", "7-8 hours", "9+ hours, still tired" -- directly inspired by Fabulous's onboarding quiz about sleep patterns [^229^][^689^] | 20 sec |
| 3.3 | **Scan Prompt 3: Focus Assessment** | "Measuring cognitive endurance..." Options: "Easily distracted", "Can focus with effort", "Deep focus is natural", "My focus is my strength" -- adapted from Fabulous's focus assessment [^229^] | 20 sec |
| 3.4 | **Scan Prompt 4: Primary Domain** | "Identifying your domain of struggle..." Options: "Physical body (strength, endurance, health)", "Mental clarity (focus, discipline, consistency)", "Emotional regulation (stress, anxiety, mood)", "Energy management (fatigue, sleep, recovery)" | 30 sec |
| 3.5 | **Scan Prompt 5: Habit History** | "Assessing previous behavioral adaptation attempts..." Options: "Never tried habit tracking", "Used apps but abandoned them", "Maintained 1-2 habits long-term", "Systematic habit builder" | 20 sec |
| 3.6 | **Scan Prompt 6: Pain Point** | "What has defeated you before?" Open text or quick-select: "I start strong but quit", "I forget to do it", "I don't see results fast enough", "Life gets in the way", "I've never tried" | 30 sec |

**Design Rationale**: The assessment phase draws from Fabulous's behavioral science-based onboarding quiz [^229^][^689^], Calm's 1-question goal assessment survey [^733^], and the Stoic app's onboarding quiz that asks about main goals, experience, and daily challenges [^701^]. By framing questions as "scans," we maintain diegetic immersion -- the System is analyzing the user, not an app asking for preferences. The six questions provide enough data for initial personalization without overwhelming the user (Brain Cycles constraint per Fogg's model [^634^]).

### Phase 4: The Starting Stats Calculation

After the assessment, the System displays the user's **Status Window** -- a holographic overlay showing their assigned stats. This is a critical moment: the stats must feel personalized but also brutally honest.

| Assessment Answer | Stat Modifier | Rationale |
|-------------------|---------------|-----------|
| **Sedentary lifestyle** | VIT (Vitality) -2 | Mirrors Jin-woo's weak starting physical condition [^728^][^732^] |
| **<5 hours sleep** | VIT (Vitality) -1, INT (Intelligence) -1 | Sleep deprivation affects both physical and cognitive performance [^664^] |
| **Easily distracted** | PER (Perception/Sense) -1 | Lower awareness/focus stat |
| **Never tried habit tracking** | All stats baseline (E-Rank) | Everyone starts E-Rank; past failures don't penalize |
| **Used apps but abandoned** | WIS +1 (knowledge of past patterns) | Failed attempts teach; this is rewarded [^669^] |
| **Maintained 1-2 habits** | One stat +1 in chosen domain | Proof of capability |
| **Physical body as domain** | STR (Strength) emphasis | Domain focus shapes initial quest recommendations |
| **Mental clarity as domain** | INT (Intelligence) emphasis | Shapes the learning path |
| **Emotional regulation as domain** | PER/Sense emphasis | Awareness is the foundation of emotional regulation |
| **Energy management as domain** | VIT (Vitality) emphasis | Recovery is the foundation |

**Starting Stat Framework (inspired by Solo Leveling's System)** [^23^][^26^]:

| Stat | Full Name | Measures | Starting Range |
|------|-----------|----------|----------------|
| STR | Strength | Physical power, exercise capacity, body discipline | 5-8 (E-Rank) |
| AGI | Agility | Speed of execution, reaction time, adaptability | 5-8 (E-Rank) |
| VIT | Vitality | Recovery, sleep quality, stamina, health | 5-8 (E-Rank) |
| INT | Intelligence | Cognitive focus, learning speed, mental models | 5-8 (E-Rank) |
| SEN | Sense | Self-awareness, emotional perception, intuition | 5-8 (E-Rank) |
| WIS | Wisdom | Knowledge from past failures, strategic thinking | 5-8 (E-Rank) |

**Starting Rank**: ALL users begin at **E-Rank** (Level 1). There are no exceptions. The narrative explicitly states: "Every other Hunter is locked at their awakening rank. You are E-Rank now -- but unlike everyone else, you can change this." [^728^][^1^]

### Phase 5: The Pact Ceremony (Commitment Device)

The Pact is the climactic moment of onboarding. It is not buried in Terms of Service -- it is a dramatic, conscious choice that the user must actively make. This draws directly from commitment device research: people who attach a stake to their commitment achieve goals significantly more often [^687^][^688^].

| Element | Description | Psychological Purpose |
|---------|-------------|----------------------|
| **The Warning** | "Before you proceed, understand: the System does not tolerate Players who accept its power without accepting its rules. This is not an app. This is a binding protocol." | Sets seriousness; filters out unmotivated users (as Fabulous's tedious onboarding filters for motivation [^689^]) |
| **The Three Laws of the System** | 1. "You must complete your Daily Quests. Ignoring them has consequences." 2. "You must log your progress honestly. The System detects deception." 3. "You must never break the Pact voluntarily. Once signed, it binds you." | Creates structured commitment; mirrors the Commandments of the Cartenon Temple [^702^] |
| **The Choice** | Two buttons, not one. Button 1: "I accept the Pact. I will not break it." (glows blue) Button 2: "I am not ready." (dim gray, always available) | Active consent is required; the "not ready" option builds trust by making the "yes" truly voluntary |
| **The Signature** | User must physically draw a symbol on the screen (fingerprint scan animation). The line glows as they trace. | Kinesthetic commitment -- the physical act of signing increases psychological binding [^687^]; Fabulous uses a fingerprint contract with animation [^689^] |
| **The Consequence Warning** | "If you fail your Daily Quests, you will be sent to the Penalty Zone. It is not pleasant. But it is necessary." | References the Penalty Zone from Solo Leveling where Jin-woo was sent to a desert with a giant centipede for 4 hours [^336^]; loss aversion is a powerful motivator per Kahneman's prospect theory [^690^] |
| **The Voice** | A synthesized voice (optional, toggleable) speaks: "Congratulations on becoming a Player." This is the exact line from Solo Leveling's System [^26^][^124^] | The auditory dimension creates emotional resonance; audio is processed in a different brain region than text |

**Psychological Design**: The Pact operates as a **commitment device** in the behavioral economics sense. Research by Dean Karlan (StickK) shows that commitment contracts with stakes achieve significantly higher success rates [^687^][^688^]. The ARISE Pact doesn't require financial stakes (though that could be an optional feature later), but it creates a **psychological stake**: the user's identity as a Player who doesn't break their word. Financial commitment devices work through loss aversion; the Pact works through identity-based commitment, which strengthens with repetition rather than creating fatigue [^690^].

The Pact also serves as **filtering**: Fabulous's onboarding is deliberately tedious because it filters out unmotivated users, leaving only those truly hungry for change [^689^]. The Pact ceremony performs a similar function -- users who won't commit to a symbolic signing are unlikely to commit to daily quests.

### Phase 6: The ARISE Moment (Climactic Activation)

After the Pact is signed, the screen goes dark. Then:

| Step | Description | Screen Design | Duration |
|------|-------------|---------------|----------|
| 6.1 | **Blackout** | Screen goes completely black. 3 seconds of silence. | 3 sec |
| 6.2 | **The Pulse** | A single blue pulse of light expands from center. A low-frequency sound plays (sub-bass). | 2 sec |
| 6.3 | **ARISE** | The word "ARISE" appears in massive holographic text, filling the screen. Particles coalesce. The user's silhouette is backlit in blue. | 3 sec |
| 6.4 | **The Status Window Materializes** | Full System interface appears -- stats, quests, inventory tabs. "Your interface is now active. Only you can see it." [^26^][^124^] | 5 sec |
| 6.5 | **First Quest Assignment** | An urgent quest notification pulses: "[DAILY QUEST] Complete your first action as a Player." This is the first hands-on tutorial moment. | 5 sec |

**Design Rationale**: This is the "Aha Moment" in product terms -- the moment the user realizes what this app truly is [^703^]. Research shows that users who experience an Aha Moment are 5-10x more likely to become active customers [^703^]. Best-in-class products achieve this in 3-5 minutes [^703^]. The ARISE moment is designed to be emotionally unforgettable -- a cinematic climax that creates an anchor memory. The word "ARISE" references the Solo Leveling:ARISE game branding [^730^].

### Phase 7: First Quest Set (Teaching Through Doing)

The System assigns a structured set of quests that teach app mechanics without breaking immersion.

| Quest | Purpose | Tutorial Element | Duration |
|-------|---------|-------------------|----------|
| **Daily Quest 1: "Log Your First Stat"** | Teach the stat tracking mechanic | User taps STR, enters their current push-up count (or "0"). System responds: "Honesty is the first virtue of a Player. Zero is not failure -- it is a starting point." | 2 min |
| **Daily Quest 2: "Set Your First Habit"** | Teach habit creation | User creates their first habit. The System guides with suggestions based on their assessment. "Your first habit should be comically small. Even E-Rank Hunters can do one push-up." | 3 min |
| **Daily Quest 3: "Complete the First Action"** | Teach completion mechanics | User marks the habit as done. Immediate XP reward, particle effects, level progress bar animation. "+10 XP. You have taken your first step toward Level 2." | 1 min |
| **Daily Quest 4: "Enable Notifications"** | Diegetic permission request | "The System requires a communication channel. Will you grant access to push notifications? [YES / NOT NOW]" (non-blocking) | 30 sec |
| **Daily Quest 5: "Set Your Wake Time"** | Diegetic alarm permission | "The System monitors your recovery cycles. Will you grant access to alarm management? [YES / NOT NOW]" | 30 sec |

**Design Rationale**: This follows the "teach by doing" pattern from game design [^705^][^708^] and Duolingo's approach of immediate lesson engagement [^663^]. Each quest teaches one mechanic and provides immediate positive reinforcement. The total time from first launch to completing all five quests is designed to be under 5 minutes -- matching Duolingo's sub-4-minute onboarding time [^663^]. The stat tracking mechanic mirrors Jin-woo's stat investment system where each level-up grants 5 stat points to distribute [^23^].

---

## The Assessment in Detail

### Question Categories and How They Affect Stats

| Category | Examples (disguised as scans) | How It Affects |
|----------|------------------------------|----------------|
| **Physical Baseline** | "Daily movement scan..." [Sedentary / Light / Moderate / Active] | Determines STR and VIT starting modifiers; shapes exercise quest difficulty |
| **Sleep Architecture** | "Recovery cycle analysis..." [<5hrs / 5-6hrs / 7-8hrs / 9+ still tired] | Affects VIT and INT; shapes recovery-focused quest recommendations [^229^] |
| **Cognitive Profile** | "Focus endurance measurement..." [Easily distracted / Focus with effort / Deep focus natural] | Affects INT and SEN; shapes learning quest complexity [^689^] |
| **Domain of Struggle** | "Primary weakness identification..." [Body / Mind / Emotion / Energy] | Determines which stat gets emphasis and which quest line is prioritized |
| **Habit History** | "Behavioral adaptation history..." [Never tried / Abandoned apps / Maintained 1-2 / Systematic builder] | Affects WIS; shapes tutorial depth (beginners get more guidance) [^75^] |
| **Failure Pattern** | "Previous defeat analysis..." [Quit too early / Forgot / No results / Life interference / Never tried] | Shapes the coaching tone and which "anti-failure" systems are prioritized |
| **Commitment Level** | "Motivation source scan..." [Desperation / Curiosity / Determination / Strategic self-improvement] | Shapes the narrative tone; desperation gets urgent messaging, curiosity gets exploratory |

### How the System "Calculates" Starting Stats

The calculation is deliberately opaque (like the actual System in Solo Leveling, which had hidden agendas [^26^][^124^]). The user sees a loading screen with "calculating..." but the algorithm is simple behind the scenes:

1. **Base value**: All stats start at 5 (E-Rank baseline)
2. **Domain bonus**: +2 to the primary stat matching the user's chosen domain
3. **Experience bonus**: +1 WIS if user has previously used habit apps (failed attempts are knowledge)
4. **Physical modifier**: +1 STR and +1 VIT if user reports moderate-to-active lifestyle
5. **Sleep modifier**: -1 to a random stat if user reports <5 hours sleep (honest penalty for honest data)
6. **Commitment bonus**: +1 to all stats if user completes the full onboarding without skipping (tests motivation)

**Final stat range**: 5-10 per stat. The user sees "E-Rank" regardless -- the exact numbers are less important than the narrative framing. The System is preparing the user for growth, not giving them a report card.

---

## The Pact Ceremony (Deep Design)

### Narrative Framing

The Pact is framed not as a legal agreement but as a magical binding -- the same way Jin-woo was bound to the System after surviving the Cartenon Temple [^702^][^336^]. The System is giving the user something no one else has: the ability to grow. In exchange, the user must commit.

### The Three-Tier Commitment Model

Inspired by commitment device research [^687^][^688^][^690^]:

| Tier | Name | What the User Commits To | System Response |
|------|------|-------------------------|-----------------|
| **Tier 1: Identity** (Day 1) | The Pact of the E-Rank | "I am a Player. I will not abandon my Daily Quests." | The System accepts. No penalty for missed days yet -- the System is "observing." |
| **Tier 2: Accountability** (Day 8) | The Pact of the D-Rank | User must actively reaffirm: "I accept the Penalty Protocol." | Missing Daily Quests now triggers the Penalty Zone -- a consequence mechanic (see below) |
| **Tier 3: Stakes** (Day 30+) | The Pact of the C-Rank | Optional: user can add real-world stakes (accountability partner, financial commitment via integration with StickK-style mechanism) [^687^] | The System "unlocks" advanced features and harder quests |

### The Penalty Zone (Consequence Mechanic)

If a user fails their Daily Quests after Tier 2, they enter the **Penalty Zone**:

- **Narrative**: "You have been sent to the Penalty Zone. Survive for 24 hours."
- **Reality**: For 24 hours, the user cannot level up, cannot earn XP, and the System interface turns desaturated (gray instead of blue)
- **Exit condition**: Complete a "survival quest" -- a deliberately hard but achievable task (e.g., "Complete 3 habits today to escape")
- **Psychological purpose**: Creates real loss aversion without being punitive. Research shows loss aversion is roughly 2:1 (losses feel twice as painful as equivalent gains) [^690^]. The Penalty Zone mirrors Jin-woo's first experience: being chased by a giant centipede in a desert for 4 hours [^336^].

---

## First Quest Set Design (24-Hour Onboarding)

### Quest Structure (mirrors Solo Leveling's System) [^26^][^336^]

| Quest Type | Description | Example | Frequency |
|------------|-------------|---------|-----------|
| **Daily Quests** | Physical/behavioral training tasks | "Complete 10 push-ups", "Log your sleep", "Drink 2L water" | Every 24 hours |
| **Main Quests** | Major story-driven objectives | "Reach Level 5", "Maintain a 7-day streak", "Complete your first stat reassessment" | Milestone-based |
| **Side Quests** | Optional but rewarding | "Try a new habit category", "Share your progress" (optional, never forced) | Context-triggered |
| **Urgent Quests** | Emergency tasks responding to user behavior | "Your sleep has been poor for 3 days. Complete a recovery quest today." | Triggered by data |

### The First 24-Hour Quest Line

| Time | Quest | Purpose | Tutorial Element |
|------|-------|---------|-------------------|
| **Hour 0-1** (during onboarding) | "Log your first stat" | Teach stat system | Tap stat, enter number, see it recorded |
| **Hour 0-1** | "Create your first habit" | Teach habit creation | Guided flow with assessment-informed suggestions |
| **Hour 0-1** | "Complete one action" | Teach completion + rewards | Mark done, see XP, see progress bar |
| **Hour 0-1** | "Enable System notifications" | Permission request | Diegetic framing (see Permission Flow below) |
| **Hour 1-4** | "Set up your evening check-in" | Teach scheduling | User picks a daily reminder time |
| **Hour 4-12** | "First evening log" | Teach daily log habit | Reminder fires, user logs day summary |
| **Hour 12-24** | "Day 1 completion" | Create first sense of accomplishment | "Day 1 complete. You have earned +50 XP. Level progress: [====>    ] 50%" |
| **Hour 24** | "Day 2 quest assignment" | Create return hook | Push notification: "Your Daily Quests have been assigned, Player." |

### Quest Design Principles (from BJ Fogg MAP Model)

Each quest must satisfy B = MAP [^634^][^639^]:

- **Motivation**: The quest must feel meaningful (narrative framing: "The System requires this")
- **Ability**: The quest must be achievable for an E-Rank (comically small: 1 push-up, not 50) [^634^]
- **Prompt**: The System delivers quests at the right moment (scheduled notifications, not random spam)

Fogg's research shows that "shrinking the behavior" until motivation only needs to barely clear the action line is the most effective approach [^634^]. For an E-Rank Player, a "Daily Quest" of "do 1 push-up" is not too small -- it is the correct size. Once the habit of starting is automatic, the behavior naturally scales [^76^].

---

## Permission Request Flow (Diegetic Design)

Every permission request is framed as a System protocol, not an OS dialog. This follows best practices: request only when needed, explain benefits, and make denial easy [^661^][^654^].

| Permission | Diegetic Framing | When Requested | Opt-Out Behavior |
|------------|-----------------|---------------|------------------|
| **Push Notifications** | "The System requires a communication channel to deliver quest assignments. Enable System notifications?" | After user completes first quest (has experienced value) | "Not now" button always present; can enable later in Settings |
| **Health Data (Apple Health / Google Fit)** | "The System can sync with your body's data stream for more accurate stat tracking. Grant access to health data?" | When user first tries to log a stat that could be auto-imported (steps, sleep) | Manual entry always available |
| **Alarm / Reminders** | "The System monitors your recovery cycles. Grant access to alarm management for optimal quest timing?" | During evening check-in setup | User can set reminders manually |
| **Camera** | "The System can verify certain physical quests through visual confirmation. Enable visual scanning?" | Only if user opts into a quest type that requires photo proof (optional feature) | Never required for core flow |
| **Location** | "The System can detect your environment to suggest location-appropriate quests. Enable environmental scanning?" | Only if user opts into location-based features (e.g., "gym detected -- log your workout?") | Never required |
| **Microphone** | "The System supports voice-logging for faster quest completion. Enable audio input?" | When user first attempts voice input (feature not shown by default) | Text input always available |

**Design Rationale**: This follows Calm's approach of giving users a path to the core functionality without signup [^733^], and Duolingo's strategy of deferring registration until after value is delivered [^663^][^671^]. Permission priming research shows that asking for access only when the feature is first used -- not at launch -- dramatically increases opt-in rates [^661^]. The diegetic framing ("System notifications" instead of "push notifications") maintains immersion while still being clear about what the user is agreeing to.

---

## First Week Retention Plan (Days 1-7)

### Retention Benchmarks

Based on industry research [^654^][^655^][^659^]:
- Day 1 retention: Target 35-40% (vs. 26% industry average)
- Day 7 retention: Target 18-25% (vs. 11% industry average)
- Day 30 retention: Target 10-15% (vs. 6% industry average)

### Daily Feature Unlocks

| Day | Feature Unlocked | Retention Hook | Behavioral Science |
|-----|-----------------|----------------|-------------------|
| **Day 1** | Status Window, First Quests, First XP | Immediate value + narrative immersion | Aha moment in <5 min [^703^]; Duolingo model [^663^] |
| **Day 2** | Daily Quest reset (first cycle) | "Your quests have been assigned, Player." | Creates first completion loop; Fogg's prompt theory [^634^] |
| **Day 3** | Stat trend graph (first 3 days of data) | Visual feedback: "Your STR has increased by [X]" | Progress visibility drives motivation; Core Drive 2 (Accomplishment) [^707^] |
| **Day 4** | Side Quest unlocked | "A Side Quest has appeared. Complete it for bonus XP." | Novelty; unpredictability drives engagement [^707^] |
| **Day 5** | Level 2 reached (with consistent completion) | First level-up ceremony: stat points to distribute | Mimics Jin-woo's first stat allocation; meaningful choice [^23^] |
| **Day 6** | The System sends first "check-in" message | "You are still E-Rank. But your trajectory has changed." | Narrative progression; identity reinforcement |
| **Day 7** | **Week 1 Assessment**: Full stat review + "D-Rank Trial" quest | "You have completed one week. The System is offering you a trial for D-Rank. Do you accept?" | Milestone moment; D-Rank trial creates forward-looking commitment |

### The "D-Rank Trial" (Day 7 Gate)

At the end of Day 7, the user is offered a **D-Rank Trial** -- a harder-than-normal daily quest set. If completed:
- User is promoted to D-Rank
- New interface color scheme (slightly more elaborate)
- Unlocks: Main Quests, Inventory system, Store preview
- The narrative: "You are no longer the weakest Player. But the gap between E-Rank and S-Rank... is still immeasurable."

This follows the gamification principle of **Development & Accomplishment** (Core Drive #2 in Octalysis) [^707^] -- users need to feel they are progressing. The D-Rank gate also serves as a **retention milestone** -- users who reach Day 7 have survived the critical first week churn period [^654^][^656^].

### Re-engagement Tactics (if user misses a day)

| Trigger | System Response | Psychology |
|---------|----------------|------------|
| Miss Day 2 | "Your quests went uncompleted. The System is waiting." | Mild guilt; narrative prompt |
| Miss Day 3 | "The System has detected inactivity. Your growth has stalled." | Loss aversion [^690^] |
| Miss Day 4 | "You are still E-Rank. But your trajectory is fading." | Identity threat; fear of losing progress |
| Miss Day 5+ | "The System does not abandon Players. But Players can abandon the System. Return when you are ready." | Respectful invitation; no punishment for absence (research: missing one day has negligible impact [^75^]) |

---

## Progressive Disclosure Plan

### What to Reveal When

Following the ChatGPT model of radical simplicity with progressive capability revelation [^640^]:

| Timeframe | Features Visible | Features Hidden |
|-----------|-----------------|-----------------|
| **Onboarding (Hour 0-1)** | Status Window, 1 stat category, 1 habit, Daily Quests | Everything else |
| **Days 1-3** | All 6 stats, up to 3 habits, basic quest system | Inventory, Store, Skills, Main Quests, Side Quests |
| **Days 4-7** | Side Quests, stat trends, level-up system | Inventory, Store, Skills, Main Quests |
| **Week 2** (if D-Rank achieved) | Inventory, Store preview, first Skill unlock | Advanced Skills, Guild system, PvP elements |
| **Week 3-4** | Main Quests, full Store, multiple Skills | Guild system, Leaderboards, Advanced features |
| **Month 2+** | Everything unlocked progressively | Nothing permanently hidden |

### Progressive Disclosure Principles [^638^][^640^][^641^]

1. **Staged revelation**: Show essential functionality immediately, with clear access to advanced features when ready
2. **Contextual disclosure**: Advanced features appear when usage patterns suggest readiness (e.g., after 7 days of consistent habit tracking, suggest "habit stacking")
3. **Multi-step wizards**: Complex processes (like the Pact ceremony) are broken into sequential stages with one decision per step
4. **Conditional logic**: The app adapts based on user inputs -- a user who reports ADHD gets shorter, more frequent quests; a user who reports high motivation gets more challenging quests

---

## The Personalization Engine (First 2 Weeks)

### Data Collection Sources

| Source | What It Collects | How It Personalizes |
|--------|-----------------|---------------------|
| **Assessment answers** | Baseline physical, mental, emotional state | Starting stats, initial quest difficulty, narrative tone |
| **Daily quest completion** | What user completes, skips, delays | Adjusts quest difficulty; identifies motivation patterns |
| **Stat logging** | User-entered metrics (push-ups, sleep, etc.) | Calculates "true" stats; detects trends |
| **Time patterns** | When user opens app, completes quests, ignores notifications | Optimizes notification timing; adjusts quest scheduling |
| **Tap patterns** | Which features user explores vs. ignores | Progressive disclosure adjustments |
| **Skip behavior** | Which onboarding steps were skipped | Identifies motivation level; adjusts tutorial depth |

### Personalization Rules (First 14 Days)

| User Behavior | System Adaptation |
|--------------|-------------------|
| Skips more than 2 onboarding questions | Suggests shorter daily quests; enables "easy mode" quest defaults |
| Completes all onboarding + signs Pact immediately | Offers standard quest difficulty; unlocks Side Quests on Day 3 instead of Day 4 |
| Logs stats consistently but doesn't create habits | Shifts focus from habit creation to stat tracking; offers "passive" tracking options |
| Creates habits but doesn't log stats | Shifts focus from numbers to streaks; gamifies the streak mechanic |
| Opens app only at night | Adjusts all quest assignments to evening; "morning quests" become "tomorrow quests" |
| Opens app multiple times per day | Enables "micro-quest" mode: tiny quests throughout the day |
| Ignores all notifications | Switches to in-app-only prompts; suggests different notification times |
| Completes everything perfectly | Automatically increases quest difficulty; warns about burnout |

### The Learning Loop

After Day 7, the System generates a personalized message: "The System has observed your patterns. Your optimal quest time appears to be [TIME]. Your strongest stat is [STAT]. Your growth trajectory has been calculated." This creates a sense of being *seen* by the System -- personalization engines work best when the user perceives the personalization [^693^].

---

## Reference Onboarding Flows (Best-in-Class Analysis)

### 1. Duolingo -- Immediate Value [^663^][^665^][^667^]

**What ARISE learns from Duolingo**:
- Get user to core value in under 4 minutes (ARISE target: under 5 minutes)
- Deferred registration -- don't ask for signup until value is proven [^671^]
- The onboarding is "hardly about the app, but instead has its focus on the user, who immediately starts using it" [^667^]
- "Reciprocity" -- the app invests in the user first, increasing motivation to reciprocate [^667^]
- Baby Schema Effect (cute mascot) -- ARISE uses the System interface itself as the "character"

### 2. Fabulous -- Behavioral Science Foundation [^229^][^689^]

**What ARISE learns from Fabulous**:
- Onboarding quiz about habits, sleep, focus levels is effective for personalization [^229^]
- BUT: Fabulous's onboarding is criticized for being "tedious," "inelegant," and "throwing behavioral science tactics at users without much thought" [^689^]
- Fabulous asks for payment before showing value -- ARISE never does this
- The "fingerprint contract" idea is borrowed but improved (more narrative weight, clearer psychological purpose)
- Duke University behavioral science backing -- ARISE should cite real behavioral science similarly

### 3. Calm -- The "Sneaky" Onboarding [^733^]

**What ARISE learns from Calm**:
- Multiple "X" buttons that ultimately let users bypass signup -- ARISE doesn't require signup at all during onboarding
- "Take a deep breath" as opening message perfectly aligns with brand -- ARISE's "You feel something watching you" serves the same purpose
- Let users experience core functionality before commitment

### 4. FromSoftware Games -- Show, Don't Tell [^673^]

**What ARISE learns from Dark Souls/Elden Ring**:
- "I like for people to discover the world themselves" -- Miyazaki [^673^]
- Minimal hand-holding; environmental cues instead of explicit tutorials
- Lack of quest markers forces player to pay attention
- Applied to ARISE: the System gives quests but doesn't micromanage completion. The user must figure out their own path to growth.

### 5. Headspace -- Meditation Onboarding [^666^]

**What ARISE learns from Headspace**:
- "Take a deep breath" as the very first interaction aligns brand with immediate action
- Clean, minimal interface reduces cognitive load
- ARISE adapts: the first thing the user does is not sign up or answer questions -- it's *experience* the System awakening

---

## Tutorial Design (Teaching Without Breaking Immersion)

### Method: The "System Tutorial" -- In-World Guidance

Instead of tooltips or walkthroughs, the System communicates through its own interface:

| Traditional Tutorial | ARISE Diegetic Tutorial |
|---------------------|------------------------|
| "Tap here to log a habit" | A quest appears: "Log your first action, Player. The input field awaits your data." |
| "This is your progress bar" | "Your level progress: [====>    ]. Fill it to ascend." |
| "Enable notifications for reminders" | "The System requires a communication channel. Will you permit it?" |
| "Here's how streaks work" | "Consecutive completion days form a Chain. Breaking it is... not recommended." |

### Tutorial Principles (from Game Design) [^705^][^707^][^708^]

1. **Interactive tutorials**: The user learns by doing, not reading -- guided tutorial levels that aren't presented as tutorials [^705^]
2. **Step-by-step with positive reinforcement**: Each small action gets "Great job! You nailed it!" style feedback [^707^]
3. **Scripted first actions**: The first few taps are guided toward meaningful outcomes [^705^]
4. **Empty states as teaching moments**: When a screen is empty, the System explains why and invites action [^708^]
5. **Never make the user feel stupid**: If the user fails, the System responds: "The first attempt is data, not failure."

---

## The "ARISE" Moment (Deep Design)

### What It Is

The ARISE moment is the climax of onboarding -- the emotional peak where the user transitions from "person downloading an app" to "Player chosen by the System." It is the Aha Moment [^703^] reimagined as a cinematic event.

### Elements of the ARISE Moment

| Element | Description | Emotional Target |
|---------|-------------|-----------------|
| **The Blackout** | Screen goes dark; all stimuli removed | Suspense, anticipation |
| **The Pulse** | Sub-bass frequency + blue light expansion | Physiological arousal |
| **The Word** | "ARISE" fills the screen in holographic text | Wonder, power, transformation |
| **The Interface** | Full System UI materializes | "This is real" -- tangible proof |
| **The First Quest** | Immediate assignment: "You have work to do." | Purpose, direction, momentum |

### Why This Works (Psychologically)

1. **Pattern interrupt**: The blackout breaks all expected UI patterns, creating a memorable event
2. **Peak-end rule**: People remember experiences by their peak emotional moment and their ending. The ARISE moment is designed to be the peak.
3. **Identity transformation**: The moment mirrors the isekai awakening trope -- the ordinary person discovers they are special. Research on identity-based habit change shows that habits tied to identity are more durable [^690^].
4. **The scarcity principle**: "No other Player in recorded history has shown this pattern" -- the user is made to feel uniquely chosen

### Timing Requirements

Per product-led growth research, the Aha Moment must happen in the first session, ideally within 3-5 minutes [^703^]. The ARISE moment happens at approximately the 4-5 minute mark -- after the scan and assessment but before the first quest. It is the bridge between "assessment" and "action."

---

## Key Metrics to Track

| Metric | Target | Benchmark Source |
|--------|--------|-----------------|
| Onboarding completion rate | >80% | Industry: 33% activation [^703^] |
| Time to first value | <5 min | Best-in-class: 3-5 min [^703^] |
| Pact acceptance rate | >70% | Willingness to commit indicates motivation |
| Day 1 retention | >35% | Industry avg: 26% [^659^] |
| Day 7 retention | >18% | Industry avg: 11% [^659^] |
| Day 30 retention | >10% | Industry avg: 6% [^659^] |
| Permission opt-in rate (notifications) | >50% | Contextual requests vs. launch requests [^661^] |
| First quest completion (within 24h) | >60% | Indicator of immediate engagement |

---

## Summary: The Solo Leveling Parallel

| Solo Leveling Event | ARISE Onboarding Equivalent | Purpose |
|--------------------|------------------------------|---------|
| Double Dungeon incident | App download + first launch | The inciting incident |
| "Congratulations on becoming a Player" | The Pact Ceremony | Formal entry into the System |
| System scan of Jin-woo's stats | The Assessment Phase | Baseline measurement |
| E-Rank assignment | Starting at E-Rank | Everyone starts at the bottom |
| "I alone level up" uniqueness | "No other Player has this growth pattern" | Makes the user feel special |
| Penalty Zone (desert, centipede) | Penalty Zone (grayed UI, survival quest) | Consequence for inaction |
| Daily Quests (push-ups, running) | Daily Quests (habit completion) | The core loop |
| Stat point allocation on level-up | Stat point distribution | Meaningful choice at milestones |
| Job Change quest at Level 40 | D-Rank Trial at Day 7 | Major progression gate |
| Shadow extraction | "Skills" unlock | Rewards for persistence |
| S-Rank reclassification | Rank progression (E->D->C->B->A->S) | Long-term aspiration |

---

## Citations

[^1^] Rescene Studio. "Solo Leveling Power System: Hunter Ranks and Gates Explained." rescenestudio.com, 2026. https://rescenestudio.com/blogs/news/solo-leveling-ranks-gates-explained

[^23^] Solo Leveling Wiki. "System." Fandom, 2026. https://solo-leveling.fandom.com/wiki/System

[^26^] Online Solo Leveling Manga. "What Is The System in Solo Leveling? How It Works Explained." onlinesololevelingmanga.us, 2026. https://onlinesololevelingmanga.us/what-is-the-system-in-solo-leveling/

[^75^] Aftertone. "Habit Formation: It Takes 66 Days, Not 21." aftertone.io, 2026. https://www.aftertone.io/science/habit-formation-timeline-66-days-not-21

[^76^] Keelify. "The 66-day habit rule explained." keelify.com, 2026. https://keelify.com/blog/66-day-habit-rule-explained

[^83^] UCL News. "How long does it take to form a habit?" University College London, 2009. https://www.ucl.ac.uk/news/2009/aug/how-long-does-it-take-form-habit

[^124^] MagicStark. "'The System' In Solo Leveling, Explained." magicstark.cz, 2026. https://magicstark.cz/en/anime-manhwa-manga/solo-leveling-explained-the-secret-behind-sung-jinwoos-power/

[^128^] CBR. "The 'System' In Solo Leveling, Explained." cbr.com, 2025. https://www.cbr.com/solo-leveling-system-explained/

[^165^] Habi. "6 Best Accountability Apps in 2026." habi.app, 2026. https://habi.app/insights/accountability-apps/

[^229^] The Liven. "Fabulous App Review: Features, Pricing and Who It's For." theliven.com, 2026. https://theliven.com/blog/wellbeing/dopamine-management/fabulous-app-review

[^277^] Reddit r/sololeveling. "Solo Leveling Ranking System." reddit.com, 2025. https://www.reddit.com/r/sololeveling/comments/p8nq71/solo_leveling_ranking_system/

[^292^] Triple Whale. "What Is the Fogg Behavior Model?" triplewhale.com. https://www.triplewhale.com/blog/fogg-behavior-model

[^294^] Northbeam. "Fogg Behavior Model: Motivation, Ability, and Prompts." northbeam.io. https://www.northbeam.io/blog/fogg-behavior-model-motivation-ability-and-prompts

[^336^] Fiction Horizon. "Solo Leveling: The Penalty Zone Explained." fictionhorizon.com, 2024. https://fictionhorizon.com/solo-leveling-the-penalty-zone-explained-heres-how-sung-jinwoo-ended-up-in-the-desert/

[^634^] Yu-kai Chou. "BJ Fogg Behavior Model: B=MAP Explained (2026)." yukaichou.com, 2026. https://yukaichou.com/behavioral-analysis/bj-fogg-extended-part-1-of-2/

[^635^] Gamification Plus. "Which Gamified Habit-Building App Do I Think Is Best in 2026?" gamificationplus.uk, 2026. https://gamificationplus.uk/which-gamified-habit-building-app-do-i-think-is-best-in-2026/

[^636^] Miro. "Behavior Design Templates & Examples." Miroverse. https://miro.com/templates/behavior-design/

[^637^] Apxor. "5 Best Mobile App User Onboarding Flows Examples For 2024." apxor.com. https://www.apxor.com/blog/user-onboarding-examples-2024

[^638^] Affective. "How Can I Use Progressive Disclosure in Mobile App Design." weareaffective.com, 2026. https://weareaffective.com/learning-centre/how-can-i-use-progressive-disclosure-in-mobile-app-design

[^639^] Medium/Bose. "From Tap to Habit: Applying BJ Fogg's Model to UX Design." medium.com, 2025. https://medium.com/@swastikbose/from-tap-to-habit-applying-bj-foggs-model-to-ux-design-58d23722e811

[^640^] UX UI Principles. "Progressive Disclosure: UX Pattern Guide." uxuiprinciples.com, 2025. https://uxuiprinciples.com/en/principles/progressive-disclosure

[^641^] LogRocket. "Progressive disclosure in UX design: Types and use cases." blog.logrocket.com, 2025. https://blog.logrocket.com/ux-design/progressive-disclosure-ux-types-use-cases/

[^642^] ProductLed. "How to Use the BJ Fogg Behavior Model to Improve User Engagement in SaaS." productled.com, 2023. https://productled.com/blog/the-bj-fogg-behavior-model-in-saas

[^643^] BlueThrone. "5 App Gamification Examples You Must Copy Today." bluethrone.io, 2025. https://bluethrone.io/blog/5-app-gamification-examples-you-must-copy-today

[^654^] TouchZen AI. "Mobile App Onboarding That Survives Day 7." touchzen.ai, 2026. https://www.touchzen.ai/blog/mobile-app-onboarding-day-7-retention

[^655^] Digia. "Mobile App Onboarding, Activation and Retention." digia.tech, 2026. https://www.digia.tech/post/mobile-app-onboarding-activation-retention/

[^656^] Pardy Panda Studios. "App Retention Strategies: How to Keep Users After the First 7 Days." pardypanda.com. https://www.pardypanda.com/blog/app-retention-strategies-how-to-keep-users-after-the-first-7-days

[^657^] StriveCloud. "Top App Retention Strategy to Master from Day 1." strivecloud.io, 2026. https://strivecloud.io/blog/top-app-retention-strategy-to-master-from-day-1

[^658^] adjoe. "How To: Improve Mobile App Retention & Keep Users Active." adjoe.io, 2025. https://adjoe.io/blog/mobile-app-retention-strategies/

[^659^] Business of Apps. "Mobile App Retention." businessofapps.com, 2025. https://www.businessofapps.com/guide/mobile-app-retention/

[^660^] Taction Software. "Healthcare Mobile App Design: Best Practices & Tips." tactionsoft.com, 2026. https://www.tactionsoft.com/blog/healthcare-mobile-app-design/

[^661^] Appcues. "Mobile App Onboarding 101: How to Hook Users on Day 1." appcues.com. https://www.appcues.com/blog/mobile-onboarding

[^662^] Isaksson, S. "Character Creation Processes in MMORPGs." DIVA Portal, 2012. https://www.diva-portal.org/smash/get/diva2:543179/FULLTEXT01.pdf

[^663^] Juno School. "The Duolingo Onboarding Experience: A 5-Minute Masterclass in User Value." junoschool.org, 2026. https://junoschool.org/article/duolingo-onboarding-experience/

[^664^] Gardner, B. et al. "Making health habitual: the psychology of 'habit-formation' and general practice." PMC, 2012. https://pmc.ncbi.nlm.nih.gov/articles/PMC3505409/

[^665^] UX Collective. "Duolingo's onboarding testing -- what's stuck?" uxdesign.cc, 2024. https://uxdesign.cc/duolingos-onboarding-2-years-on-3cbccad139f7

[^666^] NextLeap. "Product Teardown: New User Onboarding [Headspace]." assets.nextleap.app. https://assets.nextleap.app/submissions/Headspace-compressed.pdf

[^667^] Braingineers. "A Neuromarketing Study of Duolingo's Onboarding Flow." braingineers.com, 2023. https://www.braingineers.com/post/user-experience-design-a-neuromarketing-evaluation-of-duolingos-onboarding-flow

[^669^] James Clear. "How Long Does It Take to Form a Habit? Backed by Science." jamesclear.com, 2020. https://jamesclear.com/new-habit

[^670^] Scientific American. "How Long Does It Really Take to Form a Habit?" scientificamerican.com, 2024. https://www.scientificamerican.com/article/how-long-does-it-really-take-to-form-a-habit/

[^671^] GoodUX/Appcues. "Duolingo's delightful user onboarding experience." goodux.appcues.com, 2018. https://goodux.appcues.com/blog/duolingo-user-onboarding

[^672^] British Psychological Society. "How to form a habit." bps.org.uk, 2010. https://www.bps.org.uk/research-digest/how-form-habit

[^673^] Medium/Roha. "World Design lessons from FromSoftware." medium.com, 2025. https://medium.com/@Jamesroha/world-design-lessons-from-fromsoftware-78cadc8982df

[^687^] SUE Behavioural Design. "What are commitment devices? Binding future behaviour." suebehaviouraldesign.com, 2026. https://www.suebehaviouraldesign.com/en/blog/commitment-devices-explained/

[^688^] Lee, H., Hong, H., & Lee, U. "Commitment devices in online behavior change support systems." Asian HCI Symposium, 2019. https://goalsandprogress.com/wp-content/uploads/2026/02/Commitment-Devices-in-Online-Behavior-Change-Support-Systems.pdf

[^689^] The Behavioral Scientist. "Fabulous App Product Critique: Onboarding." thebehavioralscientist.com, 2023. https://www.thebehavioralscientist.com/articles/fabulous-app-product-critique-onboarding

[^690^] Goals and Progress. "Commitment Devices: 5 Examples + 3-Layer Stack That Sticks." goalsandprogress.com, 2026. https://goalsandprogress.com/commitment-devices-that-help-you-stick-to-goals/

[^692^] CareClinic. "Fabulous App Review: Unleashing the Power of Productivity." careclinic.io, 2025. https://careclinic.io/fabulous-app-review/

[^693^] Reteno. "Personalization Engines 101: Definition, Types & Use Cases." reteno.com, 2025. https://reteno.com/blog/personalization-engines-101-definition-types-use-cases

[^701^] Studio.com. "Live Stoicism. Daily. With Real Results [The Stoic Way]." studio.com, 2026. https://studio.com/apps/tanner/stoicism

[^702^] Solo Leveling Wiki. "Cartenon Temple." Fandom, 2026. https://solo-leveling.fandom.com/wiki/Cartenon_Temple

[^703^] Optif.ai. "Product-Led Growth Guide." optif.ai, 2025. https://optif.ai/guides/product-led-growth/

[^705^] Nerdy Teachers. "Game Design: Onboarding Methods." nerdyteachers.com, 2025. https://nerdyteachers.com/PICO-8/Game_Design/106

[^707^] Yu-kai Chou. "Gamification Design: The Onboarding Phase." yukaichou.com, 2026. https://yukaichou.com/gamification-study/4-experience-phases-gamification-2-onboarding-phase/

[^708^] Medium/MadeBySan. "Onboarding 101: Lessons from Game Design." medium.com, 2017. https://medium.com/@madebysan/hands-on-onboarding-lessons-from-game-design-941ab4ce8e98

[^728^] Online Solo Leveling Manga. "Hunter Ranks in Solo Leveling Explained: E-Rank to National Level." onlinesololevelingmanga.us, 2026. https://onlinesololevelingmanga.us/hunter-ranks-solo-leveling-explained/

[^730^] Netmarble. "Solo Leveling:ARISE." sololeveling.netmarble.com. https://sololeveling.netmarble.com/en

[^732^] Solo Leveling Wiki. "E-Rank." Fandom. https://solo-leveling.fandom.com/wiki/E-Rank

[^733^] UX Collective/Ramakrishnan. "Onboarding for mobile health apps." uxdesign.cc, 2019. https://uxdesign.cc/onboarding-for-mobile-health-apps-e4881a078277

[^734^] PMC. "Self-Determined Health App Evaluation Questionnaire." PMC, 2025. https://pmc.ncbi.nlm.nih.gov/articles/PMC12269797/

---

*This document was compiled from 16+ independent research queries across behavioral science, gamification, mobile UX design, game design, commitment devices, habit formation research, and Solo Leveling lore analysis.*
