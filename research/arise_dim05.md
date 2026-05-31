## Dimension 05: Notification & Alarm System Architecture

### Research Summary

This document outlines the architecture for ARISE's aggressive, psychologically effective notification system. The system is designed to be un-ignorable while preventing notification fatigue through intelligent escalation, timing optimization, and gamified snooze mechanics. All findings are derived from 20+ targeted searches across Android developer documentation, OEM-specific behavior analyses, Flutter plugin documentation, and behavioral psychology research.

---

### Alarm Delivery Architecture

| Component | Technology | Reliability Rating | Notes |
|---|---|---|---|
| Primary Alarm Engine | `AlarmManager.setAlarmClock()` + `RTC_WAKEUP` | 9.5/10 | Most reliable API; system exits Doze mode before firing; shows status bar clock icon [^47^][^509^] |
| Fallback Exact Alarm | `AlarmManager.setExactAndAllowWhileIdle()` | 7/10 | Requires `SCHEDULE_EXACT_ALARM` permission; denied by default on Android 14+ [^419^][^425^] |
| Periodic Checks | `WorkManager` (15-min flex intervals) | 6/10 | For non-critical sync; batched by Doze; minimum 15-min interval [^419^] |
| Flutter Bridge | `MethodChannel` (Native Android Service) | 9/10 | Native Kotlin service handles alarms; broadcasts to Flutter via EventChannel |
| Background Execution | Foreground Service (`alarmClock` type) | 8.5/10 | Android 14+ requires declared `foregroundServiceType`; 6hr daily cap on `dataSync` in Android 15 [^482^] |
| Permission Model | `USE_EXACT_ALARM` (Play Store reviewed) | 9/10 | Auto-granted at install for alarm apps; requires Play Console declaration [^419^][^426^] |
| Boot Rescheduling | `BOOT_COMPLETED` + `QUICKBOOT_POWERON` receivers | 8/10 | Both events needed; alarms cleared on reboot; must re-persist from local DB [^478^] |
| Wake Lock | Partial `WakeLock` (10-15s in `onReceive()`) | 7/10 | Prevents mid-execution stall; release immediately after TTS/sound completes [^509^] |

**Key Architecture Decision**: ARISE should declare itself as an **alarm app** in Play Console to qualify for `USE_FULL_SCREEN_INTENT` and `USE_EXACT_ALARM` permissions [^424^]. This avoids the user-permission gate that kills `SCHEDULE_EXACT_ALARM` by default on Android 14+ [^419^].

**Native Service Flow**:
```
[Kotlin AlarmService] → AlarmManager.setAlarmClock() → BroadcastReceiver →
WakeLock.acquire() → MethodChannel.invokeMethod("alarmFired") →
Flutter layer decides notification type → flutter_local_notifications.show()
→ WakeLock.release()
```

---

### Notification Type Catalog

| Type | Trigger | UI Style | Sound | Priority | Channel |
|---|---|---|---|---|---|
| **Morning Briefing** | Scheduled (user wake time + 5 min) | BigText with quest summary | Custom ascending chime (10s crescendo) | `IMPORTANCE_HIGH` (heads-up) | `arise_morning` |
| **Quest Countdown** | T-minus 30 min before deadline | BigText + progress bar | Subtle ticking alert | `IMPORTANCE_DEFAULT` | `arise_countdown` |
| **Quest Warning** | T-minus 10 min before deadline | BigText + action buttons (START / SNOOZE) | Firm two-tone alert | `IMPORTANCE_HIGH` | `arise_warning` |
| **Penalty Notice** | Quest deadline missed | Full-screen intent (if permitted) or heads-up | Harsh descending tone + long vibration | `IMPORTANCE_HIGH` + `setBypassDnd(true)` | `arise_critical` |
| **Streak Alert** | Daily streak at risk (uncompleted by cutoff) | BigPicture (flame icon) + BigText | Victory chime or loss warning tone | `IMPORTANCE_HIGH` | `arise_streak` |
| **Milestone Celebration** | Achievement unlocked | BigPicture (confetti animation) | Celebration sound (unique per tier) | `IMPORTANCE_DEFAULT` | `arise_reward` |
| **Nuclear Option** | Multiple missed quests + streak break | Full-screen alarm UI + persistent sound | Alarm clock sound (non-stop until acknowledged) | `IMPORTANCE_MAX` + `setBypassDnd(true)` | `arise_nuclear` |
| **Companion Nudge** | Predicted low-motivation window | Messaging-style (companion avatar) | Soft spoken phrase (TTS) | `IMPORTANCE_LOW` | `arise_companion` |

