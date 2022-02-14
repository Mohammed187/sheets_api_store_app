import 'dart:convert';

// id	name 	category	delivery	image	rate

class RestaurantFields {
  static const String id = 'id';
  static const String name = 'name';
  static const String category = 'category';
  static const String delivery = 'delivery';
  static const String image = 'image';
  static const String rate = 'rate';

  static List<String> getFields() =>
      [id, name, category, delivery, image, rate];
}

class Restaurant {
  final int? id;
  final String name;
  final String category;
  final String delivery;
  final String image;
  final int rate;

  Restaurant({
    required this.id,
    required this.name,
    required this.category,
    required this.delivery,
    required this.image,
    required this.rate,
  });

  static Restaurant fromJson(Map<String, dynamic> json) => Restaurant(
        id: jsonDecode(json[RestaurantFields.id]),
        name: json[RestaurantFields.name],
        category: json[RestaurantFields.category],
        delivery: json[RestaurantFields.delivery],
        image: json[RestaurantFields.image],
        rate: jsonDecode(json[RestaurantFields.rate]),
      );
}
