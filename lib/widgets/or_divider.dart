import 'package:fashion_hub/constants.dart';
import 'package:flutter/material.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(width: MediaQuery.of(context).size.width * 0.5 - 25 ,child: Divider(color: Colors.grey[400], thickness: 2.0, height: 2.0,)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text("OR"),
          ),
          Container(width: MediaQuery.of(context).size.width * 0.5 - 25 ,child: Divider(color: Colors.grey[400], thickness: 2.0, height: 2.0,)),
        ],
      ),
    );
  }
}
