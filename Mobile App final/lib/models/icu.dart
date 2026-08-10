class Icu {
  final String id;
  final String type;
  final bool isAvailable;

  const Icu({
    required this.id,
    required this.type,
    required this.isAvailable,
  });

  factory Icu.fromJson(Map<String, dynamic> json) {
    return Icu(
      id: json['id']?.toString() ?? '',
      type: json['type']?.toString() ?? 'General',
      isAvailable:
      json['isAvailable'] as bool? ?? false,
    );
  }
}