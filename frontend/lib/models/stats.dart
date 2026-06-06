class PlayerStats {
  final int strength;
  final int agility;
  final int vitality;
  final int intelligence;
  final int sense;

  const PlayerStats({
    required this.strength,
    required this.agility,
    required this.vitality,
    required this.intelligence,
    required this.sense,
  });

  factory PlayerStats.fromJson(Map<String, dynamic> json) {
    return PlayerStats(
      strength: json['str_stat'] as int? ?? 10,
      agility: json['agi_stat'] as int? ?? 10,
      vitality: json['vit_stat'] as int? ?? 10,
      intelligence: json['int_stat'] as int? ?? 10,
      sense: json['sen_stat'] as int? ?? 10,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'str_stat': strength,
      'agi_stat': agility,
      'vit_stat': vitality,
      'int_stat': intelligence,
      'sen_stat': sense,
    };
  }

  int get maxStat {
    final values = [strength, agility, vitality, intelligence, sense];
    return values.reduce((a, b) => a > b ? a : b);
  }

  double normalizedValue(int value) {
    final max = maxStat;
    if (max == 0) return 0.0;
    return value / max;
  }
}

class RankProgress {
  final String currentRank;
  final String nextRank;
  final int currentXp;
  final int requiredXp;
  final List<bool> completedRanks;

  const RankProgress({
    required this.currentRank,
    required this.nextRank,
    required this.currentXp,
    required this.requiredXp,
    required this.completedRanks,
  });

  factory RankProgress.fromJson(Map<String, dynamic> json) {
    final completed = (json['completed_ranks'] as List<dynamic>? ?? [])
        .map((e) => e as bool)
        .toList();
    return RankProgress(
      currentRank: json['current_rank'] as String? ?? 'E',
      nextRank: json['next_rank'] as String? ?? 'D',
      currentXp: json['current_xp'] as int? ?? 0,
      requiredXp: json['required_xp'] as int? ?? 100,
      completedRanks: completed.isEmpty ? [false, false, false, false, false, false] : completed,
    );
  }

  double get progressPercent => requiredXp > 0 ? currentXp / requiredXp : 0.0;

  static const List<String> ranks = ['E', 'D', 'C', 'B', 'A', 'S'];
}
