## Dimension 06: Health Data Integration & APIs

### Health Connect Data Types Used

Health Connect provides 40+ data types across categories of activity, body measurement, nutrition, sleep, and vitals [^434^][^436^]. For ARISE, the following data types are mapped to quest categories:

| Data Type | Quest Mapping | Auto-Complete Rule | Required Permission |
|---|---|---|---|
| `StepsRecord` | Daily Step Quests | COUNT_TOTAL >= quest threshold | `READ_STEPS` |
| `DistanceRecord` | Running/Cycling Distance | DISTANCE_TOTAL >= target (meters) | `READ_DISTANCE` |
| `ExerciseSessionRecord` | Workout Completion | Session exists with matching exerciseType | `READ_EXERCISE` |
| `ActiveCaloriesBurnedRecord` | Calorie Burn Goals | ACTIVE_CALORIES_TOTAL >= target | `READ_ACTIVE_CALORIES_BURNED` |
| `TotalCaloriesBurnedRecord` | Daily Energy Quests | ENERGY_TOTAL >= target | `READ_TOTAL_CALORIES_BURNED` |
| `HeartRateRecord` | Cardio Intensity | BPM_AVG in target zone during exercise | `READ_HEART_RATE` |
| `HydrationRecord` | Water Intake | VOLUME_TOTAL >= target (ml) | `READ_HYDRATION` |
| `NutritionRecord` | Nutrition/Macro Tracking | ENERGY_TOTAL, PROTEIN_TOTAL, etc. hit goals | `READ_NUTRITION` |
| `SleepSessionRecord` | Sleep Quality | SLEEP_DURATION_TOTAL >= target hours | `READ_SLEEP` |
| `FloorsClimbedRecord` | Stair Climbing | FLOORS_CLIMBED_TOTAL >= target | `READ_FLOORS_CLIMBED` |
| `ElevationGainedRecord` | Hiking/Elevation | ELEVATION_GAINED_TOTAL >= target (meters) | `READ_ELEVATION_GAINED` |
| `MindfulnessSessionRecord` | Meditation/Mindfulness | MINDFULNESS_DURATION_TOTAL >= target | `READ_MINDFULNESS` |
| `WeightRecord` | Body Composition Tracking | WEIGHT_AVG logged (any value) | `READ_WEIGHT` |
| `Vo2MaxRecord` | Cardio Fitness | VO2 value logged above threshold | `READ_VO2_MAX` |

**NutritionRecord Aggregate Types Available** [^468^][^472^]: `ENERGY_TOTAL` (calories), `PROTEIN_TOTAL`, `TOTAL_CARBOHYDRATE_TOTAL`, `TOTAL_FAT_TOTAL`, `SATURATED_FAT_TOTAL`, `SUGAR_TOTAL`, `DIETARY_FIBER_TOTAL`, `SODIUM_TOTAL`, plus 30+ micronutrient totals.

**ExerciseSessionRecord Exercise Types** [^434^]: 100+ types including `RUNNING`, `HIKING`, `BICYCLING`, `WEIGHTLIFTING`, `YOGA`, `MEDITATION`, `SWIMMING_POOL`, `HIGH_INTENSITY_INTERVAL_TRAINING`, `CALISTHENICS`, `MARTIAL_ARTS`, `DANCING`.

---

### Integration Architecture

#### Primary Data Hub: Health Connect

Health Connect serves as the central data hub on Android, eliminating the need for pairwise app integrations [^33^][^36^]. All health data flows through Health Connect as the single source of truth [^486^].

| Partner App | Integration Method | Data Flow | Fallback |
|---|---|---|---|
| **Lyfta** (workout tracker) | Health Connect + Lyfta REST API | Lyfta writes `ExerciseSessionRecord` + sets to HC; ARISE reads from HC via `READ_EXERCISE` permission. Alternative: Direct API key sync via `my.lyfta.app/api/v1/workouts` [^441^] | Manual workout entry; CSV import; photo proof |
| **MyFitnessPal** | Health Connect (primary) + MFP API v2 | MFP writes `NutritionRecord` to HC; ARISE reads aggregated nutrition data. MFP API v2 available at `myfitnesspalapi.com` with OAuth2 [^447^] | Manual food logging; barcode scan; photo meal log |
| **Cronometer** | Health Connect + Terra API bridge | Cronometer syncs nutrition data to HC via Terra webhooks [^440^]; ARISE reads `NutritionRecord` aggregates | Manual macro entry; food photo logging |
| **Shnuk (Schnucks)** | No public API available | Schnucks Rewards app provides recipe nutrition info and wellness guide [^582^][^598^] but does NOT expose a developer API for nutrition tracking data. ARISE cannot directly pull nutrition data from Schnucks. | Users manually log meals; Health Connect aggregation from other nutrition apps |
| **Strava** | Health Connect + Strava API with webhooks | Strava writes activities to HC; real-time webhooks push new activities [^551^]; ARISE reads `ExerciseSessionRecord` | Manual activity entry; GPX upload |
| **Native Android Sensors** | Health Connect (passive) + Health Services API on Wear OS | Health Services aggregates steps, distance, calories from device sensors [^597^]; writes to HC automatically | Manual step/activity entry |
| **Wear OS Smartwatch** | Health Services API + Health Connect | Wear OS 5+ syncs health data in background to HC [^596^]; complications show real-time stats | Phone sensors only |

