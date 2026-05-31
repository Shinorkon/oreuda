## Dimension 03: Goal Taxonomy & Decomposition Engine

### Research Summary

This document synthesizes research across psychology, behavioral science, AI planning, and organizational management to design a comprehensive goal taxonomy and AI-powered decomposition engine for the ARISE gamified life app. The core insight from the research is that **no single framework works for all goal types** — effective goal systems require framework layering matched to goal characteristics. The research draws on established taxonomies including WIST (Work, Intimacy, Spirituality, Transcendence) [^195^], Pinquart's lifespan domains [^7^], multiple goal-setting frameworks (SMART, OKR, PACT, WOOP, HARD, Backward Design), BJ Fogg's Behavior Model [^290^][^295^], Self-Determination Theory [^413^][^414^], and cutting-edge AI task decomposition research [^350^][^351^].

---

### Goal Taxonomy (12+ Domains)

The taxonomy integrates two validated academic frameworks — Pinquart's lifespan goal domains [^7^] and Emmons' WIST taxonomy of personal meaning [^195^] — and extends them into 12 operational domains with subcategories, affected stats, and recommended framework pairings.

| # | Domain | Subcategories | Primary Stats | Secondary Stats | Recommended Framework |
|---|--------|---------------|---------------|-----------------|----------------------|
| 1 | **Physical Health** | Cardiovascular fitness, strength, flexibility, sleep hygiene, nutrition, weight management, injury rehab | STR, VIT | CHA | SMART + PACT + Fogg MAP |
| 2 | **Mental Health** | Stress management, anxiety reduction, depression behavioral activation, mindfulness, emotional regulation | WIS, VIT | INT | WOOP + CBT Activation + SUDS |
| 3 | **Intellectual Growth** | Skill acquisition, formal education, reading, critical thinking, language learning, certifications | INT | WIS | Backward Design + 12 Week Year |
| 4 | **Career/Work** | Job performance, promotion, career change, side business, productivity, leadership | STR, INT | CHA | OKR + 12 Week Year |
| 5 | **Financial** | Emergency fund, debt payoff, saving, investing, retirement, major purchases | INT | STR | SMART Milestones + PACT |
| 6 | **Relationships** | Romantic partnership, family, friendships, social skills, community, networking | CHA | WIS | HARD + WOOP |
| 7 | **Spirituality** | Religious practice, meditation, meaning-making, values alignment, nature connection | WIS | VIT | HARD + PACT |
| 8 | **Transcendence/Contribution** | Volunteering, mentorship, legacy, generativity, social impact, environmental action | CHA | WIS | HARD + OKR |
| 9 | **Leisure/Recreation** | Hobbies, travel, entertainment, games, sports, creative play | VIT | CHA | PACT + Temptation Bundling |
| 10 | **Creative Expression** | Writing, music, visual arts, crafting, content creation, performance | INT, CHA | WIS | PACT + Habit Stacking |
| 11 | **Environment/Organization** | Home organization, decluttering, digital organization, workspace optimization | VIT | INT | SMART + Fogg MAP |
| 12 | **Character/Virtue** | Honesty, courage, patience, gratitude, humility, integrity | WIS | CHA | HARD + WOOP |

**Academic Foundation**: Pinquart et al. [^7^] identified five core goal domains across the lifespan: health-related (maintaining/improving physical health), psychological (inner states, self-insight), social (interpersonal relations), achievement-related (career, prosperity, prestige), and leisure (intrinsically meaningful self-rewarding activities). Emmons' research [^195^] converged on the WIST taxonomy — Work, Intimacy, Spirituality, Transcendence — across three independent research programs using diverse methodologies. The 12-domain ARISE taxonomy represents an integration and operational extension of both frameworks for practical goal-setting.

**Cross-Domain Goals**: Goals that span multiple domains receive a "primary" domain assignment and "secondary" stat contributions. For example, "run a marathon for charity" primarily maps to Physical Health (STR/VIT) with secondary contributions to Transcendence (CHA/WIS).

---

### Decomposition Templates

**Template 1: Achievement/Milestone Goals (e.g., "Save $10,000")**
- Level 1: Define target number and deadline → calculate weekly/monthly rate
- Level 2: Identify milestone checkpoints (25%, 50%, 75%, 100%)
- Level 3: Generate weekly tactics (automated transfers, expense reviews)
- Level 4: Daily micro-action (log expenses, review spending)
- Framework: SMART + 12 Week Year execution scoring [^89^][^314^]

