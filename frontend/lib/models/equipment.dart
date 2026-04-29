class Equipment {
  final String id;
  final String itemName;
  final double price;
  final String condition;
  final String sportType;
  final String sellerId;
  final bool isAvailable;

  Equipment({
    required this.id, required this.itemName, required this.price,
    required this.condition, required this.sportType, required this.sellerId, required this.isAvailable
  });

  factory Equipment.fromJson(Map<String, dynamic> json) => Equipment(
    id: json['id'], itemName: json['item_name'], price: (json['price'] as num).toDouble(),
    condition: json['condition'], sportType: json['sport_type'],
    sellerId: json['seller_id'], isAvailable: json['is_available']
  );
}
