# SECTION 7.7: Screentime Monitoring System

## Blue Ocean Feature: Digital Discipline as Gameplay

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
| Visual | Holographic scan animation of device outline |

#### Layer 2: UsageStatsManager Data Collection

**Primary API:** `android.app.usage.UsageStatsManager`

**Key Methods:**

| Method | Parameters | Returns | Use Case |
|--------|-----------|---------|----------|
| `queryAndAggregateUsageStats(beginTime, endTime)` | Long (epoch ms) x2 | `Map<String, UsageStats>` | Daily totals per app; primary data source |
| `queryUsageStats(intervalType, beginTime, endTime)` | Int interval + Long x2 | `List<UsageStats>` | Day-by-day trends; interval = `INTERVAL_DAILY` |
| `queryEvents(beginTime, endTime)` | Long x2 | `UsageEvents` | Session-level detail; app open/close/move-to-foreground events |
| `isAppInactive(packageName)` | String | Boolean | Detect unused apps for cleanup quests |

**UsageStats Object Fields (per app):**

| Field | Type | Description |
|-------|------|-------------|
| `getPackageName()` | String | App package identifier (e.g., `com.instagram.android`) |
| `getTotalTimeInForeground()` | Long | Total milliseconds app was in foreground |
| `getLastTimeUsed()` | Long | Epoch timestamp of last foreground entry |
| `getFirstTimeStamp()` | Long | Start of the queried interval |
| `getLastTimeStamp()` | Long | End of the queried interval |
| `getAppLaunchCount()` | Integer (API 35+) | Number of times app was launched |

**Collection Schedule:**

| Trigger | Frequency | Data Collected |
|---------|-----------|---------------|
| WorkManager periodic work | Every 15 minutes | `queryAndAggregateUsageStats` for current day; incremental update |
| SCREEN_ON broadcast | Real-time (event-driven) | Trigger immediate collection; refresh current session data |
| SCREEN_OFF broadcast | Real-time (event-driven) | Capture final session data for app that was in foreground |
| Midnight (00:00 local) | Daily | Full day aggregation; generate daily summary; reset counters |
| User opens Screentime Dashboard | On-demand | Full recalculation from `UsageStatsManager` |

**Collection Constraints (WorkManager):**
```kotlin
val constraints = Constraints.Builder()
    .setRequiresBatteryNotLow(true)
    .setRequiresDeviceIdle(false)  // Can run while device is in use
    .build()

val screentimeWork = PeriodicWorkRequestBuilder<ScreentimeCollectionWorker>(
    15, TimeUnit.MINUTES
).setConstraints(constraints)
 .addTag("screentime_collection")
 .build()
```

#### Layer 3: Real-Time Screen State Tracking

A `ForegroundService` maintains an independent screen-on timer that serves as both a backup validation source for UsageStatsManager data and the real-time countdown mechanism for screentime quests.

**ScreenStateReceiver:**
```kotlin
class ScreenStateReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        when (intent.action) {
            Intent.ACTION_SCREEN_ON -> {
                screenOnTime = System.currentTimeMillis()
                isScreenOn = true
                // Notify Flutter layer
                methodChannel.invokeMethod("screenStateChanged", 
                    mapOf("state" to "ON", "timestamp" to screenOnTime))
            }
            Intent.ACTION_SCREEN_OFF -> {
                val sessionDuration = System.currentTimeMillis() - screenOnTime
                totalScreenOnTimeToday += sessionDuration
                isScreenOn = false
                // Trigger final collection
                ScreentimeCollector.captureFinalSession()
            }
        }
    }
}
```

**Foreground Service Configuration:**

| Attribute | Value |
|-----------|-------|
| Service Type | `dataSync` (Android 10+) / `specialUse` (fallback) |
| Notification | Low-priority persistent: "System Monitoring Active" |
| Notification Channel | `screentime_monitor` — IMPORTANCE_LOW |
| Icon | Small holographic eye icon (SEN stat symbol) |
| Wake Lock | No wake lock held; only counts state changes |
| Battery Impact | Negligible — only processes broadcasts, no polling |

**Persistent Notification Copy:**
> "[SYSTEM] Digital environment monitoring active. Screentime data being collected for quest calibration."

#### Layer 4: App Categorization Engine

Apps are categorized into behavioral groups to enable category-level quests, limits, and analytics. The engine uses a three-tier classification system.

**Tier 1: Heuristic Mapping (Package Name Database)**

| Category | Examples | Valence |
|----------|----------|---------|
| **Social** | Instagram, TikTok, X/Twitter, Snapchat, Facebook, Threads, Reddit | Context-dependent |
| **Entertainment** | YouTube, Netflix, Twitch, Disney+, Spotify (video), mobile games | Negative if excessive |
| **Productivity** | Notion, Calendar, Gmail, Outlook, Todoist, Obsidian | Positive |
| **Communication** | WhatsApp, Messages, Telegram, Slack, Discord, Signal | Neutral |
| **Education** | Duolingo, Khan Academy, Coursera, Brilliant, Anki | Positive |
| **Fitness** | Lyfta, Strava, MyFitnessPal, Samsung Health, Fitbit | Positive |
| **Finance** | Banking apps, Robinhood, Coinbase, YNAB | Neutral |
| **Shopping** | Amazon, Temu, eBay, Shopify | Context-dependent |
| **News** | NYT, BBC, Google News, Apple News | Neutral |
| **ARISE** | ARISE itself | Excluded from all limits |
| **System** | Launcher, Settings, System UI, Phone, Clock | Excluded from all limits |

**Tier 2: On-Device ML Classification**

