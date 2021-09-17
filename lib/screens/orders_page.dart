import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion_hub/screens/productPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants.dart';
import '../size_config.dart';
import 'cart_page.dart';

class OrdersPage extends StatefulWidget {
  static String routeName = "/orders";

  const OrdersPage({Key? key}) : super(key: key);

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text(
          "Orders",
          style: GoogleFonts.playfairDisplay(
            color: primaryColor,
            fontSize: 25,
          ),
        ),
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
            .collection("users")
            .doc(user!.uid)
            .snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> usrsnapshot) {
          Widget docui;
          if (usrsnapshot.hasData) {
            List orders = usrsnapshot.data!.get('orders');
            docui = StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("products")
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  Widget? ui;
                  List userOrders = [];
                  if (snapshot.hasData) {
                    for (var item in snapshot.data!.docs) {
                      for (var order in orders) {
                        if (item.id == order['product']) {
                          userOrders.add({
                            'productDetail': item.data(),
                            'orderDetails': order
                          });
                        }
                      }
                    }
                    ui = ListView.builder(
                        padding: EdgeInsets.all(15),
                        itemCount: userOrders.length,
                        itemBuilder: (context, index) {
                          DateTime dt = (userOrders[index]['orderDetails']
                                  ['date-time'] as Timestamp)
                              .toDate();
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return ProductPage(
                                  id: userOrders[index]['orderDetails']
                                      ['product'],
                                );
                              }));
                            },
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Colors.grey)),
                              margin: EdgeInsets.symmetric(vertical: 10),
                              height: (SizeConfig.height(context) * 0.25),
                              child: Row(children: [
                                Container(
                                  width: 150,
                                  child: Image.network(
                                    userOrders[index]['productDetail']['image'],
                                    fit: BoxFit.cover,
                                    cacheHeight: (SizeConfig.height(context) *
                                            0.45 *
                                            0.6)
                                        .round(),
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      userOrders[index]['productDetail']
                                          ["Name"],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: primaryColor,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      userOrders[index]['productDetail']
                                          ["Discription"],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      rupeeSymbol +
                                          userOrders[index]['orderDetails']
                                                  ["total"]
                                              .toString(),
                                      style: GoogleFonts.roboto(
                                          color: Colors.green,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      dt.toString(),
                                      style: GoogleFonts.roboto(
                                          color: priceColor,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15),
                                    ),
                                  ],
                                )),
                              ]),
                            ),
                          );
                        });
                  } else {
                    ui = Center(
                      child: CircularProgressIndicator(
                        color: primaryColor,
                      ),
                    );
                  }
                  return ui;
                });
          } else {
            docui = Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            );
          }
          return docui;
        },
      ),
    ));
  }

  String calDisprice(int price, int disVal) {
    return (price - (price * (disVal / 100))).toString();
  }
}
