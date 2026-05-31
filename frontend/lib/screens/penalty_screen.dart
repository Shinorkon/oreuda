import 'package:flutter/material.dart';
import '../constants/colors.dart';

class PenaltyScreen extends StatelessWidget {
  const PenaltyScreen({super.key});

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
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.hpCrimson.withAlpha((0.1 * 255).round()),
                  border: Border.all(
                    color: AppColors.hpCrimson.withAlpha((0.4 * 255).round()),
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.warning_amber,
                  size: 40,
                  color: AppColors.hpCrimson,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                '[PENALTY ZONE]',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.hpCrimson,
                  letterSpacing: 3,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'QUEST FAILED',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: AppColors.hpCrimson,
                  letterSpacing: 3,
                ),
              ),
              const SizedBox(height: 32),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.slateSurface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.hpCrimson.withAlpha((0.2 * 255).round()),
                  ),
                ),
                child: Column(
                  children: [
                    _buildDebuffItem('Stat Decay', '2x for 7 days', AppColors.hpCrimson),
                    const Divider(color: Colors.white10),
                    _buildDebuffItem('Quest Rewards', '-50% for 24h', AppColors.hpCrimson),
                    const Divider(color: Colors.white10),
                    _buildDebuffItem('Streak', 'Reset to 0', AppColors.hpCrimson),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.hpCrimson.withAlpha((0.2 * 255).round()),
                    foregroundColor: AppColors.hpCrimson,
                    side: BorderSide(color: AppColors.hpCrimson.withAlpha((0.4 * 255).round())),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'BEGIN RECOVERY',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDebuffItem(String name, String effect, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.systemSilver,
            ),
          ),
          Text(
            effect,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