A lightweight TensorFlow Lite model (quantized, <500KB) learns the user's app usage patterns over time and refines categorizations:

| Feature | Source | Model Input |
|---------|--------|-------------|
| Usage time-of-day patterns | UsageStatsManager | 24-hour bucket vector |
| Session duration distribution | UsageStatsManager | Mean, median, std dev of session length |
| App open frequency | UsageStatsManager + queryEvents | Opens per day |
| Co-usage patterns | queryEvents | Which apps are opened in sequence |
| User override history | Local database | Previous user recategorizations |

**Model Behavior:**
- Initially assigns apps based on Tier 1 heuristics
- After 7 days of usage data: begins suggesting recategorizations with confidence scores
- After 30 days: fully personalized category map
- Suggestions presented to user for approval (autonomy preservation per Self-Determination Theory)

**Tier 3: User Override**

| Feature | Description |
|---------|-------------|
| Any app can be recategorized | User taps app → selects new category → immediate effect |
| Override persists | Stored in local database; survives app updates |
| Override takes precedence | Overrides both heuristic and ML classifications |
| Bulk recategorization | User can set rules (e.g., "all games → Entertainment") |

#### Layer 5: Gamification Bridge

The Gamification Bridge connects raw screentime data to ARISE's core systems: quests, stats, notifications, penalties, and analytics. It runs a continuous evaluation loop:

```
[New Screentime Data Available]
    → Update local database (AppUsageSession, DailyScreentimeSummary)
    → Evaluate active screentime quest conditions
    → Check app limits (per-app, per-category, daily total)
    → Calculate SEN impact (earn or decay)
    → Trigger notifications if thresholds breached
    → Update dashboard (if visible)
    → Schedule next evaluation
```

---

### 7.7.3 Screentime Quests

Screentime quests are a unique quest category powered by Android's UsageStatsManager. They auto-complete when the system detects the user has stayed within their self-defined limits. These quests are categorized under the Digital Wellness domain and primarily reward SEN (Sense) points. Unlike manually-completed quests, screentime quests are verified automatically by the monitoring system — the Player cannot falsely claim completion.

**Quest Type Catalog (10 Types):**

| Quest Type | Description | Example | Reward |
|-----------|-------------|---------|--------|
| **Daily Screentime Limit** | Stay under total daily screen time | "Keep total screentime under 5 hours today" | +100 XP, +2 SEN |
| **App Category Limit** | Stay under time for a category | "Social media: maximum 45 minutes today" | +80 XP, +2 SEN |
| **App-Specific Limit** | Stay under time for one app | "Instagram: maximum 15 minutes today" | +60 XP, +1 SEN |
| **Focus Session** | Complete a distraction-free session | "2-hour focus: no social or entertainment apps" | +150 XP, +3 SEN, +2 INT |
| **Morning Protocol** | No phone for first X minutes after wake | "No screen time before 8:00 AM" | +120 XP, +3 SEN |
| **Evening Protocol** | No phone after X time | "No entertainment apps after 10:00 PM" | +100 XP, +2 SEN, +2 VIT |
| **Digital Sabbath** | Zero recreational screen time for a full day | "One full day: no social, entertainment, or games" | +500 XP, +10 SEN, Title: "Digital Monk" |
| **App Lockout** | Voluntarily lock an app for a period | "Lock Instagram for 24 hours" | +50 XP per locked app, +1 SEN |
| **Unlock Count** | Stay under unlock limit | "Unlock your phone fewer than 30 times today" | +100 XP, +2 SEN |
| **Pickup Count** | Stay under pickup limit | "Pick up your phone fewer than 40 times today" | +80 XP, +2 SEN |

**Auto-Completion Logic:**

| Quest Type | Completion Condition | Verification Source |
|-----------|---------------------|-------------------|
| Daily Screentime Limit | `totalScreenTimeMs <= limit` | `DailyScreentimeSummary.totalScreenTimeMs` |
| App Category Limit | `sum(category apps) <= limit` | Aggregated from `UsageStatsManager` per app |
| App-Specific Limit | `app.totalTimeInForeground <= limit` | `UsageStatsManager.getTotalTimeInForeground()` |
| Focus Session | Zero social/entertainment app opens during window | `queryEvents()` — no `MOVE_TO_FOREGROUND` for blocked categories |
| Morning Protocol | No screen-on events before protocol time | `ScreenStateReceiver` — `ACTION_SCREEN_ON` timestamp > protocol time |
| Evening Protocol | No entertainment app opens after protocol time | `queryEvents()` — no entertainment `MOVE_TO_FOREGROUND` after protocol time |
| Digital Sabbath | Zero social/entertainment/games for 24h | Aggregated category time = 0 for full calendar day |
| App Lockout | App not opened during lock period | `UsageStatsManager` — no foreground time for locked app |
| Unlock Count | `unlockCount <= limit` | `KeyguardManager` dismiss events or `ACTION_USER_PRESENT` |
| Pickup Count | `pickupCount <= limit` | Accelerometer + proximity sensor (on-device, no cloud) |

**Quest Availability by Rank:**

| Rank | Available Quest Types |
|------|----------------------|
| E | Daily Screentime Limit only (suggested limit: 6h) |
| D | + App Category Limit, Unlock Count |
| C | + App-Specific Limit, Focus Session |
| B | + Morning Protocol, Evening Protocol, Pickup Count |
| A | + App Lockout (self-scheduled) |
| S | + Digital Sabbath, all premium features |

---

### 7.7.4 The SEN (Sense) Stat Connection

Screentime monitoring is the primary gameplay mechanism for the **SEN (Sense)** stat. Digital discipline IS mindfulness — the awareness to observe one's own attention and the will to direct it intentionally.

