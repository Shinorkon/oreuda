import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:health/health.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Daily health data snapshot used for stat calculation.
class HealthSnapshot {
  final int steps;
  final int caloriesBurned;
  final int sleepMinutes;
  final int restingHeartRate;
  final int workoutCount;
  final double? weightKg;
  final bool authorized;

  const HealthSnapshot({
    this.steps = 0,
    this.caloriesBurned = 0,
    this.sleepMinutes = 0,
    this.restingHeartRate = 0,
    this.workoutCount = 0,
    this.weightKg,
    this.authorized = false,
  });

  static const empty = HealthSnapshot(authorized: false);

  Map<String, dynamic> toJson() => {
        'steps': steps,
        'calories_burned': caloriesBurned,
        'sleep_minutes': sleepMinutes,
        'resting_hr': restingHeartRate,
        'workouts_count': workoutCount,
        'weight_kg': weightKg,
      };
}

/// Health Connect integration for OREUDA.
/// Reads real health data and converts it into RPG stats.
class HealthConnectService extends ChangeNotifier {
  HealthConnectService._();
  static final HealthConnectService instance = HealthConnectService._();

  static const _prefKey = 'setting_health_connect';
  bool? _cachedEnabled;
  bool _configured = false;
  Timer? _pollTimer;

  final _controller = StreamController<HealthSnapshot>.broadcast();

  static const _types = <HealthDataType>[
    HealthDataType.STEPS,
    HealthDataType.ACTIVE_ENERGY_BURNED,
    HealthDataType.SLEEP_ASLEEP,
    HealthDataType.HEART_RATE,
    HealthDataType.WORKOUT,
    HealthDataType.WEIGHT,
  ];

  static const _permissions = <HealthDataAccess>[
    HealthDataAccess.READ,
    HealthDataAccess.READ,
    HealthDataAccess.READ,
    HealthDataAccess.READ,
    HealthDataAccess.READ,
    HealthDataAccess.READ,
  ];

  bool get syncEnabled => _cachedEnabled ?? false;
  bool get isSupported => !kIsWeb && Platform.isAndroid;

  Stream<HealthSnapshot> get snapshotStream => _controller.stream;

  Future<void> _ensureConfigured() async {
    if (_configured || !isSupported) return;
    await Health().configure();
    _configured = true;
  }

  Future<void> loadEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    _cachedEnabled = prefs.getBool(_prefKey) ?? false;
    notifyListeners();
  }

  Future<void> setEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefKey, value);
    _cachedEnabled = value;
    notifyListeners();
    if (!value) _stopPolling();
  }

  Future<bool> requestAuthorization() async {
    if (!isSupported) return false;
    await _ensureConfigured();

    try {
      final status = await Health().getHealthConnectSdkStatus();
      if (status == null || status == HealthConnectSdkStatus.sdkUnavailable) {
        debugPrint('Health Connect SDK unavailable');
        return false;
      }
      if (status == HealthConnectSdkStatus.sdkUnavailableProviderUpdateRequired) {
        try {
          await Health().installHealthConnect();
        } catch (_) {}
        return false;
      }
    } catch (e) {
      debugPrint('Health Connect SDK status check failed: $e');
    }

    try {
      final granted = await Health().requestAuthorization(
        _types,
        permissions: _permissions,
      );
      if (granted) {
        final has = await _hasPermissions();
        if (has) await setEnabled(true);
        return has;
      }
      return granted;
    } catch (e) {
      debugPrint('Health Connect authorization failed: $e');
      return false;
    }
  }

  Future<bool> _hasPermissions() async {
    if (!isSupported) return false;
    await _ensureConfigured();
    try {
      final has = await Health().hasPermissions(_types, permissions: _permissions);
      return has ?? false;
    } catch (_) {
      return false;
    }
  }

  Future<bool> revokeAuthorization() async {
    if (!isSupported) return false;
    await _ensureConfigured();
    try {
      await Health().revokePermissions();
      await setEnabled(false);
      return true;
    } catch (e) {
      debugPrint('Health Connect revoke failed: $e');
      return false;
    }
  }

  /// Fetch today's health data snapshot.
  Future<HealthSnapshot> fetchToday() async {
    if (!isSupported || !syncEnabled) return HealthSnapshot.empty;
    await _ensureConfigured();

    final authorized = await _hasPermissions();
    if (!authorized) return HealthSnapshot.empty;

    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);

    try {
      final steps = await Health().getTotalStepsInInterval(startOfDay, now) ?? 0;

      final points = await Health().getHealthDataFromTypes(
        types: const [
          HealthDataType.ACTIVE_ENERGY_BURNED,
          HealthDataType.SLEEP_ASLEEP,
          HealthDataType.HEART_RATE,
          HealthDataType.WORKOUT,
          HealthDataType.WEIGHT,
        ],
        startTime: startOfDay,
        endTime: now,
      );

      double burned = 0;
      Duration sleep = Duration.zero;
      final hrSamples = <double>[];
      int workoutCount = 0;
      double? latestWeight;

      for (final p in points) {
        switch (p.type) {
          case HealthDataType.ACTIVE_ENERGY_BURNED:
            final v = p.value;
            if (v is NumericHealthValue) burned += v.numericValue.toDouble();
            break;
          case HealthDataType.SLEEP_ASLEEP:
            sleep += p.dateTo.difference(p.dateFrom);
            break;
          case HealthDataType.HEART_RATE:
            final v = p.value;
            if (v is NumericHealthValue) hrSamples.add(v.numericValue.toDouble());
            break;
          case HealthDataType.WORKOUT:
            workoutCount++;
            break;
          case HealthDataType.WEIGHT:
            final v = p.value;
            if (v is NumericHealthValue) latestWeight = v.numericValue.toDouble();
            break;
          default:
            break;
        }
      }

      final restingHR = hrSamples.isEmpty
          ? 0
          : hrSamples.reduce((a, b) => a < b ? a : b).round();

      return HealthSnapshot(
        steps: steps,
        caloriesBurned: burned.round(),
        sleepMinutes: sleep.inMinutes,
        restingHeartRate: restingHR,
        workoutCount: workoutCount,
        weightKg: latestWeight,
        authorized: true,
      );
    } catch (e) {
      debugPrint('Health Connect read failed: $e');
      return HealthSnapshot.empty;
    }
  }

  /// Start polling for health data every 5 minutes.
  void startPolling() {
    _stopPolling();
    _pollTimer = Timer.periodic(const Duration(minutes: 5), (_) async {
      final snap = await fetchToday();
      if (!_controller.isClosed) _controller.add(snap);
    });
  }

  void _stopPolling() {
    _pollTimer?.cancel();
    _pollTimer = null;
  }

  @override
  void dispose() {
    _stopPolling();
    _controller.close();
    super.dispose();
  }
}
