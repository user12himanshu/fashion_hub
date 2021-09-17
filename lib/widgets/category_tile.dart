import 'package:fashion_hub/widgets/rect_buy_now.dart';
import 'package:flutter/material.dart';

import '../size_config.dart';

class CategoryTile extends StatelessWidget {
  final String? text;
  final String? image;
  final Function()? onpressed;
  const CategoryTile({Key? key, this.text, this.onpressed, this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 13),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          image: DecorationImage(image: AssetImage(image!), fit: BoxFit.cover)),
      width: SizeConfig.width(context) * 0.37,
      height: SizeConfig.height(context) * 0.19,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: EdgeInsets.only(bottom: 5.0),
          child: RectBuy(
            onpressed: onpressed,
            text: text!,
            size: Size(75, 20),
          ),
        ),
      ),
    );
  }
}