**SEN Point Flow:**

| Action | SEN Impact | Notes |
|--------|-----------|-------|
| Complete any screentime quest | +1 to +10 SEN | Scales with quest difficulty |
| Maintain daily screentime limit 7 days | +5 SEN bonus | Weekly consistency reward |
| Maintain daily screentime limit 30 days | +15 SEN bonus | Monthly consistency reward |
| Exceed daily limit by <25% | No SEN change | Grace margin |
| Exceed daily limit by 25–100% for 1 day | -1 SEN | Single-day lapse |
| Exceed daily limit by 25–100% for 3+ consecutive days | -2 SEN/day | "Digital Gluttony" debuff active |
| Exceed daily limit by >100% (2x limit) | -3 SEN + debuff | Immediate penalty |
| Override an app lock | -10 SEN | Voluntary penalty for bypassing self-imposed limit |
| Complete Digital Sabbath quest | +10 SEN | Largest single SEN reward |

**SEN Unlock Thresholds (Screentime Features):**

| SEN Level | Unlock | Description |
|-----------|--------|-------------|
| SEN 15 | Basic screentime analytics | Daily/weekly reports visible in dashboard |
| SEN 20 | App lock capability | Can set per-app time limits with lock overlay |
| SEN 25 | Focus mode | Can initiate system-wide focus sessions that block categories |
| SEN 35 | Custom categories | Create personal app categories beyond defaults |
| SEN 45 | Scheduled app locks | Set recurring locks (e.g., Instagram 10 PM – 8 AM daily) |
| SEN 60 | Advanced analytics | Correlation insights: "Your sleep quality drops 23% when social media exceeds 1h" |

**"Digital Gluttony" Debuff:**

Triggered when daily screentime exceeds 2x the self-defined limit for 3+ consecutive days.

| Effect | Value | Duration |
|--------|-------|----------|
| SEN decay | -2 SEN/day | Until screentime returns below limit |
| Quest XP multiplier | 0.8x | All quests grant 20% less XP |
| Focus session disabled | Cannot start | Until debuff cleared |
| Visual | SEN stat icon pulses red | Duration of debuff |
| Cure | Reduce screentime below limit for 1 full day | Immediate clearance |

**"Digital Monk" Title:**

| Attribute | Value |
|-----------|-------|
| Unlock Condition | Complete 10 Digital Sabbath quests |
| Rarity | Rare |
| Buff Effect | Immune to "Digital Gluttony" debuff; -50% SEN penalty from screentime overages; +5% SEN from all screentime quests |
| Visual | Golden aura around SEN stat in status window |

---

### 7.7.5 Notification & Intervention System

When screentime limits are approached or exceeded, the System intervenes through an escalating notification matrix integrated with ARISE's existing alarm architecture (Section 6). All screentime notifications use the same escalation framework: calm → firm → urgent → nuclear.

**Escalation Matrix:**

| Trigger | Notification Style | System Message | Tone Tier |
|---------|-------------------|----------------|-----------|
| 75% of daily limit reached | Gentle System message (in-app + low-priority push) | "Your daily screen allocation is at 75%. 1 hour 15 minutes remains. The System observes. The choice is yours." | Calm |
| 90% of daily limit reached | Heads-up notification + soft alert sound | "[WARNING] You are approaching your daily limit. 15 minutes remain. Consider disengaging." | Firm |
| 100% of daily limit reached | Full-screen takeover | "[SYSTEM ALERT] Your daily screen allocation has been exhausted. The System recommends disengaging. Continued usage will activate Penalty Protocol." | Urgent |
| Focus session broken (opened blocked app) | Immediate notification | "Your Focus Session has been disrupted. The System has noted this. Your INT stat will not receive today's bonus. Your attention is your own — but the System records all." | Firm |
| Morning protocol violated | Immediate notification | "The Morning Protocol has been breached at 07:23. 37 minutes early. Today's SEN bonus is reduced. The path of discipline requires patience." | Firm |
| Evening protocol approaching (15 min warning) | Heads-up notification | "Evening Protocol activates in 15 minutes. Complete your entertainment now or forego it. The night belongs to rest." | Calm |
| Evening protocol violated | Immediate notification | "The Evening Protocol has been breached at 22:47. Sleep quality will be impacted. Tomorrow's VIT regeneration may be reduced." | Firm |
| App limit reached | Full-screen app lock overlay | "[APP LOCK] Instagram's daily allocation: EXHAUSTED. This gate is sealed until midnight." | Urgent |
| Digital Sabbath violated | Immediate notification | "The Digital Sabbath has been broken. The quest is marked failed. However — the System does not judge. The next Sabbath awaits." | Firm |

**App Lock Overlay Mechanism:**

When an app-specific or category limit is reached, ARISE displays a full-screen overlay over the locked app:

| Element | Specification |
|---------|--------------|
| **Background** | Semi-transparent black overlay (`#000000` at 85% opacity) |
| **Container** | Centered, 80% width, holographic cyan border with outer glow |
| **Header** | `[APP LOCK]` in bracketed cyan text, Share Tech Mono font |
| **App Name** | Target app name in white, Inter font, 20sp |
| **Status** | "Daily allocation: EXHAUSTED" in Alert Red `#FF1744` |
| **Countdown** | "Gate reopens in: HH:MM:SS" (time until midnight) in JetBrains Mono |
| **Override Button** | Present but guarded — see Override Protocol below |
| **Dismiss Button** | "Return to Launcher" — exits to home screen |
| **Animation** | PanelMaterialize (250ms scale + opacity + border-glow pulse) |
| **Sound** | Harsh descending tone (D5→A3) — same as penalty tier |

