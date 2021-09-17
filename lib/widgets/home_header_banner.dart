import 'package:fashion_hub/widgets/rect_buy_now.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';
import '../size_config.dart';

class HomeHeaderBanner extends StatelessWidget {
  final Function()? onpressed;
  const HomeHeaderBanner({
    Key? key, this.onpressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/headerContainerImage.jpg"),
              fit: BoxFit.cover
          ),
          borderRadius: BorderRadius.circular(15)
      ),
      margin: EdgeInsets.symmetric(vertical: 15, horizontal: 11),
      height: SizeConfig.height(context)*0.25,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Nice Parts", style: GoogleFonts.playfairDisplay(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w600
          ),),
          SizedBox(height: 6,),
          Text("The joys of premium fashion", style: GoogleFonts.roboto(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600
          ),),
          SizedBox(height: 12,),
          RectBuy(onpressed: onpressed, ),
        ],
      ),
    );
  }
}