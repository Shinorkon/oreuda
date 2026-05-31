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
