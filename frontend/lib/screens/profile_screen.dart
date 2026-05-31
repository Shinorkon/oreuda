import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../services/api_service.dart';
import '../widgets/rank_badge.dart';

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

    final user = _profileData?['user'];
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
                              Text(
                                'Distributable Points: ${stats?['distributable_points']}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.ariseGold,
                                  fontWeight: FontWeight.w600,
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
