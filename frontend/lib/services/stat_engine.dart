import 'health_connect_service.dart';

/// Converts real health data into RPG stats (STR/AGI/VIT/INT/SEN).
///
/// Stat formulas:
/// - STR (Strength): from workout volume, consistency
/// - AGI (Agility): from daily steps
/// - VIT (Vitality): from active calories burned, resting HR
/// - INT (Intelligence): from sleep quality/duration
/// - SEN (Sense): from weight stability, body awareness
class StatEngine {
  StatEngine._();
  static final StatEngine instance = StatEngine._();

  /// Base stat value for new users.
  static const int baseStat = 10;

  /// Maximum stat value.
  static const int maxStat = 100;

  /// Calculate all stats from a health snapshot.
  ///
  /// Returns a map: {'str': int, 'agi': int, 'vit': int, 'int': int, 'sen': int}
  Map<String, int> calculateStats(HealthSnapshot snapshot) {
    return {
      'str': _calculateStr(snapshot),
      'agi': _calculateAgi(snapshot),
      'vit': _calculateVit(snapshot),
      'int': _calculateInt(snapshot),
      'sen': _calculateSen(snapshot),
    };
  }

  /// STR — Strength: derived from workout activity.
  /// Formula: base + (workouts * 3) + min(calories/100, 20)
  int _calculateStr(HealthSnapshot s) {
    if (!s.authorized) return baseStat;
    final workoutBonus = s.workoutCount * 3;
    final calorieBonus = (s.caloriesBurned / 100).floor().clamp(0, 20);
    return (baseStat + workoutBonus + calorieBonus).clamp(baseStat, maxStat);
  }

  /// AGI — Agility: derived from daily steps.
  /// Formula: base + (steps / 1000)
  int _calculateAgi(HealthSnapshot s) {
    if (!s.authorized) return baseStat;
    final stepBonus = (s.steps / 1000).floor();
    return (baseStat + stepBonus).clamp(baseStat, maxStat);
  }

  /// VIT — Vitality: derived from active calories and heart health.
  /// Formula: base + (calories / 50) + (80 - restingHR)
  int _calculateVit(HealthSnapshot s) {
    if (!s.authorized) return baseStat;
    final calorieBonus = (s.caloriesBurned / 50).floor();
    final hrBonus = s.restingHeartRate > 0 ? (80 - s.restingHeartRate) : 0;
    return (baseStat + calorieBonus + hrBonus).clamp(baseStat, maxStat);
  }

  /// INT — Intelligence: derived from sleep quality.
  /// Formula: base + (sleepMinutes / 60) * 2
  int _calculateInt(HealthSnapshot s) {
    if (!s.authorized) return baseStat;
    final sleepHours = s.sleepMinutes / 60;
    final sleepBonus = (sleepHours * 2).floor();
    return (baseStat + sleepBonus).clamp(baseStat, maxStat);
  }

  /// SEN — Sense: derived from body awareness (weight tracking).
  /// Formula: base + (if weight tracked: 5, else 0)
  int _calculateSen(HealthSnapshot s) {
    if (!s.authorized) return baseStat;
    final weightBonus = s.weightKg != null ? 5 : 0;
    final workoutAwareness = s.workoutCount * 2;
    return (baseStat + weightBonus + workoutAwareness).clamp(baseStat, maxStat);
  }

  /// Calculate XP reward from health activity.
  /// Used when quests auto-complete.
  int calculateXpReward(HealthSnapshot snapshot) {
    if (!snapshot.authorized) return 0;
    var xp = 0;
    xp += (snapshot.steps / 100).floor(); // 1 XP per 100 steps
    xp += (snapshot.caloriesBurned / 10).floor(); // 1 XP per 10 cal
    xp += snapshot.workoutCount * 50; // 50 XP per workout
    xp += (snapshot.sleepMinutes / 30).floor(); // 1 XP per 30 min sleep
    return xp;
  }

  /// Calculate gold reward from health activity.
  int calculateGoldReward(HealthSnapshot snapshot) {
    if (!snapshot.authorized) return 0;
    var gold = 0;
    gold += (snapshot.steps / 1000).floor(); // 1 G per 1000 steps
    gold += snapshot.workoutCount * 10; // 10 G per workout
    gold += (snapshot.caloriesBurned / 100).floor(); // 1 G per 100 cal
    return gold;
  }

  /// Get a human-readable description of what contributed to each stat.
  Map<String, String> getStatBreakdown(HealthSnapshot s) {
    return {
      'str': s.authorized
          ? '${s.workoutCount} workouts, ${s.caloriesBurned} cal burned'
          : 'Connect Health Connect to track strength',
      'agi': s.authorized
          ? '${s.steps.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => ',')} steps today'
          : 'Connect Health Connect to track agility',
      'vit': s.authorized
          ? '${s.caloriesBurned} cal, RHR ${s.restingHeartRate > 0 ? s.restingHeartRate : '--'}'
          : 'Connect Health Connect to track vitality',
      'int': s.authorized
          ? '${(s.sleepMinutes / 60).toStringAsFixed(1)}h sleep'
          : 'Connect Health Connect to track intelligence',
      'sen': s.authorized
          ? s.weightKg != null
              ? 'Weight tracked: ${s.weightKg!.toStringAsFixed(1)} kg'
              : 'Log weight for body awareness'
          : 'Connect Health Connect to track sense',
    };
  }
}
