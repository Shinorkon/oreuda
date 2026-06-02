import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../services/auth_service.dart';
import '../services/settings_service.dart';
import '../services/health_connect_service.dart';
import '../services/lyfta_service.dart';
import 'auth_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final SettingsService _settings = SettingsService.instance;
  bool _lyftaLoading = false;
  String? _lyftaError;

  @override
  void initState() {
    super.initState();
    _settings.addListener(_onSettingsChanged);
    if (!_settings.isLoaded) {
      _settings.load();
    }
  }

  @override
  void dispose() {
    _settings.removeListener(_onSettingsChanged);
    super.dispose();
  }

  void _onSettingsChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _requestHealthConnect() async {
    final granted = await HealthConnectService.instance.requestAuthorization();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            granted
                ? 'Health Connect permissions granted'
                : 'Health Connect permissions denied. Enable in system settings.',
          ),
          backgroundColor: granted ? AppColors.successGreen : AppColors.hpCrimson,
        ),
      );
    }
  }

  Future<void> _showLyftaConnectDialog() async {
    final controller = TextEditingController();
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.slateSurface,
        title: const Text('Connect Lyfta', style: TextStyle(color: AppColors.pureWhite)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Enter your Lyfta API key to import workout data.',
              style: TextStyle(color: AppColors.mutedAsh, fontSize: 12),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              style: const TextStyle(color: AppColors.pureWhite),
              decoration: InputDecoration(
                hintText: 'Lyfta API Key',
                hintStyle: const TextStyle(color: AppColors.mutedAsh),
                filled: true,
                fillColor: AppColors.deepAbyss,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.holoCyan.withAlpha(77)),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel', style: TextStyle(color: AppColors.mutedAsh)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Connect', style: TextStyle(color: AppColors.holoCyan)),
          ),
        ],
      ),
    );

    if (result == true && controller.text.isNotEmpty) {
      setState(() {
        _lyftaLoading = true;
        _lyftaError = null;
      });
      try {
        await LyftaService.connect(controller.text);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Lyfta connected successfully'),
              backgroundColor: AppColors.successGreen,
            ),
          );
        }
      } catch (e) {
        setState(() => _lyftaError = e.toString());
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to connect Lyfta: $e'),
              backgroundColor: AppColors.hpCrimson,
            ),
          );
        }
      } finally {
        setState(() => _lyftaLoading = false);
      }
    }
  }

  Future<void> _logout(BuildContext context) async {
    await AuthService.clearToken();
    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const AuthScreen()),
        (route) => false,
      );
    }
  }

  Future<void> _showResetStatsDialog(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.slateSurface,
        title: const Text('Reset All Stats?', style: TextStyle(color: AppColors.hpCrimson, fontSize: 16)),
        content: const Text(
          'This will reset all your stats to base values. You will keep your level, rank, and inventory. This action cannot be undone.',
          style: TextStyle(color: AppColors.mutedAsh, fontSize: 12),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel', style: TextStyle(color: AppColors.mutedAsh)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.hpCrimson),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Stat reset not yet implemented on backend.'),
          backgroundColor: AppColors.hpCrimson,
        ),
      );
    }
  }

  Future<void> _showDeleteAccountDialog(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.slateSurface,
        title: const Text('Delete Account?', style: TextStyle(color: AppColors.hpCrimson, fontSize: 16)),
        content: const Text(
          'This will permanently delete your account and all associated data. This action cannot be undone.',
          style: TextStyle(color: AppColors.mutedAsh, fontSize: 12),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel', style: TextStyle(color: AppColors.mutedAsh)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.hpCrimson),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account deletion not yet implemented on backend.'),
          backgroundColor: AppColors.hpCrimson,
        ),
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
            _buildToggleItem(
              'Morning Briefing',
              'Daily quest summary at wake time',
              _settings.morningBriefing,
              (v) => _settings.setMorningBriefing(v),
            ),
            _buildToggleItem(
              'Quest Warnings',
              'Deadline reminders',
              _settings.questWarnings,
              (v) => _settings.setQuestWarnings(v),
            ),
            _buildToggleItem(
              'Streak Alerts',
              'Streak at-risk notifications',
              _settings.streakAlerts,
              (v) => _settings.setStreakAlerts(v),
            ),

            const SizedBox(height: 16),

            _buildSectionTitle('INTEGRATIONS'),
            _buildIntegrationCard(
              Icons.favorite,
              'Health Connect',
              _settings.healthConnectEnabled ? 'Connected' : 'Not connected',
              _settings.healthConnectEnabled ? AppColors.successGreen : AppColors.mutedAsh,
              onTap: _requestHealthConnect,
            ),
            _buildLyftaCard(),

            const SizedBox(height: 16),

            _buildSectionTitle('DISPLAY'),
            _buildToggleItem(
              'High Contrast Mode',
              'Enhanced accessibility',
              _settings.highContrast,
              (v) => _settings.setHighContrast(v),
            ),
            _buildToggleItem(
              'Reduced Motion',
              'Disable animations',
              _settings.reducedMotion,
              (v) => _settings.setReducedMotion(v),
            ),
            _buildToggleItem(
              'Haptic Feedback',
              'Vibration on actions',
              _settings.hapticFeedback,
              (v) => _settings.setHapticFeedback(v),
            ),

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
                  _buildDangerButton('Reset All Stats', () => _showResetStatsDialog(context)),
                  _buildDangerButton('Delete Account', () => _showDeleteAccountDialog(context)),
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

  Widget _buildLyftaCard() {
    return GestureDetector(
      onTap: _settings.lyftaConnected
          ? () async {
              setState(() => _lyftaLoading = true);
              try {
                await LyftaService.sync();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Lyfta sync complete'),
                      backgroundColor: AppColors.successGreen,
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Sync failed: $e'),
                      backgroundColor: AppColors.hpCrimson,
                    ),
                  );
                }
              } finally {
                setState(() => _lyftaLoading = false);
              }
            }
          : _showLyftaConnectDialog,
      child: Container(
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
              child: _lyftaLoading
                  ? const Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.holoCyan,
                        ),
                      ),
                    )
                  : const Icon(Icons.fitness_center, color: AppColors.holoCyan, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Lyfta',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.pureWhite,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _settings.lyftaConnected ? 'Connected · Tap to sync' : 'Not connected · Tap to set up',
                    style: TextStyle(
                      fontSize: 11,
                      color: _settings.lyftaConnected ? AppColors.successGreen : AppColors.mutedAsh,
                    ),
                  ),
                  if (_lyftaError != null)
                    Text(
                      _lyftaError!,
                      style: const TextStyle(fontSize: 10, color: AppColors.hpCrimson),
                    ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.mutedAsh, size: 20),
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

  Widget _buildToggleItem(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
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
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppColors.holoCyan,
            activeTrackColor: AppColors.holoCyan.withAlpha((0.3 * 255).round()),
            inactiveTrackColor: AppColors.mutedAsh.withAlpha((0.3 * 255).round()),
          ),
        ],
      ),
    );
  }

  Widget _buildIntegrationCard(
    IconData icon,
    String name,
    String status,
    Color statusColor, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
