import 'dart:convert';

// id	name	email 	password	phone	address	role

class UserFields {
  static const String id = 'id';
  static const String name = 'name';

  static const String email = 'email';
  static const String password = 'password';
  static const String phone = 'phone';
  static const String address = 'address';
  static const String role = 'role';

  static List<String> getFields() =>
      [id, name, email, password, phone, address, role];
}

class User {
  final int? id;
  final String name;

  final String email;
  final String password;
  final String phone;
  final String address;
  final int role;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
    required this.address,
    required this.role,
  });

  User copy({
    int? id,
    String? name,
    String? email,
    String? password,
    String? phone,
    String? address,
    int? role,
  }) =>
      User(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        password: password ?? this.password,
        phone: phone ?? this.phone,
        address: address ?? this.address,
        role: role ?? this.role,
      );

  Map<String, dynamic> toJson() => {
        UserFields.name: name,
        UserFields.email: email,
        UserFields.password: password,
        UserFields.phone: phone,
        UserFields.address: address,
        UserFields.role: role,
      };

  static User fromJson(Map<String, dynamic> json) => User(
        id: jsonDecode(json[UserFields.id]),
        name: json[UserFields.name],
        email: json[UserFields.email],
        password: json[UserFields.password],
        phone: json[UserFields.phone],
        address: json[UserFields.address],
        role: jsonDecode(json[UserFields.role]),
      );
}