**Template 2: Habit/Process Goals (e.g., "Exercise regularly")**
- Level 1: Define purpose (why) → connect to core value
- Level 2: Make it tiny (Fogg: <30 seconds initial version) [^290^][^297^]
- Level 3: Anchor to existing routine (habit stacking) [^352^][^353^]
- Level 4: Binary daily tracking (yes/no) + weekly review
- Framework: PACT + BJ Fogg MAP [^301^][^185^]

**Template 3: Behavioral Change Goals (e.g., "Reduce social media use")**
- Level 1: Identify trigger situations (when, where, emotional state)
- Level 2: Design obstacle-response pairs (WOOP: if-then plans) [^113^][^300^]
- Level 3: Reduce friction for desired behavior / increase friction for undesired
- Level 4: Daily trigger tracking + implementation intention review
- Framework: WOOP + Fogg MAP (environment design) [^119^]

**Template 4: Stretch/Aspirational Goals (e.g., "Write a novel")**
- Level 1: Create vivid outcome visualization (HARD: animated) [^321^]
- Level 2: Set 12-week milestone with execution scoring
- Level 3: Decompose into weekly output targets (words, scenes, chapters)
- Level 4: Daily minimum viable action (e.g., "write 50 words")
- Framework: HARD + 12 Week Year + PACT [^314^][^315^]

**Template 5: Learning/Skill Goals (e.g., "Learn Spanish to conversational level")**
- Level 1: Define desired end-state performance (Backward Design) [^293^][^299^]
- Level 2: Identify prerequisite knowledge/skills
- Level 3: Create spaced practice schedule (4-6 week mesocycles) [^302^]
- Level 4: Daily micro-learning session (Duolingo lesson, Anki review)
- Framework: Backward Design + PACT + periodization

**Template 6: Social/Relationship Goals (e.g., "Have deeper friendships")**
- Level 1: Identify specific relationship(s) to invest in
- Level 2: Define observable proxy behaviors (text frequency, meetups)
- Level 3: Schedule recurring connection rituals
- Level 4: Daily micro-action (send one message, express gratitude)
- Framework: HARD + WOOP (anticipate social anxiety obstacles) [^300^]

**Template 7: Mental Health/Fear Hierarchy Goals (e.g., "Overcome fear of public speaking")**
- Level 1: Build fear ladder using SUDS 0-100 scale [^360^][^364^]
- Level 2: Order situations from lowest to highest distress
- Level 3: Progressive exposure: start at SUDS 20-30, advance when habituated 50%
- Level 4: Daily micro-exposure or behavioral activation scheduling [^151^][^369^]
- Framework: CBT Behavioral Activation + WOOP + SUDS tracking

**Template 8: Financial Stage Goals (e.g., "Achieve financial independence")**
- Level 1: Identify current financial stage [^367^]
- Level 2: Define next milestone (emergency fund → debt freedom → retirement match → taxable investing)
- Level 3: Calculate monthly savings rate needed
- Level 4: Daily spending awareness / weekly budget review
- Framework: SMART milestones + PACT (consistent saving behavior)

---

### Proxy Indicator Library

Abstract goals require translation into measurable proxy behaviors. The following library draws on well-being measurement research [^404^][^405^][^407^], CBT practice [^360^][^151^], and behavioral science.

| Abstract Goal | Measurable Proxy | Validation Source |
|--------------|-----------------|-------------------|
| "Be more present" | Log 3 mindful moments per day (timestamp + 1-word note) | CBT activity monitoring [^151^] |
| "Be happier" | Daily 0-10 life satisfaction rating + track positive events | OECD well-being guidelines [^408^] |
| "Be more confident" | Log one "mastery moment" daily + weekly SUDS rating | SUDS scale [^360^] |
| "Have better relationships" | Weekly count of initiated meaningful conversations | Pinquart social goals [^7^] |
| "Be more productive" | Track "deep work" hours via time-blocking + daily quest completion | 12 Week Year execution score [^314^] |
| "Reduce stress" | Daily SUDS rating 0-100 + count of completed pleasant activities | Behavioral Activation [^151^] |
| "Be healthier" | Weekly count of vegetable servings + workouts + sleep hours | Pinquart health goals [^7^] |
| "Find meaning" | Weekly log of activities aligned with WIST values [^195^] | Emmons meaning research |
| "Be more creative" | Daily "creative minutes" logged + weekly output count | PACT continuous framework [^301^] |
| "Improve focus" | Daily count of uninterrupted 25-minute blocks (Pomodoro) | Attention measurement research |
| "Be more grateful" | Write 3 specific gratitudes daily (prompted at set time) | Positive psychology intervention research |
| "Build discipline" | Weekly execution score (% of planned tactics completed) | 12 Week Year [^314^]: 85% threshold |