**Channel Configuration Strategy**:
- All critical channels (`arise_critical`, `arise_nuclear`) declare `setBypassDnd(true)` on creation [^436^]
- Channels are **immutable after creation** — design importance levels carefully upfront [^432^]
- Each channel uses a unique vibration pattern (see Sound & Vibration Design section)

---

### Escalation Matrix

| Time Before Deadline | Notification Style | Message Tone | Sound Profile | Vibration |
|---|---|---|---|---|
| **> 2 hours** | Silent in-app countdown only | Neutral | None | None |
| **30 minutes** | Heads-up notification, dismissible | Helpful: *"Your quest begins in 30 minutes. Prepare."* | Soft single chime | Short double-tap |
| **10 minutes** | Heads-up with action buttons | Firm: *"10 minutes. Start now or begin your descent."* | Firm two-tone pulse | Medium burst (3 pulses) |
| **5 minutes** | Non-dismissible heads-up | Urgent: *"5 minutes. The clock is not your friend."* | Escalating alert (volume rises) | Long pattern (5 pulses) |
| **1 minute** | Full-screen intent (if permitted) | Command: *"1 minute. Execute or face consequences."* | Aggressive alarm tone | Intense vibration + sound |
| **Deadline reached** | Full-screen takeover + persistent alarm | Final: *"QUEST FAILED. Penalty applied."* | Continuous alarm (must acknowledge) | Non-stop vibration until tap |
| **Post-deadline** | Penalty summary notification | Loss-aversion: *"3-day streak lost. 50 XP deducted."* | Harsh descending tone | Heavy double-buzz |

**Escalation Principles** (derived from incident response best practices [^455^][^456^][^459^]):
1. **Limit to 4 escalation levels max** — deeper chains diffuse accountability [^459^]
2. **Progressive acknowledgment required** — each level must be explicitly acknowledged or it escalates
3. **Multi-channel redundancy** — visual + sound + vibration simultaneously for critical tiers
4. **Timeout-based escalation** — each tier has a strict timeout (3 min for nuclear, 10 min for urgent) [^455^]

---

### Full-Screen Implementation

| Requirement | Solution | Android Version Compatibility |
|---|---|---|
| Alarm-style full-screen wake | `Notification.Builder.setFullScreenIntent()` + `USE_FULL_SCREEN_INTENT` | Android 14+ (restricted to alarm/call apps only) [^418^][^46^] |
| Play Console declaration | Declare app as "Alarm" core functionality in Play Console FSI declaration | Required for auto-grant [^424^] |
| Runtime permission check | `NotificationManager.canUseFullScreenIntent()` before sending FSI | Android 14+ (API 34+) [^418^] |
| User-directed permission enable | `ACTION_MANAGE_APP_USE_FULL_SCREEN_INTENT` intent to settings | Android 14+ [^421^] |
| Xiaomi FSI workaround | FSI disabled by default on MIUI; guide user to enable in notification settings | MIUI 12+ [^41^] |
| Fallback (no FSI permission) | Heads-up notification (`IMPORTANCE_HIGH`) + wake screen (`FLAG_SCREEN_ON`) | All versions |
| Alternative full-screen wake | Start Activity with `FLAG_ACTIVITY_NEW_TASK` + `FLAG_ACTIVITY_EXCLUDE_FROM_RECENTS` + `FLAG_SCREEN_ON` from `BroadcastReceiver` | All versions (less reliable than FSI) |
| **ARISE Strategy** | Declare as alarm app → auto-grant FSI → use `setAlarmClock()` (exits Doze) → FSI for nuclear tier only → heads-up fallback | Android 10+ |