**Data Flow Pattern**:
```
[Partner App] → writes to → [Health Connect] ← reads from ← [ARISE]
                 (Lyfta, MFP, etc. write    (ARISE reads aggregated
                  ExerciseSessionRecord,      data via Jetpack SDK
                  NutritionRecord, etc.)
```

**Key Architecture Decisions**:
- **Health Connect as single integration point**: ARISE only needs to integrate with Health Connect, not each individual app [^33^][^36^]
- **Read-only model for ARISE**: ARISE reads data from Health Connect but does not write health data back, minimizing permission requirements
- **Aggregation-first**: Use `AggregateRequest` for daily totals rather than reading raw records [^527^][^34^]
- **Data origin filtering**: Use `dataOriginFilter` to attribute XP to correct source app [^527^]

---

### Auto-Completion Rules

Quests auto-complete when Health Connect aggregated data meets predefined thresholds. The completion check runs:
1. On app foreground (pull latest)
2. After background sync (push notification)
3. On Health Connect data change listener (Android 15+)

| Health Metric | Quest Trigger | Threshold | XP Reward |
|---|---|---|---|
| Steps (daily) | `StepsRecord.COUNT_TOTAL` >= 10,000 | 10,000 steps | 100 XP |
| Steps (stretch) | `StepsRecord.COUNT_TOTAL` >= 15,000 | 15,000 steps | 150 XP |
| Distance Run | `DistanceRecord.DISTANCE_TOTAL` >= 5km | 5,000 meters | 200 XP |
| Workout Completed | `ExerciseSessionRecord` with any exerciseType exists | 1 session, min 15 min | 250 XP |
| Strength Training | `ExerciseSessionRecord.EXERCISE_TYPE_WEIGHTLIFTING` | 1 session | 300 XP |
| HIIT Workout | `ExerciseSessionRecord.EXERCISE_TYPE_HIGH_INTENSITY_INTERVAL_TRAINING` | 1 session | 350 XP |
| Calories Burned | `ActiveCaloriesBurnedRecord.ACTIVE_CALORIES_TOTAL` >= 500 | 500 kcal | 150 XP |
| Heart Rate Zone | `HeartRateRecord.BPM_AVG` in 140-180 range during exercise | 20+ min in zone | 200 XP |
| Hydration | `HydrationRecord.VOLUME_TOTAL` >= 2500ml | 2.5 liters | 100 XP |
| Sleep Duration | `SleepSessionRecord.SLEEP_DURATION_TOTAL` >= 7 hours | 7+ hours | 150 XP |
| Sleep Quality | `SleepSessionRecord` with deep sleep >= 20% | 20%+ deep | 200 XP |
| Meditation | `MindfulnessSessionRecord.MINDFULNESS_DURATION_TOTAL` >= 10 min | 10+ minutes | 100 XP |
| Floors Climbed | `FloorsClimbedRecord.FLOORS_CLIMBED_TOTAL` >= 10 | 10 floors | 100 XP |
| Elevation Gain | `ElevationGainedRecord.ELEVATION_GAINED_TOTAL` >= 100m | 100 meters | 150 XP |
| Protein Goal | `NutritionRecord.PROTEIN_TOTAL` >= bodyweight * 0.8g | varies | 200 XP |
| Calorie Goal | `NutritionRecord.ENERGY_TOTAL` within +/- 10% of target | target +/-10% | 150 XP |
| Water Intake | `HydrationRecord.VOLUME_TOTAL` >= 3000ml | 3 liters | 125 XP |
| VO2 Max Check | `Vo2MaxRecord` value logged this week | any reading | 100 XP |
| Weight Logged | `WeightRecord` entry exists today | 1 reading | 50 XP |

**XP Calculation Formula** [^586^][^453^]:
- Base XP: Fixed reward for quest completion
- Streak Multiplier: 1.1x for 3-day streak, 1.25x for 7-day, 1.5x for 30-day
- Difficulty Bonus: Hard quests (HIIT, marathon training) get 2x multiplier
- First Completion Bonus: 2x XP on first-time quest completions

