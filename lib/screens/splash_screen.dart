import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:money_tracker/main.dart';
import 'package:money_tracker/screens/register_screen/register_screen.dart';
import 'package:money_tracker/widgets/bottom_navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Widget text2 = const Text(
    "Money Tracker ",
    style: TextStyle(
        color: Color(0xFF0B1C3B),
        fontSize: 20,
        fontWeight: FontWeight.w500,
        fontFamily: "alclonica"),
  );
  @override
  void initState() {
    isLoggedInBefore();
    // goToRegister(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              " Welcome To",
              style: TextStyle(
                color: Color(0xFF0B1C3B),
                fontSize: 20,
                fontWeight: FontWeight.w500,
                fontFamily: "alclonica",
              ),
            ),
            text2,
            const SizedBox(
              height: 100,
            ),
            Center(
              child: Image.asset(
                "assets/images/Counting Money GIFs _ Tenor.gif",
                // color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void goToRegister(context) async {
    await Future.delayed(
      const Duration(seconds: 5),
    );
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (ctx) {
          return const RegisterScreen();
        },
      ),
    );
  }

  Future<void> isLoggedInBefore() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    final loggedIn = sharedPrefs.getString(setStringKey);
    log(loggedIn.toString());

    if (loggedIn == null) {
      if (mounted) {
        goToRegister(context);
      }
    } else {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (ctx) {
              return const BottomNavBar(
                text: "",
              );
            },
          ),
        );
      }
    }
  }
}
