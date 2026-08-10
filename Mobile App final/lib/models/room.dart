class Room {
  final String id;
  final String type;
  final bool isAvailable;
  final double price;

  const Room({
    required this.id,
    required this.type,
    required this.isAvailable,
    required this.price,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id']?.toString() ?? '',
      type: json['type']?.toString() ?? 'General',
      isAvailable:
      json['isAvailable'] as bool? ?? false,
      price:
      (json['price'] as num?)?.toDouble() ?? 0.0,
    );
  }
}