**Anti-Gaming Protections**:
- Data must come from authenticated Health Connect source (not manual entry) for leaderboard-eligible quests
- Sudden impossible data spikes (>3 standard deviations) flagged for review
- Multiple same-day workouts from same source deduplicated via `clientRecordId` [^557^]

---

### Manual Override & Verification Systems

When Health Connect data is unavailable, incomplete, or for quest types not supported by automated tracking:

| Method | Use Case | Verification | Consequences for Fraud |
|---|---|---|---|
| **Manual Entry** | No wearable, no partner app | Honor system + random audit | Fraud detection: unrealistic values trigger "Needs Verification" flag |
| **Photo Proof** | Workout completion, meal logging | User uploads photo; optional community/AI verification | Verified photo = 1.2x XP bonus; unverified = base XP only |
| **Timer-Based** | Meditation, reading, stretching | In-app timer with screen-on requirement | Cannot be gamed without keeping app open |
| **GPS Track Upload** | Running, cycling, hiking | GPX/TCX file import with route validation | Fake routes detected via impossible speed/elevation patterns |
| **Community Verification** | Photo-based quests | Other users vote on completion photos | Crowd-sourced fraud detection; disputed entries reviewed |
| **Honor System** | Simple habits (drank water, stretched) | Self-reported checkbox | No XP for leaderboard; personal progress only |

**Trust Tiers**:
- **Tier 1 (Verified)**: Data from Health Connect with authenticated source → Full XP, leaderboard eligible
- **Tier 2 (Photo Verified)**: Manual entry with photo proof → Full XP, leaderboard eligible
- **Tier 3 (Self-Reported)**: Manual entry without proof → 50% XP, NOT leaderboard eligible
- **Tier 4 (Honor System)**: Simple checkboxes → No XP (progress tracking only)

**Fraud Detection Algorithm**:
1. Flag entries exceeding human physiological limits (e.g., 50,000 steps in 1 hour)
2. Statistical anomaly detection on user history (>3 sigma = review)
3. Cross-reference with known data patterns (e.g., GPS coordinates must match claimed activity)
4. Community reporting for suspicious entries
5. Progressive penalties: 1st offense = warning, 2nd = XP deduction, 3rd = temporary leaderboard ban

---

### Data Privacy Matrix

Health data is classified as "special category data" under GDPR Article 9, requiring explicit consent and enhanced protection [^464^][^470^][^475^].

| Data Type | Storage | Retention | User Control |
|---|---|---|---|
| Steps, Distance, Calories | On-device Health Connect + encrypted server cache | 30 days server-side; user controls HC retention | Granular per-type permission revoke; full deletion via HC |
| Heart Rate, Sleep | On-device Health Connect only (not on ARISE servers) | Never stored on ARISE servers; read-only aggregation | User can deny `READ_HEART_RATE`/`READ_SLEEP` permissions |
| Workout Sessions | Reference IDs only on ARISE; full data in HC | 90 days activity log; anonymized after | Users can delete individual workout entries |
| Nutrition (Macros) | Aggregated daily totals only; no meal details | 30 days detailed; 1 year anonymized trends | `READ_NUTRITION` permission can be revoked |
| Weight, Body Composition | On-device HC; ARISE stores only trend deltas | 1 year; can be exported or deleted | `READ_WEIGHT` permission; manual delete request |
| GPS/Route Data | Never stored on ARISE servers | Not retained | `READ_EXERCISE_ROUTE` permission required separately |
| Meditation/Mindfulness | Duration totals only | 90 days | `READ_MINDFULNESS` permission |
| Quest Completion History | ARISE server (encrypted at rest) | Until account deletion | Full export (GDPR Article 20); deletion on account close |
| XP, Levels, Achievements | ARISE server | Duration of account + 30 days post-deletion | Part of account data export; deleted with account |
| Photo Proof | Encrypted blob storage | 30 days after quest period ends | User can delete own photos anytime |

**GDPR Compliance Measures** [^464^][^467^][^470^][^475^]:
- **Explicit Consent**: Separate consent flow for health data, distinct from general T&Cs [^467^]
- **Granular Permissions**: Per-data-type consent toggles, not blanket approval
- **Two-Step Confirmation**: Selection of data types → Summary review → Confirm [^467^]
- **Right to Erasure**: Account deletion triggers full data purge within 30 days (GDPR Article 17) [^521^][^524^][^528^]
- **Data Minimization**: ARISE reads only aggregated totals; raw health data stays in Health Connect
- **Consent Versioning**: All consent records timestamped with version, scope, IP, user agent [^467^]
- **One-Tap Withdrawal**: Health permissions can be revoked from ARISE settings, triggering immediate data deletion
- **DPIA Required**: Data Protection Impact Assessment mandatory for health data processing [^475^]
- **Cross-Border Transfers**: If servers outside EU, Standard Contractual Clauses (SCCs) required [^470^]

