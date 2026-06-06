import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../services/api_service.dart';
import '../services/tab_notifier.dart';

class GuildScreen extends StatefulWidget {
  const GuildScreen({super.key});

  @override
  State<GuildScreen> createState() => _GuildScreenState();
}

class _GuildScreenState extends State<GuildScreen> {
  List<dynamic> _guilds = [];
  bool _loading = true;
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
    if (TabNotifier.index.value == 3 && mounted) {
      _loadData();
    }
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    try {
      final data = await ApiService.getGuild();
      setState(() {
        _guilds = data;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _joinGuild(int guildId, String guildName) async {
    try {
      await ApiService.joinGuild(guildId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Joined $guildName'),
            backgroundColor: AppColors.successGreen,
          ),
        );
      }
      _loadData();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed: $e'),
            backgroundColor: AppColors.hpCrimson,
          ),
        );
      }
    }
  }

  Future<void> _showCreateDialog() async {
    final nameController = TextEditingController();
    final descController = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.slateSurface,
        title: const Text('Create Guild', style: TextStyle(color: AppColors.pureWhite)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              style: const TextStyle(color: AppColors.pureWhite),
              decoration: _inputDecoration('Guild Name'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descController,
              style: const TextStyle(color: AppColors.pureWhite),
              decoration: _inputDecoration('Description'),
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
            child: const Text('Create', style: TextStyle(color: AppColors.holoCyan)),
          ),
        ],
      ),
    );

    if (result == true && nameController.text.isNotEmpty) {
      try {
        await ApiService.createGuild(nameController.text, descController.text);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Guild created'),
              backgroundColor: AppColors.successGreen,
            ),
          );
        }
        _loadData();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed: $e'),
              backgroundColor: AppColors.hpCrimson,
            ),
          );
        }
      }
    }
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      hintText: label,
      hintStyle: const TextStyle(color: AppColors.mutedAsh),
      filled: true,
      fillColor: AppColors.deepAbyss,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.holoCyan.withAlpha(77)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.voidNavy,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'GUILDS',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.holoCyan,
                      letterSpacing: 3,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _showCreateDialog,
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('CREATE', style: TextStyle(fontSize: 11)),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator(color: AppColors.holoCyan))
                  : _error != null
                      ? Center(child: Text(_error!, style: const TextStyle(color: AppColors.hpCrimson)))
                      : _guilds.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.group_off, color: AppColors.mutedAsh, size: 48),
                                  const SizedBox(height: 16),
                                  const Text(
                                    'No guilds yet.\nBe the first to create one.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: AppColors.mutedAsh),
                                  ),
                                  const SizedBox(height: 16),
                                  ElevatedButton(
                                    onPressed: _showCreateDialog,
                                    child: const Text('CREATE GUILD'),
                                  ),
                                ],
                              ),
                            )
                          : RefreshIndicator(
                              onRefresh: _loadData,
                              color: AppColors.holoCyan,
                              backgroundColor: AppColors.slateSurface,
                              child: ListView.builder(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                itemCount: _guilds.length,
                                itemBuilder: (context, index) {
                                  final guild = _guilds[index];
                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 8),
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: AppColors.slateSurface,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: Colors.white.withAlpha((0.04 * 255).round()),
                                      ),
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
                                          child: const Icon(Icons.group, color: AppColors.holoCyan, size: 20),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                guild['name'] ?? 'Unknown',
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: AppColors.pureWhite,
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                guild['description'] ?? '',
                                                style: const TextStyle(
                                                  fontSize: 11,
                                                  color: AppColors.mutedAsh,
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                '${guild['member_count'] ?? 0} / ${guild['max_members'] ?? 50} members',
                                                style: const TextStyle(
                                                  fontSize: 10,
                                                  color: AppColors.systemSilver,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: () => _joinGuild(guild['id'], guild['name']),
                                          style: ElevatedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                            backgroundColor: AppColors.holoCyan.withAlpha((0.2 * 255).round()),
                                          ),
                                          child: const Text(
                                            'JOIN',
                                            style: TextStyle(fontSize: 11, color: AppColors.holoCyan),
                                          ),
                                        ),
                                      ],
                                    ),
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
