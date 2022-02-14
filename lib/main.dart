import 'package:flutter/material.dart';
import 'package:online_store_sheets/api/store_sheets_api.dart';
import 'package:online_store_sheets/pages/cart_page.dart';
import 'package:online_store_sheets/pages/home_page.dart';
import 'package:online_store_sheets/pages/login_page.dart';
import 'package:online_store_sheets/pages/orders_page.dart';
import 'package:online_store_sheets/pages/products_page.dart';
import 'package:online_store_sheets/pages/profile_page.dart';
import 'package:online_store_sheets/pages/register_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Init API
  await StoreSheetsApi.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Delivery App',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        fontFamily: 'titillium',
      ),
      initialRoute: LoginPage.id,
      routes: {
        HomePage.id: (context) => HomePage(),
        LoginPage.id: (context) => LoginPage(),
        RegisterPage.id: (context) => RegisterPage(),
        ProductsPage.id: (context) => ProductsPage(),
        CartPage.id: (context) => CartPage(),
        ProfilePage.id: (context) => ProfilePage(),
        OrdersPage.id: (context) => OrdersPage(),
      },
    );
  }
}
