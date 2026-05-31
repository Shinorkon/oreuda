import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../services/auth_service.dart';
import 'auth_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    await AuthService.clearToken();
    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const AuthScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.voidNavy,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'SYSTEM CONFIG',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.holoCyan,
                letterSpacing: 3,
              ),
            ),

            const SizedBox(height: 24),

            _buildSectionTitle('NOTIFICATIONS'),
            _buildToggleItem('Morning Briefing', 'Daily quest summary at wake time', true),
            _buildToggleItem('Quest Warnings', 'Deadline reminders', true),
            _buildToggleItem('Streak Alerts', 'Streak at-risk notifications', true),

            const SizedBox(height: 16),

            _buildSectionTitle('INTEGRATIONS'),
            _buildIntegrationCard(
              Icons.favorite,
              'Health Connect',
              'Connected',
              AppColors.successGreen,
            ),
            _buildIntegrationCard(
              Icons.timer,
              'Screentime Monitor',
              'Active',
              AppColors.successGreen,
            ),

            const SizedBox(height: 16),

            _buildSectionTitle('DISPLAY'),
            _buildToggleItem('High Contrast Mode', 'Enhanced accessibility', false),
            _buildToggleItem('Reduced Motion', 'Disable animations', false),
            _buildToggleItem('Haptic Feedback', 'Vibration on actions', true),

            const SizedBox(height: 24),

            // Danger Zone
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.hpCrimson.withAlpha((0.05 * 255).round()),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.hpCrimson.withAlpha((0.3 * 255).round()),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'DANGER ZONE',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.hpCrimson,
                      letterSpacing: 3,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildDangerButton('Reset All Stats', () {}),
                  _buildDangerButton('Delete Account', () {}),
                  _buildDangerButton('Logout', () => _logout(context)),
                ],
              ),
            ),

            const SizedBox(height: 24),

            const Center(
              child: Text(
                'OREUDA v1.0.0',
                style: TextStyle(
                  fontSize: 10,
                  color: AppColors.mutedAsh,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppColors.mutedAsh,
          letterSpacing: 3,
        ),
      ),
    );
  }

  Widget _buildToggleItem(String title, String subtitle, bool initialValue) {
    return StatefulBuilder(
      builder: (context, setState) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.white.withAlpha((0.04 * 255).round())),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.pureWhite,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.mutedAsh,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: initialValue,
                onChanged: (v) {},
                activeThumbColor: AppColors.holoCyan,
                activeTrackColor: AppColors.holoCyan.withAlpha((0.3 * 255).round()),
                inactiveTrackColor: AppColors.mutedAsh.withAlpha((0.3 * 255).round()),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildIntegrationCard(IconData icon, String name, String status, Color statusColor) {
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
            child: Icon(icon, color: AppColors.holoCyan, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.pureWhite,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  status,
                  style: TextStyle(
                    fontSize: 11,
                    color: statusColor,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.mutedAsh, size: 20),
        ],
      ),
    );
  }

  Widget _buildDangerButton(String text, VoidCallback onPressed) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.hpCrimson,
          side: BorderSide(color: AppColors.hpCrimson.withAlpha((0.3 * 255).round())),
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}
