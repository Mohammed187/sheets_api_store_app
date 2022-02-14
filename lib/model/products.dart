import 'dart:convert';

// id	category	restaurant	name	description	image	price

class ProductFields {
  static const String id = 'id';
  static const String category = 'category';
  static const String restaurant = 'restaurant';
  static const String name = 'name';
  static const String description = 'description';
  static const String image = 'image';
  static const String price = 'price';

  static List<String> getFields() =>
      [id, category, restaurant, name, description, image, price];
}

class Product {
  final int? id;
  final String category;
  final String restaurant;
  final String name;
  final String description;
  final String image;
  final String price;

  Product({
    required this.id,
    required this.category,
    required this.restaurant,
    required this.name,
    required this.description,
    required this.image,
    required this.price,
  });

  static Product fromJson(Map<String, dynamic> json) => Product(
        id: jsonDecode(json[ProductFields.id]),
        category: json[ProductFields.category],
        restaurant: json[ProductFields.restaurant],
        name: json[ProductFields.name],
        description: json[ProductFields.description],
        image: json[ProductFields.image],
        price: json[ProductFields.price],
      );
}