---

### Framework Selection Matrix

The ARISE system selects frameworks based on goal characteristics. Research shows that framework layering produces better outcomes than any single approach [^300^].

| Goal Characteristic | Primary Framework | Secondary Framework | Rationale |
|--------------------|--------------------|---------------------|-----------|
| Vague aspiration → needs clarity | SMART | — | Translates fuzzy intent into specific target [^362^][^361^] |
| Long-term stretch goal | HARD | — | Emotional connection + vivid visualization required [^321^] |
| Process/habit building | PACT | Fogg MAP | Focuses on controllable actions, not outcomes [^301^][^185^] |
| Follow-through / procrastination | WOOP | Implementation intentions | Mental contrasting + if-then plans beat visualization [^300^][^119^] |
| Team/organizational alignment | OKR | — | Creates vertical and horizontal goal alignment [^390^][^391^] |
| Learning/educational | Backward Design | — | Starts from desired end-state performance [^293^][^299^] |
| High motivation, low ability | Fogg MAP | Facilitator prompts | Reduce behavior complexity below action line [^290^][^295^] |
| Low motivation, high ability | Fogg MAP | Spark prompts | Add emotional resonance / urgency [^294^] |
| Competing priorities | Approach-Avoidance analysis | WOOP obstacle step | Resolve Lewin-style motivational conflict [^305^][^306^] |
| Fear/anxiety-based | CBT + SUDS ladder | WOOP | Graduated exposure prevents overwhelm [^360^][^364^] |
| Burnout / overtraining | Periodization/deload | PACT (gentle) | Strategic recovery produces supercompensation [^302^][^304^] |

**Key Research Insight**: The WOOP method nearly tripled study hours in a randomized trial (4.3 vs 1.5 hours, p=.021) [^300^]. Implementation intentions alone show a medium-to-large effect (d=0.65) on goal achievement across 94 studies [^300^]. PACT goals focus on output over outcome, making them ideal for habit formation [^301^][^303^].

---

### Metric Type Catalog

| Metric Type | Data Collection Method | Verification Mechanism | Examples |
|------------|----------------------|----------------------|----------|
| **Boolean** | Manual toggle / check-in | Self-report; streak counting | "Did I meditate today?" [^301^] |
| **Numeric (count)** | Manual entry or sensor | Range validation; trend analysis | Push-ups completed, pages read [^361^] |
| **Numeric (scale)** | Slider input (0-10 or 0-100) | Within-session consistency check | SUDS anxiety rating [^360^], mood rating [^151^] |
| **Time-based** | Timer / stopwatch integration | Session duration validation | Deep work hours, meditation minutes |
| **GPS-based** | Location services | Geofence entry/exit detection | Gym visits, outdoor runs, nature time |
| **Heart-rate-based** | Wearable integration (HRM) | HR zone duration calculation | Cardio minutes in target zone |
| **Photo-proof** | Camera capture with timestamp | Image classification (optional) | Meal logging, gym attendance proof |
| **Execution score** | Tactic completion / planned tactics | Weekly auto-calculation | 12 Week Year % completion [^314^] |
| **Streak** | Consecutive daily completions | Anti-cheat: max 1 per day | Habit chain length [^352^] |
| **Milestone** | Achievement unlock on threshold | Automated on reaching threshold | Emergency fund complete, debt free |
| **Leading indicator** | Tracked input metric | Correlation with lag outcome | Workouts/week → weight loss [^355^][^359^] |
| **Lagging indicator** | Outcome measurement | Validated assessment | Weight, body fat, life satisfaction [^404^] |

---

### Time-Based Structuring Cadences