**Full-Screen Activity Architecture**:
```kotlin
// In BroadcastReceiver.onReceive()
val fullScreenIntent = Intent(context, AlarmActivity::class.java).apply {
    flags = Intent.FLAG_ACTIVITY_NEW_TASK or 
            Intent.FLAG_ACTIVITY_EXCLUDE_FROM_RECENTS or
            Intent.FLAG_ACTIVITY_CLEAR_TOP
    putExtra("quest_id", questId)
    putExtra("escalation_level", escalationLevel)
}
// Wake lock ensures screen turns on
val powerManager = context.getSystemService(Context.POWER_SERVICE) as PowerManager
val wakeLock = powerManager.newWakeLock(
    PowerManager.FULL_WAKE_LOCK or PowerManager.ACQUIRE_CAUSES_WAKEUP,
    "ARISE:AlarmWake"
)
wakeLock.acquire(30*1000L) // 30 seconds
context.startActivity(fullScreenIntent)
```

---

### Timing Intelligence Algorithm

| Factor | Weight | Data Source |
|---|---|---|
| **Historical quest start time** | 30% | Local SQLite: average completion time for this quest type over last 30 days |
| **Morning wake pattern** | 20% | First phone unlock time (captured via `UsageStatsManager`) or Health Connect sleep data |
| **Notification open time** | 15% | Which notifications the user historically taps (time-of-day histogram) |
| **Day-of-week pattern** | 15% | Quest completion rates by day (weekends vs weekdays often differ significantly) |
| **Current app usage context** | 10% | Is the user actively using the phone? (check `UsageStatsManager` last 5 min) |
| **Battery level** | 5% | Avoid notifications below 5% battery (defer to charge) |
| **DND status** | 5% | `NotificationManager.getCurrentInterruptionFilter()` — respect unless nuclear tier |

**ML Model (On-Device)**:
- Lightweight decision tree or TensorFlow Lite model
- Retrained weekly based on user behavior
- Predicts optimal notification time within a 30-minute window
- Based on proven Send Time Optimization approaches: personalized best time outperforms generic timing by 52% match rate [^514^]

**Smart Timing Rules**:
- Morning briefing: Predicted wake time + 5 minutes (fitness apps see highest engagement at 7-8am with 7.3% rate)
- Pre-quest reminders: Predicted optimal engagement window, NOT fixed schedule
- Post-quest celebration: Immediate (strike while motivation is high)
- Streak warnings: 2 hours before daily cutoff (gives time to act)

---

### Sound & Vibration Design

| Tier | Sound Design | Vibration Pattern | Implementation |
|---|---|---|---|
| **Morning Briefing** | Custom ascending chime (C4→C5, 10s crescendo) | Gentle wave pattern | `VibrationEffect.createWaveform(longArrayOf(0, 200, 100, 200, 100, 400), intArrayOf(50, 100, 80, 120, 80, 200), -1)` [^479^] |
| **Countdown** | Single subtle blip | Short tap (50ms) | `VibrationEffect.createOneShot(50, VibrationEffect.DEFAULT_AMPLITUDE)` |
| **Warning** | Two-tone alert (A4→E5) | Medium burst: 3 pulses of 200ms | `VibrationEffect.createWaveform(longArrayOf(0, 200, 150, 200, 150, 200), -1)` |
| **Critical/Penalty** | Harsh descending tone (D5→A3) | Heavy 5-pulse pattern | `VibrationEffect.createWaveform(longArrayOf(0, 300, 100, 300, 100, 300, 100, 300, 100, 500), intArrayOf(255, 255, 200, 255, 200, 255, 200, 255, 200, 255), -1)` |
| **Nuclear** | Continuous alarm (must acknowledge) | Non-stop repeating pattern until tap | Looping vibration with `VibrationEffect.createWaveform()` + handler repeat [^479^] |
| **Milestone** | Unique celebration sound per tier | Fireworks-style escalating pattern | Custom sound file per achievement tier |
| **Companion** | Text-to-Speech (whisper voice) | Gentle single pulse | TTS: "*Hey... your quest is waiting*" + 100ms pulse |

