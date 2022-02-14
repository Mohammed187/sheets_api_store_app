import 'package:flutter/material.dart';
import 'package:online_store_sheets/constants.dart';
import 'package:online_store_sheets/model/cart.dart';
import 'package:online_store_sheets/model/products.dart';
import 'package:online_store_sheets/model/restaurant.dart';
import 'package:online_store_sheets/pages/cart_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/store_sheets_api.dart';

class ProductsPage extends StatefulWidget {
  static const String id = '/products';

  const ProductsPage({Key? key, Restaurant? data})
      : _data = data,
        super(key: key);

  final Restaurant? _data;

  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  late Future<List<Product>> _products;

  int? userId;

  Future getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    userId = prefs.getInt('user_id');
  }

  Future<List<Product>> getProducts() async {
    final data = StoreSheetsApi.getRestaurantProducts(widget._data!.name);
    return data;
  }

  @override
  void initState() {
    getUserId();
    _products = getProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>>(
        future: _products,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Error Loading Data, ' + snapshot.error.toString()),
              );
            }
            if (snapshot.hasData) {
              return Container(
                color: textColor,
                child: CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      actions: [
                        IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.favorite_outline,
                              color: whiteColor,
                            )),
                        IconButton(
                            onPressed: () {
                              Navigator.pushNamed(context, CartPage.id);
                            },
                            icon: Icon(
                              Icons.shopping_cart_outlined,
                              color: whiteColor,
                            )),
                      ],
                      floating: true,
                      flexibleSpace: FlexibleSpaceBar(
                        background: Container(
                          color: Colors.transparent,
                          child: Image(
                              image: NetworkImage(widget._data!.image),
                              fit: BoxFit.cover),
                        ),
                      ),
                      expandedHeight: 300,
                      backgroundColor: Colors.transparent,
                      actionsIconTheme: IconThemeData.fallback(),
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate([
                        Padding(
                          padding: const EdgeInsets.all(defaultPadding),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget._data!.name,
                                style: Theme.of(context).textTheme.headline4,
                              ),
                              Text(
                                widget._data!.category,
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                              Text(
                                widget._data!.delivery + ' Mins',
                                style: Theme.of(context).textTheme.caption,
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                'Items',
                                style: Theme.of(context).textTheme.headline5,
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.height,
                                child: ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    return Card(
                                      child: Stack(
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsets.all(defaultPadding),
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  height: 70,
                                                  width: 70,
                                                  child: Image.network(snapshot
                                                      .data![index].image),
                                                ),
                                                SizedBox(width: 10.0),
                                                Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      snapshot
                                                          .data![index].name,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline6,
                                                    ),
                                                    Container(
                                                      padding:
                                                          EdgeInsets.all(5.0),
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              1.7,
                                                      child: Text(
                                                        snapshot.data![index]
                                                            .description,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 2,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .caption,
                                                      ),
                                                    ),
                                                    Text(
                                                      snapshot.data![index]
                                                              .price +
                                                          ' AED',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .subtitle2,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Positioned(
                                            right: 5,
                                            bottom: 5,
                                            child: IconButton(
                                              onPressed: () async {
                                                Product? item =
                                                    snapshot.data![index];
                                                final cart = {
                                                  CartFields.user: userId,
                                                  CartFields.item: '${item.id}',
                                                  CartFields.name: item.name,
                                                  CartFields.price: item.price,
                                                  CartFields.quantity: '1'
                                                };
                                                await StoreSheetsApi
                                                        .checkItemInCart(
                                                            userId, item.id)
                                                    .then(
                                                  (value) => value!.isEmpty
                                                      ? StoreSheetsApi
                                                              .addToCart(cart)
                                                          .then((value) => value
                                                              ? showSnackBar(
                                                                  item.name)
                                                              : showSnackBar(
                                                                  'No Item'))
                                                      : StoreSheetsApi
                                                          .updateCartItem(
                                                          value[0].id!,
                                                          value[0]
                                                              .copy(
                                                                  quantity: value[
                                                                              0]
                                                                          .quantity! +
                                                                      1)
                                                              .toJson(),
                                                        ),
                                                );
                                              },
                                              icon: Icon(
                                                Icons.add_shopping_cart,
                                                color: primaryColor,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]),
                    ),
                  ],
                ),
              );
            }
          }
          return Center(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }

  void showSnackBar(String item) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(item + ' added.')));
  }
}