| Goal Type | Daily | Weekly | Monthly | Quarterly | Annual |
|-----------|-------|--------|---------|-----------|--------|
| **Habits** | Binary check-in [^301^] | Streak review, habit stack assessment | Habit health score | Habit portfolio review | — |
| **Fitness** | Workout log, HR data | Deload check-in, volume tally | Progress photos, strength tests | Mesocycle planning | Annual goals [^302^] |
| **Financial** | Spending log | Budget review, net worth update | Savings rate calculation | Goal stage assessment | Tax planning, big picture [^367^] |
| **Learning** | Micro-learning session | Review, spaced repetition | Knowledge assessment | Course/phase completion | Certification target |
| **Mental Health** | Mood/SUDS rating [^151^] | Activity scheduling review | Pattern analysis | Therapist/self-review | Wellness inventory |
| **Career (OKR)** | Task execution | Execution score [^314^] | KR progress check | Objective grading | Annual planning [^390^] |
| **Relationships** | Gratitude/connection log | Initiated interactions count | Quality time assessment | Relationship review | — |
| **12 Week Year** | Tactic execution | Execution score ≥85% [^89^] | Progress vs. plan | Cycle completion + review | 4 cycles/year [^315^] |

**Critical Cadence Insight**: The 12 Week Year compresses the annual planning horizon to create urgency. Research shows 85%+ weekly tactic completion predicts goal attainment [^314^][^89^]. Execution score is calculated as: (completed tactics / planned tactics) × 100. Below 65% indicates plan failure regardless of strategy quality [^315^].

---

### Deload/Recovery Schedule

Fitness periodization research demonstrates that strategic recovery produces performance gains (supercompensation) while chronic overload leads to decline [^302^][^304^]. The ARISE system extends this principle to all goal domains.

| Domain | Standard Cycle | Deload Frequency | Deload Intensity | Deload Indicators |
|--------|---------------|-----------------|-----------------|-------------------|
| **Physical Fitness** | 3-4 weeks loading | Every 4th week | -40% volume, maintain frequency | Persistent fatigue, HR elevation, sleep disruption [^304^] |
| **Strength Training** | Progressive overload | Every 4-6 weeks | -50% volume, -10% intensity | Strength plateau, joint pain, irritability [^304^] |
| **Intellectual/Learning** | 4-6 week study blocks | Every 5th week | -50% new material, increase review | Reduced comprehension, mental fog |
| **Work/Productivity** | 12-week execution cycles | 13th week [^314^] | Planning + reflection only, no execution | Execution score declining, error rate increase |
| **Creative Work** | Project sprints | Between sprints | Input mode (consumption, inspiration) | Blocked, repetitive output, joy decline |
| **Social/Relationships** | Ongoing | Monthly "solo day" | Reduced social obligations | Social fatigue, resentment, dread |
| **Mental Health Exposure** | SUDS ladder climbing | After each 10-point advance | Return to previous step comfort zone | SUDS not reducing within session [^360^] |
| **Financial** | Monthly savings discipline | Quarterly "spend day" | Controlled discretionary spending | Deprivation mindset, budget rebellion |

**Recovery Mechanics**: During deload weeks, the system:
1. Halves XP gains (reduced but not zero — maintain streaks)
2. Emphasizes "maintenance mode" quests over progress quests
3. Triggers reflection prompts ("What did this cycle teach me?")
4. Auto-generates next-cycle plan using learnings

---

### Goal Conflict Resolution

Goal conflicts are modeled using Lewin's approach-avoidance conflict theory [^305^][^306^], where competing motivations create internal tension. The ARISE system identifies three primary conflict types:

**Type 1: Approach-Approach Conflict** (Two desirable but mutually exclusive options)
- Example: "Bulk for muscle gain" vs. "Cut for fat loss"
- Resolution: Sequential phasing — commit to one for 12 weeks, then switch
- System prompt: "Both goals serve your health. Which aligns better with your current season?"

**Type 2: Avoidance-Avoidance Conflict** (Must choose between two undesirable options)
- Example: "Pay off high-interest debt" vs. "Build emergency fund"
- Resolution: Hybrid approach — 70/30 split until threshold reached, then reallocate
- System prompt: "The optimal path may be a balanced attack. Set your allocation ratio."

**Type 3: Approach-Avoidance Conflict** (Single goal has both appealing and unappealing aspects)
- Example: Desire promotion (approach) + fear of increased responsibility (avoidance)
- Resolution: WOOP obstacle confrontation + graduated exposure [^300^]
- System prompt: "The avoidance gradient steepens as you approach the goal. What's the specific fear?"

