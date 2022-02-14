import 'dart:convert';

class PromoFields {
  static const String id = 'id';
  static const String name = 'title';
  static const String image = 'image';

  static List<String> getFields() => [id, name, image];
}

class Promo {
  final int? id;
  final String title;
  final String image;

  Promo({
    required this.id,
    required this.title,
    required this.image,
  });

  static Promo fromJson(Map<String, dynamic> json) => Promo(
        id: jsonDecode(json[PromoFields.id]),
        title: json[PromoFields.name],
        image: json[PromoFields.image],
      );
}
