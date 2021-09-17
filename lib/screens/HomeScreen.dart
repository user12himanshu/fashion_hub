import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion_hub/screens/Category%20Page/categoryPage.dart';
import 'package:fashion_hub/screens/cart_page.dart';
import 'package:fashion_hub/screens/productPage.dart';
import 'package:fashion_hub/screens/searchPage.dart';
import 'package:fashion_hub/widgets/category_tile.dart';
import 'package:fashion_hub/widgets/home_header_banner.dart';
import 'package:fashion_hub/widgets/productCard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';
import '../size_config.dart';
import 'menu.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = "/homePage";
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              toolbarHeight: 60,
              elevation: 0,
              backgroundColor: Colors.transparent,
              leading: IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, SearchPage.routeName);
                },
                icon: Icon(
                  Icons.search,
                  color: primaryColor,
                ),
              ),
              centerTitle: true,
              title: Text(
                "Fashion Hub ",
                style: GoogleFonts.playfairDisplay(
                  color: primaryColor,
                  fontSize: 25,
                ),
              ),
              actions: [
                IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, CartPage.routeName);
                    },
                    icon: Icon(
                      Icons.shopping_cart_outlined,
                      color: primaryColor,
                    )),
                IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, Menu.routeName);
                    },
                    icon: Icon(
                      Icons.menu,
                      color: primaryColor,
                    )),
              ],
            ),
            body: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection("products").snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                Widget ui;
                if (snapshot.hasData) {
                  QueryDocumentSnapshot? jfy1;
                  QueryDocumentSnapshot? jfy2;
                  for (var doc in snapshot.data!.docs) {
                    if (doc.id == "dress11") {
                      jfy1 = doc;
                    }
                    if (doc.id == "dress8") {
                      jfy2 = doc;
                    }
                  }
                  ui = ListView(
                    scrollDirection: Axis.vertical,
                    children: [
                      SizedBox(height: 10),
                      HomeHeaderBanner(
                        onpressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return ProductPage(id: 'dress15');
                          }));
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 13.0),
                        child: Text(
                          "Categories",
                          style: homeHeading,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(13),
                        width: SizeConfig.width(context),
                        height: SizeConfig.height(context) * 0.19,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            Hero(
                              tag: 'newHits',
                              child: CategoryTile(
                                text: "New Hits",
                                onpressed: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return CategoryPage(
                                      heading: "New Hits",
                                      category: "newHits",
                                    );
                                  }));
                                },
                                image: "assets/images/newHitsCategory.jpg",
                              ),
                            ),
                            Hero(
                              tag: 'dress',
                              child: CategoryTile(
                                text: "Dress",
                                onpressed: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return CategoryPage(
                                      heading: "Dress",
                                      category: "dress",
                                    );
                                  }));
                                },
                                image: "assets/images/dressCategory.jpg",
                              ),
                            ),
                            Hero(
                              tag: "shoes",
                              child: CategoryTile(
                                text: "Shoes",
                                onpressed: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return CategoryPage(
                                      heading: "Shoes",
                                      category: "shoes",
                                    );
                                  }));
                                },
                                image: "assets/images/shoesCategory.jpg",
                              ),
                            ),
                            Hero(
                              tag: 'beauty',
                              child: CategoryTile(
                                text: "Beauty",
                                onpressed: () {},
                                image: "assets/images/beautyCategory.jpg",
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: Text(
                          "Just for you",
                          style: homeHeading,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(13),
                        width: SizeConfig.width(context),
                        height: SizeConfig.height(context) * 0.45,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            ProductCard(
                              image: jfy1!.get("image"),
                              name: jfy1.get("Name"),
                              discription: jfy1.get("Discription"),
                              price: jfy1.get("Price"),
                              discount: jfy1.get("Discount"),
                              discountVal: jfy1.get("discountVal"),
                              onpressed: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return ProductPage(id: jfy1!.id);
                                }));
                              },
                            ),
                            SizedBox(
                              width: 13,
                            ),
                            ProductCard(
                              image: jfy2!.get("image"),
                              name: jfy2.get("Name"),
                              discription: jfy2.get("Discription"),
                              price: jfy2.get("Price"),
                              discount: jfy2.get("Discount"),
                              discountVal: jfy2.get("discountVal"),
                              onpressed: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return ProductPage(id: jfy2!.id);
                                }));
                              },
                            )
                          ],
                        ),
                      )
                    ],
                  );
                } else {
                  ui = Center(
                    child: CircularProgressIndicator(
                      color: primaryColor,
                    ),
                  );
                }
                return ui;
              },
            )));
  }
}
