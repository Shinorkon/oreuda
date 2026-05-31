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
      default:
        return Icons.task_alt;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.slateSurface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withAlpha((0.04 * 255).round())),
      ),
      child: Row(
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
                  ],
                ),
              ],
            ),
          ),
          if (quest.status == 'active' && onComplete != null) ...[
            IconButton(
              onPressed: onComplete,
              icon: const Icon(Icons.check_circle, color: AppColors.successGreen),
              iconSize: 28,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ] else if (quest.status == 'completed') ...[
            const Icon(Icons.check_circle, color: AppColors.successGreen, size: 24),
          ],
        ],
      ),
    );
  }
}
