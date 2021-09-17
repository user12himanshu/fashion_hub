import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion_hub/screens/paymentPage.dart';
import 'package:fashion_hub/widgets/custom_text_field.dart';
import 'package:fashion_hub/widgets/filled_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';

enum paymentOption { card, paypal, googlepay }

class CheckOutPage extends StatefulWidget {
  final double? subtotal, total;
  final int? noItems;
  final bool? isBuyNow;

  const CheckOutPage(
      {Key? key, this.subtotal, this.total, this.noItems, this.isBuyNow})
      : super(key: key);

  @override
  _CheckOutPageState createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  User? user = FirebaseAuth.instance.currentUser;
  bool isChecked = false;
  paymentOption option = paymentOption.card;
  int paymentint = 0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        toolbarHeight: 60,
        title: Text(
          "Checkout",
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
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          Widget ui;
          if (snapshot.hasData) {
            ui = ListView(
              padding: EdgeInsets.all(8),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 13.0),
                  child: Text(
                    "Shipping Address",
                    style: GoogleFonts.playfairDisplay(
                      color: primaryColor,
                      fontSize: 22,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                snapshot.data!.get("address") == ""
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3.0),
                        child: TextButton(
                          onPressed: () {
                            TextEditingController addressController =
                                TextEditingController();
                            TextEditingController zipController =
                                TextEditingController();
                            showCupertinoDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text("Add an address"),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CustomTextField(
                                          hintText: "Address",
                                          controller: addressController,
                                        ),
                                        CustomTextField(
                                          hintText: "Zip Code",
                                          controller: zipController,
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          FirebaseFirestore.instance
                                              .collection("users")
                                              .doc(user!.uid)
                                              .update({
                                            "address": addressController.text,
                                            "zip code": zipController.text
                                          }).then((value) => Navigator.of(context).pop());
                                        },
                                        child: Text(
                                          "Add",
                                          style: TextStyle(color: primaryColor),
                                        ),
                                        style: TextButton.styleFrom(
                                            splashFactory:
                                                NoSplash.splashFactory),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          "Cancel",
                                          style: TextStyle(color: primaryColor),
                                        ),
                                        style: TextButton.styleFrom(
                                            splashFactory:
                                                NoSplash.splashFactory),
                                      ),
                                    ],
                                  );
                                });
                          },
                          child: Text(
                            "Add an address",
                            style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.w400),
                          ),
                          style: TextButton.styleFrom(
                              side: BorderSide(
                                  color: Colors.grey[300]!, width: 1),
                              splashFactory: NoSplash.splashFactory),
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey)),
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                snapshot.data!.get("address") +
                                    "\nZip Code: " +
                                    snapshot.data!.get("zip code"),
                                style: TextStyle(
                                    color: primaryColor, fontSize: 17),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  TextEditingController addressController =
                                      TextEditingController();
                                  TextEditingController zipController =
                                      TextEditingController();
                                  showCupertinoDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text("Add an address"),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              CustomTextField(
                                                hintText: "Address",
                                                controller: addressController,
                                              ),
                                              CustomTextField(
                                                hintText: "Zip Code",
                                                controller: zipController,
                                              ),
                                            ],
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                FirebaseFirestore.instance
                                                    .collection("users")
                                                    .doc(user!.uid)
                                                    .update({
                                                  "address":
                                                      addressController.text,
                                                  "zip code": zipController.text
                                                }).then((value) =>
                                                        Navigator.pop(context));
                                              },
                                              child: Text(
                                                "Edit",
                                                style: TextStyle(
                                                    color: primaryColor),
                                              ),
                                              style: TextButton.styleFrom(
                                                  splashFactory:
                                                      NoSplash.splashFactory),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text(
                                                "Cancel",
                                                style: TextStyle(
                                                    color: primaryColor),
                                              ),
                                              style: TextButton.styleFrom(
                                                  splashFactory:
                                                      NoSplash.splashFactory),
                                            ),
                                          ],
                                        );
                                      });
                                },
                                icon: Icon(Icons.edit))
                          ],
                        ),
                      ),
                SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 13.0),
                  child: Text(
                    "Payment",
                    style: GoogleFonts.playfairDisplay(
                      color: primaryColor,
                      fontSize: 22,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Column(
                  children: [
                    Container(
                      height: 55,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[400]!)),
                      child: RadioListTile<paymentOption>(
                        secondary: Icon(
                          Icons.payment,
                          color: primaryColor,
                        ),
                        activeColor: primaryColor,
                        value: paymentOption.card,
                        groupValue: option,
                        onChanged: (value) {
                          setState(() {
                            option = value!;
                          });
                          print(value);
                        },
                        title: Text(
                          "Card",
                          style: GoogleFonts.roboto(
                              color: primaryColor, fontSize: 20),
                        ),
                      ),
                    ),
                    Container(
                      height: 55,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[400]!)),
                      child: RadioListTile<paymentOption>(
                        secondary: Icon(
                          FontAwesomeIcons.paypal,
                          color: primaryColor,
                        ),
                        activeColor: primaryColor,
                        value: paymentOption.paypal,
                        groupValue: option,
                        onChanged: (value) {
                          setState(() {
                            option = value!;
                          });
                          paymentint = 1;
                        },
                        title: Text(
                          "Paypal",
                          style: GoogleFonts.roboto(
                              color: primaryColor, fontSize: 20),
                        ),
                      ),
                    ),
                    Container(
                      height: 55,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[400]!)),
                      child: RadioListTile<paymentOption>(
                        secondary: Icon(
                          FontAwesomeIcons.googlePay,
                          color: primaryColor,
                        ),
                        activeColor: primaryColor,
                        value: paymentOption.googlepay,
                        groupValue: option,
                        onChanged: (value) {
                          setState(() {
                            option = value!;
                          });
                          paymentint = 2;
                        },
                        title: Text(
                          "GooglePay",
                          style: GoogleFonts.roboto(
                              color: primaryColor, fontSize: 20),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 100,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Subtotal (${widget.noItems}) items)",
                      style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                    Text(
                      rupeeSymbol + widget.subtotal!.toString(),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total",
                      style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                    Text(
                      rupeeSymbol + (widget.total).toString(),
                      style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                FilledButton(
                    onpressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return PaymentPage(
                          paymentint: paymentint,
                          isBuyNow: widget.isBuyNow ?? false,
                          total: widget.total!,
                        );
                      }));
                    },
                    text: "Proceed to payment",
                    isLoading: false)
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
      ),
    ));
  }
}
