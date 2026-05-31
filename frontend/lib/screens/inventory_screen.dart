import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../services/api_service.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  List<dynamic> _items = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    try {
      final data = await ApiService.getInventory();
      setState(() {
        _items = data['items'] ?? [];
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _useItem(dynamic item) async {
    try {
      await ApiService.useItem(item['id']);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Used: ${item['item_name']}'),
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

  Future<void> _equipItem(dynamic item) async {
    try {
      await ApiService.equipItem(item['id']);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${item['equipped'] ? 'Unequipped' : 'Equipped'}: ${item['item_name']}'),
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
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'INVENTORY',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.holoCyan,
                  letterSpacing: 3,
                ),
              ),
            ),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator(color: AppColors.holoCyan))
                  : _error != null
                      ? Center(child: Text(_error!, style: const TextStyle(color: AppColors.hpCrimson)))
                      : _items.isEmpty
                          ? const Center(
                              child: Text(
                                'Your inventory is empty.\nVisit the Black Market.',
                                textAlign: TextAlign.center,
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
                                  final isEquipped = item['equipped'] ?? false;
                                  final isConsumable = item['item_type'] == 'consumable';

                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 8),
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: AppColors.slateSurface,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: isEquipped
                                            ? AppColors.holoCyan.withAlpha((0.5 * 255).round())
                                            : Colors.white.withAlpha((0.04 * 255).round()),
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
                                            isConsumable
                                                ? Icons.local_dining
                                                : Icons.shield,
                                            color: _rarityColor(rarity),
                                            size: 20,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    item['item_name'] ?? 'Unknown',
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w600,
                                                      color: AppColors.pureWhite,
                                                    ),
                                                  ),
                                                  if (isEquipped) ...[
                                                    const SizedBox(width: 8),
                                                    Container(
                                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                      decoration: BoxDecoration(
                                                        color: AppColors.holoCyan.withAlpha((0.15 * 255).round()),
                                                        borderRadius: BorderRadius.circular(4),
                                                      ),
                                                      child: const Text(
                                                        'EQUIPPED',
                                                        style: TextStyle(
                                                          fontSize: 8,
                                                          fontWeight: FontWeight.w700,
                                                          color: AppColors.holoCyan,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ],
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
                                                    'x${item['quantity'] ?? 1}',
                                                    style: const TextStyle(
                                                      fontSize: 11,
                                                      color: AppColors.systemSilver,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        if (isConsumable)
                                          ElevatedButton(
                                            onPressed: () => _useItem(item),
                                            style: ElevatedButton.styleFrom(
                                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                              backgroundColor: AppColors.successGreen.withAlpha((0.2 * 255).round()),
                                            ),
                                            child: const Text(
                                              'USE',
                                              style: TextStyle(fontSize: 11, color: AppColors.successGreen),
                                            ),
                                          )
                                        else
                                          ElevatedButton(
                                            onPressed: () => _equipItem(item),
                                            style: ElevatedButton.styleFrom(
                                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                              backgroundColor: isEquipped
                                                  ? AppColors.hpCrimson.withAlpha((0.2 * 255).round())
                                                  : AppColors.holoCyan.withAlpha((0.2 * 255).round()),
                                            ),
                                            child: Text(
                                              isEquipped ? 'UNEQUIP' : 'EQUIP',
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: isEquipped ? AppColors.hpCrimson : AppColors.holoCyan,
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
