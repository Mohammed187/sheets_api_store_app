import 'package:flutter/material.dart';
import 'package:online_store_sheets/constants.dart';
import 'package:online_store_sheets/pages/login_page.dart';
import 'package:online_store_sheets/pages/orders_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  static const String id = '/profile';

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  

  // Log out user
  Future logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email', '');
    prefs.setString('password', '');

    setState(() {
      Navigator.pushNamedAndRemoveUntil(
          context, LoginPage.id, (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Account')),
      body: SizedBox(
        child: ListView.builder(
          itemCount: profileList.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: Icon(profileList[index].icon!),
              title: Text(profileList[index].title!),
              onTap: () {
                switch (index) {
                  case 0:
                    Navigator.pushNamed(context, OrdersPage.id);
                    break;
                  case 5:
                    logout();
                    break;
                  default:
                  // do nothing
                }
              },
            );
          },
        ),
      ),
    );
  }
}
