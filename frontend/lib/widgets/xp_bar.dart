import 'package:flutter/material.dart';
import '../constants/colors.dart';

class XpBar extends StatelessWidget {
  final int currentXp;
  final int level;

  const XpBar({super.key, required this.currentXp, required this.level});

  int _xpRequired() {
    final next = level + 1;
    return (100 * next * next * next) ~/ 100;
  }

  double get progress {
    final req = _xpRequired();
    if (req == 0) return 0;
    return (currentXp % req) / req;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'LV.$level',
              style: const TextStyle(
                fontSize: 10,
                color: AppColors.mutedAsh,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '${currentXp % _xpRequired()}/${_xpRequired()} XP',
              style: const TextStyle(
                fontSize: 10,
                color: AppColors.mutedAsh,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: Container(
            height: 6,
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(20),
              borderRadius: BorderRadius.circular(3),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress.clamp(0.0, 1.0),
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.systemBlue, AppColors.holoCyan],
                  ),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