**Domain-Specific Conflict Resolution Rules**:
- **Bulk vs. Cut (Fitness)**: Use body composition data; recommend bulk if <15% body fat, cut if >20%, maintain between
- **Save vs. Spend (Finance)**: Apply 50/30/20 rule as default; allow user override with justification
- **Rest vs. Train (Fitness)**: Use HRV + subjective readiness; auto-suggest deload if 2+ recovery metrics decline
- **Work vs. Relationships**: Weekly time audit; alert if work consistently exceeds self-defined relationship threshold

---

### AI Decomposition Prompt Architecture

The decomposition engine uses a hierarchical LLM-based approach inspired by current agentic AI research [^350^][^351^][^357^][^358^].

**Component 1: Goal Classification Module**
- Prompt strategy: Multi-class classification with few-shot examples
- Input: Natural language goal description
- Output: Domain assignment + goal type classification + recommended framework(s)
- Citation: LLM task decomposition taxonomy for dividing complex objectives [^350^]

**Component 2: Framework Application Layer**
- Prompt strategy: Template instantiation with domain-specific knowledge
- Input: Classified goal + user context (stats, history, preferences)
- Output: Structured goal using selected framework (SMART, PACT, WOOP, etc.)
- Citation: Prompted LLM with domain/task priors outperforms zero-shot [^350^]

**Component 3: Subgoal Decomposition Engine**
- Prompt strategy: Recursive decomposition with dependency graph construction
- Input: Framework-structured goal
- Output: Hierarchical quest tree (goal → milestones → quests → daily actions)
- Citation: Hierarchical LLM agents using subgoal decomposition achieve 88-100% success rates [^357^]

**Component 4: Proxy Indicator Generator**
- Prompt strategy: Abstract-to-behavioral translation using validated proxy library
- Input: Vague or abstract goal component
- Output: Measurable behavioral proxy with metric type recommendation
- Citation: Value-based decomposition splits ambiguous goals into quantified sub-goals [^299^]

**Component 5: Time Structure Assignment**
- Prompt strategy: Rule-based cadence matching with user calendar awareness
- Input: Decomposed quest tree + user availability patterns
- Output: Time-anchored plan with review checkpoints
- Citation: 12 Week Year execution scoring requires weekly review cadence [^314^][^89^]

**Component 6: Conflict Detection & Resolution**
- Prompt strategy: Goal portfolio analysis for competing objectives
- Input: All active goals + resource constraints
- Output: Conflict alerts + resolution recommendations
- Citation: Approach-avoidance dynamics require gradient analysis [^305^]

**Component 7: Recovery/Periodization Integration**
- Prompt strategy: Fatigue-aware scheduling with deload prediction
- Input: Execution trends + completion rates + subjective energy ratings
- Output: Auto-scheduled deload weeks + adjusted quest difficulty
- Citation: 3:1 or 4:1 loading-to-recovery ratio prevents non-functional overreaching [^302^]

**Prompt Chain Architecture**:
```
User Input → Classification → Framework Selection → 
Decomposition → Proxy Assignment → Time Structuring → 
Conflict Check → Recovery Integration → Final Quest Tree
```

Each stage feeds into the next, with the option for user override at any checkpoint (supporting autonomy per Self-Determination Theory [^413^][^414^]).

---

### Edge Case Handling

**Unusual Goals**: Goals that don't fit standard templates trigger the "Custom Goal Wizard." The user describes the goal in natural language, the AI classifies it against the taxonomy, and if no match exceeds 70% confidence, it enters "Experimental" mode with:
- Custom framework builder
- Manual proxy indicator definition
- Community-suggested decomposition patterns

**Multi-Domain Goals**: Goals spanning >2 domains receive:
- Primary domain assignment (highest stat weight)
- Secondary domain tag(s) for cross-domain XP allocation
- Decomposition into domain-specific sub-quests
- Example: "Run a charity marathon" → Physical (60%) + Transcendence (30%) + Financial (10%)

**Seasonal Goals**: Goals with natural time bounds (e.g., "Learn to ski this winter") receive:
- Seasonal activation/deactivation
- Pre-season preparation quests
- In-season intensity quests
- Post-season reflection and maintenance quests

