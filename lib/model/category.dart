import 'dart:convert';

class CategoryFields {
  static const String id = 'id';
  static const String name = 'title';
  static const String image = 'image';

  static List<String> getFields() => [id, name, image];
}

class Category {
  final int? id;
  final String title;
  final String image;

  Category({
    required this.id,
    required this.title,
    required this.image,
  });

  static Category fromJson(Map<String, dynamic> json) => Category(
        id: jsonDecode(json[CategoryFields.id]),
        title: json[CategoryFields.name],
        image: json[CategoryFields.image],
      );
}
