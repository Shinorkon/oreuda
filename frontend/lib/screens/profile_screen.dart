import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../services/api_service.dart';
import '../services/tab_notifier.dart';
import '../widgets/rank_badge.dart';
import 'leaderboard_screen.dart';

class _StatAllocation {
  int str = 0, agi = 0, vit = 0, int_ = 0, sen = 0;
  int get total => str + agi + vit + int_ + sen;
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? _profileData;
  bool _isLoading = true;

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
    if (TabNotifier.index.value == 4 && mounted) {
      _loadData();
    }
  }

  Future<void> _showStatAllocationDialog(int availablePoints) async {
    final alloc = _StatAllocation();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) {
          Widget buildStatRow(String label, int value, ValueChanged<int> onChanged, Color color) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  SizedBox(
                    width: 40,
                    child: Text(
                      label,
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: color),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline, color: AppColors.mutedAsh, size: 20),
                    onPressed: value > 0 ? () => setDialogState(() => onChanged(value - 1)) : null,
                  ),
                  SizedBox(
                    width: 32,
                    child: Text(
                      '$value',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.pureWhite),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline, color: AppColors.holoCyan, size: 20),
                    onPressed: alloc.total < availablePoints
                        ? () => setDialogState(() => onChanged(value + 1))
                        : null,
                  ),
                  const Spacer(),
                  Text(
                    'Allocating: $value',
                    style: const TextStyle(fontSize: 11, color: AppColors.mutedAsh),
                  ),
                ],
              ),
            );
          }

          return AlertDialog(
            backgroundColor: AppColors.slateSurface,
            title: const Text(
              'ALLOCATE STATS',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.holoCyan, letterSpacing: 2),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Points available: ${availablePoints - alloc.total}',
                  style: const TextStyle(fontSize: 12, color: AppColors.ariseGold, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),
                buildStatRow('STR', alloc.str, (v) => alloc.str = v, AppColors.hpCrimson),
                buildStatRow('AGI', alloc.agi, (v) => alloc.agi = v, AppColors.holoCyan),
                buildStatRow('VIT', alloc.vit, (v) => alloc.vit = v, AppColors.successGreen),
                buildStatRow('INT', alloc.int_, (v) => alloc.int_ = v, AppColors.ariseGold),
                buildStatRow('SEN', alloc.sen, (v) => alloc.sen = v, AppColors.mutedAsh),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Cancel', style: TextStyle(color: AppColors.mutedAsh)),
              ),
              ElevatedButton(
                onPressed: alloc.total > 0 ? () => Navigator.pop(ctx, true) : null,
                child: const Text('Confirm'),
              ),
            ],
          );
        },
      ),
    );

    if (confirmed == true && alloc.total > 0) {
      setState(() => _isLoading = true);
      try {
        await ApiService.allocateStats(
          str: alloc.str,
          agi: alloc.agi,
          vit: alloc.vit,
          int_: alloc.int_,
          sen: alloc.sen,
        );
        await _loadData();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Stats allocated. You have grown stronger.'),
              backgroundColor: AppColors.successGreen,
            ),
          );
        }
      } catch (e) {
        setState(() => _isLoading = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to allocate: $e'), backgroundColor: AppColors.hpCrimson),
          );
        }
      }
    }
  }

  Future<void> _loadData() async {
    try {
      final data = await ApiService.getMe();
      setState(() {
        _profileData = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load profile: $e'),
            backgroundColor: AppColors.hpCrimson,
          ),
        );
      }
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

    final user = _profileData;
    final stats = _profileData?['stats'];
    final titles = (_profileData?['titles'] as List<dynamic>? ?? []);

    return Scaffold(
      backgroundColor: AppColors.voidNavy,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadData,
          color: AppColors.holoCyan,
          backgroundColor: AppColors.slateSurface,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    const SizedBox(height: 24),

                    // Avatar
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.deepAbyss,
                            border: Border.all(
                              color: AppColors.holoCyan.withAlpha((0.4 * 255).round()),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.holoCyan.withAlpha((0.2 * 255).round()),
                                blurRadius: 20,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.person,
                            size: 40,
                            color: AppColors.systemSilver,
                          ),
                        ),
                        Positioned(
                          bottom: -2,
                          right: -2,
                          child: RankBadge(
                            rank: user?['rank'] ?? 'E',
                            size: 32,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    Text(
                      user?['display_name'] ?? 'Hunter',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.pureWhite,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      'Level ${user?['level'] ?? 1} ${user?['rank'] ?? 'E'}-Rank Hunter',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.holoCyan,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Stats Grid
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.slateSurface,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'STATS',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: AppColors.mutedAsh,
                                letterSpacing: 3,
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildStatBar('STR', stats?['str_stat'] ?? 10, AppColors.strColor),
                            _buildStatBar('AGI', stats?['agi_stat'] ?? 10, AppColors.agiColor),
                            _buildStatBar('VIT', stats?['vit_stat'] ?? 10, AppColors.vitColor),
                            _buildStatBar('INT', stats?['int_stat'] ?? 10, AppColors.intColor),
                            _buildStatBar('SEN', stats?['sen_stat'] ?? 10, AppColors.senColor),
                            const SizedBox(height: 12),
                            if ((stats?['distributable_points'] ?? 0) > 0)
                              GestureDetector(
                                onTap: () => _showStatAllocationDialog(stats?['distributable_points'] ?? 0),
                                child: Container(
                                  margin: const EdgeInsets.only(top: 8),
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: AppColors.ariseGold.withAlpha((0.1 * 255).round()),
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: AppColors.ariseGold.withAlpha((0.3 * 255).round()),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.add_chart, color: AppColors.ariseGold, size: 14),
                                      const SizedBox(width: 6),
                                      Text(
                                        '${stats?['distributable_points']} Points — TAP TO ALLOCATE',
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: AppColors.ariseGold,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Titles
                    if (titles.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.slateSurface,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'TITLES',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.mutedAsh,
                                  letterSpacing: 3,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: titles.map<Widget>((t) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.ariseGold.withAlpha((0.1 * 255).round()),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: AppColors.ariseGold.withAlpha((0.3 * 255).round()),
                                      ),
                                    ),
                                    child: Text(
                                      t['title_name'],
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: AppColors.ariseGold,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      ),

                    const SizedBox(height: 16),

                    // Rank Track
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.slateSurface,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'RANK PROGRESSION',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: AppColors.mutedAsh,
                                letterSpacing: 3,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: ['E', 'D', 'C', 'B', 'A', 'S'].map((rank) {
                                final currentRank = user?['rank'] ?? 'E';
                                final rankOrder = ['E', 'D', 'C', 'B', 'A', 'S'];
                                final isCompleted = rankOrder.indexOf(rank) <= rankOrder.indexOf(currentRank);
                                final isCurrent = rank == currentRank;

                                return Column(
                                  children: [
                                    Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: isCompleted
                                            ? (isCurrent ? AppColors.systemBlue : AppColors.successGreen)
                                            : Colors.transparent,
                                        border: Border.all(
                                          color: isCompleted
                                              ? (isCurrent ? AppColors.systemBlue : AppColors.successGreen)
                                              : Colors.white.withAlpha((0.2 * 255).round()),
                                          width: 2,
                                        ),
                                        boxShadow: isCurrent
                                            ? [
                                                BoxShadow(
                                                  color: AppColors.systemBlue.withAlpha((0.5 * 255).round()),
                                                  blurRadius: 10,
                                                ),
                                              ]
                                            : null,
                                      ),
                                      child: isCompleted
                                          ? const Icon(Icons.check, size: 12, color: AppColors.black)
                                          : null,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      rank,
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: isCompleted
                                            ? (isCurrent ? AppColors.systemBlue : AppColors.successGreen)
                                            : AppColors.mutedAsh,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Leaderboard Button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const LeaderboardScreen(),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.slateSurface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.ariseGold.withAlpha((0.3 * 255).round()),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.emoji_events,
                                color: AppColors.ariseGold.withAlpha((0.8 * 255).round()),
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'GLOBAL RANKINGS',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.pureWhite,
                                        letterSpacing: 2,
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      'See where you stand among all hunters',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: AppColors.mutedAsh,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(
                                Icons.chevron_right,
                                color: AppColors.mutedAsh,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatBar(String label, int value, Color color) {
    final maxValue = 100.0;
    final progress = (value / maxValue).clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          SizedBox(
            width: 30,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: Container(
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha((0.06 * 255).round()),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: progress,
                  child: Container(
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 30,
            child: Text(
              '$value',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
