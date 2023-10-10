import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/screens/authentication/login_screen.dart';
import 'package:chat_app/utils/app_color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../home/home_screen.dart';
import '../widgets/common_elevated_button.dart';
import '../widgets/common_text_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  signUp() async {
    UserCredential? userCredential;
    try {
      userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim().toString(),
        password: passwordController.text.trim().toString(),
      );
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message.toString())));
    }
    if (userCredential != null) {
      String uId = userCredential.user!.uid;
      UserModel userModel = UserModel(
        uId: uId,
        name: nameController.text.trim().toString(),
        email: emailController.text.trim().toString(),
      );
      await FirebaseFirestore.instance
          .collection("users")
          .doc(uId)
          .set(userModel.toMap())
          .then((value) {
        nameController.clear();
        emailController.clear();
        passwordController.clear();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
          (route) => false,
        );
      }).catchError((e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    double width = MediaQuery.sizeOf(context).width;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(
                height: height * 0.14,
              ),
              Center(
                child: Text(
                  "Create Account",
                  style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              SizedBox(
                height: height * 0.06,
              ),
              CommonTextFiled(
                controller: nameController,
                labelText: "Enter name",
              ),
              SizedBox(
                height: height * 0.035,
              ),
              CommonTextFiled(
                controller: emailController,
                labelText: "Enter email address",
              ),
              SizedBox(
                height: height * 0.035,
              ),
              TextField(
                cursorColor: AppColor.white,
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: "Enter password",
                  suffixIcon: Icon(
                    Icons.visibility,
                    color: AppColor.grey,
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.1,
              ),
              CommonElevatedButton(
                height: height,
                labelText: "Sign up",
                onPressed: () {
                  if (emailController.text.trim().isNotEmpty &&
                      passwordController.text.trim().isNotEmpty) {
                    signUp();
                  } else {
                    debugPrint("enter field to continue");
                  }
                },
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text("Already have an account? Login"),
              ),
              SizedBox(
                height: height * 0.01,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
