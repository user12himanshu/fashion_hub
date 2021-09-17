import 'package:fashion_hub/constants.dart';
import 'package:flutter/material.dart';

class Gpay extends StatelessWidget {
  const Gpay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextFormField(
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
            hintText: "Phone",
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: primaryColor))),
      ),
    );
  }
}
