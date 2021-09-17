import 'package:fashion_hub/constants.dart';
import 'package:flutter/material.dart';

class AuthLowerText extends StatelessWidget {
  final String? text;
  final String? buttonText;
  final Function()? onPressed;

  const AuthLowerText({Key? key, this.text, this.buttonText, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(text!),
        TextButton(onPressed: onPressed, child: Text(
          buttonText!, style: TextStyle(color: primaryColor),
        ),style: TextButton.styleFrom(
          splashFactory: NoSplash.splashFactory,
        ),)
      ],
    );
  }
}
