import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion_hub/constants.dart';
import 'package:fashion_hub/screens/HomeScreen.dart';
import 'package:fashion_hub/screens/logIn.dart';
import 'package:fashion_hub/widgets/auth_lower_text.dart';
import 'package:fashion_hub/widgets/custom_text_field.dart';
import 'package:fashion_hub/widgets/filled_button.dart';
import 'package:fashion_hub/widgets/or_divider.dart';
import 'package:fashion_hub/widgets/outlined_social_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUp extends StatefulWidget {
  static const routeName = "/signUp";
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        toolbarHeight: 60,
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
          "SignUp",
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
              controller: nameController,
              hintText: "Name",
            ),
            CustomTextField(
              controller: emailController,
              hintText: "Email",
            ),
            CustomTextField(
                controller: passwordController,
                hintText: "Password",
                isPass: true),
            SizedBox(
              height: 20,
            ),
            FilledButton(
              onpressed: () {
                setState(() {
                  isLoading = true;
                });
                signUp(emailController.text.trim(),
                        passwordController.text.trim(), nameController.text)
                    .then((value) {
                  setState(() {
                    isLoading = false;
                  });
                  Navigator.pushNamed(context, HomeScreen.routeName);
                });
              },
              text: "Sign Up",
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
              text: "Already have an account?",
              buttonText: "Log In",
              onPressed: () {
                Navigator.pushNamed(context, LogIn.routeName);
              },
            )
          ],
        ),
      ),
    ));
  }

  Future signUp(String email, String password, String name) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      User? user = FirebaseAuth.instance.currentUser;
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user!.uid)
          .set(newUserData(name, email));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }
}
