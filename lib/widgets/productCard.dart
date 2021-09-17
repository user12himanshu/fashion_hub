import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';
import '../size_config.dart';

class ProductCard extends StatefulWidget {
  final String? image, name, discription;
  final bool? discount;
  final int? price, discountVal;
  final Function()? onpressed;

  const ProductCard(
      {Key? key,
      this.image,
      this.name,
      this.discription,
      this.price,
      this.discount,
      this.discountVal,
      this.onpressed})
      : super(key: key);

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onpressed,
      child: Container(
        margin: EdgeInsets.all(3),
        width: SizeConfig.width(context) * 0.45,
        height: SizeConfig.height(context) * 0.45,
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              height: SizeConfig.height(context) * 0.45 * 0.6,
              width: SizeConfig.width(context) * 0.45,
              child: Image.network(
                widget.image!,
                cacheHeight: (SizeConfig.height(context) * 0.45 * 0.6).round(),
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  return Center(
                    child: CircularProgressIndicator(
                      color: primaryColor,
                      strokeWidth: 1.0,
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
              ),
            ),
            Text(
              widget.name!,
              style: GoogleFonts.roboto(
                  color: primaryColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 15),
              textAlign: TextAlign.center,
            ),
            Text(
              widget.discription!,
              style: GoogleFonts.roboto(
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                  fontSize: 14),
              textAlign: TextAlign.center,
            ),
            widget.discount!
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        rupeeSymbol + widget.price!.toString(),
                        style: GoogleFonts.roboto(
                          color: primaryColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          decoration: TextDecoration.lineThrough,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        rupeeSymbol +
                            calDisprice(widget.price!, widget.discountVal!)
                                .toString(),
                        style: GoogleFonts.roboto(
                            color: priceColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 15),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  )
                : Text(
                    rupeeSymbol + widget.price!.toString(),
                    style: GoogleFonts.roboto(
                        color: priceColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 15),
                    textAlign: TextAlign.center,
                  ),
          ],
        ),
      ),
    );
  }

  String calDisprice(int price, int disVal) {
    return (price - (price * (disVal / 100))).toString();
  }
}
