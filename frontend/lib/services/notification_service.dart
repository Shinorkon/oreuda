import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Local notification service for OREUDA.
/// Shows quest completion, streak alerts, and level-up notifications.
class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) {
        // Handle notification tap
      },
    );

    _initialized = true;
  }

  Future<void> showQuestComplete({
    required String questTitle,
    required int xpReward,
    required int goldReward,
  }) async {
    await _show(
      id: 1,
      title: '⚔️ Quest Complete: $questTitle',
      body: '+$xpReward XP · +$goldReward G · The System acknowledges your effort.',
    );
  }

  Future<void> showLevelUp({
    required int newLevel,
    required String newRank,
  }) async {
    await _show(
      id: 2,
      title: '⬆️ Level Up!',
      body: 'You have reached Level $newLevel — Rank $newRank Hunter.',
    );
  }

  Future<void> showStreakAtRisk() async {
    await _show(
      id: 3,
      title: '🔥 Streak at Risk',
      body: 'Complete a quest in the next 2 hours to keep your streak alive.',
    );
  }

  Future<void> showDailyQuestsReset() async {
    await _show(
      id: 4,
      title: '🌅 New Day, New Quests',
      body: 'Your daily quests have been generated. Execute.',
    );
  }

  Future<void> _show({
    required int id,
    required String title,
    required String body,
  }) async {
    if (!_initialized) await init();

    const androidDetails = AndroidNotificationDetails(
      'oreuda_main',
      'OREUDA Notifications',
      channelDescription: 'Quest completions, level-ups, and streak alerts',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      enableVibration: true,
      playSound: true,
    );

    const details = NotificationDetails(android: androidDetails);
    await _plugin.show(id, title, body, details);
  }
}