**30-Day Read Limitation** [^430^][^433^]:
- By default, apps can only read Health Connect data from the last 30 days
- `PERMISSION_READ_HEALTH_DATA_HISTORY` required for older data
- ARISE must request this permission during onboarding for users who want historical quest credit
- Reading own app's previously written data has no historical limit [^430^]

---

### Wearable Integration

| Device Type | Capabilities | Widget/Complication Options |
|---|---|---|
| **Wear OS 5+ Smartwatch** | Full Health Services API: steps, HR, GPS, calories, sleep, SpO2, ECG [^597^][^571^] | GOAL_PROGRESS complication for quest progress; RANGED_VALUE for steps/HR; Tiles for quick workout start [^535^][^596^] |
| **Wear OS 4** | Health Services API with limited background sync | Basic complications; no background Health Connect sync [^596^] |
| **Samsung Galaxy Watch** | Samsung Health + Health Connect dual path | Samsung Health tiles; Health Connect data sync [^485^] |
| **Fitbit (Pixel Watch)** | Fitbit app + Health Connect bridge | Fitbit exercise tiles; data flows to HC [^599^] |
| **Apple Watch** | HealthKit (iOS counterpart to Health Connect) | Activity rings complications; workout auto-detection [^444^] |
| **Garmin** | Garmin Connect + Health Connect (Android) | Garmin complications; syncs to HC on Android |

**Wear OS Complication Data Types Supported** [^535^]:
- `GOAL_PROGRESS`: Show quest completion percentage (e.g., "7,234/10,000 steps")
- `RANGED_VALUE`: Show metric in a range (e.g., heart rate zone)
- `SHORT_TEXT`: Quick stat display (e.g., "+250 XP today")
- `LONG_TEXT`: Detailed quest status
- Update period: Minimum 300 seconds (5 minutes) [^535^]

**Always-On Display (AOD)** [^571^]:
- Wear OS supports AOD showing time + complications in low-power state
- Built-in burn-in protection shifts UI elements periodically
- Battery-optimized watch faces using Watch Face Format (WFF) recommended
- ARISE complications visible in AOD mode for quest progress at a glance

**Wear OS 5 Background Sync** [^596^]:
- Wear OS 5 enables Health Connect background sync for all historical data (not just 30 days)
- No need to keep apps open for data sharing
- 20% less battery consumption during workouts

**Implementation Pattern**:
```kotlin
// Wear OS Complication Data Source for Quest Progress
class QuestProgressDataSource : SuspendingComplicationDataSourceService() {
    override suspend fun onComplicationRequest(request: ComplicationRequest): ComplicationData? {
        val steps = healthConnectManager.getTodaySteps() // from HC
        val goal = 10000
        return GoalProgressComplicationData.Builder(
            value = steps.toFloat(),
            targetValue = goal.toFloat(),
            contentDescription = "Quest Progress"
        ).setText(PlainComplicationText.Builder("$steps/$goal").build())
        .build()
    }
}
```

---

### Fallback Strategies

| Scenario | Fallback Strategy | User Experience |
|---|---|---|
| **No Health Connect available** (Android < 13, not installed) | Prompt user to install HC from Play Store; offer manual entry mode [^486^] | Onboarding wizard guides HC installation; manual mode available immediately |
| **No partner fitness app** | Direct Lyfta API integration (if user has Lyfta Pro); manual workout logging; CSV import [^441^] | "Connect Lyfta" button; "Log Workout Manually" option; import from CSV |
| **No nutrition app** | Built-in food database with barcode scanning; manual macro entry; photo food diary | Searchable food database; barcode scanner; quick-add macros |
| **Shnuk (Schnucks) users** | Shnuk/Schnucks has NO public API for nutrition data [^582^][^598^]. Users must manually log meals from Schnucks recipes, or connect MyFitnessPal/Cronometer as primary nutrition tracker | Recipe nutrition info displayed in-app but not auto-synced; manual "I ate this" toggle |
| **Permission denied** | Graceful degradation: show quests that don't need denied data types; re-request permission in context [^490^] | "Enable Steps for Quest Progress" inline prompts; reduced but functional experience |
| **Offline / No sync** | Queue quest completions locally; sync on reconnection; WorkManager retry with backoff [^557^] | "Quests will sync when online" banner; local XP awarded immediately |
| **Battery optimization blocking sync** | Direct user to device-specific battery whitelist settings; dontkillmyapp.com guidance [^483^] | In-app battery optimization helper; per-device instructions |
| **30-day historical data limit** | Request `PERMISSION_READ_HEALTH_DATA_HISTORY` during onboarding [^430^][^435^] | "Import past progress?" onboarding screen; grants extended history access |
| **Wearable not connected** | Fall back to phone sensors (accelerometer, pedometer); lower accuracy but functional | Auto-detect phone-only mode; reduced step accuracy note |
| **Health Connect data conflict** | Use `lastModifiedTime` metadata; prefer data from authoritative source (wearable > phone > manual) [^557^][^572^] | Invisible to user; conflict resolution logged for debugging |
| **Lyfta API unavailable** | Read workout data from Health Connect (Lyfta writes to HC); if HC also unavailable, manual entry | Seamless fallback chain; user notified of sync issue |