**Design Principles**:
- All sounds are **custom** — never use system default notification sounds
- Sounds are designed to feel like they come from "the System" — clinical, authoritative, slightly dystopian
- Vibration patterns are unique per channel so users learn to identify urgency by feel alone [^473^][^476^]
- For Android O+, play sound/vibration manually via foreground service to bypass channel restrictions [^479^]

---

### Do Not Disturb Strategy

| DND Mode | ARISE Behavior | Implementation |
|---|---|---|
| **Total Silence** | Only nuclear tier (streak break) bypasses | Channel-level `setBypassDnd(true)` on `arise_nuclear` channel [^432^][^436^] |
| **Alarms Only** | All alarm-category notifications pass through | Set notification category to `NotificationCategory.Alarm` [^432^] |
| **Priority Only** | Critical + nuclear bypass; others queue | `setBypassDnd(true)` on `arise_critical` and `arise_nuclear` channels |
| **DND Off** | All notifications fire normally | Standard behavior |

**Critical Quest Deadline Handling**:
- For quest deadlines with < 10 minutes remaining: **always bypass DND** regardless of user setting
- This requires `ACCESS_NOTIFICATION_POLICY` permission to detect and modify DND state [^432^]
- If user has disabled all ARISE notifications, show a **local on-screen alert** when app is opened next (cannot be disabled)

---

### Snooze Mechanics

| Snooze Count | Cost | Delay | Sound on Re-trigger | Visual Indicator |
|---|---|---|---|---|
| **1st** | Free | 5 minutes | Same as original | "Snoozed" badge |
| **2nd** | -5 XP | 3 minutes | Slightly more urgent | "-5 XP" shown |
| **3rd** | -15 XP | 2 minutes | Escalated tone | "-15 XP" shown + warning color |
| **4th** | -30 XP + streak warning | 1 minute | Critical alert | "STREAK AT RISK" banner |
| **5th+** | Penalty applied (quest failed) | N/A | Penalty notification | Red failure screen |

**Snooze Design Principles** (based on loss aversion psychology [^461^][^337^]):
- **Free first snooze** — reduces friction, gets user used to the button
- **Escalating XP cost** — leverages loss aversion; users feel XP loss more intensely than equivalent gain [^461^]
- **Streak warning at 4th** — "Don't break your streak" is emotionally powerful; Apple Watch users report compulsion and guilt around incomplete rings [^337^]
- **No infinite snooze** — hard cap at 4 before auto-fail prevents procrastination loops
- **Progressive cost visibility** — always show the cost BEFORE user confirms snooze

**Snooze UI Pattern**:
```
[SNOOZE] button long-press reveals:
  "Snooze? (5 min delay)
   Cost: -5 XP
   Streak risk if snoozed again"
```

---

### Battery Optimization & OEM Reliability Matrix

