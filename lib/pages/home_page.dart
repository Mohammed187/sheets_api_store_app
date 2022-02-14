import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:online_store_sheets/api/store_sheets_api.dart';
import 'package:online_store_sheets/constants.dart';
import 'package:online_store_sheets/model/category.dart';
import 'package:online_store_sheets/model/promo.dart';
import 'package:online_store_sheets/model/restaurant.dart';
import 'package:online_store_sheets/pages/products_page.dart';
import 'package:online_store_sheets/pages/profile_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  static const String id = '/home';

  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Category>> _categories;
  late Future<List<Promo>> _promos;
  late Future<List<Restaurant>> _restaurants;
  late Future<List<Restaurant>> _featured;
  String dropdownValue = '';

  Future<List<Category>> getCategories() async {
    final data = StoreSheetsApi.getCategories();
    return data;
  }

  Future<List<Promo>> getPromos() async {
    final data = StoreSheetsApi.getPromos();
    return data;
  }

  Future<List<Restaurant>> getRestaurants() async {
    final data = StoreSheetsApi.getRestaurants();
    return data;
  }

  Future<List<Restaurant>> getFeatured() async {
    final data = StoreSheetsApi.getFeaturedRestaurants();
    return data;
  }

  Future getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final email = prefs.getString('email');

    int? id =
        await StoreSheetsApi.getUserDetails(email!).then((value) => value!.id);

    prefs.setInt('user_id', id!);
  }

  @override
  void initState() {
    getUserId();
    _categories = getCategories();
    _promos = getPromos();
    _restaurants = getRestaurants();
    _featured = getFeatured();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: SvgPicture.asset('assets/icons/ic_delivery_man.svg'),
        leadingWidth: 40.0,
        title: locationDropMenu(),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.favorite_border)),
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, ProfilePage.id);
              },
              icon: Icon(Icons.person_outline)),
        ],
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 100.0,
                  child: FutureBuilder<List<Category>>(
                    future: _categories,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text('Error Loading Data, ' +
                                snapshot.error.toString()),
                          );
                        }

                        if (snapshot.hasData) {
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return Container(
                                alignment: Alignment.bottomCenter,
                                margin: EdgeInsets.all(5.0),
                                height: 60.0,
                                width: 80.0,
                                child: Text(
                                  snapshot.data![index].title,
                                  style: TextStyle(
                                      color: textColor,
                                      fontWeight: FontWeight.w600),
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        snapshot.data![index].image),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      }
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                ),
                Container(
                  height: 200.0,
                  margin: EdgeInsets.all(defaultMargin),
                  child: FutureBuilder<List<Promo>>(
                    future: _promos,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text('Error Loading Data, ' +
                                snapshot.error.toString()),
                          );
                        }

                        if (snapshot.hasData) {
                          var images = <Widget>[];
                          for (var promo in snapshot.data!) {
                            images.add(Image.network(promo.image));
                          }

                          return ImageSlideshow(
                            isLoop: true,
                            initialPage: 0,
                            autoPlayInterval: 3000,
                            width: double.infinity,
                            height: 200.0,
                            children: images,
                          );
                        }
                      }
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                ),
                Text(
                  'Featured',
                  style: TextStyle(
                      fontSize: titleFontSize, fontWeight: FontWeight.w600),
                ),
                Container(
                  height: 266.0,
                  margin: EdgeInsets.all(defaultMargin),
                  child: FutureBuilder<List<Restaurant>>(
                    future: _featured,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text('Error Loading Data, ' +
                                snapshot.error.toString()),
                          );
                        }

                        if (snapshot.hasData) {
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Stack(
                                    children: [
                                      InkWell(
                                        onTap: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ProductsPage(
                                                      data: snapshot
                                                          .data![index]),
                                            )),
                                        child: Container(
                                          alignment: Alignment.bottomCenter,
                                          margin: EdgeInsets.all(5.0),
                                          height: 200.0,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              1.5,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                  snapshot.data![index].image),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        right: 20,
                                        bottom: -10,
                                        child: Container(
                                          alignment: Alignment.center,
                                          child: Text(
                                              snapshot.data![index].delivery),
                                          width: 70,
                                          height: 50,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15.0)),
                                              boxShadow: const [
                                                BoxShadow(
                                                    color: primaryColor,
                                                    offset: Offset(-3, -3),
                                                    blurRadius: 10.0)
                                              ]),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    snapshot.data![index].name,
                                    style: TextStyle(
                                        fontSize: titleFontSize,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    snapshot.data![index].category,
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      }
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                ),
                Text(
                  'Explore More',
                  style: TextStyle(
                      fontSize: titleFontSize, fontWeight: FontWeight.w600),
                ),
                Container(
                  height: 266.0,
                  margin: EdgeInsets.all(defaultMargin),
                  child: FutureBuilder<List<Restaurant>>(
                    future: _restaurants,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text('Error Loading Data, ' +
                                snapshot.error.toString()),
                          );
                        }

                        if (snapshot.hasData) {
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Stack(
                                    children: [
                                      InkWell(
                                        onTap: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ProductsPage(
                                                      data: snapshot
                                                          .data![index]),
                                            )),
                                        child: Container(
                                          alignment: Alignment.bottomCenter,
                                          margin: EdgeInsets.all(5.0),
                                          height: 200.0,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              1.5,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                  snapshot.data![index].image),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        right: 20,
                                        bottom: -10,
                                        child: Container(
                                          alignment: Alignment.center,
                                          child: Text(
                                              snapshot.data![index].delivery),
                                          width: 70,
                                          height: 50,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15.0)),
                                              boxShadow: const [
                                                BoxShadow(
                                                    color: primaryColor,
                                                    offset: Offset(-3, -3),
                                                    blurRadius: 10.0)
                                              ]),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    snapshot.data![index].name,
                                    style: TextStyle(
                                        fontSize: titleFontSize,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    snapshot.data![index].category,
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      }
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  DropdownButton<String> locationDropMenu() {
    return DropdownButton(
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      underline: Container(
        height: 0,
        color: Colors.transparent,
      ),
      value: "Home",
      items: <String>['Home', 'Work', 'Current Location']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: TextStyle(fontSize: 15.0),
          ),
        );
      }).toList(),
      onChanged: (String? value) {
        setState(() {
          dropdownValue = value!;
        });
      },
    );
  }
}
