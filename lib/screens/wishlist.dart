import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion_hub/screens/productPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';
import '../size_config.dart';

class WishList extends StatefulWidget {
  static String routeName = "/wishlist";
  const WishList({Key? key}) : super(key: key);

  @override
  _WishListState createState() => _WishListState();
}

class _WishListState extends State<WishList> {
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
                "Wishlist",
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
                  List wishlist = docsnapshot.data!.get("wishlist");
                  docData = StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("products")
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      List wishlistDocs = [];
                      Widget? ui;
                      if (snapshot.hasData) {
                        for (var doc in snapshot.data!.docs) {
                          if (wishlist.contains(doc.id)) {
                            wishlistDocs.add(doc);
                          }
                        }
                        if (wishlistDocs.isEmpty) {
                          ui = Center(
                            child: Text(
                              "Your wishlist is empty!",
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 18),
                            ),
                          );
                        } else {
                          ui = Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: ListView.builder(
                                itemCount: wishlistDocs.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return ProductPage(
                                          id: wishlistDocs[index].id,
                                        );
                                      }));
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          border:
                                              Border.all(color: Colors.grey)),
                                      margin:
                                          EdgeInsets.symmetric(vertical: 10),
                                      height:
                                          (SizeConfig.height(context) * 0.25),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 150,
                                            child: Image.network(
                                              wishlistDocs[index].get("image"),
                                              fit: BoxFit.cover,
                                              cacheHeight:
                                                  (SizeConfig.height(context) *
                                                          0.45 *
                                                          0.6)
                                                      .round(),
                                              loadingBuilder:
                                                  (BuildContext context,
                                                      Widget child,
                                                      ImageChunkEvent?
                                                          loadingProgress) {
                                                if (loadingProgress == null) {
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
                                                  wishlistDocs[index]
                                                      .get("Name"),
                                                  textAlign: TextAlign.center,
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
                                                  wishlistDocs[index]
                                                      .get("Discription"),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                SizedBox(
                                                  height: 15,
                                                ),
                                                wishlistDocs[index]
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
                                                            wishlistDocs[index]
                                                                    .get(
                                                                        "discountVal")
                                                                    .toString() +
                                                                "% | ",
                                                            style: GoogleFonts
                                                                .roboto(
                                                              color: priceColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 15,
                                                            ),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Text(
                                                            rupeeSymbol +
                                                                calDisprice(
                                                                        wishlistDocs[index].get(
                                                                            "Price"),
                                                                        wishlistDocs[index]
                                                                            .get("discountVal"))
                                                                    .toString(),
                                                            style: GoogleFonts.roboto(
                                                                color:
                                                                    priceColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 15),
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Text(
                                                            rupeeSymbol +
                                                                wishlistDocs[
                                                                        index]
                                                                    .get(
                                                                        "Price")
                                                                    .toString(),
                                                            style: GoogleFonts
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
                                                            wishlistDocs[index]
                                                                .get("Price")
                                                                .toString(),
                                                        style:
                                                            GoogleFonts.roboto(
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
                                                  wishlist.remove(
                                                      wishlistDocs[index].id);
                                                  print(wishlist);
                                                  FirebaseFirestore.instance
                                                      .collection("users")
                                                      .doc(user!.uid)
                                                      .update({
                                                    "wishlist": wishlist
                                                  });
                                                },
                                                icon: Icon(Icons.close)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
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