| OEM | Restrictions | Workarounds | Detection Code |
|---|---|---|---|
| **Samsung (One UI 4.0+)** | "Put apps to sleep" default ON; foreground services killed after 20 min of screen-off; "Deep sleeping apps" block all background work [^471^][^481^] | Guide user through: Settings → Battery → Background usage limits → Disable "Put unused apps to sleep" → Remove app from Sleeping + Deep sleeping lists | `Build.MANUFACTURER.contains("samsung")` |
| **Xiaomi (MIUI 12+)** | "Autostart" permission required (not standard Android); apps killed 5 min after screen-off; Battery Saver blocks ALL background BLE/alarms [^431^][^471^] | Force user to enable Autostart during onboarding; show device-specific tutorial with screenshots; detect MIUI and show guided flow | `Build.MANUFACTURER.contains("xiaomi")` ||
| **OnePlus (OxygenOS 11+)** | "Intelligent Control" silently kills background services; battery optimization dialog buried 4 menus deep [^431^] | Show full-screen interstitial with step-by-step; use `isIgnoringBatteryOptimizations()` to detect restriction state | `Build.MANUFACTURER.contains("oneplus")` |
| **OPPO/Realme (ColorOS)** | Requires battery optimization exemption + "Startup Manager" permission; background scanning limited to 10 min [^431^] | No programmatic workaround; must educate users in onboarding with manufacturer-specific screenshots | `Build.MANUFACTURER.contains("oppo") \|\| Build.MANUFACTURER.contains("realme")` |
| **Google Pixel** | Reference implementation; most reliable for alarms | Minimal workarounds needed; standard `REQUEST_IGNORE_BATTERY_OPTIMIZATIONS` sufficient | `Build.MANUFACTURER.contains("google")` |

**Samsung-Specific Onboarding (Critical)**:
Samsung users show 43% 7-day churn without battery exemption guidance; this drops to 29% with guided setup [^471^]. ARISE **must** implement:
1. Manufacturer detection on first launch
2. Full-screen guided tutorial with Samsung-specific screenshots
3. Deep-link to exact settings page using `android.settings.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS`
4. Verification check that shows confirmation screen after user completes steps

**Keep-Alive Mechanism**:
- Schedule `WorkManager` job every 15 minutes to "poke" the alarm service [^431^]
- This absurd workaround actually works on Samsung/Xiaomi where foreground services get killed
- Use `setAlarmClock()` to force system to prioritize ARISE alarms over OEM battery optimization

---

### Notification Fatigue Prevention

| Strategy | Implementation | Data Source |
|---|---|---|
| **Frequency cap** | Max 5 push notifications per week (non-dismissible count only) | 64% of users may stop using an app if they receive more than 5 push notifications per week [^458^] |
| **Event-based > Scheduled** | Trigger notifications based on user actions (quest started, streak at risk) rather than fixed times | Event-based notifications outperform scheduled by significant margin [^78^][^85^] |
| **Smart batching** | Morning briefing consolidates all daily quest info into ONE notification | Reduces notification count while maintaining information density |
| **Companion mode toggle** | User can reduce companion nudge frequency from "Frequent" to "Minimal" to "System Only" | Respects user preference gradient |
| **Cool-down period** | After a nuclear-level alert, suppress all non-critical notifications for 30 minutes | Prevents emotional overload after penalty |
| **Notification value audit** | Every notification must contain ACTIONABLE value (start quest, protect streak) — no "engagement" pings | Empty notifications are the #1 cause of disable actions |
| **Disable detection** | If user disables notification channel, show in-app dialog explaining exactly what they'll miss | Last-chance retention before they leave |
| **Weekend reduction** | Reduce notification frequency by 50% on weekends (unless streak at risk) | Users are more tolerant of weekday nudges |

**Android 15 Notification Cooldown Impact** [^502^][^504^][^505^]:
- Android 15+ automatically lowers volume for burst notifications from same app
- ARISE must space notifications **> 2 minutes apart** to avoid cooldown suppression
- Alarms and priority conversations are EXEMPT from cooldown — use `NotificationCategory.Alarm` for critical notifications
- The cooldown lasts for 2 minutes; plan escalation timing accordingly

---

### Android 15/16 Changes Impact

