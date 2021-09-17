import 'package:flutter/material.dart';

import '../constants.dart';

class RectBuy extends StatelessWidget {
  final String? text;
  final Function()? onpressed;
  final Size? size;
  const RectBuy({Key? key, this.onpressed, this.size, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(onPressed:onpressed, child: Text(text?? "Buy Now", style: TextStyle(color: primaryColor),), style: TextButton.styleFrom(
        backgroundColor: Colors.white,
        fixedSize: size?? Size(80, 30),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        splashFactory: NoSplash.splashFactory),);
  }
}
