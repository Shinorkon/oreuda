## Facet: Android Notification, Alarm & Health Integration Systems

**Research Date**: 2025-07-15
**Searches Performed**: 13 independent search queries across 12 topics
**Sources**: Android Developer Documentation, Medium technical blogs, GitHub repos, Stack Overflow, ACM research papers, arXiv, Google I/O announcements

---

## Key Findings

### AlarmManager & Exact Alarms

- **Android 14 broke SCHEDULE_EXACT_ALARM defaults**: Starting Android 14, `SCHEDULE_EXACT_ALARM` permission is **denied by default** for newly installed apps targeting Android 13+ (API 33+). Existing apps keep the permission on upgrade, but new installs and backup restores get denied. [^34^]
- **USE_EXACT_ALARM for alarm clock apps**: Calendar and alarm clock apps should declare `USE_EXACT_ALARM` (a normal permission granted at install time) rather than `SCHEDULE_EXACT_ALARM`. However, this requires Google Play review and acceptance — apps must genuinely be alarm/timer/calendar apps. [^38^] [^40^]
- **Exact alarm methods affected**: `setExact()`, `setExactAndAllowWhileIdle()`, and `setAlarmClock()` all require the permission. Calling them without permission throws `SecurityException`. [^34^]
- **setAlarmClock() is the most reliable**: Among all AlarmManager methods, `setAlarmClock()` is the most reliable — it causes the system to exit Doze mode shortly before the alarm fires, and it shows an alarm icon in the status bar. [^35^]
- **canScheduleExactAlarms() is mandatory**: Apps must check `AlarmManager.canScheduleExactAlarms()` before scheduling, and listen for `ACTION_SCHEDULE_EXACT_ALARM_PERMISSION_STATE_CHANGED` broadcast when the user grants permission. [^34^]
- **Graceful degradation required**: If permission is denied, apps should fall back to `setWindow()` (inexact alarms) or use `setAndAllowWhileIdle()` which has fewer restrictions. [^38^]

### Full-Screen Intent Notifications

- **FSI severely restricted in Android 14/15**: Full-Screen Intent notifications are now restricted to **critical use cases only** — calling and alarm apps. Play Console declarations are mandatory. Apps outside these categories don't get `USE_FULL_SCREEN_INTENT` permission by default. [^46^]
- **Manual user consent now required**: Users must explicitly enable FSI in Settings for non-alarm/non-call apps. Even with the permission, FSI only works when the device is locked — in all other cases it shows as a regular heads-up notification. [^44^] [^46^]
- **Implementation requires**: `USE_FULL_SCREEN_INTENT` permission in manifest, `setFullScreenIntent()` on NotificationBuilder, HIGH importance channel, and `showWhenLocked="true"` + `turnScreenOn="true"` on the Activity. [^41^] [^45^]
- **OEM differences matter**: Xiaomi and other OEMs disable full-screen intents by default — users must manually enable "Show on Lock screen" in app settings. [^41^]
- **Activity flags required**: For lock screen display, activities need `FLAG_SHOW_WHEN_LOCKED`, `FLAG_TURN_SCREEN_ON`, and `FLAG_KEEP_SCREEN_ON`. A `WakeLock` should be acquired for 10+ seconds. [^35^] [^41^]

### Notification Channels & Importance

- **IMPORTANCE_HIGH triggers heads-up**: Notification channels with `IMPORTANCE_HIGH` (value 2) show as heads-up notifications (floating banner) and play sound. `IMPORTANCE_DEFAULT` (value 0) shows in status bar, may or may not be heads-up. [^37^] [^39^]
- **Channel settings are immutable**: Once a notification channel is created, its importance/sound/vibration cannot be changed programmatically — only the user can change them in system Settings. To "change" settings, you must create a new channel with a different ID. [^41^]
- **Custom sounds and vibrations**: Channels support custom sound URIs, vibration patterns (e.g., `0,250,500,250`), and LED colors. Android 15 adds per-channel `VibrationEffect` for richer vibration patterns. [^39^] [^84^]
- **DND bypass capability**: Channels can be configured with `setBypassDnd(true)` to bypass Do Not Disturb, but this also requires the app's notification category to be allowed in the system's DND exception settings. [^137^]
- **Lock screen visibility**: `VISIBILITY_PUBLIC` shows full notification on lock screen, `VISIBILITY_PRIVATE` hides content, `VISIBILITY_SECRET` doesn't show at all. [^39^]