**Schnucks/Shnuk Integration Note**:
Schnucks Rewards is a grocery store loyalty app with recipe nutrition information and a wellness guide [^582^][^598^][^600^]. It does NOT provide a developer API for accessing user nutrition logs or meal tracking data. The app shows nutrition info for recipes and products but cannot push structured nutrition data to Health Connect. ARISE should:
1. NOT attempt direct API integration with Schnucks (no API available)
2. Provide manual recipe logging: "I made this Schnucks recipe" → auto-fill nutrition from recipe database
3. Direct users to connect MyFitnessPal or Cronometer for automated nutrition tracking
4. Display Schnucks recipe nutrition data in ARISE for reference when manual logging

---

### Data Model Design: Health Data → Game Layer Mapping

```
┌─────────────────────────────────────────────────────────────────┐
│                    HEALTH DATA LAYER                              │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐          │
│  │ Health Connect│  │ Lyfta API    │  │ Manual Entry │          │
│  │ (Steps, HR,   │  │ (Workouts,   │  │ (Photos,     │          │
│  │  Nutrition,   │  │  Sets, Reps) │  │  Timer, GPS) │          │
│  │  Sleep)       │  │              │  │              │          │
│  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘          │
└─────────┼──────────────────┼──────────────────┼──────────────────┘
          │                  │                  │
          ▼                  ▼                  ▼
┌─────────────────────────────────────────────────────────────────┐
│                  AGGREGATION & NORMALIZATION                      │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │  DailyAggregates (date, userId, metric, value, source)   │    │
│  │  - steps_total, distance_total, calories_active,          │    │
│  │    nutrition_protein, nutrition_calories, sleep_duration, │    │
│  │    hydration_total, floors_climbed, elevation_gained      │    │
│  └─────────────────────────────────────────────────────────┘    │
└──────────────────────────────────┬──────────────────────────────┘
                                   │
                                   ▼
┌─────────────────────────────────────────────────────────────────┐
│                    QUEST ENGINE                                   │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │  QuestTemplate (id, triggerMetric, threshold, xpReward,  │    │
│  │    category, difficulty, cooldown, requiresVerification)  │    │
│  └─────────────────────────────────────────────────────────┘    │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │  UserQuest (userId, questId, status, progress,           │    │
│  │    completedAt, xpAwarded, verificationTier)             │    │
│  └─────────────────────────────────────────────────────────┘    │
└──────────────────────────────────┬──────────────────────────────┘
                                   │
                                   ▼
┌─────────────────────────────────────────────────────────────────┐
│                    GAME LAYER                                     │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐          │
│  │ XP & Leveling │  │ Stats (STR,  │  │ Achievements  │          │
│  │ (totalXP,     │  │  AGI, VIT,   │  │ & Badges      │          │
│  │  currentLevel,│  │  INT, WIS)   │  │ (milestone    │          │
│  │  xpToNext)    │  │              │  │  awards)      │          │
│  └──────────────┘  └──────────────┘  └──────────────┘          │
└─────────────────────────────────────────────────────────────────┘
```

**Stat Mapping** [^586^][^558^]:
| Health Metric | Game Stat | Mapping Logic |
|---|---|---|
| Steps, Distance, Cardio | **AGI (Agility)** | Daily activity volume → AGI XP |
| Strength Workouts, Weight Lifted | **STR (Strength)** | Total volume (sets × reps × weight) → STR XP |
| Sleep Duration, Rest Days, HRV | **VIT (Vitality)** | Recovery metrics → VIT XP |
| Nutrition Adherence, Hydration | **WIS (Wisdom)** | Consistency in healthy habits → WIS XP |
| Meditation, Mindfulness, Learning | **INT (Intelligence)** | Mental wellness activities → INT XP |

**XP Distribution**:
- **Core Stats**: 60% of earned XP distributed to primary stat based on quest type
- **Secondary Stats**: 20% to related stats (e.g., cardio gives small STR bonus)
- **General Pool**: 20% to overall character level

---

### Background Sync Architecture

**Sync Strategy**: Periodic pull via WorkManager with push triggers

