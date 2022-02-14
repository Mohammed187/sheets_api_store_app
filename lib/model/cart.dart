import 'dart:convert';

// id	name	email 	password	phone	address	role

class CartFields {
  static const String id = 'id';
  static const String user = 'user';
  static const String item = 'item';
  static const String name = 'name';
  static const String price = 'price';
  static const String quantity = 'quantity';
  static const String total = 'total';

  static List<String> getFields() =>
      [id, user, item, name, price, quantity, total];
}

class Cart {
  final int? id;
  final int? user;
  final int? item;
  final String? name;
  final String price;
  final int? quantity;
  final String? total;

  Cart({
    this.id,
    required this.user,
    required this.item,
    required this.name,
    required this.price,
    required this.quantity,
    this.total,
  });

  Cart copy({
    int? id,
    int? user,
    int? item,
    String? name,
    String? price,
    int? quantity,
    String? total,
  }) =>
      Cart(
        id: id ?? this.id,
        user: user ?? this.user,
        item: item ?? this.item,
        name: name ?? this.name,
        price: price ?? this.price,
        quantity: quantity ?? this.quantity,
        total: total ?? this.total,
      );

  Map<String, dynamic> toJson() => {
        CartFields.user: user,
        CartFields.item: item,
        CartFields.name: name,
        CartFields.price: price,
        CartFields.quantity: quantity,
      };

  static Cart fromJson(Map<String, dynamic> json) => Cart(
        id: jsonDecode(json[CartFields.id]),
        user: jsonDecode(json[CartFields.user]),
        item: jsonDecode(json[CartFields.item]),
        name: json[CartFields.name],
        price: json[CartFields.price],
        quantity: jsonDecode(json[CartFields.quantity]),
        total: json[CartFields.total],
      );
}
