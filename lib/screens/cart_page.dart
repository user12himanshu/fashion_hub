import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion_hub/screens/checkoutPage.dart';
import 'package:fashion_hub/size_config.dart';
import 'package:fashion_hub/widgets/filled_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';

class CartPage extends StatefulWidget {
  static String routeName = "/cart";
  const CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              toolbarHeight: 60,
              title: Text(
                "Cart",
                style: GoogleFonts.playfairDisplay(
                  color: primaryColor,
                  fontSize: 25,
                ),
              ),
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
            ),
            body: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .doc(user!.uid)
                  .snapshots(),
              builder: (context, AsyncSnapshot<DocumentSnapshot> docsnapshot) {
                Widget docData;
                if (docsnapshot.hasData) {
                  List cart = docsnapshot.data!.get("cart");
                  docData = StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("products")
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      List cartDocs = [];
                      Widget? ui;
                      double subtotal = 0;
                      if (snapshot.hasData) {
                        for (var doc in snapshot.data!.docs) {
                          if (cart.contains(doc.id)) {
                            cartDocs.add(doc);
                          }
                        }
                        for (var doc in cartDocs) {
                          subtotal += double.parse(calDisprice(
                              doc.get("Price"), doc.get("discountVal")));
                        }
                        if (cartDocs.isEmpty) {
                          ui = Center(
                            child: Text(
                              "Your cart is empty!",
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 18),
                            ),
                          );
                        } else {
                          ui = SingleChildScrollView(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Column(
                                children: [
                                  Container(
                                    height: SizeConfig.height(context) * 0.68,
                                    width: SizeConfig.width(context),
                                    child: ListView.builder(
                                        itemCount: cartDocs.length,
                                        itemBuilder: (context, index) {
                                          return Container(
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                border: Border.all(
                                                    color: Colors.grey)),
                                            margin: EdgeInsets.symmetric(
                                                vertical: 10),
                                            height: (SizeConfig.height(context) *
                                                0.25),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 150,
                                                  child: Image.network(
                                                    cartDocs[index].get("image"),
                                                    fit: BoxFit.cover,
                                                    cacheHeight:
                                                        (SizeConfig.height(
                                                                    context) *
                                                                0.45 *
                                                                0.6)
                                                            .round(),
                                                    loadingBuilder:
                                                        (BuildContext context,
                                                            Widget child,
                                                            ImageChunkEvent?
                                                                loadingProgress) {
                                                      if (loadingProgress ==
                                                          null) {
                                                        return child;
                                                      }
                                                      return Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                          color: primaryColor,
                                                          strokeWidth: 1.0,
                                                          value: loadingProgress
                                                                      .expectedTotalBytes !=
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
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.center,
                                                    children: [
                                                      Text(
                                                        cartDocs[index]
                                                            .get("Name"),
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            color: primaryColor,
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.w600),
                                                      ),
                                                      SizedBox(
                                                        height: 15,
                                                      ),
                                                      Text(
                                                        cartDocs[index]
                                                            .get("Discription"),
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.w600),
                                                      ),
                                                      SizedBox(
                                                        height: 15,
                                                      ),
                                                      cartDocs[index]
                                                              .get("Discount")
                                                          ? Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  cartDocs[index]
                                                                          .get(
                                                                              "discountVal")
                                                                          .toString() +
                                                                      "% | ",
                                                                  style:
                                                                      GoogleFonts
                                                                          .roboto(
                                                                    color:
                                                                        priceColor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontSize: 15,
                                                                  ),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                ),
                                                                SizedBox(
                                                                  width: 10,
                                                                ),
                                                                Text(
                                                                  rupeeSymbol +
                                                                      calDisprice(
                                                                              cartDocs[index].get("Price"),
                                                                              cartDocs[index].get("discountVal"))
                                                                          .toString(),
                                                                  style: GoogleFonts.roboto(
                                                                      color:
                                                                          priceColor,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontSize:
                                                                          15),
                                                                ),
                                                                SizedBox(
                                                                  width: 10,
                                                                ),
                                                                Text(
                                                                  rupeeSymbol +
                                                                      cartDocs[
                                                                              index]
                                                                          .get(
                                                                              "Price")
                                                                          .toString(),
                                                                  style:
                                                                      GoogleFonts
                                                                          .roboto(
                                                                    color:
                                                                        primaryColor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontSize: 15,
                                                                    decoration:
                                                                        TextDecoration
                                                                            .lineThrough,
                                                                  ),
                                                                ),
                                                              ],
                                                            )
                                                          : Text(
                                                              rupeeSymbol +
                                                                  cartDocs[index]
                                                                      .get(
                                                                          "Price")
                                                                      .toString(),
                                                              style: GoogleFonts.roboto(
                                                                  color:
                                                                      priceColor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize: 15),
                                                            ),
                                                    ],
                                                  ),
                                                ),
                                                Align(
                                                  alignment: Alignment.topRight,
                                                  child: IconButton(
                                                      splashRadius: 1,
                                                      constraints: BoxConstraints(
                                                          minWidth: 20,
                                                          minHeight: 20,
                                                          maxHeight: 20,
                                                          maxWidth: 20),
                                                      padding: EdgeInsets.all(0),
                                                      iconSize: 15,
                                                      onPressed: () {
                                                        print("pressed");
                                                        cart.remove(
                                                            cartDocs[index].id);
                                                        print(cart);
                                                        FirebaseFirestore.instance
                                                            .collection("users")
                                                            .doc(user!.uid)
                                                            .update(
                                                                {"cart": cart});
                                                      },
                                                      icon: Icon(Icons.close)),
                                                ),
                                              ],
                                            ),
                                          );
                                        }),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Subtotal (${cartDocs.length} items)",
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                      Text(
                                        rupeeSymbol + subtotal.toString(),
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Dilevery",
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                      Text(
                                        rupeeSymbol + "40",
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                    ],
                                  ),
                                  Divider(
                                    color: Colors.grey,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Total",
                                        style: TextStyle(
                                            color: primaryColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                      Text(
                                        rupeeSymbol + (subtotal + 40).toString(),
                                        style: TextStyle(
                                            color: primaryColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  FilledButton(
                                      onpressed: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(builder: (context) {
                                          return CheckOutPage(
                                            subtotal: subtotal,
                                            total: subtotal + 40,
                                            noItems: cartDocs.length,
                                          );
                                        }));
                                      },
                                      text: "Checkout",
                                      isLoading: false)
                                ],
                              ),
                            ),
                          );
                        }
                      } else {
                        ui = Center(
                          child: CircularProgressIndicator(
                            color: primaryColor,
                          ),
                        );
                      }
                      return ui;
                    },
                  );
                } else {
                  docData = Center(
                    child: CircularProgressIndicator(
                      color: primaryColor,
                    ),
                  );
                }
                return docData;
              },
            )));
  }

  String calDisprice(int price, int disVal) {
    return (price - (price * (disVal / 100))).toString();
  }
}
