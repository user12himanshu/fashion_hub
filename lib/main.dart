import 'package:fashion_hub/screens/Category%20Page/categoryPage.dart';
import 'package:fashion_hub/screens/HomeScreen.dart';
import 'package:fashion_hub/screens/cart_page.dart';
import 'package:fashion_hub/screens/first_Screen.dart';
import 'package:fashion_hub/screens/logIn.dart';
import 'package:fashion_hub/screens/menu.dart';
import 'package:fashion_hub/screens/orders_page.dart';
import 'package:fashion_hub/screens/searchPage.dart';
import 'package:fashion_hub/screens/sign_up.dart';
import 'package:fashion_hub/screens/wishlist.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isSignedin = false;
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      isSignedin = false;
    } else {
      isSignedin = true;
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        HomeScreen.routeName: (context) => HomeScreen(),
        SignUp.routeName: (context) => SignUp(),
        LogIn.routeName: (context) => LogIn(),
        Menu.routeName: (context) => Menu(),
        CategoryPage.routeName: (context) => CategoryPage(),
        CartPage.routeName: (context) => CartPage(),
        WishList.routeName: (context) => WishList(),
        OrdersPage.routeName: (context) => OrdersPage(),
        SearchPage.routeName: (context) => SearchPage(),
      },
      title: 'Fashion Hub',
      theme: ThemeData(scaffoldBackgroundColor: Colors.white),
      home: isSignedin ? HomeScreen() : FirstScreen(),
    );
  }
}
