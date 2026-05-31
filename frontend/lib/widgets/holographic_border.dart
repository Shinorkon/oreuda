import 'package:flutter/material.dart';
import '../constants/colors.dart';

class HolographicBorder extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final Color borderColor;
  final double borderWidth;
  final List<BoxShadow>? boxShadow;

  const HolographicBorder({
    super.key,
    required this.child,
    this.borderRadius = 12,
    this.borderColor = AppColors.holoCyan,
    this.borderWidth = 1,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: borderColor.withAlpha((0.3 * 255).round()),
          width: borderWidth,
        ),
        boxShadow: boxShadow ?? [
          BoxShadow(
            color: borderColor.withAlpha((0.15 * 255).round()),
            blurRadius: 20,
            spreadRadius: 1,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: child,
      ),
    );
  }
}
