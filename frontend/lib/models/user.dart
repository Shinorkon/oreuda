class User {
  final int id;
  final String email;
  final String username;
  final String displayName;
  final int level;
  final int xp;
  final String rank;
  final int gold;
  final int essence;
  final int streakDays;
  final int bestStreak;

  User({
    required this.id,
    required this.email,
    required this.username,
    required this.displayName,
    required this.level,
    required this.xp,
    required this.rank,
    required this.gold,
    required this.essence,
    required this.streakDays,
    required this.bestStreak,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      username: json['username'],
      displayName: json['display_name'],
      level: json['level'],
      xp: json['xp'],
      rank: json['rank'],
      gold: json['gold'],
      essence: json['essence'],
      streakDays: json['streak_days'],
      bestStreak: json['best_streak'],
    );
  }
}

class PlayerStats {
  final int strStat;
  final int agiStat;
  final int vitStat;
  final int intStat;
  final int senStat;
  final int distributablePoints;
  final int hp;
  final int energy;
  final int focusStat;

  PlayerStats({
    required this.strStat,
    required this.agiStat,
    required this.vitStat,
    required this.intStat,
    required this.senStat,
    required this.distributablePoints,
    required this.hp,
    required this.energy,
    required this.focusStat,
  });

  factory PlayerStats.fromJson(Map<String, dynamic> json) {
    return PlayerStats(
      strStat: json['str_stat'],
      agiStat: json['agi_stat'],
      vitStat: json['vit_stat'],
      intStat: json['int_stat'],
      senStat: json['sen_stat'],
      distributablePoints: json['distributable_points'],
      hp: json['hp'],
      energy: json['energy'],
      focusStat: json['focus_stat'],
    );
  }
}
