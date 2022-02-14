import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gsheets/gsheets.dart';
import 'package:online_store_sheets/model/cart.dart';
import 'package:online_store_sheets/model/order.dart';
import 'package:online_store_sheets/model/products.dart';
import 'package:online_store_sheets/model/promo.dart';
import 'package:online_store_sheets/model/category.dart';
import 'package:online_store_sheets/model/restaurant.dart';
import 'package:online_store_sheets/model/user.dart';

class StoreSheetsApi {
  // Credentials
  static const _credentials = r'''{
  "type": "service_account",
  "project_id": "XXXXXXXX",
  "private_key_id": "XXXXXX",
  "private_key": "XXXXXXXXX",
  "client_email": "XXXXX",
  "client_id": "XXXXXXX",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/XXXXXXXX"
}
''';
  // Spreadsheet ID
  static const _spreadsheetId = '1gPs1T4YXAPfXRCe4ViKrhBNlrTwJZOVEowghLWUD50o';

  static final _gsheets = GSheets(_credentials);

  static Worksheet? _userSheet;
  static Worksheet? _categorySheet;
  static Worksheet? _promoSheet;
  static Worksheet? _restaurantSheet;
  static Worksheet? _productsSheet;
  static Worksheet? _cartSheet;
  static Worksheet? _orderSheet;

  static Future init() async {
    try {
      final spreadsheet = await _gsheets.spreadsheet(_spreadsheetId);

      _userSheet = await _getWorkSheet(spreadsheet, title: 'users');
      _categorySheet = await _getWorkSheet(spreadsheet, title: 'category');
      _promoSheet = await _getWorkSheet(spreadsheet, title: 'promo');
      _restaurantSheet = await _getWorkSheet(spreadsheet, title: 'restaurants');
      _productsSheet = await _getWorkSheet(spreadsheet, title: 'products');
      _cartSheet = await _getWorkSheet(spreadsheet, title: 'cart');
      _orderSheet = await _getWorkSheet(spreadsheet, title: 'order');

// Users Sheet
      final _firstRow = UserFields.getFields();
      _userSheet!.values.insertRow(1, _firstRow);
// Category Sheet
      final _firstCatRow = CategoryFields.getFields();
      _categorySheet!.values.insertRow(1, _firstCatRow);
// Promo Sheet
      final _firstPromoRow = PromoFields.getFields();
      _promoSheet!.values.insertRow(1, _firstPromoRow);
// Restaurant Sheet
      final _firstRxRow = RestaurantFields.getFields();
      _restaurantSheet!.values.insertRow(1, _firstRxRow);
// Products sheet
      final _firstProductsRow = ProductFields.getFields();
      _productsSheet!.values.insertRow(1, _firstProductsRow);
// Cart Fields
      final _firstCartRow = CartFields.getFields();
      _cartSheet!.values.insertRow(1, _firstCartRow);
    } catch (e) {
      debugPrint('Init Error: $e');
    }
  }

  static Future<Worksheet> _getWorkSheet(
    Spreadsheet spreadsheet, {
    required String title,
  }) async {
    try {
      return await spreadsheet.addWorksheet(title);
    } catch (e) {
      return spreadsheet.worksheetByTitle(title)!;
    }
  }

  // get all users
  static Future<List<User>> getUsers() async {
    if (_userSheet == null) return <User>[];

    final users = await _userSheet!.values.map.allRows();
    return users == null ? <User>[] : users.map(User.fromJson).toList();
  }

  // get user details by ID
  static Future<User?> getUserDetails(String email) async {
    if (_userSheet == null) return null;

    final user = await _userSheet!.values.map.allRows();
    if (user == null) {
      return null;
    } else {
      return user
          .map(User.fromJson)
          .where((element) => element.email == email)
          .toList()
          .first;
    }
  }

  // add User
  static Future<bool> addUser(Map<String, dynamic> user) async {
    if (_userSheet == null) return false;

    return await _userSheet!.values.map.appendRow(user, fromColumn: 2);
  }

  // check User
  static Future<bool> checkUser(String? email, String? password) async {
    if (_userSheet == null) return false;

    final users = await _userSheet!.values.map.allRows();
    return users == null
        ? false
        : users
            .map(User.fromJson)
            .where((element) =>
                element.email == email && element.password == password)
            .toList()
            .isNotEmpty;
  }

