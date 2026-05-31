import 'package:flutter/material.dart';
import '../constants/colors.dart';

class NotificationScreen extends StatelessWidget {
  final String title;
  final String message;
  final String type; // notification, warning, urgent
  final VoidCallback? onAccept;
  final VoidCallback? onDecline;

  const NotificationScreen({
    super.key,
    required this.title,
    required this.message,
    this.type = 'notification',
    this.onAccept,
    this.onDecline,
  });

  Color get _accentColor {
    switch (type) {
      case 'warning':
        return AppColors.alertRed;
      case 'urgent':
        return AppColors.hpCrimson;
      default:
        return AppColors.holoCyan;
    }
  }

  String get _bracketText {
    switch (type) {
      case 'warning':
        return '[WARNING]';
      case 'urgent':
        return '[URGENT]';
      default:
        return '[NOTIFICATION]';
    }
  }

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
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _accentColor.withAlpha((0.1 * 255).round()),
                  border: Border.all(
                    color: _accentColor.withAlpha((0.3 * 255).round()),
                    width: 2,
                  ),
                ),
                child: Icon(
                  type == 'warning' ? Icons.warning_amber : Icons.notifications_active,
                  size: 32,
                  color: _accentColor,
                ),
              ),

              const SizedBox(height: 24),

              Text(
                _bracketText,
                style: TextStyle(
                  fontSize: 12,
                  color: _accentColor,
                  letterSpacing: 3,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 16),

              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: AppColors.pureWhite,
                  letterSpacing: 1,
                ),
              ),

              const SizedBox(height: 16),

              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.systemSilver,
                  height: 1.6,
                ),
              ),

              const SizedBox(height: 40),

              if (onAccept != null)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onAccept,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _accentColor,
                      foregroundColor: AppColors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'ACCEPT',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),

              if (onDecline != null) ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: onDecline,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.mutedAsh,
                      side: BorderSide(color: Colors.white.withAlpha((0.2 * 255).round())),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'DECLINE',
                      style: TextStyle(
                        fontSize: 12,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
