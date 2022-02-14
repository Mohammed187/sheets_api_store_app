import 'dart:convert';

// id	user items	total	address	payment	date	status

enum Status { placed, confirmed, packed, transit, delivered }

class OrderFields {
  static const String id = 'id';
  static const String user = 'user';
  static const String items = 'items';
  static const String total = 'total';
  static const String address = 'address';
  static const String payment = 'payment';
  static const String date = 'date';
  static const String status = 'status';

  static List<String> getFields() =>
      [id, user, items, total, address, payment, date, status];
}

class Order {
  final int? id;
  final int? user;
  final String? items;
  final String? total;
  final String address;
  final String? payment;
  final String? date;
  final String? status;

  Order({
    this.id,
    required this.user,
    required this.items,
    required this.total,
    required this.address,
    required this.payment,
    required this.date,
    required this.status,
  });

  Order copy({
    int? id,
    int? user,
    String? items,
    String? total,
    String? address,
    String? payment,
    String? date,
    String? status,
  }) =>
      Order(
        id: id ?? this.id,
        user: user ?? this.user,
        items: items ?? this.items,
        total: total ?? this.total,
        address: address ?? this.address,
        payment: payment ?? this.payment,
        date: date ?? this.date,
        status: status ?? this.status,
      );

  Map<String, dynamic> toJson() => {
        OrderFields.user: user,
        OrderFields.items: items,
        OrderFields.total: total,
        OrderFields.address: address,
        OrderFields.payment: payment,
        OrderFields.date: date,
        OrderFields.status: status,
      };

  static Order fromJson(Map<String, dynamic> json) => Order(
        id: jsonDecode(json[OrderFields.id]),
        user: jsonDecode(json[OrderFields.user]),
        items: json[OrderFields.items],
        address: json[OrderFields.address],
        payment: json[OrderFields.payment],
        total: json[OrderFields.total],
        date: json[OrderFields.date],
        status: json[OrderFields.status],
      );
}