| Change | Impact on ARISE | Mitigation |
|---|---|---|
| **Notification Cooldown (Android 15)** | Burst notifications get volume-reduced | Space escalation notifications > 2 min apart; use Alarm category for exemptions [^502^][^504^] |
| **Adaptive Vibration (Pixel)** | Vibration strength auto-adjusts per environment | Design patterns to work at both high and low intensity; test on Pixel devices [^503^] |
| **6-hour cap on `dataSync` FGS (Android 15)** | Background sync service limited | Use `alarmClock` foreground service type instead; not subject to cap [^482^] |
| **`BOOT_COMPLETED` FGS restrictions (Android 15)** | Some FGS types can't start from boot receiver | Start alarm rescheduling from `BroadcastReceiver`, not FGS; alarmClock type exempt |
| **Notification channel cooldown** | Repeated notifications from same app muted | Ensure each escalation tier uses different notification ID |
| **Modes expansion (Android 15)** | DND becomes full "Modes" system | Integrate with Modes API to respect Work/Sleep modes appropriately [^503^] |
| **STRICT_FOREGROUND_SERVICE_EXEMPTION (Android 15)** | Forces OEMs to respect FGS exemptions | Declare in manifest; won't fix OEM issues for 18+ months due to slow adoption [^431^] |

---

### Flutter Integration Stack

| Plugin | Purpose | Notes |
|---|---|---|
| `flutter_local_notifications` | Primary notification display | Use ONE plugin only; incompatible with awesome_notifications [^430^] |
| `android_alarm_manager_plus` | Exact alarm scheduling | oneShotAt/periodic; requires SCHEDULE_EXACT_ALARM handling [^472^][^478^] |
| `permission_handler` | Runtime permission requests | SCHEDULE_EXACT_ALARM, POST_NOTIFICATIONS, ACCESS_NOTIFICATION_POLICY |
| `timezone` + `flutter_timezone` | TZ-aware scheduling | Required for flutter_local_notifications zonedSchedule [^430^] |
| `MethodChannel` (custom) | Native alarm service ↔ Flutter | Kotlin service triggers Dart callbacks via platform channel |
| `shared_preferences` | Alarm persistence queue | Store alarm metadata; re-persist on BOOT_COMPLETED |

**Why NOT awesome_notifications**: While awesome_notifications supports full-screen notifications and critical alerts [^432^], it is **explicitly incompatible** with flutter_local_notifications. Both plugins compete for the same native resources [^430^]. ARISE should use `flutter_local_notifications` for notifications + custom Kotlin service for alarm handling via `MethodChannel`.

**Recommended pubspec.yaml**:
```yaml
dependencies:
  flutter_local_notifications: ^18.0.0
  android_alarm_manager_plus: ^4.0.0
  permission_handler: ^11.0.0
  timezone: ^0.10.0
  flutter_timezone: ^3.0.0
```

**AndroidManifest.xml declarations**:
```xml
<uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM" />
<uses-permission android:name="android.permission.USE_EXACT_ALARM" />
<uses-permission android:name="android.permission.USE_FULL_SCREEN_INTENT" />
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED" />
<uses-permission android:name="android.permission.WAKE_LOCK" />
<uses-permission android:name="android.permission.ACCESS_NOTIFICATION_POLICY" />
<uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
<uses-permission android:name="android.permission.FOREGROUND_SERVICE_ALARM_CLOCK" />

<service
    android:name=".service.AriseAlarmService"
    android:foregroundServiceType="alarmClock"
    android:exported="false" />

<receiver
    android:name=".receiver.AlarmBroadcastReceiver"
    android:exported="false" />
    
<receiver
    android:name=".receiver.BootReceiver"
    android:enabled="true"
    android:exported="true">
    <intent-filter>
        <action android:name="android.intent.action.BOOT_COMPLETED" />
        <action android:name="android.intent.action.QUICKBOOT_POWERON" />
    </intent-filter>
</receiver>
```

---

### Critical Implementation Notes

1. **Alarm apps get special treatment**: By declaring ARISE as an alarm app in Play Console, we qualify for `USE_EXACT_ALARM` (auto-granted) and `USE_FULL_SCREEN_INTENT` (auto-granted) [^424^]. This is the single most important architectural decision for reliability.

2. **Samsung will kill your alarms**: 43% of Samsung users churn within 7 days without battery exemption guidance [^471^]. The onboarding flow for Samsung devices must be a full-screen, step-by-step guided tutorial with screenshots.

3. **Notification channels cannot be modified**: After creation, channel importance, sound, vibration, and DND bypass are locked [^432^]. Create channels with maximum appropriate settings at install time.

