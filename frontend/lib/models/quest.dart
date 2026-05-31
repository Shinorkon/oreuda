class Quest {
  final int id;
  final String title;
  final String description;
  final String questType;
  final String difficulty;
  final String status;
  final int xpReward;
  final int goldReward;
  final Map<String, dynamic>? statRewards;
  final String category;
  final String? deadline;
  final String createdAt;

  Quest({
    required this.id,
    required this.title,
    required this.description,
    required this.questType,
    required this.difficulty,
    required this.status,
    required this.xpReward,
    required this.goldReward,
    this.statRewards,
    required this.category,
    this.deadline,
    required this.createdAt,
  });

  factory Quest.fromJson(Map<String, dynamic> json) {
    return Quest(
      id: json['id'],
      title: json['title'],
      description: json['description'] ?? '',
      questType: json['quest_type'],
      difficulty: json['difficulty'],
      status: json['status'],
      xpReward: json['xp_reward'],
      goldReward: json['gold_reward'],
      statRewards: json['stat_rewards'],
      category: json['category'],
      deadline: json['deadline'],
      createdAt: json['created_at'],
    );
  }
}
