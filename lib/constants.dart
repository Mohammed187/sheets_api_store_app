import 'package:flutter/material.dart';

const Color primaryColor = Colors.teal;
const Color secondaryColor = Color.fromARGB(255, 135, 108, 211);
const Color textColor = Colors.white;
const Color whiteColor = Colors.white;
const Color redColor = Color.fromARGB(255, 94, 12, 12);

const double defaultPadding = 10.0;
const double defaultMargin = 10.0;

const double titleFontSize = 20.0;

final profileList = [
  ProfileItem(Icons.document_scanner, 'Orders'),
  ProfileItem(Icons.favorite_outline, 'Favourites'),
  ProfileItem(Icons.details, 'My Details'),
  ProfileItem(Icons.payment_outlined, 'payment Methods'),
  ProfileItem(Icons.location_on_outlined, 'Saved Addresses'),
  ProfileItem(Icons.exit_to_app, 'Log out'),
];

class ProfileItem {
  IconData? icon;
  String? title;

  ProfileItem(this.icon, this.title);
}
