class InventoryItem {
  final int id;
  final String itemName;
  final String itemType;
  final String rarity;
  final int quantity;
  final bool equipped;
  final Map<String, dynamic>? statBonuses;
  final String description;

  InventoryItem({
    required this.id,
    required this.itemName,
    required this.itemType,
    required this.rarity,
    required this.quantity,
    required this.equipped,
    this.statBonuses,
    required this.description,
  });

  factory InventoryItem.fromJson(Map<String, dynamic> json) {
    return InventoryItem(
      id: json['id'],
      itemName: json['item_name'],
      itemType: json['item_type'],
      rarity: json['rarity'],
      quantity: json['quantity'],
      equipped: json['equipped'],
      statBonuses: json['stat_bonuses'],
      description: json['description'] ?? '',
    );
  }
}

class StoreItem {
  final int id;
  final String name;
  final String description;
  final String itemType;
  final String rarity;
  final int goldCost;
  final int essenceCost;

  StoreItem({
    required this.id,
    required this.name,
    required this.description,
    required this.itemType,
    required this.rarity,
    required this.goldCost,
    required this.essenceCost,
  });

  factory StoreItem.fromJson(Map<String, dynamic> json) {
    return StoreItem(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? '',
      itemType: json['item_type'],
      rarity: json['rarity'],
      goldCost: json['gold_cost'],
      essenceCost: json['essence_cost'],
    );
  }
}