**Override Protocol (Friction Design):**

The System allows overrides — autonomy is preserved — but imposes meaningful friction:

| Step | Action | Time | Purpose |
|------|--------|------|---------|
| 1 | Tap "Override Lock" | Instant | Explicit intent |
| 2 | 30-second countdown begins | 30 seconds | Cooling-off period; cannot be skipped |
| 3 | During countdown: "Are you certain?" pulses | 30 seconds | Moment of reflection |
| 4 | Countdown reaches 0 → "Confirm Override" activates | Instant | Second confirmation required |
| 5 | Override costs applied immediately | Instant | Consequence |

**Override Costs:**

| Cost Type | Amount | Applied |
|-----------|--------|---------|
| SEN penalty | -10 SEN | Immediately |
| XP penalty | -50 XP | Immediately |
| Quest status | Marked FAILED | Associated screentime quest |
| Override counter | +1 | Tracked in `AppLimit.overrideCount` |
| Daily override cap | Max 3 per day | Further overrides blocked until midnight |

**Premium Feature — Scheduled App Locks:**

Silver/Gold subscribers can set recurring app locks without consuming override charges:

| Schedule Type | Example | Override Cost |
|--------------|---------|---------------|
| Daily recurring | "Lock Instagram every day 10:00 PM – 8:00 AM" | Free (subscription benefit) |
| Weekday only | "Lock games Monday–Friday until 6:00 PM" | Free |
| Weekend Digital Sabbath | "Lock all entertainment Saturday 00:00 – Sunday 00:00" | Free |
| One-time emergency lock | "Lock TikTok for 48 hours starting now" | Free |

---

### 7.7.6 Dashboard & Analytics

The Screentime Dashboard provides the Player with comprehensive awareness of their digital consumption patterns, rendered in ARISE's holographic cyan UI aesthetic.

**Daily Screentime Report (auto-generated at midnight):**

| Metric | Display | Comparison |
|--------|---------|------------|
| Total screen time | Large counter (HH:MM) with day-over-day delta arrow | vs. yesterday, vs. 7-day average |
| Category breakdown | Segmented holographic ring (pie chart) | Green (under limit), yellow (75%), red (exceeded) |
| Top 5 apps by time | Ranked list with app icon, name, time, % of total | vs. yesterday |
| Unlock count | Numeric with trend arrow | vs. 7-day average |
| Pickup count | Numeric with trend arrow | vs. 7-day average |
| Average session length | MM:SS | vs. 7-day average |
| Quest completion | Which screentime quests completed/failed today | Status badges |
| SEN impact | Net SEN change from today's screentime behavior | + or - with magnitude |

**Weekly Screentime Report (generated Sunday at midnight):**

| Metric | Display |
|--------|---------|
| 7-day trend line | Line chart: total daily screentime across 7 days |
| Best day / worst day | Day name + time; highlighted in green/red |
| Improvement vs. previous week | Percentage change; up arrow = good (less screentime) |
| Category trend | Stacked bar chart: category breakdown per day |
| SEN summary | Net SEN earned/lost from screentime this week |
| Weekly quest completion | X/7 screentime quests completed |
| Personalized insight | ML-generated observation: "Your Tuesday screentime is 34% above average. Consider setting an App Lock for Instagram on Tuesdays." |

**Visual Design Specifications:**

| Element | Design |
|---------|--------|
| Primary chart | Holographic ring/arc chart with color-coded segments |
| Under limit | Success Green `#00E676` glow |
| Approaching limit (75–99%) | Shadow Gold `#FFB300` pulse |
| Limit exceeded | Alert Red `#FF3D00` with WarningPulse animation |
| Trend lines | Aether Blue `#4FC3F7` with gradient fill |
| Transitions | 400ms crossfade between day/week/month views |
| Background | Deep Abyss `#0B1426` with subtle DataStream animation |

---

### 7.7.7 Privacy & Data Handling

Screentime data is among the most sensitive personal data ARISE handles. The architecture is privacy-first by design.

**Data Handling Principles:**

| Principle | Implementation |
|-----------|---------------|
| **All data on-device** | Every byte of screentime data stored in local SQLite/Drift database only |
| **Never sent to backend** | Zero screentime data in API calls, sync payloads, or analytics telemetry |
| **No cloud sync** | Screentime data does not sync across devices; local only |
| **User purge capability** | One-tap purge: Settings → Privacy → "Delete All Screentime Data" → immediate deletion |
| **Auto-purge option** | User can set automatic deletion after 30/60/90 days |
| **GDPR compliance** | Screentime data classified as personal data under GDPR Article 9; explicit consent required separate from general T&Cs |
| **ML is local-only** | App categorization ML model runs entirely on-device; no server calls for classification |
| **No third-party sharing** | Screentime data never shared with analytics providers, ad networks, or any external service |

**Data Storage Scope:**

| Data Type | Storage Location | Synced to Backend | Retention |
|-----------|-----------------|-------------------|-----------|
| Raw UsageStats data | Local only (ephemeral, processed then discarded) | No | 24 hours (rolling window) |
| AppUsageSession records | Local SQLite (Drift) | No | User-configured (default 90 days) |
| DailyScreentimeSummary | Local SQLite (Drift) | No | User-configured (default 90 days) |
| App categorization map | Local SQLite (Drift) | No | Persistent |
| App limits & rules | Local SQLite (Drift) | No | Persistent |
| Quest completion status | Local SQLite + Backend (quest metadata only) | Yes (quest type + completion boolean only) | Persistent |
| SEN stat changes | Backend (stat values only, no source data) | Yes | Persistent |

**Consent Flow:**