```
┌──────────────────────────────────────────────────────────────────┐
│                    BACKGROUND SYNC PIPELINE                       │
│                                                                   │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────────────┐  │
│  │ WorkManager │───▶│ HealthConnect│───▶│ Quest Completion    │  │
│  │ (Periodic   │    │ Aggregate   │    │ Engine              │  │
│  │  15 min)    │    │ Read        │    │ (Threshold Check)   │  │
│  └─────────────┘    └─────────────┘    └─────────────────────┘  │
│         │                                              │         │
│         │    ┌─────────────┐    ┌─────────────────────┘         │
│         └───▶│ FCM Push    │◀───│ Award XP, Send Notif         │
│              │ (Triggers)  │    │ Update Leaderboard            │
│              └─────────────┘    └──────────────────────────────┘
└──────────────────────────────────────────────────────────────────┘
```

**WorkManager Configuration** [^556^][^559^]:
```kotlin
val constraints = Constraints.Builder()
    .setRequiredNetworkType(NetworkType.CONNECTED)
    .setRequiresBatteryNotLow(true)
    .build()

val syncWork = PeriodicWorkRequestBuilder<HealthSyncWorker>(
    15, TimeUnit.MINUTES,  // repeat interval
    5, TimeUnit.MINUTES    // flex interval
).setConstraints(constraints)
 .setBackoffCriteria(BackoffPolicy.EXPONENTIAL, 10, TimeUnit.MINUTES)
 .addTag("health_sync")
 .build()

WorkManager.getInstance(context).enqueueUniquePeriodicWork(
    "arise_health_sync",
    ExistingPeriodicWorkPolicy.KEEP,
    syncWork
)
```

**Battery Optimization** [^483^][^484^]:
- Manufacturer-specific battery settings can kill background sync
- Samsung: Settings → Battery → Background Usage Limits → Allow
- Xiaomi: Settings → Battery → App Battery Saver → No restrictions
- Huawei: Settings → Battery → App Launch → Manage manually
- Pixel: Settings → Apps → Battery → Unrestricted
- Link users to dontkillmyapp.com for device-specific guidance
- Use foreground service with `health` type during active workout tracking

**Push Triggers** (supplement periodic sync):
- Firebase Cloud Messaging high-priority messages wake app for immediate sync
- Health Connect on Android 15+ supports background data change listeners
- Strava/Lyfta webhooks push new activity events in real-time

**Token-Based Sync for Historical Data** [^563^]:
- Store Health Connect `changesToken` for incremental sync
- Tokens expire after 30 days of inactivity
- Fallback strategies: read all data + deduplicate, or read from last known timestamp
- Upsert using `clientRecordId` prevents duplicates on retry [^557^]

---

### Android Health & Fitness Permissions Matrix

| Permission | Data Types | Runtime Required | ARISE Usage |
|---|---|---|---|
| `android.permission.health.READ_STEPS` | `StepsRecord`, `StepsCadenceRecord` | Yes (HC dialog) | Step quests, AGI stat |
| `android.permission.health.READ_DISTANCE` | `DistanceRecord` | Yes (HC dialog) | Running/cycling quests |
| `android.permission.health.READ_EXERCISE` | `ExerciseSessionRecord` | Yes (HC dialog) | Workout completion quests |
| `android.permission.health.READ_HEART_RATE` | `HeartRateRecord`, `RestingHeartRateRecord` | Yes (HC dialog) | Cardio zone quests |
| `android.permission.health.READ_TOTAL_CALORIES_BURNED` | `TotalCaloriesBurnedRecord` | Yes (HC dialog) | Daily calorie burn quests |
| `android.permission.health.READ_ACTIVE_CALORIES_BURNED` | `ActiveCaloriesBurnedRecord` | Yes (HC dialog) | Active burn quests |
| `android.permission.health.READ_NUTRITION` | `NutritionRecord` | Yes (HC dialog) | Macro/calorie quests |
| `android.permission.health.READ_HYDRATION` | `HydrationRecord` | Yes (HC dialog) | Water intake quests |
| `android.permission.health.READ_SLEEP` | `SleepSessionRecord` | Yes (HC dialog) | Sleep quality quests |
| `android.permission.health.READ_MINDFULNESS` | `MindfulnessSessionRecord` | Yes (HC dialog) | Meditation quests |
| `android.permission.health.READ_WEIGHT` | `WeightRecord` | Yes (HC dialog) | Body composition tracking |
| `android.permission.health.READ_FLOORS_CLIMBED` | `FloorsClimbedRecord` | Yes (HC dialog) | Stair climbing quests |
| `android.permission.health.READ_ELEVATION_GAINED` | `ElevationGainedRecord` | Yes (HC dialog) | Hiking quests |
| `android.permission.health.READ_VO2_MAX` | `Vo2MaxRecord` | Yes (HC dialog) | Cardio fitness tracking |
| `PERMISSION_READ_HEALTH_DATA_HISTORY` | All types (historical) | Yes (HC dialog) | Import past 30+ days |
| `PERMISSION_READ_HEALTH_DATA_IN_BACKGROUND` | All types (background) | Yes (HC dialog) | Android 15+ background read |
| `ACTIVITY_RECOGNITION` | Activity detection | Yes (runtime) | Motion-based quest triggers |
| `BODY_SENSORS` | Heart rate (Wear OS 5.1-) | Yes (runtime) | Wearable heart rate |
| `FOREGROUND_SERVICE_HEALTH` | Health FGS type | Manifest only | Workout tracking service |
| `HIGH_SAMPLING_RATE_SENSORS` | Accelerometer | Manifest only | Motion detection |
| `POST_NOTIFICATIONS` | Notifications | Yes (Android 13+) | Quest completion alerts |
| `INTERNET` | Network access | Manifest only | API calls, sync |
| `ACCESS_FINE_LOCATION` | GPS routes | Yes (runtime) | Running/cycling route tracking |

