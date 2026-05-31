import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/colors.dart';
import '../models/quest.dart';
import '../services/api_service.dart';
import '../services/health_connect_service.dart';
import '../services/stat_engine.dart';
import '../services/settings_service.dart';
import '../widgets/rank_badge.dart';
import '../widgets/system_message.dart';
import '../widgets/xp_bar.dart';
import '../widgets/quest_card.dart';
import 'notification_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic> _userData = {};
  List<Quest> _quests = [];
  Map<String, dynamic> _stats = {};
  bool _isLoading = true;
  String? _systemMessage;
  HealthSnapshot? _healthSnapshot;
  bool _healthSyncing = false;

  @override
  void initState() {
    super.initState();
    _loadData();
    _syncHealthIfEnabled();
  }

  Future<void> _syncHealthIfEnabled() async {
    final settings = SettingsService.instance;
    if (!settings.isLoaded) await settings.load();

    if (settings.healthConnectEnabled) {
      setState(() => _healthSyncing = true);
      try {
        final snap = await HealthConnectService.instance.fetchToday();
        if (snap.authorized) {
          // Send to backend
          await ApiService.syncHealth({
            'date': DateTime.now().toIso8601String().split('T')[0],
            ...snap.toJson(),
          });
          // Check quest completion
          await ApiService.post('/quests/check-completion');
        }
        setState(() {
          _healthSnapshot = snap;
          _healthSyncing = false;
        });
        // Reload to get updated quests
        await _loadData();
      } catch (e) {
        setState(() => _healthSyncing = false);
      }
    }
  }

  Future<void> _loadData() async {
    try {
      final user = await ApiService.getMe();
      final questsData = await ApiService.getDailyQuests();
      final stats = await ApiService.getStats();

      // Also get health-calculated stats if available
      Map<String, dynamic> healthStats = {};
      try {
        healthStats = await ApiService.getHealthStats();
      } catch (_) {
        // Health stats may not be available
      }

      setState(() {
        _userData = user;
        _quests = questsData.map((q) => Quest.fromJson(q)).toList();
        _stats = healthStats.isNotEmpty ? healthStats : stats;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  String _getSystemMessage() {
    final user = _userData['user'] ?? {};
    final streak = user['streak_days'] ?? 0;

    // Check for quests nearing completion
    final nearlyComplete = _quests.where((q) {
      if (q.targetValue == null || q.targetValue == 0) return false;
      return q.progress > 0.5 && q.progress < 1.0;
    }).toList();

    if (nearlyComplete.isNotEmpty) {
      final q = nearlyComplete.first;
      final remaining = q.targetValue! - q.currentValue;
      if (q.metricType == 'steps') {
        return '${q.title}: ${remaining.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => ',')} steps to go!';
      } else if (q.metricType == 'calories') {
        return '${q.title}: $remaining cal to go!';
      }
      return '${q.title}: Almost there!';
    }

    if (streak == 0) {
      return 'Complete a quest today to start your streak.';
    }

    return 'Daily quests reset at midnight. Complete all for +150 XP bonus.';
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.voidNavy,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.holoCyan),
        ),
      );
    }

    final user = _userData['user'] ?? {};
    final stats = _stats;

    return Scaffold(
      backgroundColor: AppColors.voidNavy,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadData,
          color: AppColors.holoCyan,
          backgroundColor: AppColors.slateSurface,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'OREUDA',
                        style: GoogleFonts.orbitron(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.holoCyan,
                          letterSpacing: 4,
                        ),
                      ),
                      Row(
                        children: [
                          if (_healthSyncing)
                            const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.holoCyan,
                              ),
                            ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const NotificationScreen(
                                    title: 'System Alert',
                                    message: 'Your daily quests have been generated. Execute.',
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: AppColors.slateSurface,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.holoCyan.withAlpha(51),
                                ),
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  const Icon(
                                    Icons.notifications_outlined,
                                    color: AppColors.pureWhite,
                                    size: 18,
                                  ),
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: Container(
                                      width: 8,
                                      height: 8,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColors.hpCrimson,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Rank Card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.deepAbyss, AppColors.slateSurface],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: AppColors.holoCyan.withAlpha(77),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user['display_name'] ?? 'Hunter',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.pureWhite,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Rank ${user['rank'] ?? 'E'} Hunter',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: AppColors.systemSilver,
                                  ),
                                ),
                              ],
                            ),
                            RankBadge(rank: user['rank'] ?? 'E'),
                          ],
                        ),
                        const SizedBox(height: 16),
                        XpBar(
                          currentXp: user['xp'] ?? 0,
                          level: user['level'] ?? 1,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.monetization_on, size: 14, color: AppColors.ariseGold),
                                const SizedBox(width: 4),
                                Text(
                                  '${user['gold'] ?? 0} G',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.ariseGold,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(Icons.local_fire_department, size: 14, color: AppColors.hpCrimson),
                                const SizedBox(width: 4),
                                Text(
                                  '${user['streak_days'] ?? 0}d streak',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.hpCrimson,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Stats Row
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.slateSurface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.white.withAlpha(13),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem('STR', stats['str_stat'] ?? 10, AppColors.strColor),
                        _buildStatItem('AGI', stats['agi_stat'] ?? 10, AppColors.agiColor),
                        _buildStatItem('VIT', stats['vit_stat'] ?? 10, AppColors.vitColor),
                        _buildStatItem('INT', stats['int_stat'] ?? 10, AppColors.intColor),
                        _buildStatItem('SEN', stats['sen_stat'] ?? 10, AppColors.senColor),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // System Message
                SystemMessage(message: _getSystemMessage()),

                const SizedBox(height: 16),

                // Daily Quests Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'DAILY QUESTS',
                            style: GoogleFonts.orbitron(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.mutedAsh,
                              letterSpacing: 2,
                            ),
                          ),
                          if (_healthSnapshot != null && _healthSnapshot!.authorized)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.successGreen.withAlpha(30),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.favorite, size: 10, color: AppColors.successGreen),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Live',
                                    style: TextStyle(
                                      fontSize: 9,
                                      color: AppColors.successGreen,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      if (_quests.isEmpty)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(24),
                            child: Text(
                              'No active quests. Pull down to generate daily quests.',
                              style: TextStyle(color: AppColors.mutedAsh, fontSize: 12),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      else
                        ..._quests.map((q) => QuestCard(
                          quest: q,
                          onComplete: q.status == 'active' ? () => _completeQuest(q.id) : null,
                        )),
                    ],
                  ),
                ),

                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _completeQuest(int questId) async {
    try {
      await ApiService.completeQuest(questId);
      await _loadData();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Quest completed. The System acknowledges your effort.'),
            backgroundColor: AppColors.successGreen,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to complete quest.'),
            backgroundColor: AppColors.hpCrimson,
          ),
        );
      }
    }
  }

  Widget _buildStatItem(String label, int value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: AppColors.mutedAsh,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '$value',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }
}