Screentime monitoring requires a separate explicit consent flow, distinct from general terms:

```
[First Screentime Feature Access]
    → Dedicated consent screen explaining what data is collected
    → Granular toggles: (1) Total screentime, (2) Per-app data, (3) App categorization
    → Summary review → Confirm
    → Consent record stored locally with timestamp, version, scope
    → Can be withdrawn anytime → immediate data deletion + feature lock
```

---

### 7.7.8 Technical Implementation (Flutter + Android)

#### Native Kotlin Service Architecture

```
ScreentimeMonitorService (ForegroundService)
├── ScreenStateReceiver (BroadcastReceiver)
│   ├── ACTION_SCREEN_ON → record screenOnTime, notify Flutter
│   └── ACTION_SCREEN_OFF → calculate session duration, trigger collection
├── UsageStatsCollector (singleton)
│   ├── queryDailyTotals() → UsageStatsManager.queryAndAggregateUsageStats()
│   ├── queryAppEvents() → UsageStatsManager.queryEvents()
│   ├── queryTrendData() → UsageStatsManager.queryUsageStats(INTERVAL_DAILY)
│   └── computeUnlockCount() → KeyguardManager / ACTION_USER_PRESENT
├── AppCategorizationEngine
│   ├── HeuristicClassifier (package name → category lookup)
│   ├── MLCategorizer (TensorFlow Lite on-device model)
│   └── UserOverrideManager (local override storage)
├── LimitEnforcer
│   ├── evaluateAppLimits() → check per-app/category/daily limits
│   ├── triggerNotification() → invoke flutter_local_notifications
│   └── showAppLockOverlay() → SYSTEM_ALERT_WINDOW overlay
└── ScreentimeDataStore (Drift/SQLite local database)
    ├── app_usage_session table
    ├── daily_screentime_summary table
    ├── app_limit table
    └── app_category_mapping table
```

**Flutter Integration — MethodChannel:**

Channel name: `screentime`

| Method | Direction | Parameters | Returns | Description |
|--------|-----------|------------|---------|-------------|
| `requestPermission()` | Flutter → Native | — | `boolean` (granted) | Check/request PACKAGE_USAGE_STATS |
| `isPermissionGranted()` | Flutter → Native | — | `boolean` | Check current permission status |
| `getDailyStats()` | Flutter → Native | `date` (String, ISO-8601) | `DailyScreentimeSummary` JSON | Full day stats |
| `getAppBreakdown()` | Flutter → Native | `date`, `category?` | `List<AppUsage>` JSON | Per-app time breakdown |
| `getCurrentSession()` | Flutter → Native | — | `AppUsageSession?` JSON | Currently active app session |
| `setAppLimit()` | Flutter → Native | `AppLimit` JSON | `boolean` (success) | Create/update app limit |
| `removeAppLimit()` | Flutter → Native | `packageName` | `boolean` (success) | Delete app limit |
| `lockApp()` | Flutter → Native | `packageName`, `durationMs?` | `boolean` | Immediate app lock |
| `unlockApp()` | Flutter → Native | `packageName` | `boolean` | Remove app lock |
| `isMonitoringActive()` | Flutter → Native | — | `boolean` | Service running status |
| `startMonitoring()` | Flutter → Native | — | `boolean` | Start foreground service |
| `stopMonitoring()` | Flutter → Native | — | `boolean` | Stop foreground service |
| `purgeAllData()` | Flutter → Native | — | `boolean` | Delete all local screentime data |

**Flutter Integration — EventChannel:**

Channel name: `screentime_events`

| Event | Payload | Description |
|-------|---------|-------------|
| `screenTurnedOn` | `{timestamp}` | Screen turned on |
| `screenTurnedOff` | `{timestamp, sessionDurationMs}` | Screen turned off |
| `appLimitApproaching` | `{packageName, appName, currentMs, limitMs, percentUsed}` | App at 75% of limit |
| `appLimitReached` | `{packageName, appName, limitMs}` | App limit exceeded |
| `dailyLimitApproaching` | `{currentMs, limitMs, percentUsed}` | Daily total at 75% |
| `dailyLimitReached` | `{currentMs, limitMs}` | Daily limit exceeded |
| `focusSessionBroken` | `{packageName, appName, focusSessionId}` | Blocked app opened during focus |
| `morningProtocolViolated` | `{violationTime, protocolTime}` | Screen on before protocol time |
| `eveningProtocolViolated` | `{violationTime, protocolTime}` | Blocked app opened after protocol time |
| `appLockTriggered` | `{packageName, appName, unlocksAt}` | App lock overlay shown |
| `screentimeQuestCompleted` | `{questId, questType}` | Auto-completed screentime quest |
| `senChanged` | `{newSen, delta, reason}` | SEN stat modified by screentime behavior |

**WorkManager Schedule:**

```kotlin
// Periodic collection work — every 15 minutes
val periodicWork = PeriodicWorkRequestBuilder<ScreentimeCollectionWorker>(
    15, TimeUnit.MINUTES
).setConstraints(
    Constraints.Builder()
        .setRequiresBatteryNotLow(true)
        .build()
).setBackoffCriteria(
    BackoffPolicy.EXPONENTIAL,
    10, TimeUnit.MINUTES
).addTag("screentime_periodic")
 .build()

WorkManager.getInstance(context).enqueueUniquePeriodicWork(
    "screentime_collection",
    ExistingPeriodicWorkPolicy.KEEP,
    periodicWork
)

// One-time work triggered on SCREEN_OFF — captures final session
val screenOffWork = OneTimeWorkRequestBuilder<ScreentimeFinalSessionWorker>()
    .addTag("screentime_screen_off")
    .build()
// Enqueued by ScreenStateReceiver on ACTION_SCREEN_OFF
```

