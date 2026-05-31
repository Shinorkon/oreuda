import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/colors.dart';
import '../models/quest.dart';
import '../services/api_service.dart';
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

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final user = await ApiService.getMe();
      final questsData = await ApiService.getDailyQuests();
      final stats = await ApiService.getStats();
      setState(() {
        _userData = user;
        _quests = questsData.map((q) => Quest.fromJson(q)).toList();
        _stats = stats;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
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
                        _buildStatItem('STR', _stats['str_stat'] ?? 10, AppColors.strColor),
                        _buildStatItem('AGI', _stats['agi_stat'] ?? 10, AppColors.agiColor),
                        _buildStatItem('VIT', _stats['vit_stat'] ?? 10, AppColors.vitColor),
                        _buildStatItem('INT', _stats['int_stat'] ?? 10, AppColors.intColor),
                        _buildStatItem('SEN', _stats['sen_stat'] ?? 10, AppColors.senColor),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // System Message
                if (_systemMessage != null)
                  SystemMessage(message: _systemMessage!)
                else
                  const SystemMessage(
                    message: 'Daily quests reset in 4h 22m. Complete all 3 for +150 XP bonus.',
                  ),

                const SizedBox(height: 16),

                // Daily Quests Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                      const SizedBox(height: 10),
                      if (_quests.isEmpty)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(24),
                            child: Text(
                              'No active quests. Generate daily quests from the Quest Board.',
                              style: TextStyle(color: AppColors.mutedAsh, fontSize: 12),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      else
                        ..._quests.map((q) => QuestCard(
                          quest: q,
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
