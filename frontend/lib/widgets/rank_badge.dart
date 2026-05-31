import 'package:flutter/material.dart';
import '../constants/colors.dart';

class RankBadge extends StatelessWidget {
  final String rank;
  final double size;

  const RankBadge({super.key, required this.rank, this.size = 36});

  Color get _rankColor {
    switch (rank) {
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

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [_rankColor, _rankColor.withAlpha((0.7 * 255).round())],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(size * 0.22),
        boxShadow: [
          BoxShadow(
            color: _rankColor.withAlpha((0.4 * 255).round()),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Center(
        child: Text(
          rank,
          style: TextStyle(
            color: rank == 'S' ? AppColors.black : AppColors.pureWhite,
            fontSize: size * 0.44,
            fontWeight: FontWeight.w900,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}