---

### 7.7.9 Integration with Existing Systems

#### Quest System Integration (Section 5)

Screentime quests appear alongside regular daily quests in the quest panel. They are visually distinguished by a unique icon (eye symbol for SEN/digital awareness) and are auto-completed by the monitoring system — the Player does not manually mark them complete.

| Integration Point | Behavior |
|------------------|----------|
| Quest generation | Screentime quests generated at 6:00 AM alongside daily quests; max 2 screentime quests per day |
| Quest display | Eye icon (SEN symbol) + "[DIGITAL]" prefix in quest list |
| Auto-complete | System evaluates conditions at midnight; if met, quest auto-completes with full reward |
| Manual complete | Not available — screentime quests require verified data |
| Quest rejection | Can be rejected like other quests (up to 2 rejections per day) |
| Failure state | If conditions not met at midnight → marked FAILED → triggers standard quest failure flow |

#### Penalty System Integration (Section 8)

| Integration Point | Behavior |
|------------------|----------|
| Quest failure | Failed screentime quests trigger the same penalty tiers as other quests (Minor/Moderate/Major) |
| Digital Gluttony debuff | Excessive screentime (2x limit for 3+ days) triggers unique debuff (Section 7.7.4) |
| Recovery quests | Failed screentime quests generate standard Redemption Quests |
| Penalty Zone | Digital Gluttony does NOT trigger Penalty Zone directly; it is a separate debuff system |
| Grace Days | Screentime quests can be skipped with Grace Days (1 per week) |

#### Notification System Integration (Section 6)

| Integration Point | Behavior |
|------------------|----------|
| Escalation matrix | Screentime notifications use same 4-tier escalation (calm → firm → urgent → nuclear) |
| Full-screen takeovers | App lock overlays use same `FullScreenIntent` + alarm architecture as quest deadlines |
| Sound profiles | Same sound tier mapping: soft chime → two-tone → descending tone → continuous alarm |
| Vibration | Same vibration patterns per escalation tier |
| DND bypass | App lock and limit-exceeded notifications bypass do-not-disturb (same as critical quest alerts) |
| OEM workarounds | Same battery exemption guidance and `setAlarmClock()` reliability strategy |

#### Stats Integration (Section 3)

| Stat | Screentime Impact |
|------|-------------------|
| **SEN (primary)** | All screentime quest completions → +SEN; failures/excess → -SEN |
| **INT (secondary)** | Focus session completions → +INT; focus session breaks → no INT bonus |
| **VIT (tertiary)** | Evening protocol completions → +VIT (via sleep quality association) |
| **STR** | No direct impact |
| **AGI** | No direct impact |

**Derived Stats Impact:**

| Derived Stat | Impact |
|-------------|--------|
| Focus (`(INT + SEN) / 2`) | Improved by focus session quests |
| Energy (`(VIT + AGI) / 2 x 10`) | Indirectly improved by evening protocol → better sleep |

#### Skill Tree Integration (Section 3.8)

| Skill | Branch | Unlock | Effect |
|-------|--------|--------|--------|
| "Digital Willpower" | Empath (SEN) | SEN 25 | +20% SEN from all screentime quests |
| "Focus Mind" | Sage (INT) | INT 30 | Focus sessions grant +1 additional INT |
| "Early Riser" | Fortress (VIT) | VIT 20 | Morning protocol violation grace: first 10 minutes free |
| "Digital Discipline" | Empath (SEN) | SEN 40 | App lock override cost reduced from -10 SEN to -5 SEN |

---

## SECTION 5 UPDATE: Quest System — Screentime Quest Category

### 5.1.x Screentime Quest Category

Screentime quests are a unique quest category powered by Android's `UsageStatsManager`. They auto-complete when the system detects the user has stayed within their self-defined limits. These quests are categorized under the Digital Wellness domain and primarily reward SEN (Sense) points.

Unlike manually-completed quests, screentime quests are verified by objective device usage data — the Player cannot falsely claim completion. This creates a trust tier above even photo-verified quests: **Tier 0 (System Verified)**. System-verified quests grant full XP and are leaderboard-eligible.

**Quest Type Table:**

| Quest Type | Description | Example | Reward |
|-----------|-------------|---------|--------|
| **Daily Screentime Limit** | Stay under total daily screen time | "Keep total screentime under 5 hours today" | +100 XP, +2 SEN |
| **App Category Limit** | Stay under time for a category | "Social media: maximum 45 minutes today" | +80 XP, +2 SEN |
| **App-Specific Limit** | Stay under time for one app | "Instagram: maximum 15 minutes today" | +60 XP, +1 SEN |
| **Focus Session** | Complete a distraction-free session | "2-hour focus: no social or entertainment apps" | +150 XP, +3 SEN, +2 INT |
| **Morning Protocol** | No phone for first X minutes after wake | "No screen time before 8:00 AM" | +120 XP, +3 SEN |
| **Evening Protocol** | No entertainment apps after X time | "No entertainment apps after 10:00 PM" | +100 XP, +2 SEN, +2 VIT |
| **Digital Sabbath** | Zero recreational screen time for a full day | "One full day: no social, entertainment, or games" | +500 XP, +10 SEN, Title: "Digital Monk" |
| **App Lockout** | Voluntarily lock an app for a period | "Lock Instagram for 24 hours" | +50 XP per locked app, +1 SEN |
| **Unlock Count** | Stay under unlock limit | "Unlock your phone fewer than 30 times today" | +100 XP, +2 SEN |
| **Pickup Count** | Stay under pickup limit | "Pick up your phone fewer than 40 times today" | +80 XP, +2 SEN |

