class PizzaItem {
  final int? id; // ID opcional para ser gerado automaticamente
  final String name;
  final String price;
  final String imagePath;

  PizzaItem({
    this.id,
    required this.name,
    required this.price,
    required this.imagePath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'imagePath': imagePath,
    };
  }

  factory PizzaItem.fromMap(Map<String, dynamic> map) {
    return PizzaItem(
      id: map['id'],
      name: map['name'],
      price: map['price'],
      imagePath: map['imagePath'],
    );
  }
}
