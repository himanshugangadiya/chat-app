import 'package:chat_app/controller/app_bindings.dart';
import 'package:chat_app/screens/authentication/login_screen.dart';
import 'package:chat_app/screens/authentication/sign_up_screen.dart';
import 'package:chat_app/screens/home/home_screen.dart';
import 'package:chat_app/utils/app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chat_app/controller/app_bindings.dart';
import 'firebase_options.dart';

currentUser() {
  if (FirebaseAuth.instance.currentUser != null) {
    return true;
  } else {
    return false;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: AllBindings(),
      theme: darkTheme,
      // home: currentUser() ? const HomeScreen() : const SignUpScreen(),
      home: const LoginScreen(),
    );
  }
}
