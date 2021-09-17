import 'package:fashion_hub/constants.dart';
import 'package:flutter/material.dart';

class Paypal extends StatelessWidget {
  const Paypal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          "To pay with Paypal, Click the button bellow",
          style: TextStyle(color: primaryColor, fontSize: 18),
        ),
        GestureDetector(
          onTap: () {
            print("Button Pressed");
          },
          child: Image.network(
              "https://www.paypalobjects.com/webstatic/en_AU/i/buttons/btn_paywith_primary_l.png"),
        )
      ],
    );
  }
}
