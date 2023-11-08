import 'dart:html';
import 'package:bookaitool/Screens/HomePageDesktop.dart';
import 'package:bookaitool/Screens/SuccessPaymentPage.dart';
import 'package:bookaitool/constants.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:bookaitool/Screens/LandingPage.dart';
import 'package:flutter/material.dart';
import 'Screens/HomePageMobile.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'loginpage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Stripe.publishableKey = PayConstants.publishable_key;
  GoogleSignIn googleSignIn = GoogleSignIn(
    clientId: ApiKeys.GoogleAuthSignIn,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool? isDesktop;
  @override
  void initState() {
    super.initState();

    if (window.screen!.width! < 768) {
      isDesktop = false;
      // Add your mobile-specific code here
    } else {
      isDesktop = true;
      // Add your desktop-specific code here
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue, // Set the primary color to blue
        fontFamily: 'Roboto', // Use Google's Roboto font
      ),
      home: LiquidSwipe(pages: [
        const LandingPage(),
        isDesktop == true ? const MyHomePageDesktop() : const MyHomePageMobile()
      ]),
      routes: {
        AppRoutes.landing: (context) => const LandingPage(),
        AppRoutes.signUp: (context) => const SignUpPage(),
        AppRoutes.signIn: (context) => const SignInPage(),
        AppRoutes.home: (context) => isDesktop == true
            ? const MyHomePageDesktop()
            : const MyHomePageMobile(),
        '/success': (_) => const SuccessPaymentPage()
      },
      // Example: routes: {'/home': (context) => HomeScreen()},
    );
  }
}
