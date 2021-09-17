import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';

class OutlinedSocialButton extends StatelessWidget {
  final String? text;
  final IconData? icon;
  final void Function()? onpressed;
  const OutlinedSocialButton({Key? key, this.text, this.icon, this.onpressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(onPressed: onpressed, child: Row(

      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Icon(icon, size: 20, color: Color(0xff393939),),
        ),
        SizedBox(width: 80,),
        Text(text!, style: GoogleFonts.roboto(
            color: primaryColor,
            fontWeight: FontWeight.w500
        ),)
      ],
    ),
      style: TextButton.styleFrom(
          fixedSize: Size(MediaQuery.of(context).size.width - 40, 40),
          backgroundColor: Colors.white,
          splashFactory: NoSplash.splashFactory,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40)
          ),
          side: BorderSide(color: greyColor, width: 1.5)
      ),);
  }
}
