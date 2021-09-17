import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion_hub/screens/HomeScreen.dart';
import 'package:fashion_hub/screens/Payments/creditCard_widget.dart';
import 'package:fashion_hub/screens/Payments/gpay.dart';
import 'package:fashion_hub/screens/Payments/paypal.dart';
import 'package:fashion_hub/screens/orders_page.dart';
import 'package:fashion_hub/size_config.dart';
import 'package:fashion_hub/widgets/filled_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';

class PaymentPage extends StatefulWidget {
  final int? paymentint;
  final double? total;
  final bool? isBuyNow;

  const PaymentPage({Key? key, this.paymentint, this.total, this.isBuyNow})
      : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  DocumentReference docSnap = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser!.uid);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              toolbarHeight: 60,
              title: Text(
                "Payment",
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
              stream:
                  FirebaseFirestore.instance.collection("products").snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                Widget ui;
                if (snapshot.hasData) {
                  ui = Container(
                    padding: EdgeInsets.all(10),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Choose your preferred payment method",
                            style: TextStyle(
                                color: primaryColor,
                                fontSize: 18,
                                fontWeight: FontWeight.w400),
                          ),
                          Container(
                            width: SizeConfig.width(context),
                            height: SizeConfig.height(context) * 0.5,
                            child: DefaultTabController(
                              initialIndex: widget.paymentint!,
                              length: 3,
                              child: Column(
                                children: [
                                  TabBar(
                                    tabs: [
                                      Tab(
                                        icon: Icon(
                                          Icons.payment,
                                          color: primaryColor,
                                        ),
                                      ),
                                      Tab(
                                        icon: Icon(
                                          FontAwesomeIcons.paypal,
                                          color: primaryColor,
                                        ),
                                      ),
                                      Tab(
                                        icon: Icon(
                                          FontAwesomeIcons.googlePay,
                                          color: primaryColor,
                                        ),
                                      ),
                                    ],
                                    indicatorColor: primaryColor,
                                  ),
                                  Container(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 20),
                                      height: SizeConfig.height(context) * 0.38,
                                      child: TabBarView(children: [
                                        CardWidget(),
                                        Paypal(),
                                        Gpay()
                                      ]))
                                ],
                              ),
                            ),
                          ),
                          FilledButton(
                            text: "Pay",
                            onpressed: () {
                              widget.isBuyNow! ? buyNowOrder() : cartOrder();
                            },
                            isLoading: false,
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

  Future<void> buyNowOrder() async {
    List? orders;
    await docSnap.get().then((value) {
      orders = value.get("orders");
      orders!.add({
        "cart": false,
        "product": value.get("buy now"),
        "total": widget.total,
        "date-time": DateTime.now()
      });
      docSnap.update({'orders': orders}).then((value) {
        showCupertinoDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Order has been placed!"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, OrdersPage.routeName);
                    },
                    child: Text(
                      "Show orders",
                      style: TextStyle(color: primaryColor),
                    )),
                TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, HomeScreen.routeName);
                    },
                    child: Text(
                      "Home",
                      style: TextStyle(color: primaryColor),
                    )),
              ],
            );
          },
        );
      });
    });
  }

  Future<void> cartOrder() async {
    List? cart;
    List? orders;
    await docSnap.get().then((value) {
      cart = value.get("cart");
      orders = value.get("orders");
      for (var item in cart!) {
        orders!
            .add({"cart": true, "product": item, "date-time": DateTime.now()});
      }
      docSnap.update({'orders': orders}).then((value) {
        docSnap.update({"cart": []});
        showCupertinoDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Order has been placed!"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, OrdersPage.routeName);
                    },
                    child: Text(
                      "Show orders",
                      style: TextStyle(color: primaryColor),
                    )),
                TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, HomeScreen.routeName);
                    },
                    child: Text(
                      "Home",
                      style: TextStyle(color: primaryColor),
                    )),
              ],
            );
          },
        );
      });
    });
  }
}