### Foreground Services

- **Foreground service types are mandatory**: Android 14+ requires every foreground service to declare a service type (e.g., `health`, `location`, `shortService`) and matching permissions. [^36^]
- **Health type foreground service**: Requires `FOREGROUND_SERVICE_HEALTH` permission in manifest, and runtime permissions like `BODY_SENSORS`, `READ_HEART_RATE`, `READ_SKIN_TEMPERATURE`, `READ_OXYGEN_SATURATION`, or `ACTIVITY_RECOGNITION`. [^36^]
- **"In-use" permission restriction**: Starting Android 14, foreground services requiring "in-use" permissions (camera, microphone, location, body sensors) cannot be created when the app is in background. Exception: if the service is started from a visible overlay or notification interaction. [^33^]
- **shortService exemption**: `FOREGROUND_SERVICE_TYPE_SHORT_SERVICE` doesn't need a type-specific permission and can run for ~3 minutes. Useful for critical alarm delivery work. [^33^]
- **Background start exemptions**: Foreground services can be started from background via: exact alarm completion, boot completed broadcast, FCM high-priority message, notification interaction, geofence trigger, or if the app has battery optimization disabled. [^33^]
- **Android 15 adds `mediaProcessing`**: New foreground service type for media transcoding tasks. [^82^]

### Health Connect API

- **40+ data types supported**: Steps, Heart Rate, Sleep Session, Exercise Session, Distance, Calories, Weight, Blood Glucose, Blood Pressure, Body Fat, Body Temperature, Hydration, Nutrition, Menstruation, Ovulation Test, Oxygen Saturation, Power, Respiratory Rate, Resting Heart Rate, Speed, Vo2Max, and more. [^33^] [^43^]
- **Android 14+ built-in**: Health Connect is included in Android 14+ as a system framework. For Android 13, users must install the Health Connect app from Play Store. [^39^]
- **Granular permissions model**: Each data type requires separate `READ_` and `WRITE_` permissions (e.g., `android.permission.health.READ_STEPS`, `android.permission.health.READ_HEART_RATE`). Permissions are requested via a dedicated Health Connect permission dialog. [^34^] [^39^]
- **30-day read limitation**: By default, apps can only read data from the past 30 days. For historical data, apps must request `PERMISSION_READ_HEALTH_DATA_HISTORY`. On Android 15+, this restriction was relaxed but still requires explicit permission. [^112^] [^114^] [^115^]
- **Own data vs other apps' data**: On Android 14+, apps can read their own written data without the 30-day limit, but data from other apps is still subject to it unless historical permission is granted. [^112^]
- **Background reading limitations**: Prior to Android 15, Health Connect does NOT sync data in background — the app must be in foreground or use a foreground service. Android 15 adds a background read permission allowing data polling every 15 minutes. [^125^]
- **Privacy requirements**: Apps must declare a privacy policy, provide a `health_permissions.xml` file, and handle permission rationale via intent filters. Screen lock must be enabled on the device. [^37^] [^39^]
- **Android 16 FHIR health records**: Android 16 adds medical records support in Health Connect using FHIR format, starting with immunization records. New permissions: `READ_MEDICAL_DATA_IMMUNIZATION`, `WRITE_MEDICAL_DATA`. [^131^] [^135^]
- **Android 16 ACTIVITY_INTENSITY**: New data type aligned with WHO guidelines for moderate and vigorous activity tracking. [^135^]

### Google Fit REST API Deprecation

