class Item {
  final String name;
  final String category;
  final double price;
  final DateTime date;

  Item({
    this.name,
    this.category,
    this.price,
    this.date,
  });

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      name: map['name'] ?? '?',
      category: map['category'] ?? 'Any',
      price: (map['price'] ?? 0).toDouble(),
      date: map['date'] == null ? DateTime.now() : DateTime.parse(map['date']),
    );
  }
}
