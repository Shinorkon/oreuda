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
  // Dynamic quest fields
  final int? targetValue;
  final int currentValue;
  final String? metricType;

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
    this.targetValue,
    this.currentValue = 0,
    this.metricType,
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
      targetValue: json['target_value'],
      currentValue: json['current_value'] ?? 0,
      metricType: json['metric_type'],
    );
  }

  /// Progress percentage (0.0 to 1.0)
  double get progress {
    if (targetValue == null || targetValue == 0) return 0.0;
    return (currentValue / targetValue!).clamp(0.0, 1.0);
  }

  bool get isCompleted => status == 'completed';
}
