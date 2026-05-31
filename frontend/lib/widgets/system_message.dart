import 'package:flutter/material.dart';
import '../constants/colors.dart';

class SystemMessage extends StatelessWidget {
  final String message;

  const SystemMessage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.holoCyan.withAlpha((0.06 * 255).round()),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(0),
          topRight: Radius.circular(8),
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
        border: const Border(
          left: BorderSide(color: AppColors.holoCyan, width: 2),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '[NOTIFICATION] ',
            style: TextStyle(
              fontSize: 11,
              color: AppColors.bracketCyan,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.systemSilver,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
