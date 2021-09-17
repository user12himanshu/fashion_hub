import 'package:flutter/material.dart';

import '../constants.dart';

class FilledButton extends StatelessWidget {
  final void Function()? onpressed;
  final bool? isLoading;
  final String? text;
  const FilledButton({Key? key, this.onpressed, this.text, this.isLoading}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(onPressed: onpressed, child: isLoading! ? Center(child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3,)) :Text(text!, style: TextStyle(color: Colors.white, fontSize: 17),), style: TextButton.styleFrom(
        backgroundColor: primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        splashFactory: NoSplash.splashFactory,
        fixedSize: Size(MediaQuery.of(context).size.width - 40, 45)
    ),);
  }
}