---

## SECTION 4 UPDATE: Goal Taxonomy — Digital Wellness Domain

### Domain #13: Digital Wellness

| # | Domain | Subcategories | Stats Affected | Framework | Metric Types |
|---|--------|--------------|----------------|-----------|-------------|
| 13 | **Digital Wellness** | Screentime reduction, App limits, Focus sessions, Morning/evening protocols, Digital sabbath, Notification hygiene, Social media boundaries | SEN (primary), INT (secondary), VIT (tertiary) | PACT (habit-based) + SMART (limit-based) | Time-based (UsageStatsManager), Count (unlocks/pickups), Boolean (protocol compliance) |

**Subcategory Detail:**

| Subcategory | Description | Primary Metric | Sample Quest |
|-------------|-------------|---------------|--------------|
| Screentime reduction | Reduce total daily device usage | Time (ms) | "Stay under 4h total today" |
| App limits | Restrict specific apps or categories | Time per app/category | "Instagram: max 20 minutes" |
| Focus sessions | Sustained distraction-free periods | Boolean + time | "2-hour focus: no social apps" |
| Morning protocols | Delay first phone use after waking | Boolean + timestamp | "No screen before 8:00 AM" |
| Evening protocols | Stop recreational use before bed | Boolean + timestamp | "No entertainment after 10:00 PM" |
| Digital sabbath | Full days without recreational screens | Boolean (full day) | "Zero recreational screens Sunday" |
| Notification hygiene | Reduce interruptions | Count (notifications received) | "Mute 5 non-essential app notifications" |
| Social media boundaries | Specific limits on social platforms | Time + open count | "Twitter: max 3 opens, 10 minutes" |

**Framework Application:**

| Subcategory | Primary Framework | Rationale |
|-------------|-------------------|-----------|
| Screentime reduction | SMART | Specific time target, measurable via UsageStatsManager |
| App limits | SMART | Specific app + specific time limit |
| Focus sessions | PACT | Process-based (sustained attention practice) |
| Morning/evening protocols | PACT | Habit-based daily practice |
| Digital sabbath | PACT | Process commitment (full day behavior) |
| Notification hygiene | SMART | Specific count targets |

---

## SECTION 12 UPDATE: Data Model — Screentime Entities

### 12.x Screentime Entities

**AppUsageSession:**

| Field | Type | Description |
|-------|------|-------------|
| `id` | UUID (PK) | Primary key |
| `package_name` | String | App package identifier (e.g., `com.instagram.android`) |
| `category` | Enum | Social, Entertainment, Productivity, Communication, Education, Fitness, Finance, Shopping, News, ARISE, System, Unknown |
| `start_time` | DateTime (epoch ms) | Session start timestamp |
| `end_time` | DateTime (epoch ms) | Session end timestamp |
| `duration_ms` | Integer | Total time in foreground for this session |
| `date` | Date (YYYY-MM-DD) | Bucket date for daily aggregation |
| `is_completed` | Boolean | Whether session was properly closed (screen off/app switch) vs. interrupted |

**DailyScreentimeSummary:**

| Field | Type | Description |
|-------|------|-------------|
| `date` | Date (PK) | Calendar date — one record per day |
| `total_screen_time_ms` | Integer | Total milliseconds screen was on |
| `total_unlock_count` | Integer | Number of times phone was unlocked |
| `total_pickup_count` | Integer | Number of times phone was picked up (accelerometer) |
| `average_session_length_ms` | Integer | Mean duration of app sessions |
| `longest_session_app` | String | Package name of app with longest single session |
| `longest_session_ms` | Integer | Duration of longest single session |
| `category_breakdown_json` | JSON | `{"Social": 3600000, "Entertainment": 1800000, ...}` |
| `top_apps_json` | JSON | `[{"package": "com.instagram.android", "time_ms": 2400000, "launch_count": 12}, ...]` |
| `protocol_compliance_json` | JSON | `{"morning_protocol": true, "evening_protocol": false, "digital_sabbath": null}` |
| `quest_completion_status_json` | JSON | Which screentime quests were completed today |
| `sen_earned` | Integer | Net SEN points earned today from screentime behavior |
| `gluttony_debuff_active` | Boolean | Whether Digital Gluttony debuff is active |
| `created_at` | DateTime | Record creation timestamp |
| `updated_at` | DateTime | Last update timestamp |

**AppLimit:**

| Field | Type | Description |
|-------|------|-------------|
| `id` | UUID (PK) | Primary key |
| `package_name` | String | Target app package (null for category-level limits) |
| `category` | Enum | Target category (null for app-specific limits) |
| `limit_type` | Enum | `DAILY_TOTAL`, `PER_APP`, `CATEGORY`, `FOCUS_BLOCK` |
| `daily_limit_ms` | Integer | Daily time limit in milliseconds |
| `active_days` | JSON | `[true, true, true, true, true, true, true]` — one boolean per day (Mon-Sun) |
| `is_active` | Boolean | Whether limit is currently enforced |
| `created_at` | DateTime | Creation timestamp |
| `updated_at` | DateTime | Last modification timestamp |

**AppCategoryMapping:**

| Field | Type | Description |
|-------|------|-------------|
| `package_name` | String (PK) | App package identifier |
| `heuristic_category` | Enum | Category from Tier 1 heuristic |
| `ml_category` | Enum | Category from Tier 2 ML model (nullable) |
| `ml_confidence` | Float | ML confidence score (0.0–1.0) |
| `user_override_category` | Enum | User-specified category (nullable) |
| `final_category` | Enum | Effective category (user_override > ml > heuristic) |
| `first_seen` | DateTime | When app was first detected on device |
| `last_updated` | DateTime | When categorization was last modified |

