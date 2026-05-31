import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../models/quest.dart';

class QuestCard extends StatelessWidget {
  final Quest quest;
  final VoidCallback? onComplete;
  final VoidCallback? onFail;

  const QuestCard({super.key, required this.quest, this.onComplete, this.onFail});

  Color get _difficultyColor {
    switch (quest.difficulty) {
      case 'E':
        return AppColors.mutedAsh;
      case 'D':
        return AppColors.successGreen;
      case 'C':
        return AppColors.systemBlue;
      case 'B':
        return const Color(0xFF9C27B0);
      case 'A':
        return const Color(0xFFFF9800);
      case 'S':
        return AppColors.ariseGold;
      default:
        return AppColors.mutedAsh;
    }
  }

  IconData get _categoryIcon {
    switch (quest.category) {
      case 'Physical':
        return Icons.fitness_center;
      case 'Mental':
        return Icons.self_improvement;
      case 'Intellectual':
        return Icons.menu_book;
      case 'Discipline':
        return Icons.lock_clock;
      case 'Dungeon':
        return Icons.castle;
      default:
        return Icons.task_alt;
    }
  }

  /// Calculate progress percentage (0.0 to 1.0)
  double get _progress {
    if (quest.targetValue == null || quest.targetValue == 0) return 0.0;
    return (quest.currentValue / quest.targetValue!).clamp(0.0, 1.0);
  }

  String get _progressText {
    if (quest.targetValue == null) return '';
    if (quest.metricType == 'sleep') {
      final currentHours = (quest.currentValue / 60).toStringAsFixed(1);
      final targetHours = (quest.targetValue! / 60).toStringAsFixed(1);
      return '$currentHours / $targetHours h';
    }
    if (quest.metricType == 'calories') {
      return '${quest.currentValue} / ${quest.targetValue} cal';
    }
    if (quest.metricType == 'steps') {
      return '${quest.currentValue.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => ',')} / ${quest.targetValue.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => ',')}';
    }
    return '${quest.currentValue} / ${quest.targetValue}';
  }

  @override
  Widget build(BuildContext context) {
    final isCompleted = quest.status == 'completed';
    final progress = _progress;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.slateSurface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withAlpha((0.04 * 255).round())),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.holoCyan.withAlpha((0.1 * 255).round()),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(_categoryIcon, color: AppColors.holoCyan, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      quest.title,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.pureWhite,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      quest.description,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.mutedAsh,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (isCompleted)
                const Icon(Icons.check_circle, color: AppColors.successGreen, size: 28)
              else if (onComplete != null)
                IconButton(
                  onPressed: onComplete,
                  icon: const Icon(Icons.check_circle_outline, color: AppColors.successGreen),
                  iconSize: 28,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
            ],
          ),
          // Progress bar for active quests with targets
          if (!isCompleted && quest.targetValue != null && quest.targetValue! > 0) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha((0.06 * 255).round()),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: progress,
                        child: Container(
                          decoration: BoxDecoration(
                            color: _difficultyColor,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  _progressText,
                  style: TextStyle(
                    fontSize: 10,
                    color: AppColors.mutedAsh,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: _difficultyColor.withAlpha((0.15 * 255).round()),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  quest.difficulty,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: _difficultyColor,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${quest.xpReward} XP',
                style: const TextStyle(
                  fontSize: 10,
                  color: AppColors.ariseGold,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${quest.goldReward} G',
                style: const TextStyle(
                  fontSize: 10,
                  color: AppColors.systemSilver,
                ),
              ),
              if (quest.questType == 'dungeon') ...[
                const SizedBox(width: 8),
                const Icon(Icons.castle, size: 12, color: AppColors.hpCrimson),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
