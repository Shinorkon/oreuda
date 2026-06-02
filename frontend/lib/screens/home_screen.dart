import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../models/quest.dart';
import '../models/stats.dart';
import '../services/api_service.dart';
import '../services/health_connect_service.dart';
import '../services/notification_service.dart';
import '../services/settings_service.dart';
import '../services/tab_notifier.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _loading = true;
  Map<String, dynamic>? _user;
  List<Quest> _quests = [];
  PlayerStats? _stats;
  HealthSnapshot? _health;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
    TabNotifier.index.addListener(_onTabChanged);
  }

  @override
  void dispose() {
    TabNotifier.index.removeListener(_onTabChanged);
    super.dispose();
  }

  void _onTabChanged() {
    if (TabNotifier.index.value == 0 && mounted) {
      _loadData();
    }
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    try {
      // Sync health data
      final health = await _syncHealthData();
      // Check quest completion (backend auto-completes)
      final completed = await ApiService.checkQuestCompletion();
      // Send notifications for completed quests
      if (completed.isNotEmpty && SettingsService.instance.questWarnings) {
        for (final q in completed) {
          await NotificationService.instance.showQuestComplete(
            questTitle: q.title,
            xpReward: q.xpReward,
            goldReward: q.goldReward,
          );
        }
      }
      // Fetch daily quests
      final quests = await ApiService.getDailyQuests();
      // Fetch user and stats
      final user = await ApiService.getMe();
      final stats = await ApiService.getStats();

      setState(() {
        _user = user;
        _quests = quests;
        _stats = stats;
        _health = health;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<HealthSnapshot?> _syncHealthData() async {
    try {
      final snapshot = await HealthConnectService.instance.fetchToday();
      // Only sync if Health Connect is actually authorized and has real data
      if (snapshot.authorized && snapshot.steps > 0) {
        await ApiService.syncHealth(snapshot);
        return snapshot;
      }
    } catch (e) {
      // Health Connect not available or not authorized
      debugPrint('Health sync error: $e');
    }
    return null;
  }

  Future<void> _completeQuest(Quest quest) async {
    try {
      await ApiService.completeQuest(quest.id);
      await NotificationService.instance.showQuestComplete(
        questTitle: quest.title,
        xpReward: quest.xpReward,
        goldReward: quest.goldReward,
      );
      _loadData();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: AppColors.voidNavy,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.holoCyan),
        ),
      );
    }

    if (_error != null) {
      return Scaffold(
        backgroundColor: AppColors.voidNavy,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: AppColors.hpCrimson, size: 48),
              const SizedBox(height: 16),
              Text(_error!, style: const TextStyle(color: AppColors.pureWhite)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadData,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.voidNavy,
      body: RefreshIndicator(
        color: AppColors.holoCyan,
        backgroundColor: AppColors.slateSurface,
        onRefresh: _loadData,
        child: CustomScrollView(
          slivers: [
            // App Bar
            SliverToBoxAdapter(
              child: _buildHeader(),
            ),
            // Stats Row
            SliverToBoxAdapter(
              child: _buildStatsRow(),
            ),
            // Health Data
            if (_health != null)
              SliverToBoxAdapter(
                child: _buildHealthCard(),
              ),
            // Quests Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'ACTIVE QUESTS',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.mutedAsh,
                        letterSpacing: 3,
                      ),
                    ),
                    Text(
                      '${_quests.where((q) => q.status == 'active').length} REMAINING',
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.mutedAsh,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _buildQuestCard(_quests[index]),
                childCount: _quests.length,
              ),
            ),
            const SliverPadding(padding: EdgeInsets.only(bottom: 32)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final level = _user?['level'] ?? 1;
    final xp = _user?['xp'] ?? 0;
    final nextLevelXp = level * 1000;
    final progress = (xp / nextLevelXp).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _user?['username']?.toUpperCase() ?? 'HUNTER',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: AppColors.pureWhite,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'RANK: ${_user?['rank'] ?? 'E'}  |  LEVEL $level',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.holoCyan,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.ariseGold.withAlpha((0.1 * 255).round()),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.monetization_on, color: AppColors.ariseGold, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '${_user?['gold'] ?? 0}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ariseGold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // XP Bar
          Container(
            height: 6,
            decoration: BoxDecoration(
              color: AppColors.deepAbyss,
              borderRadius: BorderRadius.circular(3),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress,
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.holoCyan, AppColors.holoCyan],
                  ),
                  borderRadius: BorderRadius.circular(3),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.holoCyan.withAlpha((0.5 * 255).round()),
                      blurRadius: 8,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '$xp / $nextLevelXp XP',
            style: const TextStyle(
              fontSize: 10,
              color: AppColors.mutedAsh,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    if (_stats == null) return const SizedBox.shrink();

    final stats = <Map<String, dynamic>>[
      {'label': 'STR', 'value': _stats!.strength, 'color': AppColors.hpCrimson},
      {'label': 'AGI', 'value': _stats!.agility, 'color': AppColors.holoCyan},
      {'label': 'VIT', 'value': _stats!.vitality, 'color': AppColors.successGreen},
      {'label': 'INT', 'value': _stats!.intelligence, 'color': AppColors.ariseGold},
      {'label': 'SEN', 'value': _stats!.sense, 'color': AppColors.mutedAsh},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: stats.map((s) => Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.slateSurface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: (s['color'] as Color).withAlpha((0.2 * 255).round()),
              ),
            ),
            child: Column(
              children: [
                Text(
                  s['label'] as String,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: s['color'] as Color,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${s['value']}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.pureWhite,
                  ),
                ),
              ],
            ),
          ),
        )).toList(),
      ),
    );
  }

  Widget _buildHealthCard() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.slateSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withAlpha((0.04 * 255).round())),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'TODAY\'S DATA',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.mutedAsh,
              letterSpacing: 3,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildHealthMetric(Icons.directions_walk, '${_health!.steps}', 'Steps'),
              _buildHealthMetric(Icons.local_fire_department, '${_health!.caloriesBurned}', 'Kcal'),
              _buildHealthMetric(Icons.bedtime, '${(_health!.sleepMinutes / 60).toStringAsFixed(1)}h', 'Sleep'),
              _buildHealthMetric(Icons.fitness_center, '${_health!.workoutCount}', 'Workouts'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHealthMetric(IconData icon, String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: AppColors.holoCyan, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.pureWhite,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: AppColors.mutedAsh,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestCard(Quest quest) {
    final isCompleted = quest.status == 'completed';
    final progress = quest.targetValue != null && quest.targetValue! > 0
        ? (quest.currentValue / quest.targetValue!).clamp(0.0, 1.0)
        : 0.0;

    Color questColor = AppColors.holoCyan;
    if (quest.questType == 'daily') questColor = AppColors.holoCyan;
    if (quest.questType == 'weekly') questColor = AppColors.ariseGold;
    if (quest.questType == 'dungeon') questColor = AppColors.hpCrimson;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.slateSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCompleted
              ? AppColors.successGreen.withAlpha((0.3 * 255).round())
              : Colors.white.withAlpha((0.04 * 255).round()),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  quest.title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isCompleted ? AppColors.successGreen : AppColors.pureWhite,
                    decoration: isCompleted ? TextDecoration.lineThrough : null,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: questColor.withAlpha((0.1 * 255).round()),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  quest.questType.toUpperCase(),
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: questColor,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            quest.description,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.mutedAsh,
            ),
          ),
          const SizedBox(height: 12),
          // Progress bar
          if (quest.targetValue != null && quest.targetValue! > 0)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${quest.currentValue} / ${quest.targetValue}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.mutedAsh,
                      ),
                    ),
                    Text(
                      '${(progress * 100).toInt()}%',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: questColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.deepAbyss,
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: progress,
                    child: Container(
                      decoration: BoxDecoration(
                        color: isCompleted ? AppColors.successGreen : questColor,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildRewardBadge(Icons.star, '${quest.xpReward} XP', AppColors.ariseGold),
              const SizedBox(width: 8),
              _buildRewardBadge(Icons.monetization_on, '${quest.goldReward}', AppColors.ariseGold),
              const Spacer(),
              if (!isCompleted)
                GestureDetector(
                  onTap: () => _completeQuest(quest),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: questColor.withAlpha((0.15 * 255).round()),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: questColor.withAlpha((0.3 * 255).round()),
                      ),
                    ),
                    child: Text(
                      'COMPLETE',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: questColor,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRewardBadge(IconData icon, String text, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 12),
        const SizedBox(width: 2),
        Text(
          text,
          style: TextStyle(
            fontSize: 11,
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
