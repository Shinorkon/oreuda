import 'package:flutter/material.dart';
import '../constants/colors.dart';

class DungeonScreen extends StatelessWidget {
  final String dungeonName;
  final String dungeonType;
  final int totalDays;

  const DungeonScreen({
    super.key,
    required this.dungeonName,
    this.dungeonType = 'normal',
    this.totalDays = 30,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Gate Portal
              Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.gatePurple.withAlpha((0.3 * 255).round()),
                      const Color(0xFF9C27B0).withAlpha((0.1 * 255).round()),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.6, 1.0],
                  ),
                  border: Border.all(
                    color: AppColors.gatePurple.withAlpha((0.4 * 255).round()),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.gatePurple.withAlpha((0.3 * 255).round()),
                      blurRadius: 40,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.door_front_door,
                  size: 56,
                  color: AppColors.gatePurple,
                ),
              ),

              const SizedBox(height: 32),

              Text(
                '[DUNGEON GATE]',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.gatePurple,
                  letterSpacing: 4,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 16),

              Text(
                dungeonName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: AppColors.pureWhite,
                  letterSpacing: 2,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                '$totalDays-Day Challenge\nComplete all daily quests to clear each floor.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.systemSilver,
                  height: 1.6,
                ),
              ),

              const SizedBox(height: 32),

              // Rewards
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildRewardPill('5000 XP'),
                  const SizedBox(width: 8),
                  _buildRewardPill('Legendary Item'),
                  const SizedBox(width: 8),
                  _buildRewardPill('S-Rank Title'),
                ],
              ),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.gatePurple,
                    foregroundColor: AppColors.pureWhite,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                  ),
                  child: const Text(
                    'ENTER DUNGEON',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 3,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              Text(
                'WARNING: Abandoning forfeits all dungeon progress.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.hpCrimson.withAlpha((0.8 * 255).round()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRewardPill(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.ariseGold.withAlpha((0.1 * 255).round()),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.ariseGold.withAlpha((0.2 * 255).round()),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          color: AppColors.ariseGold,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