**Permission Request Flow** [^485^][^486^][^490^]:
1. Declare all `android.permission.health.READ_*` permissions in AndroidManifest.xml
2. Include mandatory `ViewPermissionUsageActivity` activity-alias [^486^]
3. Query Health Connect package availability: `<queries><package android:name="com.google.android.apps.healthdata" /></queries>`
4. At runtime, create permission set and launch via `PermissionController.createRequestPermissionResultContract()`
5. Handle partial grants: check `getGrantedPermissions()` and request missing individually
6. On Android 14+, use `ACTION_MANAGE_HEALTH_PERMISSIONS` intent for re-requesting denied permissions [^490^]

**Foreground Service Type "health"** [^577^][^578^][^576^]:
- Declare `FOREGROUND_SERVICE_HEALTH` permission in manifest
- Requires at least one of: `BODY_SENSORS`, `READ_HEART_RATE`, `READ_SKIN_TEMPERATURE`, `READ_OXYGEN_SATURATION`, or `ACTIVITY_RECOGNITION`
- Use case: workout tracking, continuous heart-rate monitoring
- On Android 15, background body sensor access requires `READ_HEALTH_DATA_IN_BACKGROUND` (API 36+) or `BODY_SENSORS_BACKGROUND` (API 33-35)

---

### Implementation Checklist

**Phase 1: Core Health Connect Integration**
- [ ] Add `androidx.health.connect:connect-client` dependency
- [ ] Declare all required permissions in AndroidManifest.xml
- [ ] Add `ViewPermissionUsageActivity` activity-alias
- [ ] Implement permission request flow with graceful degradation
- [ ] Read aggregated data for steps, distance, calories, exercise
- [ ] Implement quest completion threshold checking
- [ ] Award XP and update stats on quest completion

**Phase 2: Partner App Integrations**
- [ ] Document Lyfta Health Connect integration path
- [ ] Document MyFitnessPal Health Connect path + API v2 fallback
- [ ] Document Cronometer Health Connect path
- [ ] Handle Schnucks: manual recipe logging (no API available)
- [ ] Implement Strava webhook + Health Connect dual path

**Phase 3: Background Sync & Reliability**
- [ ] Implement WorkManager periodic sync (15-minute intervals)
- [ ] Add battery optimization bypass guidance
- [ ] Implement offline queue for quest completions
- [ ] Add FCM push triggers for real-time updates
- [ ] Handle 30-day historical data limit with `PERMISSION_READ_HEALTH_DATA_HISTORY`

**Phase 4: Wearable & Widgets**
- [ ] Implement Wear OS complication data source (GOAL_PROGRESS)
- [ ] Add always-on display compatible complication
- [ ] Implement Wear OS Tile for quick quest view
- [ ] Support Health Services API for workout detection

**Phase 5: Privacy & Compliance**
- [ ] Implement explicit consent flow (GDPR Article 9)
- [ ] Add granular per-data-type permission toggles
- [ ] Implement account deletion → full data purge
- [ ] Add data export functionality (GDPR Article 20)
- [ ] Complete Data Protection Impact Assessment (DPIA)
- [ ] Document Records of Processing Activities (ROPA)

---

### References

