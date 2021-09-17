import 'package:fashion_hub/constants.dart';
import 'package:fashion_hub/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CardWidget extends StatelessWidget {
  const CardWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Credit Card Information",
          style:
              TextStyle(color: Colors.grey[800], fontWeight: FontWeight.w600),
        ),
        SizedBox(
          height: 10,
        ),
        TextFormField(
          style: TextStyle(fontWeight: FontWeight.bold),
          decoration: InputDecoration(
              hintText: "Card Number",
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryColor))),
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Container(
              width: SizeConfig.width(context) * 0.5 - 15,
              child: TextFormField(
                style: TextStyle(fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                    hintText: "Expiry Date",
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: primaryColor))),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Container(
              width: SizeConfig.width(context) * 0.5 - 15,
              child: TextFormField(
                keyboardType: TextInputType.number,
                style: TextStyle(fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                    hintText: "CVV",
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: primaryColor))),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        TextFormField(
          keyboardType: TextInputType.name,
          style: TextStyle(fontWeight: FontWeight.bold),
          decoration: InputDecoration(
              hintText: "Card Holder's Name",
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryColor))),
        ),
      ],
    );
  }
}
