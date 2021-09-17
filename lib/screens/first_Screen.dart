import 'package:fashion_hub/screens/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FirstScreen extends StatelessWidget {
  static const routeName = "/firstPage";
  const FirstScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/firstPage.jpg'),
                fit: BoxFit.cover)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              "Welcome to Fashion Hub",
              style: GoogleFonts.playfairDisplay(
                  color: Colors.white,
                  fontSize: 30.0,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 50,),
            Text(
              "A premium online store for women and their stylish choice",
              style: GoogleFonts.roboto(
                  color: Colors.white,
                  fontSize: 25.0,
                  fontWeight: FontWeight.w400),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 50,),
            Padding(
              padding: EdgeInsets.only(bottom: 50.0),
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, SignUp.routeName);
                },
                child: Text(
                  "Get Started",
                  style: GoogleFonts.roboto(fontSize: 23, color: Colors.black),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  splashFactory: NoSplash.splashFactory,
                  fixedSize: Size(175, 50)
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
