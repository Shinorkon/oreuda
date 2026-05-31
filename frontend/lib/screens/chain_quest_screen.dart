import 'package:flutter/material.dart';
import '../constants/colors.dart';

class ChainQuestScreen extends StatelessWidget {
  final String chainName;
  final int currentDay;
  final int totalDays;
  final String questTitle;
  final String difficulty;

  const ChainQuestScreen({
    super.key,
    required this.chainName,
    required this.currentDay,
    required this.totalDays,
    required this.questTitle,
    required this.difficulty,
  });

  Color get _difficultyColor {
    switch (difficulty) {
      case 'D': return AppColors.successGreen;
      case 'C': return AppColors.systemBlue;
      case 'B': return const Color(0xFF9C27B0);
      case 'A': return const Color(0xFFFF9800);
      case 'S': return AppColors.ariseGold;
      default: return AppColors.mutedAsh;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.voidNavy,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Center(
                child: Column(
                  children: [
                    Text(
                      chainName.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: AppColors.pureWhite,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Day $currentDay of $totalDays',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.ariseGold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Chain Visual
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.slateSurface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  alignment: WrapAlignment.center,
                  children: List.generate(totalDays, (index) {
                    final day = index + 1;
                    final isCompleted = day < currentDay;
                    final isCurrent = day == currentDay;

                    return Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: isCompleted
                            ? AppColors.successGreen.withAlpha((0.5 * 255).round())
                            : isCurrent
                                ? AppColors.ariseGold
                                : Colors.white.withAlpha((0.08 * 255).round()),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: isCompleted
                              ? AppColors.successGreen
                              : isCurrent
                                  ? AppColors.ariseGold
                                  : Colors.white.withAlpha((0.1 * 255).round()),
                        ),
                        boxShadow: isCurrent
                            ? [
                                BoxShadow(
                                  color: AppColors.ariseGold.withAlpha((0.4 * 255).round()),
                                  blurRadius: 8,
                                ),
                              ]
                            : null,
                      ),
                    );
                  }),
                ),
              ),

              const SizedBox(height: 24),

              // Current Quest Card
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.slateSurface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.white.withAlpha((0.06 * 255).round())),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        questTitle,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.pureWhite,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: _difficultyColor.withAlpha((0.15 * 255).round()),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '$difficulty-Rank',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: _difficultyColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Complete this quest to advance to the next day of the chain.',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.systemSilver,
                          height: 1.5,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.hpCrimson.withAlpha((0.06 * 255).round()),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.warning_amber, size: 16, color: AppColors.hpCrimson),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Missing a day will reset the chain. Use your streak freeze wisely.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.hpCrimson,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.ariseGold,
                            foregroundColor: AppColors.black,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text(
                            'COMPLETE QUEST',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
