import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion_hub/screens/orders_page.dart';
import 'package:fashion_hub/screens/wishlist.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';
import 'cart_page.dart';
import 'logIn.dart';

class Menu extends StatelessWidget {
  static String routeName = "/menu";

  const Menu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
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
          title: Text(
            "More",
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
              ),
            ),
          ],
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("users")
              .doc(user!.uid)
              .snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
            Widget? ui;
            if (snapshot.hasData) {
              ui = Column(
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Center(
                    child: Text(
                      "Hi, " + snapshot.data!.get("Name"),
                      style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 18),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Menutile(
                    title: "Wishlsit",
                    leading: Icons.favorite_border,
                    action: Icons.chevron_right,
                    onpressed: () {
                      Navigator.pushNamed(context, WishList.routeName);
                    },
                  ),
                  Menutile(
                    title: "My orders",
                    leading: Icons.list_alt,
                    action: Icons.chevron_right,
                    onpressed: () {
                      Navigator.pushNamed(context, OrdersPage.routeName);
                    },
                  ),
                  Menutile(
                    title: "Customer Support",
                    leading: Icons.person_outline,
                    action: Icons.chevron_right,
                    onpressed: () {},
                  ),
                  Menutile(
                    title: "About Us",
                    leading: Icons.info_outline,
                    action: Icons.chevron_right,
                    onpressed: () {},
                  ),
                  Menutile(
                    title: "Log Out",
                    leading: Icons.logout,
                    action: Icons.chevron_right,
                    onpressed: () {
                      showCupertinoDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Log out?"),
                              content: Text(
                                  "You can always access your content by logging in again!"),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      FirebaseAuth.instance.signOut().then(
                                          (value) => Navigator.pushNamed(
                                              context, LogIn.routeName));
                                    },
                                    child: Text(
                                      "Log out",
                                      style: TextStyle(color: primaryColor),
                                    )),
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      "Cancel",
                                      style: TextStyle(color: primaryColor),
                                    )),
                              ],
                            );
                          });
                    },
                  ),
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
      ),
    );
  }
}

class Menutile extends StatelessWidget {
  final String? title;
  final IconData? leading, action;
  final void Function()? onpressed;

  const Menutile({
    Key? key,
    this.title,
    this.leading,
    this.action,
    this.onpressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        leading,
        color: primaryColor,
      ),
      onTap: onpressed,
      title: Text(
        title!,
        style: TextStyle(color: primaryColor, fontWeight: FontWeight.w500),
      ),
      trailing: Icon(
        action,
        color: primaryColor,
      ),
    );
  }
}
