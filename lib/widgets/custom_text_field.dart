import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final bool? isPass;
  const CustomTextField({Key? key, this.controller, this.hintText, this.isPass}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 20 ),
      child: TextFormField(
        controller: controller,
        style: GoogleFonts.roboto(
          fontSize: 16,
          fontWeight: FontWeight.w500
        ),
        obscureText: isPass?? false,
        decoration: InputDecoration(
            hintText: hintText,
            focusedBorder:  OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(7)),
                borderSide: BorderSide(color: primaryColor)
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(7)),
                borderSide: BorderSide(color: greyColor,)
            )
        ),
      ),
    );
  }
}
