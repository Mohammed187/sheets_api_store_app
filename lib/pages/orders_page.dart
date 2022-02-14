import 'package:flutter/material.dart';
import 'package:online_store_sheets/api/store_sheets_api.dart';
import 'package:online_store_sheets/constants.dart';
import 'package:online_store_sheets/model/order.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrdersPage extends StatefulWidget {
  static const String id = '/orders';

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  late Future<List<Order>?> _orders;

  Future<List<Order>?> getUserOrders() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final id = prefs.getInt('user_id');

    final data = await StoreSheetsApi.getUserOrders(id);
    return data;
  }

  @override
  void initState() {
    _orders = getUserOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
      ),
      body: FutureBuilder<List<Order>?>(
          future: _orders,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Center(
                  child:
                      Text('Error fetching data, ' + snapshot.error.toString()),
                );
              }
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return Card(
                      shadowColor: primaryColor,
                      child: ListTile(
                        leading: Icon(Icons.fastfood_outlined),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(snapshot.data![index].items!),
                            Text(snapshot.data![index].address),
                            Text(snapshot.data![index].payment!),
                          ],
                        ),
                        trailing: Text(snapshot.data![index].status!),
                      ),
                    );
                  },
                );
              }
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}