4. **Android 15 cooldown affects burst escalation**: The 2-minute notification cooldown means nuclear escalation must be paced. Use `Alarm` category to exempt critical notifications from cooldown [^502^].

5. **setAlarmClock() is the only Doze-exiting API**: Unlike `setExact()`, `setAlarmClock()` forces the system to exit Doze mode shortly before firing, making it the most reliable alarm mechanism on all Android versions [^47^].

6. **FSI only works on lock screen**: As of Android 14/15, full-screen intents only display when the device is locked. If the user is actively using their phone, FSI shows as a regular top-bar notification [^46^]. Design for both scenarios.

7. **Permission denied is permanent on Samsung**: If a user denies `SCHEDULE_EXACT_ALARM`, the "Alarms & Reminders" section may disappear from app settings entirely on Samsung devices, making re-grant impossible without reinstall [^422^]. This is why `USE_EXACT_ALARM` (auto-granted) is critical.

---

### References

[^34^] Android Developer Docs: SCHEDULE_EXACT_ALARM behavior changes (Android 14)
[^35^] Android Developer Docs: AlarmManager.setAlarmClock() - Doze exemption
[^37^] Android Developer Docs: Notification importance levels
[^38^] Android Developer Docs: USE_EXACT_ALARM permission
[^40^] Google Play Policy: Exact alarm permission restrictions
[^41^] OEM-specific notification behavior documentation
[^46^] ProAndroidDev: Full-Screen Intent Notifications in Android 14 & 15 (2025)
[^47^] ProAndroidDev: Beyond Doze - Building Reliable Background Execution (2026)
[^75^] Google Fit REST API deprecation notice
[^76^] Google Fit shutdown timeline (June 30, 2025)
[^78^] Notification fatigue research: event-based vs scheduled
[^85^] Optimal notification frequency study
[^137^] Android DND bypass mechanism documentation
[^138^] Android 16 features and changes list
[^419^] Android Developer Docs: Schedule exact alarms denied by default (Android 14)
[^421^] Android Source: Full-screen intent limits
[^422^] Samsung Community: Alarms & Reminders section disappears after denial
[^424^] Google Play requirements on Full-screen intent
[^425^] HackMD: Android 14 AlarmManager SCHEDULE_EXACT_ALARM
[^426^] StackOverflow: SCHEDULE_EXACT_ALARM vs USE_EXACT_ALARM
[^431^] Medium: OEM BLE Hell - Samsung, Xiaomi, OnePlus battery optimization
[^432^] pub.dev: awesome_notifications package documentation
[^436^] Medium: Unhush - How to bypass Android Do Not Disturb
[^455^] OneNoughtOne: Alerting Design - Building Effective Alert Systems
[^456^] OneUptime: How to Create Alert Escalation Paths
[^458^] Inngage: Push Notifications 2025 Insights
[^459^] incident.io: Escalation policy anti-patterns
[^461^] Medium: Streaks and Daily Rewards as Habit-Forming Systems
[^471^] Medium: OEM BLE Hell (detailed Samsung analysis)
[^472^] CodeClever: Flutter App Development - Scheduling Background Tasks
[^473^] ComputerWorld: Custom vibration patterns on Android
[^474^] Medium: Flutter alarm manager package guide
[^478^] pub.dev: android_alarm_manager_plus package
[^479^] StackOverflow: Android O Notification Channels - vibration/sound
[^481^] dontkillmyapp.com: Samsung device analysis
[^482^] ForaSoft: Foreground Services and Deep Links on Android 14
[^502^] Medium: Notification Cooldown in Android 15+
[^504^] Android Central: How to enable Notification Cooldown
[^505^] Android Authority: Android 15's Notification Cooldown
[^509^] Microsoft Q&A: AlarmManager + Foreground Service delay
[^511^] Iterable: What is Send Time Optimization?
[^514^] Airship: Machine Learning Model for Predictive Send Time Optimization
