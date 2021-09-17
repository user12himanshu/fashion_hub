import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion_hub/screens/checkoutPage.dart';
import 'package:fashion_hub/size_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:full_screen_image_null_safe/full_screen_image_null_safe.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';
import 'cart_page.dart';

class ProductPage extends StatefulWidget {
  final String? id;

  const ProductPage({Key? key, this.id}) : super(key: key);

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  Future addToCart(Map data) async {}
  String status = " ";
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              toolbarHeight: 60,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  FontAwesomeIcons.chevronLeft,
                  color: primaryColor,
                ),
              ),
              centerTitle: true,
              actions: [
                IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, CartPage.routeName);
                    },
                    icon: Icon(
                      Icons.shopping_cart_outlined,
                      color: primaryColor,
                    )),
              ],
            ),
            body: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("products")
                  .doc(widget.id)
                  .snapshots(),
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                Widget ui;
                if (snapshot.hasData) {
                  ui = SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Hero(
                      tag: snapshot.data!.get("Name"),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Center(
                            child: FullScreenWidget(
                              child: Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(10)),
                                height: SizeConfig.height(context) * 0.5,
                                width: SizeConfig.width(context) * 0.7,
                                child: Image.network(
                                  snapshot.data!.get("image"),
                                  loadingBuilder: (BuildContext context,
                                      Widget child,
                                      ImageChunkEvent? loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    }
                                    return Center(
                                      child: CircularProgressIndicator(
                                        color: primaryColor,
                                        strokeWidth: 1.0,
                                        value:
                                            loadingProgress.expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes!
                                                : null,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  snapshot.data!.get("Name"),
                                  style: GoogleFonts.roboto(
                                      color: primaryColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  snapshot.data!.get("Discription"),
                                  style: GoogleFonts.roboto(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 17),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                snapshot.data!.get("Discount")
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            snapshot.data!
                                                    .get("discountVal")
                                                    .toString() +
                                                "% | ",
                                            style: GoogleFonts.roboto(
                                              color: priceColor,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 20,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            rupeeSymbol +
                                                calDisprice(
                                                        snapshot.data!
                                                            .get("Price"),
                                                        snapshot.data!
                                                            .get("discountVal"))
                                                    .toString(),
                                            style: GoogleFonts.roboto(
                                                color: priceColor,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 20),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            rupeeSymbol +
                                                snapshot.data!
                                                    .get("Price")
                                                    .toString(),
                                            style: GoogleFonts.roboto(
                                              color: primaryColor,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 20,
                                              decoration:
                                                  TextDecoration.lineThrough,
                                            ),
                                          ),
                                        ],
                                      )
                                    : Text(
                                        rupeeSymbol +
                                            snapshot.data!
                                                .get("Price")
                                                .toString(),
                                        style: GoogleFonts.roboto(
                                            color: priceColor,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 20),
                                      ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextButton(
                                onPressed: () {
                                  FirebaseFirestore.instance
                                      .collection("users")
                                      .doc(user!.uid)
                                      .update({
                                    "buy now": snapshot.data!.id
                                  }).then((value) => {
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return CheckOutPage(
                                                isBuyNow: true,
                                                subtotal: snapshot.data!
                                                        .get("Discount")
                                                    ? calDispriceint(
                                                            snapshot.data!
                                                                .get("Price"),
                                                            snapshot.data!.get(
                                                                "discountVal")) +
                                                        40
                                                    : snapshot.data!.get("Price"),
                                                noItems: 1,
                                                total: snapshot.data!
                                                        .get("Discount")
                                                    ? (calDispriceint(
                                                            snapshot.data!
                                                                .get("Price"),
                                                            snapshot.data!.get(
                                                                "discountVal")) +
                                                        40)
                                                    : snapshot.data!
                                                            .get("Price") +
                                                        40,
                                              );
                                            })),
                                          });
                                },
                                child: Text(
                                  "Buy Now",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17),
                                ),
                                style: TextButton.styleFrom(
                                    fixedSize: Size(120, 50),
                                    backgroundColor: primaryColor,
                                    splashFactory: NoSplash.splashFactory),
                              ),
                              TextButton(
                                onPressed: () {
                                  List? cart;
                                  FirebaseFirestore.instance
                                      .collection("users")
                                      .doc(user!.uid)
                                      .get()
                                      .then((value) {
                                    cart = value.get("cart");
                                    cart!.add(snapshot.data!.id);
                                    FirebaseFirestore.instance
                                        .collection("users")
                                        .doc(user!.uid)
                                        .update({"cart": cart});
                                  });
                                  setState(() {
                                    status = "Item added to cart";
                                  });
                                },
                                child: Text("Add to Cart",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17)),
                                style: TextButton.styleFrom(
                                    fixedSize: Size(120, 50),
                                    backgroundColor: primaryColor,
                                    splashFactory: NoSplash.splashFactory),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                  splashFactory: NoSplash.splashFactory),
                              onPressed: () {
                                List? wishlist;
                                FirebaseFirestore.instance
                                    .collection("users")
                                    .doc(user!.uid)
                                    .get()
                                    .then((value) {
                                  wishlist = value.get("wishlist");
                                  wishlist!.add(snapshot.data!.id);
                                  FirebaseFirestore.instance
                                      .collection("users")
                                      .doc(user!.uid)
                                      .update({"wishlist": wishlist});
                                });
                                setState(() {
                                  status = "Item added to wishlist";
                                });
                              },
                              child: Text(
                                "Add to Wishlist",
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              )),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            status,
                            style: TextStyle(color: primaryColor, fontSize: 15),
                          )
                        ],
                      ),
                    ),
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

  String calDisprice(int price, int disVal) {
    return (price - (price * (disVal / 100))).toString();
  }

  int calDispriceint(int price, int disVal) {
    return (price - (price * (disVal / 100))).toInt();
  }
}
