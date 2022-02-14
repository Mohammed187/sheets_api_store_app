import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:online_store_sheets/api/store_sheets_api.dart';
import 'package:online_store_sheets/constants.dart';
import 'package:online_store_sheets/model/cart.dart';
import 'package:online_store_sheets/model/order.dart';
import 'package:online_store_sheets/pages/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Payment { visa, cash }

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({Key? key}) : super(key: key);

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  Payment? payment = Payment.visa;
  final _formKey = GlobalKey<FormState>();
  final address = TextEditingController();
  final phone = TextEditingController();
  int? userId;
  List<String> cartItems = [];
  int total = 0;

  Future<List<Cart>?> getCartList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    userId = prefs.getInt('user_id');

    final data = await StoreSheetsApi.getCartList(userId);
    return data;
  }

  @override
  void initState() {
    getCartList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(right: defaultMargin),
                    height: 50,
                    width: 50,
                    child: SvgPicture.asset('assets/icons/ic_delivery_man.svg'),
                  ),
                  Text(
                    'Deliver in  35 - 55 min',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
              SizedBox(height: defaultMargin),
              Text(
                'Deliver to ',
                style: Theme.of(context).textTheme.headline6,
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: address,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your address';
                            }
                            return null;
                          },
                          minLines: 2,
                          maxLines: 2,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Address',
                            helperText: 'Area - Street - Bldg - Flat/Villa #',
                          ),
                        ),
                        SizedBox(height: defaultMargin),
                        TextFormField(
                          controller: phone,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your phone number';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Phone number',
                            helperText: '05X XXXX ...',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Text(
                'Payment',
                style: Theme.of(context).textTheme.headline6,
              ),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      title: const Text('Visa'),
                      leading: Radio<Payment>(
                        value: Payment.visa,
                        groupValue: payment,
                        onChanged: (Payment? value) {
                          setState(() {
                            payment = value;
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text('Cash'),
                      leading: Radio<Payment>(
                        value: Payment.cash,
                        groupValue: payment,
                        onChanged: (Payment? value) {
                          setState(() {
                            payment = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Card(
                shadowColor: primaryColor,
                color: primaryColor,
                child: TextButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      getCartList().then((value) {
                        for (var item in value!) {
                          cartItems.add(item.name!);
                          total += int.parse(item.total!);
                        }

                        Map<String, dynamic> order = {
                          OrderFields.user: userId,
                          OrderFields.items: cartItems.join(','),
                          OrderFields.total: total.toString(),
                          OrderFields.address: address.text + phone.text,
                          OrderFields.payment: payment.toString(),
                          OrderFields.date: DateTime.now().toString(),
                          OrderFields.status: 'placed'
                        };

                        StoreSheetsApi.placeOrder(order).then((value) {
                          value
                              ? {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Order placed')),
                                  ),
                                  Navigator.pushNamedAndRemoveUntil(
                                      context, HomePage.id, (route) => false)
                                }
                              : ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Error placing order')));
                        });
                      });
                    }
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(defaultPadding),
                    child: Text(
                      'Place Order',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: whiteColor),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
