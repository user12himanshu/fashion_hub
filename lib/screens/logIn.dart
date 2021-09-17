import 'package:fashion_hub/screens/HomeScreen.dart';
import 'package:fashion_hub/screens/sign_up.dart';
import 'package:fashion_hub/widgets/auth_lower_text.dart';
import 'package:fashion_hub/widgets/custom_text_field.dart';
import 'package:fashion_hub/widgets/filled_button.dart';
import 'package:fashion_hub/widgets/or_divider.dart';
import 'package:fashion_hub/widgets/outlined_social_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';

class LogIn extends StatefulWidget {
  static const String routeName = "/logIn";
  const LogIn({Key? key}) : super(key: key);

  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 60,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            FontAwesomeIcons.chevronLeft,
            color: primaryColor,
          ),
        ),
        centerTitle: true,
        title: Text(
          "Login",
          style: GoogleFonts.playfairDisplay(
            color: primaryColor,
            fontSize: 25,
          ),
        ),
      ),
      body: Container(
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            CustomTextField(
              controller: emailController,
              hintText: "Email",
            ),
            CustomTextField(
                controller: passwordController,
                hintText: "Password",
                isPass: true),
            SizedBox(height: 20),
            FilledButton(
              onpressed: () {
                setState(() {
                  isLoading = true;
                });
                logIN(emailController.text.trim(),
                        passwordController.text.trim())
                    .then((value) {
                  setState(() {
                    isLoading = false;
                  });
                  Navigator.pushNamed(context, HomeScreen.routeName);
                });
              },
              text: "Log In",
              isLoading: isLoading,
            ),
            OrDivider(),
            OutlinedSocialButton(
              text: "Continue with Google",
              icon: FontAwesomeIcons.google,
              onpressed: () {},
            ),
            OutlinedSocialButton(
              text: "Continue with Facebook",
              icon: FontAwesomeIcons.facebook,
              onpressed: () {},
            ),
            OutlinedSocialButton(
              text: "Continue with Apple",
              icon: FontAwesomeIcons.apple,
              onpressed: () {},
            ),
            AuthLowerText(
              text: "New User?",
              buttonText: "Create an Account",
              onPressed: () {
                Navigator.pushNamed(context, SignUp.routeName);
              },
            )
          ],
        ),
      ),
    ));
  }

  Future logIN(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }
}