- **Google Fit API shut down June 30, 2025**: All Google Fit APIs (including REST API) were deprecated. New developer sign-ups ended May 1, 2024. [^75^] [^76^] [^80^]
- **No direct REST replacement**: There is NO REST API replacement for Health Connect. Health Connect is a device-centric, on-device API only. For cloud-based integrations, Google points to the Fitbit Web API or Google Health API (OAuth-based). [^75^] [^79^]
- **Migration paths**: Steps tracking → Health Connect. History API → Google Health API. Wear OS Fit API → Health Services (PassiveMonitoringClient, ExerciseClient). [^81^]

### Calendar Integration

- **Calendar Provider API**: The built-in `CalendarContract` API allows querying events, adding events via intents, and checking availability. Direct access requires `READ_CALENDAR`/`WRITE_CALENDAR` permissions. [^120^] [^122^]
- **Intent-based approach (recommended)**: Apps can use `Intent.ACTION_INSERT` with `Events.CONTENT_URI` to create events without needing calendar permissions — it hands off to the Calendar app. [^120^] [^122^]
- **Free/busy query**: The `FreeBusyRequest` API (via Google Calendar API v3) can query busy time slots for a given time range. Events marked as `AVAILABILITY_FREE` don't show as busy time. [^121^] [^123^]
- **Event availability types**: `AVAILABILITY_BUSY` (blocks time), `AVAILABILITY_FREE` (doesn't conflict), `AVAILABILITY_TENTATIVE` (may change but considered busy). [^123^]
- **Key intent extras**: `EXTRA_EVENT_BEGIN_TIME`, `EXTRA_EVENT_END_TIME`, `EXTRA_EVENT_ALL_DAY`, `EVENT_LOCATION`, `DESCRIPTION`, `RRULE` (recurrence), `ACCESS_LEVEL`, `AVAILABILITY`. [^120^]

### Cross-App Data Sharing

- **ContentProvider pattern**: The standard Android way to share structured data between apps. One app exposes a ContentProvider; others query it with proper permissions. Used internally by Health Connect for data access. [^129^]
- **BroadcastReceiver pattern**: Apps can send broadcast intents that other apps listen for. Useful for event-driven data sharing (e.g., workout completed, alarm triggered). [^129^]
- **IntentService approach**: Wrapping data access in a Service that returns results as intents provides good privacy isolation — data stays in private storage. [^129^]
- **Health Connect as aggregator**: Health Connect eliminates the need for pairwise app integrations. Any app can read/write standardized health data through the unified API, with user-controlled permissions. [^33^] [^36^]
- **Security considerations**: File-based sharing (`MODE_WORLD_READABLE`) is deprecated due to security risks. ContentProvider with URI permissions is the recommended approach. [^129^]

### Battery Optimization & Doze Mode

- **Doze mode behavior**: When device is screen-off, unplugged, and stationary: network suspended, wake locks ignored, standard alarms batched, jobs deferred. Only `setAlarmClock()`, `setExactAndAllowWhileIdle()`, and `setAndAllowWhileIdle()` can fire. [^35^] [^47^]
- **REQUEST_IGNORE_BATTERY_OPTIMIZATIONS**: Apps can request exemption via `ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS` intent, but Google Play may reject apps that use this unless the core functionality genuinely requires it (e.g., alarm clocks). [^35^] [^38^] [^40^]
- **isIgnoringBatteryOptimizations()**: Apps can check their exemption status. Whitelisted apps can use network and hold partial wake locks during Doze, but jobs/deferred alarms still apply. [^35^]
- **App Standby Buckets**: Android assigns apps to buckets (ACTIVE, WORKING_SET, FREQUENT, RARE, RESTRICTED) based on usage. Alarms are further batched for apps in less-active buckets. [^47^]
- **setAlarmClock() is the most Doze-resistant**: Alarm clocks shown via `setAlarmClock()` are displayed in the status bar and cause the system to temporarily exit Doze. This is the recommended approach for critical alarms. [^35^]
- **OEM process killing**: Beyond Doze, OEMs (Samsung, Xiaomi, Huawei) aggressively kill background apps. `setAlarmClock()` + foreground service + battery optimization exemption is the most reliable combination. [^47^]

### Notification Fatigue Research

- **Immediate screen-on delivery backfires**: Research from HKU and Nanyang Business School found that delivering notifications immediately when the screen turns on reduces same-day app logins by ~16%. A modest delay of 1-6 minutes after screen-on shows peak engagement. [^126^]
- **Non-monotonic engagement pattern**: User engagement follows a non-monotonic curve — immediate interruption is penalized most heavily during high-stakes periods (weekday mornings). Optimal timing requires balancing intrusiveness vs. timeliness. [^126^]
- **User interruptibility categories**: Research identifies 4 interruptibility types: (1) Always available, (2) Task-prioritizing, (3) Task-content-dependent, (4) Mental-state-dependent. Optimal notification timing requires matching to user category. [^118^]
- **Temporal Interaction Model (TIM)**: A deep learning approach (Kuaishou) that models user behavior patterns across time slots using attention mechanisms. It optimizes holistic timing of multiple notifications within a day, improving engagement without excessive disruption. [^119^]
- **User-centric design reduces fatigue**: Studies show that giving users control over notification types and frequency leads to more pleasant, engaging experiences. Context-aware systems (location, activity, time) reduce unnecessary notifications. [^42^]
- **Notification cooldown in Android 15/16**: The system now automatically suppresses grouped notifications sent in rapid succession (for up to 2 minutes). Does NOT affect priority notifications like alarms and calls. [^82^] [^131^]
- **Snoozing is common**: Users frequently snooze notifications for short periods (usually under 2 days). Most snoozed: messages, calendar, social media, email. Systems that allow intelligent deferral improve user satisfaction. [^128^]

### Flutter Alarm Plugins

- **android_alarm_manager_plus**: Community-maintained plugin wrapping AlarmManager. Supports exact and repeating alarms, requires `SCHEDULE_EXACT_ALARM` permission, boot completed receiver, and `AlarmService` declaration in manifest. Limited by Android background restrictions. [^90^]
- **flutter_local_notifications**: Most popular notification plugin (7.2K likes). Supports scheduled notifications, custom sounds, vibration patterns, full-screen intents. BUT: on iOS, background execution is severely limited — no background code runs when notification fires. [^32^] [^83^]
- **awesome_notifications**: Comprehensive notification solution with full-screen intent, big picture, media notifications. 3.4K likes. Still limited by iOS background restrictions and Android 14+ exact alarm permission requirements. [^32^]
- **flutter_alarm_clock**: Lightweight wrapper around Android Clock app intents. Can create alarms/timers in the SYSTEM clock app, not within your own app. Simple but limited. [^132^]
- **fullscreen_wake_screen**: Flutter plugin to wake screen and show fullscreen UI. Useful for alarm/call scenarios — shows a route as fullscreen over lock screen. [^141^]
- **Key limitation**: No Flutter plugin can fully replicate native alarm clock behavior on both platforms. iOS fundamentally restricts background code execution on notification delivery. Most serious alarm apps use platform channels with native Android implementation. [^83^] [^143^]
- **alarm package**: A newer Flutter package that attempts cross-platform alarm functionality. Limited by the same iOS background restrictions. [^83^]
- **Practical recommendation**: For ARISE's aggressive alarm requirements, a hybrid approach is needed — Flutter for UI, native Android service for alarm scheduling and delivery, with MethodChannel communication.

### Android 15 New Features

- **Notification vibration per channel**: Android 15 supports `NotificationChannel.setVibrationEffect()` for richer, per-channel vibration patterns. Users can distinguish notification types by vibration feel. [^84^] [^89^]
- **Notification cooldown**: System automatically suppresses rapid successive notifications from the same app, lowering sound and minimizing alerts for up to 2 minutes. Does NOT affect calls/alarms. [^82^] [^131^]
- **Improved Do Not Disturb rules**: `AutomaticZenRule` enhancements allow apps to create custom DND modes with icons, trigger descriptions, and `ZenDeviceEffects` (grayscale, night mode, dim wallpaper). [^84^] [^89^]
- **Target API 35 required**: New apps must target Android 15 (API 35) by August 2025. [^82^]
- **FLAG_STOPPED state changes**: Pending intents are now cancelled when an app enters the stopped state, preventing stale alarms from firing after force-stop. [^82^]
- **New foreground service type**: `mediaProcessing` for transcoding tasks. [^82^]
- **Audio focus restrictions**: Apps targeting API 35 must be in foreground or have an audio foreground service to request audio focus. [^82^]
- **LoudnessCodecController**: New API for normalizing audio loudness between tracks (CTA-2075 standard). [^82^]

### Android 16 New Features (Future-Proofing)

- **Health Connect FHIR support**: Apps can read/write medical records in FHIR format (starting with immunizations). Requires early access program approval. [^131^] [^135^] [^136^]
- **Health Connect background read**: Android 15+ allows apps to read Health Connect data in background every 15 minutes with new background read permission. [^125^]
- **Notification force-grouping**: Android 16 defaults to bundling notifications from the same app. [^131^]
- **Progress-centric notifications**: New notification type for tracking user-initiated processes from start to finish — higher visibility in notification drawer. [^138^]
- **Rich Ongoing Notifications**: Potential new API for status bar chips (similar to iOS Dynamic Island) showing ongoing activity info. [^135^]
- **Do Not Disturb → Priority Mode**: DND being rebranded as "Priority Mode" with more customization options and dedicated Quick Settings tiles. [^135^]
- **Notification cooldown**: Carried forward from Android 15 — rapid notification bursts are dampened. [^131^]
- **Two API releases in 2025**: Q2 (Android 16, with behavior changes) and Q4 (new APIs only, no behavior changes). [^138^]

---

## API Capability Matrix

| API/Feature | Capability | Limitations | Android Version |
|---|---|---|---|
| AlarmManager.setExact() | Fire at precise time | Batched in Doze; requires SCHEDULE_EXACT_ALARM | 4.4+ (restricted 12+) |
| AlarmManager.setExactAndAllowWhileIdle() | Fire in Doze/low-power mode | 10s wake lock exemption only; requires exact alarm permission | 6.0+ (restricted 12+) |
| AlarmManager.setAlarmClock() | Most reliable; shows in status bar | User-visible alarm icon; still needs permission | 4.4+ (restricted 12+) |
| AlarmManager.setAndAllowWhileIdle() | Inexact alarm in Doze | Not exact — batched to maintenance windows | 6.0+ |
| Full-Screen Intent Notification | Show UI over lock screen | Android 14+: alarm/call apps only; Play Console declaration | 9+ (severely restricted 14+) |
| USE_FULL_SCREEN_INTENT | Permission for FSI | Must declare use case in Play Console; user can disable | 14+ |
| NotificationChannel (HIGH) | Heads-up notification | Channel settings immutable after creation | 8.0+ |
| NotificationChannel.setBypassDnd() | Bypass Do Not Disturb | Requires DND exception category enabled by user | 8.0+ |
| Foreground Service (health type) | Background health data access | Requires BODY_SENSORS or specific read permissions | 14+ |
| Foreground Service (shortService) | 3-min critical work | Cannot start other FGS; non-sticky; timeout = ANR | 14+ |
| Health Connect API | Unified health data read/write | 30-day history limit; background read limited pre-15 | 13+ (system 14+) |
| PERMISSION_READ_HEALTH_DATA_HISTORY | Read data older than 30 days | Must be explicitly requested; feature-availability check needed | 15+ |
| Health Connect background read | Polling every 15 min | New permission in Android 15; requires foreground service pre-15 | 15+ |
| REQUEST_IGNORE_BATTERY_OPTIMIZATIONS | Partial Doze exemption | Google Play may reject apps using this | 6.0+ |
| Calendar Provider API | Read/write calendar events | Requires permissions; intent-based approach recommended | 4.0+ |
| FreeBusyRequest (Google Calendar API) | Query busy time slots | Requires Google account + OAuth; network call | All (API v3) |
| WakeLock (PARTIAL) | Keep CPU running | Ignored in Doze unless app is whitelisted | All |
| WakeLock (SCREEN_BRIGHT) | Wake and turn on screen | Requires WAKE_LOCK permission; acquire for 10+ seconds | All |
| PowerManager.isIgnoringBatteryOptimizations() | Check whitelist status | User-controllable; not guaranteed | 6.0+ |
| SYSTEM_ALERT_WINDOW | Draw over other apps | Can start FGS from background; special permission | All |

---

## Permission Requirements

| Feature | Permissions Needed | Special Requirements |
|---|---|---|
| Exact Alarms (general apps) | `SCHEDULE_EXACT_ALARM` | Runtime permission; denied by default on 14+; must check `canScheduleExactAlarms()` |
| Exact Alarms (alarm/clock apps) | `USE_EXACT_ALARM` | Normal permission; requires Google Play review; must genuinely be alarm app |
| Full-Screen Intent | `USE_FULL_SCREEN_INTENT` | Play Console declaration mandatory; alarm/call apps only on 14+ |
| Foreground Service (health) | `FOREGROUND_SERVICE`, `FOREGROUND_SERVICE_HEALTH` | Plus one of: BODY_SENSORS, READ_HEART_RATE, ACTIVITY_RECOGNITION |
| Foreground Service (short) | `FOREGROUND_SERVICE` | No type-specific permission; 3-minute timeout |
| Health Connect Read Steps | `android.permission.health.READ_STEPS` | Per-data-type permission; user grants via Health Connect dialog |
| Health Connect Read Heart Rate | `android.permission.health.READ_HEART_RATE` | Same pattern for all 40+ data types |
| Health Connect Historical Data | `PERMISSION_READ_HEALTH_DATA_HISTORY` | Feature availability check required; Android 15+ |
| Health Connect Background Read | Background read permission (Android 15+) | Foreground service required pre-Android 15 |
| Read Calendar | `android.permission.READ_CALENDAR` | Dangerous permission; runtime request needed |
| Write Calendar | `android.permission.WRITE_CALENDAR` | Dangerous permission; runtime request needed |
| Battery Optimization Exemption | `REQUEST_IGNORE_BATTERY_OPTIMIZATIONS` | Google Play may reject; use only if core functionality requires it |
| Wake Lock | `android.permission.WAKE_LOCK` | Normal permission; ignored in Doze unless whitelisted |
| Post Notifications | `android.permission.POST_NOTIFICATIONS` | Runtime permission on Android 13+ |
| Activity Recognition | `android.permission.ACTIVITY_RECOGNITION` | For fitness data; runtime permission |
| Body Sensors | `android.permission.BODY_SENSORS` | For heart rate etc.; runtime permission; "in-use" restriction |
| System Alert Window | `SYSTEM_ALERT_WINDOW` | Special permission; draw over other apps; can bypass FGS restrictions |

---

## Best Practices & Anti-Patterns

### Best Practices

1. **Use setAlarmClock() for critical alarms**: It is the most Doze-resistant method, causes system to exit Doze early, and shows a visible alarm icon in the status bar. [^35^]

2. **Always check canScheduleExactAlarms() before scheduling**: On Android 12+, calling exact alarm APIs without permission throws `SecurityException`. Check in `onResume()` as well since user may change permission in Settings. [^34^]

3. **Listen for permission changes**: Register a receiver for `ACTION_SCHEDULE_EXACT_ALARM_PERMISSION_STATE_CHANGED` to re-schedule alarms when the user grants permission. [^34^]

4. **Use NotificationChannel with IMPORTANCE_HIGH**: For alarm notifications, use HIGH importance for heads-up display. Set custom sound, vibration pattern, and `setBypassDnd(true)`. [^37^] [^41^]

5. **Acquire WakeLock for 10+ seconds**: When alarm fires, acquire a `SCREEN_BRIGHT_WAKE_LOCK` for at least 10 seconds to ensure the activity fully starts before the system can sleep again. [^35^]

6. **Implement graceful degradation**: If exact alarm permission is denied, fall back to `setWindow()` (inexact) or guide the user to Settings. Don't crash. [^38^]

7. **Use Health Connect for health data**: It's the future-proof, Google-endorsed path. 40+ data types, unified permissions, on-device storage. Migration from Google Fit is mandatory anyway. [^75^] [^81^]

8. **Request historical data permission early**: If you need more than 30 days of health data, request `PERMISSION_READ_HEALTH_DATA_HISTORY` at onboarding. Check feature availability first. [^115^]

9. **Test on real devices, not just emulators**: OEM-specific process management (Samsung, Xiaomi) can break alarms that work on Pixel. Test across manufacturers. [^47^]

10. **Optimize notification timing with delay**: Research shows a 1-6 minute delay after screen-on events maximizes engagement vs. immediate delivery. [^126^]

### Anti-Patterns

1. **Don't use REQUEST_IGNORE_BATTERY_OPTIMIZATIONS lightly**: Google Play's automated review may reject apps with this permission unless the core functionality genuinely requires it (e.g., alarm clocks). [^38^] [^40^]

2. **Don't assume FSI works on all devices**: Xiaomi, Oppo, Vivo disable full-screen intents by default. Always provide a fallback notification path. [^41^]

3. **Don't use Foreground Service for long-polling Health Connect pre-Android 15**: Background reading wasn't supported before Android 15. Use foreground service only when necessary. [^125^]

4. **Don't rely on Google Fit REST API**: It's shut down as of June 2025. No direct REST replacement exists. Plan for Health Connect (on-device) or Fitbit Web API (cloud). [^75^] [^79^]

5. **Don't create notification channels with changing configs**: Channels are immutable. If you need different settings, create a new channel with a different ID. [^41^]

6. **Don't schedule alarms without checking permission on every app start**: Permissions can be revoked at any time. Always verify before rescheduling. [^34^]

7. **Don't assume iOS can do the same alarm behavior**: iOS fundamentally restricts background code execution when notifications fire. Cross-platform alarm apps need platform-specific implementations. [^83^]

---

## Recommended Deep-Dive Areas

### 1. Native Android Alarm Service with Flutter UI
**Why it matters**: Flutter plugins alone cannot achieve the aggressive alarm behavior ARISE requires. A native Android `Service` + `AlarmManager` with Flutter UI overlay via MethodChannel is the only reliable architecture for exact alarm delivery that survives Doze and OEM process killing. [^83^] [^143^]

### 2. Health Connect Background Data Sync Architecture
**Why it matters**: ARISE needs to read steps, sleep, and heart rate data to determine optimal intervention timing. On Android <15, this requires a foreground service. On Android 15+, a new background read permission enables 15-minute polling. The architecture must handle both paths. [^125^]

### 3. Do Not Disturb / Priority Mode Interaction
**Why it matters**: ARISE's intervention notifications must bypass DND to be effective. Android 15+ enhanced `AutomaticZenRule` allows creating custom DND modes. Understanding DND bypass + notification channel `setBypassDnd()` + alarm category classification is critical for reliable delivery. [^89^] [^137^]

### 4. Notification Timing Intelligence Engine
**Why it matters**: Research shows immediate notification delivery backfires (-16% engagement). ARISE should implement a Temporal Interaction Model-like approach — using screen-on patterns, historical engagement data, and contextual signals to compute optimal delivery windows (1-6 min delay after screen-on). [^119^] [^126^]

### 5. OEM-Specific Alarm Reliability Testing
**Why it matters**: Samsung (One UI), Xiaomi (MIUI), Oppo (ColorOS) all implement aggressive battery optimization that can break standard AlarmManager behavior. A comprehensive test matrix across OEMs is essential. Consider `setAlarmClock()` + battery whitelist + foreground service as the most reliable combination. [^47^]

### 6. Android 15+ Notification Cooldown Impact
**Why it matters**: Android 15's notification cooldown automatically suppresses rapid successive notifications. ARISE must ensure intervention alarms are classified as priority (alarm category) to avoid being caught by cooldown grouping. [^82^] [^131^]

### 7. Calendar Free-Time Slot Detection
**Why it matters**: ARISE needs to find "free time" windows for interventions. The Calendar Provider API can query events, and `AVAILABILITY_FREE` events don't block time. Combining calendar data with Health Connect activity data enables intelligent intervention scheduling. [^120^] [^123^]

### 8. Health Connect to Calendar Data Pipeline
**Why it matters**: The most powerful ARISE feature would correlate health data (poor sleep, low steps) with calendar free time to proactively suggest interventions. This requires a pipeline: Health Connect read → aggregate analysis → calendar free-time query → alarm scheduling → full-screen intent delivery.

---

## Sources Summary

| # | Source | Topic |
|---|---|---|
| [^34^] | Android Developer Docs | SCHEDULE_EXACT_ALARM Android 14 changes |
| [^35^] | Android Developer Docs | Doze mode and AlarmManager behavior |
| [^36^] | Android Developer Docs | Foreground service types (health) |
| [^37^] | Pushwoosh Documentation | Notification importance levels |
| [^38^] | HackMD / Code with DH | Android 14 AlarmManager permission crash |
| [^39^] | PushAlert Documentation | Notification channel configuration |
| [^40^] | ProAndroidDev | Battery optimization and Doze |
| [^41^] | Victor Brandalise Blog | Full-screen intent on lock screen |
| [^42^] | IJPREMS Research Paper | Notification fatigue studies |
| [^43^] | Flutter health package docs | Health Connect data types reference |
| [^44^] | Stack Overflow | FSI not opening on Android 14 |
| [^45^] | Giorgos Neokleous Blog | Full-screen intent notifications |
| [^46^] | ProAndroidDev | FSI changes Android 14 & 15 |
| [^47^] | ProAndroidDev | Beyond Doze: background execution |
| [^75^] | Android Developer Docs | Google Fit Migration FAQ |
| [^76^] | Spike API Blog | Google Fit shutdown migration |
| [^79^] | Stack Overflow | Fit REST API replacement |
| [^80^] | Ars Technica | Google Fit API shutdown news |
| [^81^] | Android Developer Docs | Fit migration guide |
| [^82^] | Medium (Ali Alam) | Android 15 developer guide |
| [^83^] | Stack Overflow | Flutter alarm background task |
| [^84^] | Android Developer Docs | Android 15 features |
| [^89^] | Android Developer Docs | Android 15 DND rules |
| [^90^] | Bomberbot Blog | Alarm Manager Plus Flutter |
| [^112^] | Android Developer Docs | Health Connect read restrictions |
| [^114^] | GitHub Issue | Health Connect 30-day history |
| [^115^] | Stack Overflow | 30-day restriction workaround |
| [^118^] | ACM Automotive UI | Interruptibility study |
| [^119^] | arXiv/ICMR | Temporal Interaction Model |
| [^120^] | MIT AFS / Android Docs | Calendar Provider API |
| [^121^] | Stack Overflow | FreeBusy API usage |
| [^125^] | Validic Docs | Health Connect background read |
| [^126^] | HKU Research Seminar | Push notification timing |
| [^128^] | PMC/NIH | Notification interaction delay |
| [^129^] | Stack Overflow | Cross-app data sharing |
| [^131^] | Wikipedia / Android Authority | Android 16 features |
| [^132^] | pub.dev | flutter_alarm_clock plugin |
| [^135^] | Android Authority | Android 16 confirmed features |
| [^137^] | Stack Overflow | Bypass Do Not Disturb |
| [^141^] | pub.dev | fullscreen_wake_screen plugin |
| [^143^] | GitHub Flutter Issue | Alarm manager wakelock request |

---

*Document generated for ARISE technical foundation research. Cross-reference with landscape scan (arise_wide01.md) for Phase 1 context.*