  // get all categories
  static Future<List<Category>> getCategories() async {
    if (_categorySheet == null) return <Category>[];

    final categories = await _categorySheet!.values.map.allRows();

    return categories == null
        ? <Category>[]
        : categories.map(Category.fromJson).toList();
  }

  // get all promo
  static Future<List<Promo>> getPromos() async {
    if (_promoSheet == null) return <Promo>[];

    final promos = await _promoSheet!.values.map.allRows();

    return promos == null ? <Promo>[] : promos.map(Promo.fromJson).toList();
  }

  // get all restaurant
  static Future<List<Restaurant>> getRestaurants() async {
    if (_restaurantSheet == null) return <Restaurant>[];

    final restaurants = await _restaurantSheet!.values.map.allRows();

    return restaurants == null
        ? <Restaurant>[]
        : restaurants.map(Restaurant.fromJson).toList();
  }

  // get all restaurant based on rate
  static Future<List<Restaurant>> getFeaturedRestaurants() async {
    if (_restaurantSheet == null) return <Restaurant>[];

    final restaurants = await _restaurantSheet!.values.map.allRows();

    return restaurants == null
        ? <Restaurant>[]
        : restaurants
            .map(Restaurant.fromJson)
            .where((element) => element.rate > 4)
            .toList();
  }

  // get products list for a Rx
  static Future<List<Product>> getRestaurantProducts(String? restaurant) async {
    if (_productsSheet == null) return <Product>[];

    final products = await _productsSheet!.values.map.allRows();

    return products == null
        ? <Product>[]
        : products
            .map(Product.fromJson)
            .where((element) => element.restaurant == restaurant)
            .toList();
  }

  // get product details by id
  static Future<Product?> getProductDetails(int? id) async {
    if (_productsSheet == null) return null;

    final products = await _productsSheet!.values.map.allRows();

    if (products == null) {
      return null;
    } else {
      return products
          .map(Product.fromJson)
          .firstWhere((element) => element.id == id);
    }
  }

// add to cart
  static Future<bool> addToCart(Map<String, dynamic> cart) async {
    if (_cartSheet == null) return false;

    return await _cartSheet!.values.map.appendRow(cart, fromColumn: 2);
  }

// check if the item in Cart
  static Future<List<Cart>?> checkItemInCart(int? user, int? id) async {
    if (_cartSheet == null) return <Cart>[];

    final cart = await _cartSheet!.values.map.allRows();

    return cart == null
        ? []
        : cart
            .map(Cart.fromJson)
            .where((element) => element.user == user && element.item == id)
            .toList();
  }

// update cart item
  static Future<bool> updateCartItem(int id, Map<String, dynamic> cart) async {
    if (_cartSheet == null) return false;

    return _cartSheet!.values.map.insertRowByKey(id, cart);
  }

// get all items in cart
  static Future<List<Cart>?> getCartList(int? user) async {
    if (_cartSheet == null) return <Cart>[];

    final cart = await _cartSheet!.values.map.allRows();

    return cart == null
        ? []
        : cart
            .map(Cart.fromJson)
            .where((element) => element.user == user)
            .toList();
  }

  // delete all items in cart
  static Future<bool> deleteById(int id) async {
    if (_cartSheet == null) return false;

    final index = await _cartSheet!.values.rowIndexOf(id);
    if (index == -1) return false;
    return _cartSheet!.clearRow(index, fromColumn: 2, length: 5);
  }

  // update cart items count
  static Future<bool> updateCell({
    required int id,
    required String key,
    required dynamic value,
  }) async {
    if (_cartSheet == null) return false;
    return _cartSheet!.values.insertValueByKeys(
      value,
      columnKey: key,
      rowKey: id,
    );
  }

  // place order
  static Future<bool> placeOrder(Map<String, dynamic> order) async {
    if (_orderSheet == null) return false;

    return await _orderSheet!.values.map.appendRow(order, fromColumn: 2);
  }

  // get all orders per user
  static Future<List<Order>?> getUserOrders(int? user) async {
    if (_orderSheet == null) return <Order>[];

    final orders = await _orderSheet!.values.map.allRows();

    return orders == null
        ? []
        : orders
            .map(Order.fromJson)
            .where((element) => element.user == user)
            .toList();
  }
}
