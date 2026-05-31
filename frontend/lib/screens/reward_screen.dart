import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/colors.dart';

class RewardScreen extends StatelessWidget {
  final int xpEarned;
  final int? goldEarned;
  final int? newLevel;

  const RewardScreen({
    super.key,
    required this.xpEarned,
    this.goldEarned,
    this.newLevel,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.voidNavy.withAlpha(242),
      body: SafeArea(
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(24),
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: AppColors.deepAbyss,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.ariseGold.withAlpha(102),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.ariseGold.withAlpha(51),
                  blurRadius: 30,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 2,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.transparent, AppColors.ariseGold, Colors.transparent],
                    ),
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),

                const Text(
                  '✦',
                  style: TextStyle(fontSize: 40),
                ),

                const SizedBox(height: 12),

                Text(
                  '[QUEST COMPLETE]',
                  style: GoogleFonts.shareTechMono(
                    fontSize: 11,
                    color: AppColors.ariseGold,
                    letterSpacing: 2,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  newLevel != null ? 'LEVEL UP!' : 'QUEST COMPLETE',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.orbitron(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.pureWhite,
                  ),
                ),

                const SizedBox(height: 20),

                _buildRewardItem('⚡', 'Experience Gained', '+$xpEarned XP'),
                if (goldEarned != null && goldEarned! > 0)
                  _buildRewardItem('💰', 'Gold Earned', '+$goldEarned G'),
                if (newLevel != null)
                  _buildRewardItem('⬆', 'New Level', 'LV.$newLevel'),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.ariseGold,
                      foregroundColor: AppColors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'CLAIM REWARDS ✦',
                      style: GoogleFonts.orbitron(
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRewardItem(String icon, String text, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0x0AFFFFFF)),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            child: Text(
              icon,
              style: const TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.systemSilver,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: GoogleFonts.jetBrainsMono(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.ariseGold,
            ),
          ),
        ],
      ),
    );
  }
}
