import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:online_store_sheets/api/store_sheets_api.dart';
import 'package:online_store_sheets/constants.dart';
import 'package:online_store_sheets/model/cart.dart';
import 'package:online_store_sheets/pages/checkout_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartPage extends StatefulWidget {
  static const String id = '/cart';
  const CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late Future<List<Cart>?> _cartList;
  int total = 0;
  int? userId;

  Future<List<Cart>?> getCartList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    userId = prefs.getInt('user_id');

    final data = await StoreSheetsApi.getCartList(userId);
    return data;
  }

  @override
  void initState() {
    _cartList = getCartList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _cartList.then((value) {
                  for (var item in value!) {
                    StoreSheetsApi.deleteById(item.id!);
                  }
                });
              });
            },
            icon: Icon(
              Icons.delete,
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.all(defaultPadding),
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: defaultMargin),
                            height: 50,
                            width: 50,
                            child: SvgPicture.asset(
                                'assets/icons/ic_delivery_man.svg'),
                          ),
                          Text(
                            'Deliver in  35 - 55 min',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Card(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.all(defaultPadding),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Cutlery',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          Switch(value: true, onChanged: null)
                        ],
                      ),
                    ),
                  ),
                ),
                Card(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        'Order Notes',
                      ),
                    ),
                  ),
                ),
                Text(
                  'Items',
                  textAlign: TextAlign.start,
                  style: Theme.of(context)
                      .textTheme
                      .headline6!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Cart>?>(
                future: _cartList,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                            'Error loading data, ' + snapshot.error.toString()),
                      );
                    }
                    if (snapshot.hasData) {
                      for (var item in snapshot.data!) {
                        total += int.parse(item.total!);
                      }

                      return Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                final cart = snapshot.data![index];

                                return SizedBox(
                                  child: Card(
                                    shadowColor: primaryColor,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.all(defaultPadding),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(' x ' +
                                                cart.quantity.toString()),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(cart.name!),
                                                Text('price: ' +
                                                    cart.price.toString() +
                                                    ' AED'),
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text('Total: ' +
                                                    cart.total.toString() +
                                                    ' AED'),
                                              ],
                                            ),
                                          ]),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          Card(
                            child: Container(
                              height: 100,
                              padding: EdgeInsets.all(defaultPadding),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        'Total',
                                        style: TextStyle(
                                          fontSize: 18.0,
                                        ),
                                      ),
                                      Text(
                                        total.toString() + ' AED',
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          color: primaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor: primaryColor,
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                CheckoutPage(),
                                          ));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: defaultPadding * 4,
                                      ),
                                      child: Text(
                                        'Place Order',
                                        style: TextStyle(color: whiteColor),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      );
                    }
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
