import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../models/quest.dart';
import '../services/api_service.dart';
import '../services/tab_notifier.dart';
import '../widgets/quest_card.dart';

class QuestBoardScreen extends StatefulWidget {
  const QuestBoardScreen({super.key});

  @override
  State<QuestBoardScreen> createState() => _QuestBoardScreenState();
}

class _QuestBoardScreenState extends State<QuestBoardScreen> {
  String _selectedTab = 'Daily';
  List<Quest> _quests = [];
  bool _isLoading = true;

  final List<String> _tabs = ['Daily', 'Weekly', 'Dungeons', 'Chains', 'Side'];

  @override
  void initState() {
    super.initState();
    _loadQuests();
    TabNotifier.index.addListener(_onTabChanged);
  }

  @override
  void dispose() {
    TabNotifier.index.removeListener(_onTabChanged);
    super.dispose();
  }

  void _onTabChanged() {
    if (TabNotifier.index.value == 1 && mounted) {
      _loadQuests();
    }
  }

  Future<void> _loadQuests() async {
    setState(() => _isLoading = true);
    try {
      final typeMap = {
        'Daily': 'daily',
        'Weekly': 'weekly',
        'Dungeons': 'dungeon',
        'Chains': 'chain',
        'Side': 'side',
      };
      final data = await ApiService.getQuests(type: typeMap[_selectedTab]);
      setState(() {
        _quests = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load quests: $e'),
            backgroundColor: AppColors.hpCrimson,
          ),
        );
      }
    }
  }

  Future<void> _generateDaily() async {
    setState(() => _isLoading = true);
    try {
      await ApiService.getDailyQuests();
      await _loadQuests();
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to generate quests: $e'),
            backgroundColor: AppColors.hpCrimson,
          ),
        );
      }
    }
  }

  Future<void> _completeQuest(int questId) async {
    try {
      await ApiService.completeQuest(questId);
      await _loadQuests();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.voidNavy,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'QUEST BOARD',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.holoCyan,
                      letterSpacing: 3,
                    ),
                  ),
                  if (_selectedTab == 'Daily')
                    ElevatedButton.icon(
                      onPressed: _generateDaily,
                      icon: const Icon(Icons.auto_fix_high, size: 16),
                      label: const Text('GENERATE', style: TextStyle(fontSize: 11)),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                    ),
                ],
              ),
            ),

            // Tabs
            Container(
              height: 40,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _tabs.length,
                itemBuilder: (context, index) {
                  final tab = _tabs[index];
                  final isActive = tab == _selectedTab;
                  return GestureDetector(
                    onTap: () {
                      setState(() => _selectedTab = tab);
                      _loadQuests();
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: isActive
                            ? AppColors.holoCyan.withAlpha((0.15 * 255).round())
                            : AppColors.slateSurface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isActive
                              ? AppColors.holoCyan.withAlpha((0.5 * 255).round())
                              : Colors.transparent,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        tab.toUpperCase(),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isActive ? AppColors.holoCyan : AppColors.mutedAsh,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // Quest List
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: AppColors.holoCyan),
                    )
                  : _quests.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _selectedTab == 'Dungeons'
                                    ? Icons.door_front_door_outlined
                                    : Icons.task_alt,
                                size: 48,
                                color: AppColors.mutedAsh.withAlpha((0.5 * 255).round()),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No ${_selectedTab.toLowerCase()} quests available.',
                                style: const TextStyle(
                                  color: AppColors.mutedAsh,
                                  fontSize: 14,
                                ),
                              ),
                              if (_selectedTab == 'Daily') ...[
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: _generateDaily,
                                  child: const Text('GENERATE DAILY QUESTS'),
                                ),
                              ],
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: _loadQuests,
                          color: AppColors.holoCyan,
                          backgroundColor: AppColors.slateSurface,
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: _quests.length,
                            itemBuilder: (context, index) {
                              final quest = _quests[index];
                              return QuestCard(
                                quest: quest,
                                onComplete: () => _completeQuest(quest.id),
                              );
                            },
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
