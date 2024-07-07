import 'package:campusbite/screens/authentication/email_verification.dart';
import 'package:campusbite/screens/authentication/forget_password.dart';
import 'package:campusbite/screens/authentication/login.dart';
import 'package:campusbite/screens/authentication/mobile.dart';
import 'package:campusbite/screens/home.dart';
import 'package:campusbite/screens/profile.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:campusbite/screens/welcome.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(CampusBites());
}

class CampusBites extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        PhoneNumberPage.id: (context) => PhoneNumberPage(),
        EmailVerificationScreen.id: (context) => EmailVerificationScreen(),
        HomeScreen.id : (context) => HomeScreen(),
        ForgotPasswordScreen.id : (context) => ForgotPasswordScreen(),
        ProfilePage.id : (context) => ProfilePage(),
      },
    );
  }
}