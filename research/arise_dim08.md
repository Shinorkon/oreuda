# Dimension 08: Social & Guild System Design

## Overview

The ARISE social system is designed to provide **accountability without surveillance**, **competition without toxicity**, and **connection without exposure**. Drawing from Solo Leveling's guild and Shadow Army hierarchy, behavioral economics research on commitment devices, and self-determination theory, the system creates social structures that genuinely motivate habit formation while respecting user privacy.

> **Core Philosophy**: "No public profiles, no followers, no likes" — private guilds + anonymous global board only.

---

## 1. Guild System Specification

### 1.1 Guild Formation & Structure

| Feature | Description | Privacy Level |
|---------|-------------|---------------|
| **Guild Creation** | Any Hunter Rank E or above can create a guild with a custom name (e.g., "Ahjin", "Fame Guild"). Guild names must be unique. Max 1 guild creation per user. | Guild name visible to all; creator identity visible only to members |
| **Guild Size** | 2-10 members. Hard cap at 10 to maintain intimacy and accountability. Research shows smaller groups produce higher individual contribution rates. [^470^] | Member count visible on guild card; member list private |
| **Guild Name** | Inspired by Solo Leveling guilds (Ahjin, White Tiger, Reaper, Hunter's, Scavenger). Users choose or random-generate thematic names. | Public |
| **Guild Roles** | Guild Master (1), Officer (1-2, appointed by Master), Soldier (remaining). Roles determine raid management permissions. | Visible to guild members only |
| **Guild Tiers** | Bronze → Silver → Gold → Platinum → Diamond guild tiers, based on collective weekly completion rate. Higher tiers unlock cosmetic rewards and larger raid bonuses. | Tier badge visible publicly |
| **Guild Hall** | A shared visual space showing all member shadows in formation. Customizable banner and emblem. Serves as the hub for raids, feed, and member status. | Members only |
| **Guild Disband** | Automatic disband after 30 days of 0 member logins. Guild Master can transfer ownership before leaving. Members notified 7 days in advance. | N/A |

### 1.2 Membership Mechanics

- **Join Methods**: (a) Direct invite from any member, (b) Join link with 24-hour expiry, (c) Guild code (6-character alphanumeric). No open/public guild discovery — all guilds are invite-only or code-access [^605^].
- **Leaving**: Members can leave without penalty. No "guild kick" feature — toxicity prevention through exit, not exclusion.
- **Guild Master Transfer**: Auto-transfers to most active member after 14 days of Guild Master inactivity.
- **Simultaneous Membership**: Users can belong to exactly 1 guild at a time. This creates commitment and prevents guild-hopping for rewards.

### 1.3 Shared Guild Leaderboard

- **Intra-Guild Weekly Board**: Ranks members by completion rate (Habits + Dailies completed / total assigned). Updated in real-time.
- **Sorting**: Primary by weekly completion %, secondary by total XP earned.
- **Visibility**: Members only. No opt-out (the point of guild membership is mutual visibility).
- **Streak Display**: Each member shows current daily streak as a flame icon. Missing a day reduces guild average.
- **No Punishment for Misses**: Board ranks by positive completion, NOT by penalizing failures. The worst-ranked member is simply the one with fewest completions — no negative badges. [^494^]

### 1.4 Guild Quest Feed

- **What Appears**: Habit/Daily completion announcements (e.g., "ShadowKnight completed Morning Workout"), Quest completion celebrations, New member joins, Raid victory/defeat results.
- **What Does NOT Appear**: Specific content of tasks (no "Brushed teeth" or "Called therapist"), personal journal entries, failed habits, streak losses, any task descriptions beyond category tags.
- **Update Frequency**: Real-time, batched into digest format every 6 hours.
- **Privacy**: Members only. No export or share to external platforms.

---

## 2. Guild Raid Design

### 2.1 Raid System Overview

Guild Raids are simultaneous group challenges where all guild members must complete personal habit goals within a time window. Inspired by WoW Guild Challenges [^483^] and Habitica's boss damage system [^466^], but inverted: instead of one member's failure hurting the group, collective success benefits everyone.

### 2.2 Raid Types

| Raid Type | Duration | Participation Requirement | Reward Structure |
|-----------|----------|--------------------------|------------------|
| **Daily Skirmish** | 24 hours | 100% member completion of all assigned Dailies | +10% XP bonus to all participants; +1 Essence shard per member |
| **Weekly Campaign** | 7 days | 70%+ guild average completion rate | Tiered: 70-79% = Bronze chest, 80-89% = Silver chest, 90-99% = Gold chest, 100% = Legendary chest. Contents: Shadow Extracts, Essence, cosmetic items [^483^] |
| **Boss Assault** | 72 hours | Collective 500+ habits completed across all members | All members receive Boss Slayer badge; highest contributor gets named Shadow; guild hall displays defeated boss trophy permanently |
| **Solo Leveling Marathon** | 30 days | Guild maintains 85%+ average completion for full month | Exclusive Shadow Army skin for all members; guild name etched on Seasonal Monument (anonymous) |

### 2.3 Raid Mechanics

- **Participation Threshold**: Raids succeed at 70%+ completion specifically to avoid the "one member fails, everyone suffers" dynamic that creates toxicity [^466^]. This is deliberate — research shows cooperative structures where individual failure doesn't collapse group rewards produce higher motivation than punishing designs [^464^].
- **Contribution Scaling**: Higher-ranked guilds (Gold+) face higher completion thresholds (75-85%) for the same rewards, creating appropriate challenge escalation.
- **Visual Progress**: Guild-wide progress bar visible in Guild Hall, updated in real-time. Shows collective progress toward the threshold.
- **Time Windows**: Raids start at the same time for all members (UTC midnight) to create shared rhythm. Daily resets at each user's local midnight.
- **Opt-In**: Guild Master initiates raids; members automatically included but can set "Away" status (max 7 days) to excuse themselves without penalty.

### 2.4 Reward Distribution

- **Collective Chest Model**: All qualifying members receive identical base rewards. No individual performance-based distribution within a raid — the group succeeds or succeeds together [^470^].
- **MVP Bonus**: The member with highest individual completion during a raid receives a small cosmetic bonus (title, badge variant) but NOT additional functional rewards. This prevents power concentration.
- **Streak Carry**: Guilds with 3+ consecutive raid victories gain a "Momentum" visual buff in their Guild Hall, conferring +5% XP for the next raid attempt.

---

## 3. Leaderboard Design

### 3.1 Anonymous Global Leaderboard

| Board Type | Sorting | Visibility | Update Frequency |
|------------|---------|------------|------------------|
| **Global Hunter Rank** | By Hunter Rank tier (E → National Level), then by XP within tier | Username only (chosen pseudonym), no profile photos, no guild names, no country flags | Weekly recalculation at Sunday 00:00 UTC |
| **Weekly XP Gainers** | Most XP earned this week | Username + rank change arrow (up/down/hold) | Daily update at 00:00 UTC |
| **Shadow Army Strength** | Total shadow power score (sum of all extracted shadows) | Username + rank only | Weekly |
| **Streak Legends** | Longest active daily habit streak | Username + streak count | Real-time |

- **Username-Only Policy**: The global board displays ONLY the pseudonym the user chose at onboarding (e.g., "ShadowHunter_7", "IgrisFan"). No avatars, no guild affiliation, no profile data. This is core to ARISE's privacy promise — even top-ranked players remain anonymous. [^604^] [^605^]
- **No Click-Through**: Usernames on the global board are NOT clickable. You cannot view someone's profile, guild, or history from the board. The board exists purely as an ambient motivational signal.
- **Anonymous Rank Metaphor**: Ranks mirror the Solo Leveling system — E, D, C, B, A, S, then SS, SSS, and National Level. Users know their tier but not their exact numeric position within it (except for top 100 per tier, who see their number).

### 3.2 Guild vs. Global Leaderboards

| Dimension | Guild Leaderboard | Global Leaderboard |
|-----------|-------------------|-------------------|
| Identity | Real guild names + member pseudonyms | Anonymous pseudonyms only |
| Scope | Within guild | Entire server |
| Metric | Weekly completion % | Hunter Rank / XP / Shadow Power |
| Clickable | Yes (member profiles visible) | No (static display only) |
| Privacy | Members only | All users |

### 3.3 Opt-Out Mechanism

- **Global Board Opt-Out**: Users can toggle "Appear on Global Boards" off in settings at any time. This immediately removes them from all global rankings. No penalty.
- **Default**: Opt-IN required at onboarding (not opt-out). Users must explicitly choose to appear on global boards. [^530^]
- **Guild Board**: Cannot opt out — guild membership implies mutual accountability visibility.

---

## 4. Social Feed Design

### 4.1 Content Types & Visibility

| Content Type | Example | Visibility | Who Sees It |
|-------------|---------|------------|-------------|
| **Habit Completion** | "A guild member completed a Strength Habit" | Guild only | Guild members |
| **Daily Streak Milestone** | "Member reached 7-day streak" | Guild only | Guild members |
| **Quest Completion** | "Member completed 'Read 5 Books' quest" | Guild only | Guild members |
| **Shadow Extraction** | "Member extracted a new shadow" | Guild + optional global | Guild always; global if user opts in |
| **Rank Up** | "Member promoted to D-Rank" | Guild + global (anon) | Guild sees name; global sees pseudonym only |
| **Raid Progress** | "Guild Raid 73% complete" | Guild only | Guild members |
| **Raid Victory** | "Guild completed Weekly Campaign!" | Guild + global (anon) | Guild sees full details; global sees "A guild completed a raid" |

### 4.2 Content NOT Shared (Privacy Guardrails)

- Specific habit/task names (no "Brushed teeth", "Therapy session")
- Personal journal entries or notes
- Failed habits, missed days, or negative data
- Geolocation, device info, time patterns beyond "today"
- Guild member real names or contact information
- Any content entered as free text by the user [^605^] [^607^]

### 4.3 Feed Architecture

- **Guild Feed**: Chronological, filterable by content type. Retains 30 days of history.
- **Global Feed**: Does not exist as a social feed — only the anonymous global leaderboard provides ambient social awareness.
- **No Commenting/Liking**: The guild feed has no social reaction mechanisms. This prevents comparison anxiety and performance pressure [^494^]. Members see completions as informational, not performative.
- **Digest Mode**: Daily summary at 20:00 local time: "Today in [Guild]: 5 habits completed, 2 quests finished, Raid at 68%."

---

## 5. Accountability Partners

### 5.1 1:1 Partnership System

- **Body Doubling Model**: Inspired by Focusmate's research on virtual coworking [^590^] [^593^], the Accountability Partner system pairs two users for mutual check-ins.
- **Matching**: Users can (a) invite a friend via link/code, (b) be matched by the app based on similar Hunter Rank and active hours.
- **Partnership Structure**: 
  - Partners see each other's daily habit completion status (completed/not completed, NOT content)
  - Partners can send 3 pre-written check-in prompts per day: "How's today going?", "Don't forget your habits!", "You've got this!"
  - No free-text messaging — only structured prompts to prevent social obligation creep [^591^]
- **Check-in Windows**: Partners agree on a shared check-in time (e.g., 9 AM and 9 PM). Both receive notifications at that time showing partner's status.
- **Streak Together**: Partners share a "Partnership Streak" counting consecutive days both completed all Dailies. Breaking it resets both — mutual accountability without punishment.
- **Max Partnerships**: 1 active partnership at a time. Dissolution requires no approval — either partner can end it without notification.

### 5.2 Research Basis

Research from the American Society of Training and Development found that having a specific accountability appointment increases goal completion rates to 95% (vs. 65% for just telling someone) [^165^]. Focusmate users report 161% productivity increases from virtual body doubling [^165^]. The ARISE system distills this to its essential form: presence, visibility, and lightweight check-in structure [^590^] [^592^].

---

## 6. Toxicity Prevention

### 6.1 Prevention Mechanics

| Mechanic | Description |
|----------|-------------|
| **No Public Profiles** | Users cannot view any profile beyond their guild. No follower counts, no public achievement galleries. Eliminates performative pressure. [^605^] |
| **No Free-Text Messaging** | All social communication uses structured prompts. No guild chat, no DMs, no comments. Eliminates harassment vectors. [^494^] |
| **No Failure Broadcasting** | Failed habits and missed days are NEVER visible to anyone. Only completions are shared. Prevents shame spirals. |
| **No Rank Shaming** | Global leaderboard shows pseudonyms only with no click-through. No way to identify or contact top/bottom players. |
| **No Guild Kick** | Members can leave but cannot be kicked. Prevents bullying through exclusion. |
| **Guild Size Cap (10)** | Small groups create accountability; large groups create anonymity for toxic behavior. Research shows toxicity scales with group size. [^615^] |
| **Anonymous Global Only** | The only public social signal is the anonymous leaderboard. No identity, no guild affiliation, no way to target individuals. [^602^] [^604^] |
| **No Competitive Penalties** | Losing a raid simply means no bonus — no damage, no lost items, no public defeat announcement. |
| **Positive Framing Only** | All feed messages frame progress positively. No "X missed their habits" — instead, collective encouragement toward the goal. |
| **Emotion-Neutral Design** | Status indicators use color-coded bars (not emojis with emotional expressions), meeting users where they are without forcing positivity. [^494^] |

### 6.2 Shame Avoidance Design

Research on toxic positivity in wellness apps shows that framing emotions as "good/bad" and pushing constant positivity can harm users navigating mental health challenges [^494^]. ARISE avoids:

- **No "Perfect Day" shaming**: Unlike Habitica's Perfect Day achievement which can create pressure [^468^], ARISE celebrates individual completions without requiring 100% completion for recognition.
- **No Visible Failure Chains**: Missing 3 days in a row shows no public signal. The streak simply pauses.
- **Realistic Affirmations**: System messages use grounded language: "You're building consistency, one day at a time" rather than "You're amazing! Crush it!" [^494^]

### 6.3 Escalating Response System

If toxicity somehow occurs (e.g., through external platforms linked via guild invites):

- **Report**: One-tap report on any member (anonymous to the reporter)
- **Mute**: Block all feed content from a specific member within your guild
- **Leave**: Immediate guild departure, no penalty, no notification
- **Guild Dissolution**: If 50%+ of members leave within 7 days, system auto-investigates for toxicity patterns

---

## 7. Shadow Army Social Metaphor

### 7.1 Shadow Extraction as Social Bonding

In Solo Leveling, the Shadow Army consists of 7 grades of shadow soldiers extracted from defeated enemies [^62^] [^486^]. In ARISE, this maps to social features:

| Solo Leveling Concept | ARISE Game Design | Social Mapping |
|----------------------|-------------------|---------------|
| **Shadow Extraction** | Completing a difficult habit streak (7+ days) "extracts" a shadow | Personal achievement becomes a visible entity in Guild Hall |
| **Shadow Grades** | 7 shadow tiers from Normal to Grand Marshal | Represents member's consistent contribution level to the guild |
| **Shadow Naming** | At Knight Grade+, shadows can be named | Guild members can assign nicknames to each other's visible shadows (with permission) |
| **Shadow Army Formation** | Guild Hall displays all member shadows in military formation | Visual representation of guild strength and cohesion |
| **Level Up Shadows** | Shadows grow stronger as their owner maintains streaks | Members with longer streaks have more impressive shadow visuals |

### 7.2 Shadow Grades & Guild Contribution

| Shadow Grade | Solo Leveling Equivalent [^62^] | ARISE Unlock Condition | Visual in Guild Hall |
|-------------|-------------------------------|----------------------|---------------------|
| Normal | Weakest foot soldiers | Default shadow on joining guild | Basic shadow silhouette |
| Elite | B-Rank Hunter strength | Complete 7-day streak | Shadow with weapon |
| Knight | A-Rank Hunter strength | Complete 30-day streak | Shadow with armor + nameplate |
| Elite Knight | Basic S-Rank strength | Complete 60-day streak | Shadow with aura effect |
| General | Advanced S-Rank strength | Complete 100-day streak | Shadow with speech bubble, unique animation |
| Marshal | Highest attainable rank | Complete 180-day streak | Massive shadow with particle effects |
| Grand Marshal | Lieutenant to Shadow Monarch | Complete 365-day streak | Unique legendary shadow, one per guild max |

### 7.3 Guild Hall Visual

The Guild Hall displays all member shadows in a military formation. More active members have larger, more impressive shadows at the front. Less active members still appear but with smaller silhouettes. This creates:

- **Ambient accountability**: You see your shadow's size relative to others without explicit comparison
- **Collective pride**: The formation looks more impressive as a whole when everyone is active
- **No shame**: Even the smallest shadow is still part of the army — belonging is unconditional

---

## 8. Invite System

### 8.1 Friend Invites

- **Invite Link**: Each user generates a unique invite link valid for 24 hours. Supports WhatsApp, SMS, email, copy-to-clipboard [^521^] [^522^].
- **Deferred Deep Linking**: Clicking the link opens ARISE directly (or App Store if not installed) with referrer attribution maintained [^522^].
- **Invite Preview**: Recipients see a preview card: "[Username] invited you to join ARISE — a habit-building RPG inspired by Solo Leveling."
- **Referral Reward**: Double-sided incentive: referrer gets +500 Essence, referee gets +500 Essence + rare starter Shadow skin. Rewards unlock after referee completes 7-day onboarding. [^521^] [^525^]

### 8.2 Guild Invites

- **Guild Invite Link**: Guild Master/Officers generate links valid for 24 hours, max 10 uses.
- **Guild Code**: Static 6-character code for guild entry. Can be rotated if leaked.
- **No Open Discovery**: Guilds cannot be browsed or searched. All entry is via invite or code.
- **Invite Dashboard**: Guild Masters see pending invites, successful joins, and active members. [^521^]

### 8.3 Referral Best Practices Applied

Following proven referral design [^521^] [^522^] [^527^]:

- **Moment-of-Delight Trigger**: Invite prompt appears after user completes their first 7-day streak — when they're most motivated.
- **Give $5, Get $5 Framing**: "Give a friend +500 Essence, get +500 Essence when they complete their first week."
- **Progress Visibility**: Referral dashboard shows pending → completed → rewarded status for each invite. [^521^]
- **Fraud Prevention**: Device fingerprinting prevents multiple-account abuse. Max 10 successful referrals per user. [^521^]

---

## 9. Cross-Guild Events

### 9.1 Server-Wide Events

| Event Type | Frequency | Mechanic | Community Impact |
|-----------|-----------|----------|-----------------|
| **World Boss Invasion** | Monthly (3 days) | All guilds collectively contribute habit completions to deplete a shared boss HP bar. All participants who contributed receive rewards if boss is defeated. No guild vs guild — purely collaborative server-wide. | Creates shared purpose across the entire server; all users work toward one goal |
| **Seasonal Rift** | Quarterly (2 weeks) | Special themed event with unique shadow extraction opportunities and limited-time quests. Based on Solo Leveling arcs (e.g., "Double Dungeon Arc", "Jeju Island Raid"). | Drives retention through novelty and FOMO; seasonal content creates return triggers |
| **Hunter Examination** | Bi-annual (1 week) | Individual challenge mode: users complete increasingly difficult habit chains to earn rank-up badges. Anonymous leaderboard for the event only. | Tests individual skill; creates personal achievement stories |
| **Guild Tournament** | Quarterly | Cooperative competition: guilds ranked by collective completion % during the event window. Top 10 guilds receive tiered cosmetic rewards. Anonymous guild names on public board. | Healthy intergroup competition without individual exposure |

### 9.2 Event Design Principles

- **Cooperative over Competitive**: World Boss events use cooperative mechanics (collective contribution) rather than guild-vs-guild. Research shows cooperative group competition produces highest task enjoyment and performance [^470^] [^464^].
- **Anonymous Participation**: Cross-guild leaderboards show guild pseudonyms only (e.g., "A guild from Sector 7"), not actual guild names or member lists.
- **Participation Rewards**: All contributors receive base rewards; top performers receive cosmetic bonuses only. No power-gap creation between participants and non-participants.
- **70% Threshold Applied**: Server-wide events succeed at 70% collective participation, maintaining the accessibility standard. [^470^]

---

## 10. Privacy Architecture

### 10.1 Data Visibility Matrix

| Data Element | User Themselves | Guild Members | Global (Anonymous) | Server |
|-------------|----------------|---------------|-------------------|--------|
| Task names & descriptions | Yes | No | No | Encrypted at rest |
| Habit completion status | Yes | Yes (today only) | No | 30-day retention |
| Completion percentage | Yes | Yes | No | 90-day retention |
| Hunter Rank | Yes | Yes | Yes (pseudonym) | Indefinite |
| Streak count | Yes | Yes | Yes (if opted in) | Indefinite |
| Guild membership | Yes | Yes | No | Until leave |
| Guild name | Yes | Yes | No (except anon tourney) | Indefinite |
| Pseudonym | Yes | Yes | Yes | Indefinite |
| Real name/email | Yes | No | No | GDPR-compliant storage |
| Device info | Yes | No | No | Not collected |
| Location | Yes | No | No | Not collected |

### 10.2 Privacy Principles

- **Privacy by Design**: Privacy protections are default, not opt-in. Only pseudonyms and completion aggregates ever leave the device for social features. [^529^] [^530^]
- **Data Minimization**: ARISE collects only: (a) habit completion timestamps, (b) XP/currency values, (c) pseudonym, (d) guild affiliation. No personal content, no biometric data, no location. [^529^]
- **Purpose Limitation**: Completion data is used ONLY for guild raid calculations and leaderboard sorting. Never for advertising, never shared with third parties. [^533^]
- **Federated Architecture**: Habit content (task names, descriptions) never leaves the device. Only completion boolean + timestamp is transmitted. [^529^]
- **Right to Erasure**: Full account deletion wipes all social data within 30 days. Guild membership auto-terminated. [^530^]
- **No Contact List Access**: ARISE never accesses phone contacts or social graphs. All connections are via explicit invite links. [^605^]

### 10.3 Opt-Out Mechanisms

- **Global Leaderboard**: Toggle off at any time, immediate effect.
- **Guild Feed Participation**: "Quiet Mode" hides your completions from the feed while still counting for raids. Guild members see you as "Quiet" — not a negative signal.
- **Accountability Partnership**: End at any time, no questions asked.
- **Account Deletion**: One-tap initiation, 7-day grace period, then full erasure.

---

## 11. Competition Psychology

### 11.1 When Competition Motivates vs. Demoralizes

Research provides clear guidance on designing healthy competition [^470^] [^464^] [^608^] [^609^]:

**Motivating Competition:**
- Intergroup (team) competition > individual competition > no competition [^470^]
- Competition with evenly matched opponents [^469^]
- Low-stakes rewards (bragging rights, not material advantage)
- Cooperative context (working WITH teammates to compete)
- Positive feedback framing

**Demoralizing Competition:**
- Individual pure competition (zero-sum) [^464^]
- Unmatched opponents (new vs. veteran)
- Public failure visibility
- Heavy emphasis on winning [^469^]
- Upward comparison with idealized others [^608^]

### 11.2 ARISE Application

ARISE applies this research through:

- **Guild Tournament uses intergroup competition**: Guilds cooperate internally to compete externally — the "best of both worlds" that research shows produces highest enjoyment [^470^].
- **Anonymous global board prevents upward comparison spiral**: Users see pseudonyms ranked by rank, not real people with curated achievement galleries. Reduces the negative body-talk correlation seen in fitness apps [^608^].
- **Skill-based implicit matching**: Guilds are matched against similar-tier guilds in tournaments (though names are anonymous). Research shows matched competition is essential for positive outcomes [^613^].
- **No individual leaderboards within guilds**: The guild board shows completion %, not total XP. A new member can top the board with good habits just as easily as a veteran.

### 11.3 Skill-Based Matchmaking Principles

Drawing from SBMM research [^613^] [^617^] [^618^]:

- **Avoid ELO Hell**: Guild tournament matchmaking considers guild tier + average member rank + historical completion rate. New guilds face new guilds.
- **Blowout Prevention**: Activision research shows blowout matches (one-sided) increase churn across ALL skill levels. [^617^] ARISE ensures guild matchups within 15% completion-rate differential.
- **Variance Reduction**: Research shows higher variance in opponent skill = higher churn. [^618^] Tournaments use narrow matching bands, accepting longer queue times for fairer matches.

---

## 12. Retention Impact

### 12.1 Social Feature Retention Data

Research across gaming and productivity apps provides strong support for social features:

| Source | Finding |
|--------|---------|
| Industry benchmark | Gamification with social features increases D30 retention by 15-30% [^60^] |
| Live service game study | Guild/team features increase retention by +52% — the single biggest engagement booster [^606^] |
| MMORPG study | Guild system impact on retention is STRONGER than friend system impact. Both positive, but guild > friends. [^612^] |
| Dragon Nest study | Social interaction features (friends, guild) are critical for distinguishing loyal users from churners [^614^] |
| Productivity app benchmark | Productivity apps have 8.4% D30 retention baseline; social features can push this to 10-11%+ [^492^] |
| Social gaming study | Players in guilds are nearly TWICE as likely to continue beyond first month [^606^] |
| Habitica research | Tyler Renelle (creator) states "social accountability is essential" for habit building [^465^] |

### 12.2 ARISE Retention Strategy

Based on this data, ARISE's social system targets:

- **D7 Retention**: Guild formation prompt at Day 3 (after habit system understood). Guild members see each other's daily activity, creating a reason to return.
- **D30 Retention**: Weekly raids create 7-day rhythm. Guild tournament participation requires sustained engagement. Target: 10%+ D30 (above 8.4% productivity baseline).
- **Long-term**: Shadow grade progression (7-day → 365-day) creates multi-month arc. World Boss events create monthly return triggers.

### 12.3 Why Guilds > Friends for Retention

The SSRN study [^612^] found that guild systems produce stronger retention than friend systems because:

- **Social pressure to return**: Guild members notice absence
- **Social inventiveness**: Guild activities create emergent gameplay
- **Structured commitment**: Guild raids create specific return triggers
- **Collective identity**: "We are Ahjin Guild" is stronger than "I have a friend who uses ARISE"

ARISE uses guilds as the primary social unit (not friend lists) specifically for this reason.

---

## 13. Summary: The ARISE Social Philosophy

The ARISE social system exists at the intersection of three research-backed principles:

1. **Self-Determination Theory**: Social features satisfy the need for *Relatedness* (guild membership, accountability partners) without undermining *Autonomy* (opt-out everywhere, no forced participation) or *Competence* (shadow progression, skill-based matching). [^54^] [^620^]

2. **Cooperative Competition**: All competition is structured as guilds cooperating internally to achieve external goals — the format research shows produces highest motivation and lowest toxicity. [^470^] [^464^]

3. **Privacy by Design**: No public profiles, no personal data sharing, no content visibility. Social accountability comes from commitment visibility (did you complete your habits?), not self-disclosure (what were your habits?). [^529^] [^530^]

The result is a social system that genuinely motivates — through the 3x goal-achievement boost of accountability [^471^] — without the surveillance, comparison anxiety, or toxicity that plague most social productivity apps.

---

## Citations

[^54^] Self-Determination Theory: All 6 Mini-Theories - Yu-kai Chou, yukaichou.com
[^60^] Retention Rates for Mobile Apps by Industry - Plotline, plotline.so
[^62^] Shadows | Solo Leveling Wiki - Fandom
[^165^] 6 Best Accountability Apps in 2026 (Real People, Tested) - Habi, habi.app
[^277^] Solo Leveling Ranking System - Reddit r/sololeveling
[^329^] How impact improves game retention in D1, D7, D30 - Dots.eco
[^375^] Gamification and Self-Determination Theory - Sam Kenyon, Medium
[^433^] Gamification Benchmarks 2026 - Xtremepush
[^463^] Habitica: Gamified Taskmanager - MWM AI
[^464^] The Effects of Cooperation and Competition on Motivation - Tauer & Harackiewicz (2004)
[^465^] Habitica Design Challenge: An Octalysis Review - Yu-kai Chou
[^466^] Habitica - Warrior, Healer, Rogue or Magician? - Moritz Wachter
[^467^] Transforming Productivity with Open Source Gamification - dev.to
[^468^] Habitica productivity blog - WordPress
[^469^] Cooperation and Competition Help Student Learning - TILT
[^470^] Cooperation vs. Competition: Not an Either/Or Proposition - Psychology Today
[^471^] What is stickK? - stickK Help Center
[^472^] Habitica: a role-playing game for self improvement - LWN
[^483^] Guild Challenge - Wowpedia
[^485^] Level Up: Tackling Toxicity in Online Gaming Communities - iCanHelp
[^486^] Solo Leveling: Shadows, Explained - GameRant
[^488^] Mobile App Growth Strategy: Data-Driven Guide - Enable3
[^489^] How we can tackle toxicity to create more inclusive gaming - WEF
[^490^] Habitica (gamification blog) - WordPress
[^491^] Combatting Toxicity: Designing an Intelligent System - OCADU Thesis
[^492^] User Retention Strategies in Mobile App Development - Upscalix
[^493^] All Shadow Ranks in Jin Woo's Army Explained - YouTube
[^494^] Toxic Positivity (and How to Avoid It) in Games - Digital Thriving Playbook
[^521^] How to Launch a Mobile App Referral Program - Adapty
[^522^] UX Insights: Referral Program Best Practices - Branch.io
[^523^] Designing a Referral System - Medium
[^524^] Developing a reward system in applications - 2Grand
[^525^] Referral Program Best Practices - Genius Referrals
[^527^] How to design a referral program - Andrew Chen
[^528^] 5 Rules for Designing Your App to Get More Referrals - Telerik
[^529^] Architecting Privacy By Design - IEEE Digital Privacy
[^530^] Privacy by Design: Building Data Protection from the Ground Up - ComplyDog
[^531^] Consumer controls over platforms' data collection - UK Government
[^532^] Privacy-Centric Social Media Controls - TrendHunter
[^533^] Guidelines on Deceptive design patterns in social media - EDPB
[^590^] How A Body Double Can Help You Stay Productive - Focusmate
[^591^] Body doubling: The productivity hack you didn't know you needed - Happiful
[^592^] Body Doubling with Focusmate - Thinking Organized
[^593^] The ADHD Body Double - ADD.org
[^594^] Focusmate homepage - focusmate.com
[^602^] Introducing AnonyPost - DEV Community
[^603^] 10 Best Anonymous Messaging Apps in USA - 75way
[^604^] Best Anonymous Messaging App Options in 2025 - Cape
[^605^] How to Develop an Anonymous Social Network - Eastern Peak
[^606^] Strategies for Engagement and Retention in Live Service Games - IJSET
[^607^] How to Develop an Anonymous Social Media App - Clockwise
[^608^] The code of sustainable success in fitness apps - PMC
[^609^] Run together: exploring the relationship between motivation and social features - METU
[^610^] Anonymous Social Networking App Development - Kate Abrosimova, Medium
[^611^] Increase long-term retention by adding social features - DIVA Portal
[^612^] Impacts of Two Social Systems on User Retention - SSRN
[^613^] What Is Skill-Based Matchmaking (SBMM)? - PubNub
[^614^] User segmentation for retention management in online social games - ScienceDirect
[^615^] Motivations for engaging with social features in online multiplayer games - LUT Thesis
[^616^] Players Blame Skill-Based Matchmaking for Losing in Call of Duty - Hacker News
[^617^] Deprioritizing skill-based matchmaking turned Call of Duty into The Bad Place - GameDeveloper
[^618^] Match experiences affect interest: Impacts of matchmaking and performance on churn - PMC
[^619^] We Need to Talk About Skill Based Matchmaking - frostilyte.ca
[^620^] Self-Determination Theory for Multiplayer Games - Digital Thriving Playbook
[^621^] A Self-Determination Theory Approach - Rochester University
[^622^] The Motivational Pull of Video Games - Ryan, Rigby & Przybylski (2006)
[^623^] Best 15 Workout Accountability Apps in 2024 - GoalsWon