**Conditional Goals**: Goals contingent on external events (e.g., "If I get the promotion, start MBA") receive:
- Trigger condition definition
- Preparatory quest branch (activated immediately)
- Main quest branch (activated on trigger)
- Both branches visible but only preparatory active

**Maintenance Goals**: Ongoing goals without endpoint (e.g., "Stay fit") receive:
- Perpetual quest status with rotating micro-challenges
- Periodic reassessment prompts (quarterly)
- Escalation paths when maintenance becomes improvement

---

### Progress Tracking System

**Leading vs. Lagging Indicators** [^355^][^359^]:

| Domain | Leading Indicator (Input) | Lagging Indicator (Outcome) |
|--------|--------------------------|---------------------------|
| Fitness | Weekly workouts completed | Body composition, strength PRs |
| Finance | Monthly savings rate | Net worth, investment balance |
| Learning | Study hours, lessons completed | Assessment scores, project output |
| Career | Execution score, projects shipped | Promotion timeline, salary growth |
| Mental Health | Daily mood/SUDS ratings, activity count | Clinical assessment, well-being index |
| Relationships | Initiated interactions, quality time hours | Relationship satisfaction score |

**Milestone Definitions**: Milestones are non-binary achievement markers that unlock:
- Stage 0: Discovery (just starting, <25% progress)
- Stage 1: Building (25-50%, early momentum)
- Stage 2: Accelerating (50-75%, compound effects visible)
- Stage 3: Approaching (75-90%, final push phase)
- Stage 4: Mastery (90-100%, habituated)
- Stage 5: Transcendence (>100%, maintaining above target)

**Completion Criteria**:
- Binary goals: Single completion event
- Numeric goals: Target threshold reached
- Habit goals: 66+ consecutive days (habit research threshold) or Stage 4 sustained for 4 weeks
- Learning goals: Demonstrated competence via assessment or output
- Social goals: Self-reported + relationship-partner-reported satisfaction

---

### User Customization Framework

Based on Self-Determination Theory [^413^][^414^][^417^], user customization is designed to support the three basic psychological needs: autonomy, competence, and relatedness.

**Autonomy Support (Override Capabilities)**:
- Users can override AI framework selection with rationale
- Users can modify decomposed quest trees (add/remove/reorder)
- Users can set their own proxy indicators
- Users can define custom domains and subcategories
- Users can adjust all time cadences (within evidence-based bounds)

**Competence Support**:
- Difficulty auto-adjustment based on execution score history
- Progressive disclosure (beginners see simplified templates, advanced users see full system)
- Skill tree unlocking (new frameworks become available as user demonstrates mastery)
- Optimal challenge calibration (quests at ~85% success rate for flow state)

**Relatedness Support**:
- Accountability partnership integration
- Community goal templates ("Join 500 people doing the 30-day meditation challenge")
- Mentorship matching for domain-specific goals
- Social sharing of milestones and streaks

**Override Limits**: To preserve system integrity, certain elements have "soft guardrails":
- Execution score threshold warnings (below 65% triggers plan review, not lockout)
- Deload week recommendations become mandatory only after 3 consecutive ignored warnings
- Goal conflict resolution defaults to user choice with risk warnings
- Safety-critical goals (mental health exposure therapy) require clinician confirmation for modifications

**Customization Depth Levels**:
1. **Beginner**: AI selects everything; user confirms or requests changes
2. **Intermediate**: User selects framework; AI handles decomposition
3. **Advanced**: User modifies decomposition; AI provides suggestions
4. **Expert**: User builds custom frameworks; AI validates and optimizes

---

### Key Citations Summary