**Updated Entity Relationship Diagram:**

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
                    |———< DailyScreentimeSummary (N)  [NEW]
                    |———< AppLimit (N)                 [NEW]
                    |———> Guild (N) via Guild_Member
                    |———< Leaderboard_Entry (N)
                    |———< Accountability_Partner (N)

AppUsageSession (N) ————> DailyScreentimeSummary (N)  [aggregated into]
AppLimit (N) ———— enforces ————> AppCategoryMapping (N)  [references package/category]
```

---

## SECTION 15 UPDATE: Development Phases — Screentime Milestones

### Phase 1 Extension (Month 2–3): Basic Screentime Tracking

| Milestone | Deliverable | Success Criteria |
|-----------|------------|-----------------|
| MS1.1 | UsageStatsManager integration | `queryAndAggregateUsageStats()` functional; daily totals computed per app |
| MS1.2 | Permission flow | `PACKAGE_USAGE_STATS` permission requested diegetically; redirect to Settings functional |
| MS1.3 | Foreground service | `ScreentimeMonitorService` running with low-priority persistent notification |
| MS1.4 | Daily/weekly screentime reports | Dashboard shows total time, category breakdown, top 5 apps |
| MS1.5 | Basic app categorization | Heuristic package-name mapping (Social, Entertainment, Productivity, etc.) |
| MS1.6 | Daily screentime limit quest | First screentime quest type: stay under total daily limit; auto-completes |
| MS1.7 | SEN stat integration | Screentime quest completions → +SEN; excess → SEN decay |

**Team addition:** 1 Android-native Kotlin developer (specialized in `UsageStatsManager` and foreground services).

### Phase 2 Extension (Month 4–5): App Limits & Focus Sessions

| Milestone | Deliverable | Success Criteria |
|-----------|------------|-----------------|
| MS2.1 | Per-app time limits | User can set daily limit for any app; enforced via monitoring |
| MS2.2 | App lock overlay | Full-screen overlay blocks access when limit reached; override with friction |
| MS2.3 | Focus session quests | User initiates focus session; System blocks social/entertainment; quest auto-completes on success |
| MS2.4 | Category-level quests | App Category Limit quests (e.g., "Social media: max 45 minutes") |
| MS2.5 | Morning/evening protocol quests | Time-based protocol quests with violation detection |
| MS2.6 | Unlock/pickup count tracking | `KeyguardManager` + accelerometer integration for count-based quests |

### Phase 3 Extension (Month 6–7): Advanced Digital Wellness

| Milestone | Deliverable | Success Criteria |
|-----------|------------|-----------------|
| MS3.1 | Digital Sabbath quests | Full-day zero-recreational-screen quests with "Digital Monk" title reward |
| MS3.2 | On-device ML categorization | TensorFlow Lite model suggests app recategorizations after 7 days of usage data |
| MS3.3 | Advanced analytics dashboard | 7/30/90-day trends, correlation insights, personalized recommendations |
| MS3.4 | Custom app categories | User-created categories beyond defaults (SEN 35+ unlock) |
| MS3.5 | Scheduled app locks (premium) | Recurring locks for Silver/Gold subscribers |
| MS3.6 | App lock override analytics | Track override frequency, surface insights: "You override Instagram locks 3x/week" |
| MS3.7 | Screentime-quest cross-referencing | "Your Deep Work quest completion rate drops 40% when social media exceeds 1h/day" |

---

## Appendix: Android API Reference Summary

| API | Class/Method | Minimum API | Purpose |
|-----|-------------|-------------|---------|
| `UsageStatsManager` | `queryAndAggregateUsageStats()` | 21 (Lollipop) | Daily per-app usage totals |
| `UsageStatsManager` | `queryUsageStats()` | 21 | Historical trends by interval |
| `UsageStatsManager` | `queryEvents()` | 21 | Session-level app open/close events |
| `UsageStatsManager` | `isAppInactive()` | 23 | Detect unused apps |
| `AppOpsManager` | `checkOpNoThrow()` | 19 | Check if `PACKAGE_USAGE_STATS` granted |
| `Settings` | `ACTION_USAGE_ACCESS_SETTINGS` | 21 | Intent to grant usage access |
| `ForegroundService` | `startForeground()` | 26 (Oreo required) | Persistent background monitoring |
| `BroadcastReceiver` | `ACTION_SCREEN_ON` / `ACTION_SCREEN_OFF` | 1 | Real-time screen state |
| `WorkManager` | `PeriodicWorkRequest` | 14 (with compat) | Scheduled data collection |
| `KeyguardManager` | `isKeyguardLocked()` / dismiss events | 16 | Unlock count detection |
| `SensorManager` | `TYPE_ACCELEROMETER` + `TYPE_PROXIMITY` | 3 | Pickup detection |
| `SYSTEM_ALERT_WINDOW` | Window overlay | 1 | App lock full-screen overlay |
| `DeviceStateManager` | `subscribeToDeviceState()` | 34 (Android 14) | Future: enhanced interaction state |

---

*This specification represents a complete, implementable design for the ARISE Screentime Monitoring System. All Android API references are grounded in official Android documentation. The architecture is privacy-first by design, gamification-second by philosophy, and technically sound by construction. Estimated implementation effort: 6–8 engineer-weeks across Phases 1–3, contingent on one Kotlin-native Android developer with UsageStatsManager experience.*

*No existing habit or life-RPG application has integrated screentime monitoring at this depth. This is a genuine blue ocean feature — defensive moat and user value, simultaneously.*
