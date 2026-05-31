import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persistent user settings for OREUDA.
/// All toggles are stored in SharedPreferences and survive app restarts.
class SettingsService extends ChangeNotifier {
  SettingsService._();
  static final SettingsService instance = SettingsService._();

  static const _keyMorningBriefing = 'setting_morning_briefing';
  static const _keyQuestWarnings = 'setting_quest_warnings';
  static const _keyStreakAlerts = 'setting_streak_alerts';
  static const _keyHighContrast = 'setting_high_contrast';
  static const _keyReducedMotion = 'setting_reduced_motion';
  static const _keyHapticFeedback = 'setting_haptic_feedback';
  static const _keyHealthConnectEnabled = 'setting_health_connect';
  static const _keyLyftaConnected = 'setting_lyfta_connected';

  bool _morningBriefing = true;
  bool _questWarnings = true;
  bool _streakAlerts = true;
  bool _highContrast = false;
  bool _reducedMotion = false;
  bool _hapticFeedback = true;
  bool _healthConnectEnabled = false;
  bool _lyftaConnected = false;
  bool _loaded = false;

  // ─── Getters ───
  bool get morningBriefing => _morningBriefing;
  bool get questWarnings => _questWarnings;
  bool get streakAlerts => _streakAlerts;
  bool get highContrast => _highContrast;
  bool get reducedMotion => _reducedMotion;
  bool get hapticFeedback => _hapticFeedback;
  bool get healthConnectEnabled => _healthConnectEnabled;
  bool get lyftaConnected => _lyftaConnected;
  bool get isLoaded => _loaded;

  // ─── Load from disk ───
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _morningBriefing = prefs.getBool(_keyMorningBriefing) ?? true;
    _questWarnings = prefs.getBool(_keyQuestWarnings) ?? true;
    _streakAlerts = prefs.getBool(_keyStreakAlerts) ?? true;
    _highContrast = prefs.getBool(_keyHighContrast) ?? false;
    _reducedMotion = prefs.getBool(_keyReducedMotion) ?? false;
    _hapticFeedback = prefs.getBool(_keyHapticFeedback) ?? true;
    _healthConnectEnabled = prefs.getBool(_keyHealthConnectEnabled) ?? false;
    _lyftaConnected = prefs.getBool(_keyLyftaConnected) ?? false;
    _loaded = true;
    notifyListeners();
  }

  // ─── Setters ───
  Future<void> setMorningBriefing(bool value) async {
    _morningBriefing = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyMorningBriefing, value);
    notifyListeners();
  }

  Future<void> setQuestWarnings(bool value) async {
    _questWarnings = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyQuestWarnings, value);
    notifyListeners();
  }

  Future<void> setStreakAlerts(bool value) async {
    _streakAlerts = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyStreakAlerts, value);
    notifyListeners();
  }

  Future<void> setHighContrast(bool value) async {
    _highContrast = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyHighContrast, value);
    notifyListeners();
  }

  Future<void> setReducedMotion(bool value) async {
    _reducedMotion = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyReducedMotion, value);
    notifyListeners();
  }

  Future<void> setHapticFeedback(bool value) async {
    _hapticFeedback = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyHapticFeedback, value);
    notifyListeners();
  }

  Future<void> setHealthConnectEnabled(bool value) async {
    _healthConnectEnabled = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyHealthConnectEnabled, value);
    notifyListeners();
  }

  Future<void> setLyftaConnected(bool value) async {
    _lyftaConnected = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyLyftaConnected, value);
    notifyListeners();
  }
}