| Citation | Source | Key Contribution |
|----------|--------|-----------------|
| [^7^] | Pinquart et al., PMC | Five goal domains across lifespan: health, psychological, social, achievement, leisure |
| [^54^] | Y. Chou, Octalysis | SDT in gamification: 6 mini-theories applied to engagement design |
| [^89^] | Griply Blog | 12 Week Year: 85%+ execution score as leading indicator |
| [^113^] | Thriva Hub | WOOP strategy: 4-step protocol with implementation intentions |
| [^119^] | ScienceDirect | MCII research: WOOP works through non-conscious cognitive processes |
| [^151^] | Berries Blog | Behavioral Activation: activity scheduling, mood/pleasure/mastery tracking |
| [^185^] | DLC Training | PACT goals: Purposeful, Actionable, Continuous, Trackable |
| [^195^] | Emmons, HKU | WIST taxonomy: Work, Intimacy, Spirituality, Transcendence |
| [^290^] | DrPaulMcCarthy | BJ Fogg B=MAP model: Motivation, Ability, Prompt |
| [^293^] | Agentic Design | Goal decomposition: SMART + dependency mapping + impact prioritization |
| [^295^] | Decision Lab | Fogg Behavior Model: compensatory relationship between motivation and ability |
| [^297^] | Nehrlich Blog | Tiny Habits: ABC sequence (Anchor, Behavior, Celebration) |
| [^299^] | BSC Designer | Value-based decomposition: quantified sub-goals for stakeholders |
| [^300^] | Goals and Progress | WOOP nearly tripled study hours (4.3 vs 1.5); implementation intentions d=0.65 |
| [^301^] | Goals and Progress | PACT: output-focused, binary tracking, continuous progress |
| [^302^] | RundiDa | Supercompensation: 3:1 or 4:1 loading-to-recovery ratio |
| [^303^] | Ness Labs | PACT as humane alternative to outcome-focused goal setting |
| [^304^] | Fitness Programer | Deload week: -20-40% volume, prevents overtraining syndrome |
| [^305^] | Battle Within | Approach-avoidance conflict: Lewin's gradient theory |
| [^306^] | Deutsch Handbook | Three conflict types: approach-approach, avoidance-avoidance, approach-avoidance |
| [^312^] | EHM Tech | Temptation bundling: 51% gym visit increase, 10-14% sustained at 17 weeks |
| [^314^] | Tahir Ramzan | 12 Week Year: weekly scorecard, execution score, 13th week review |
| [^315^] | Bagerbach | Execution score formula: completed/planned × 100; 65-75% suboptimal |
| [^321^] | Mark Murphy | HARD goals: Heartfelt, Animated, Required, Difficult |
| [^350^] | arXiv 2402.02716 | LLM task decomposition taxonomy: CoT, ReAct, HuggingGPT approaches |
| [^351^] | arXiv 2408.16090 | Hierarchical LLM agents: subgoal decomposition + low-level action policies |
| [^352^] | Habi Blog | Habit stacking: chain 2-3 habits, extend gradually |
| [^353^] | Readdle | Habit stacking as cue-response automaticity in stable contexts |
| [^355^] | Maximizer | Leading indicators predict; lagging indicators confirm |
| [^360^] | NIH PMC | SUDS scale 0-100: fear hierarchy building, habituation at 50% reduction |
| [^361^] | Forbes | SMART goals: specific, measurable, achievable, relevant, time-bound |
| [^362^] | Asana | SMART transformation: vague to actionable with 5 criteria |
| [^364^] | Interactive Counselling | SUDS in exposure therapy: start at lowest-rated item, advance on habituation |
| [^367^] | Finance Strategists | Financial milestones: short-term (1-2yr), medium-term (2-5yr), long-term (5yr+) |
| [^369^] | U. Michigan | Behavioral Activation manual: 320 pleasant activities, activity scheduling |
| [^390^] | Workboard | OKRs: 3-5 objectives, 4-6 key results, quarterly cycle |
| [^391^] | What Matters | OKR history: Andy Grove at Intel → John Doerr → Google |
| [^396^] | Wikipedia | OKR framework: objectives (qualitative) + key results (measurable) |
| [^404^] | Replicability Index | Subjective well-being: life satisfaction as distinct from hedonic affect |
| [^405^] | Ruggeri et al., PubMed | 10-dimension multidimensional psychological well-being |
| [^407^] | Harvard LKS Center | Well-being measurement scales: Life Engagement, Meaning, Flourishing, PERMA |
| [^408^] | OECD | Life satisfaction measurement: 0-10 scale, policy evaluation guidelines |
| [^413^] | SUE Behavioral Design | SDT: autonomy, competence, relatedness as innate psychological needs |
| [^414^] | Positive Psychology | SDT continuum: amotivation → external → introjected → identified → integrated → intrinsic |
| [^417^] | Wikipedia | SDT: Edward Deci and Richard Ryan, 1985 foundational work |

---

*Document compiled from 18+ research queries across academic databases, behavioral science literature, organizational management research, and AI planning publications. All citations use inline reference numbers corresponding to search results.*