[^33^] Health Connect eliminates need for pairwise app integrations (wide research)
[^34^] Integrating HealthConnect to Access Exercise Data — Medium, 2024
[^36^] Foreground service type "health" requires FGS_HEALTH permission (wide research)
[^43^] Health Connect: 40+ data types, on-device API, Android 14+ built-in (wide research)
[^75^] Google Fit REST API shutdown June 30, 2025 (wide research)
[^76^] Google Fit migration to Health Connect (wide research)
[^112^] Health Connect 30-day read limitation (wide research)
[^114^] Historical data needs special permission (wide research)
[^125^] Background reading only on Android 15+ (wide research)
[^430^] Read raw data | Android Developers — 30-day read rules
[^431^] Fit migration guide | Android Developers
[^432^] Google's Shift from Google Fit to Health Connect — Mindbowser
[^433^] Read aggregated data | Android Developers — read limitations
[^434^] Health Connect data types | Android Developers — complete list
[^435^] Health Connect data history permission — GitHub issue
[^436^] android.health.connect.datatypes | API reference
[^440^] Cronometer API Integration via Terra
[^441^] Lyfta API Access — my.lyfta.app/community/api
[^442^] LiftShift — How Lyfta sync works
[^444^] Lyfta Apps & Integrations page
[^447^] MyFitnessPal Developer API docs — myfitnesspalapi.com
[^448^] Cronometer Roadmap — user API request discussion
[^453^] Best Gamified Fitness Apps — NutriBalance analysis
[^463^] Declare appropriate permissions | Android Developers (Wear OS)
[^464^] GDPR Compliance for Fitness Apps — gdpr-advisor.com
[^467^] GDPR Consent Requirements for Health Data — Momentum
[^468^] NutritionRecord | Android Developers API reference
[^470^] GDPR for Wearable Technology — Compliance Guide
[^475^] GDPR Compliance for Digital Health Apps — Taylor Wessing
[^483^] Android Health Connect SDK Troubleshooting — Open Wearables
[^484^] Best practices for Health Connect battery optimization — ROOK
[^485^] Android Health Connect — Junction documentation
[^486^] Integrating Health Connect SDK — Medium simplified guide
[^487^] Health Connect permission Android 14 issue — GitHub
[^488^] Health Connect Android 13 to 14 migration guide
[^489^] Health Connect permission issue Android < 14 — Stack Overflow
[^490^] Exploring Health Connect Pt. 1 — Permissions setup
[^521^] Data Erasure Request Handling — Watchdog Security
[^522^] Aggregate data request — Samsung Health SDK
[^524^] GDPR Right to Be Forgotten — Usercentrics
[^526^] Health Connect aggregate search — Stack Overflow
[^527^] Read aggregated data | Android Developers
[^528^] Art. 17 GDPR — Right to erasure
[^530^] GDPR Right to Be Forgotten — GDPR.eu
[^532^] Best Practices for GDPR-Compliant Data Deletion — Reform.app
[^533^] RunFit: Running Complications app
[^535^] Building complication data sources for Wear OS — Android Developers Blog
[^550^] Develop Workout Experiences with Health Connect
[^551^] Strava API Integration — Open Wearables
[^553^] Strava integration — Terra
[^556^] Android WorkManager: A Complete Technical Deep Dive
[^557^] Write data | Android Developers — Health Connect
[^558^] Health App Gamification — StriveCloud
[^559^] WorkManager vs AlarmManager vs JobScheduler
[^561^] Health Connect technical implementation — Grokipedia
[^562^] Exploring Health Connect Pt. 3 — Updating and Deleting Data
[^563^] Synchronize data | Android Developers — Health Connect
[^566^] Delete data | Android Developers — Health Connect
[^567^] Health and fitness tracking app data model — GitHub
[^571^] Wear OS — Grokipedia (features, AOD, complications)
[^572^] Health Connect data type format | Android Developers
[^574^] Custom Conflict Resolution — PowerSync documentation
[^576^] Android Foreground Services — newly.app
[^577^] Foreground service types are required — Android Developers
[^578^] Foreground service types | Background work — Android Developers
[^580^] Peer-to-Peer Conflict Detection — Microsoft SQL Server
[^581^] Guide to Foreground Services on Android 14 — Medium
[^582^] Schnucks Rewards App Knowledge Base
[^584^] How to Implement Last-Write-Wins — OneUptime
[^585^] Sync Conflict Handling in Offline-First PWAs — Dev.to
[^586^] Gamification in digital healthcare — F1000Research
[^588^] Foreground Service crashing on Android 14 — Stack Overflow
[^589^] Digital nudges and gamification — PMC
[^590^] GDPR for digital health — Chino.io
[^591^] Privacy Policy Compliance of Health Apps — JMIR mHealth
[^592^] Privacy of Fitness Applications — ACM
[^593^] GDPR for Gyms and Fitness — Dev.to
[^594^] Health Connect read data limits — Android Developers
[^595^] Aggregating multiple real-world data sources — PMC
[^596^] Wear OS 5 upgrades — Android Central
[^597^] Health Services on Wear OS | Android Developers
[^598^] Schnucks adds new features to mobile app — Grocery Dive
[^599^] Health & Fitness Tracking for Wear OS — Android.com
[^600^] Schnucks adds Shopping List and Wellness Guide — Grocery Insight
[^601^] Linking Rewards in Games to Exercise — Research paper
