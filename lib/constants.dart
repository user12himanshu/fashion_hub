import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color primaryColor = Color(0xff1a1a1a);
const Color greyColor = Color(0xffe8e8e8);
const Color priceColor = Color(0xffff0090);

TextStyle homeHeading = GoogleFonts.playfairDisplay(
  color: primaryColor,
  fontSize: 26,
);

const String rupeeSymbol = "₹";

Map<String, dynamic> newUserData(String name, String email) {
  return {
    "Mobile": "",
    "Name": name,
    "address": "",
    "zip code": "",
    "cart": [],
    "orders": [],
    "buy now": "",
    "email": email,
    "wishlist": []
  };
}
