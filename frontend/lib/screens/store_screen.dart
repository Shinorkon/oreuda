import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../services/api_service.dart';
import '../services/tab_notifier.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  List<dynamic> _items = [];
  bool _loading = true;
  String? _error;
  int _gold = 0;

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
    if (TabNotifier.index.value == 2 && mounted) {
      _loadData();
    }
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    try {
      final user = await ApiService.getMe();
      final items = await ApiService.getStoreItems();
      setState(() {
        _gold = user['gold'] ?? 0;
        _items = items;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _buyItem(dynamic item) async {
    try {
      await ApiService.buyItem(item['id']);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Purchased: ${item['name']}'),
            backgroundColor: AppColors.successGreen,
          ),
        );
      }
      _loadData();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Purchase failed: $e'),
            backgroundColor: AppColors.hpCrimson,
          ),
        );
      }
    }
  }

  Color _rarityColor(String rarity) {
    switch (rarity) {
      case 'legendary': return const Color(0xFFFF9800);
      case 'epic': return const Color(0xFF9C27B0);
      case 'rare': return AppColors.systemBlue;
      case 'common': return AppColors.mutedAsh;
      default: return AppColors.mutedAsh;
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
                    'BLACK MARKET',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.holoCyan,
                      letterSpacing: 3,
                    ),
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
                          '$_gold',
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
            ),

            // Items list
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator(color: AppColors.holoCyan))
                  : _error != null
                      ? Center(child: Text(_error!, style: const TextStyle(color: AppColors.hpCrimson)))
                      : _items.isEmpty
                          ? const Center(
                              child: Text(
                                'No items available.',
                                style: TextStyle(color: AppColors.mutedAsh),
                              ),
                            )
                          : RefreshIndicator(
                              onRefresh: _loadData,
                              color: AppColors.holoCyan,
                              backgroundColor: AppColors.slateSurface,
                              child: ListView.builder(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                itemCount: _items.length,
                                itemBuilder: (context, index) {
                                  final item = _items[index];
                                  final rarity = item['rarity'] ?? 'common';
                                  final canAfford = _gold >= (item['gold_cost'] ?? 0);

                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 8),
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: AppColors.slateSurface,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: _rarityColor(rarity).withAlpha((0.3 * 255).round()),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: _rarityColor(rarity).withAlpha((0.1 * 255).round()),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Icon(
                                            item['item_type'] == 'consumable'
                                                ? Icons.local_dining
                                                : item['item_type'] == 'gear'
                                                    ? Icons.shield
                                                    : Icons.card_giftcard,
                                            color: _rarityColor(rarity),
                                            size: 20,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item['name'] ?? 'Unknown',
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: AppColors.pureWhite,
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                item['description'] ?? '',
                                                style: const TextStyle(
                                                  fontSize: 11,
                                                  color: AppColors.mutedAsh,
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 4),
                                              Row(
                                                children: [
                                                  Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                    decoration: BoxDecoration(
                                                      color: _rarityColor(rarity).withAlpha((0.15 * 255).round()),
                                                      borderRadius: BorderRadius.circular(4),
                                                    ),
                                                    child: Text(
                                                      rarity.toUpperCase(),
                                                      style: TextStyle(
                                                        fontSize: 9,
                                                        fontWeight: FontWeight.w700,
                                                        color: _rarityColor(rarity),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Text(
                                                    '${item['gold_cost']} G',
                                                    style: const TextStyle(
                                                      fontSize: 11,
                                                      color: AppColors.ariseGold,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: canAfford ? () => _buyItem(item) : null,
                                          style: ElevatedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                            backgroundColor: canAfford
                                                ? AppColors.holoCyan.withAlpha((0.2 * 255).round())
                                                : AppColors.mutedAsh.withAlpha((0.2 * 255).round()),
                                          ),
                                          child: Text(
                                            'BUY',
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: canAfford ? AppColors.holoCyan : AppColors.mutedAsh,
                                            ),
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
