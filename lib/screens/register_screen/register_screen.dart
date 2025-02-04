import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:money_tracker/main.dart';
import 'package:money_tracker/widgets/button_widget.dart';
import 'package:money_tracker/widgets/text_form_field_widget.dart';
import 'package:money_tracker/widgets/bottom_navbar.dart';
import 'package:money_tracker/widgets/app_bar_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController textController = TextEditingController();
  bool isDataMatched = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: const AppBarWidget(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 100,
                  ),
                  Image.asset(
                    "assets/images/what-is-transactions-types-of-accounting-transactions.webp",
                    height: 200,
                    width: 300,
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                  TextFormFieldWidget(
                    inputFormatters: [LengthLimitingTextInputFormatter(20)],
                    validator: (p0) {
                      if (isDataMatched && textController.text.isNotEmpty) {
                        log("data matching");
                        return null;
                      } else {
                        log("data not matching");
                        return "Enter Username";
                      }
                    },
                    hintText: "Username",
                    textController: textController,
                  ),
                  const SizedBox(
                    height: 140,
                  ),
                  ButtonWidget(
                    onTap: () {
                      formKey.currentState!.validate();
                      goToHome(context, textController);
                    },
                    text: "Continue",
                    color: const Color(0xFF0B1C3B),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void goToHome(
      BuildContext context, TextEditingController textController) async {
    final userController = textController.text;
    if (userController.isNotEmpty && isDataMatched) {
      final sharedPrefs = await SharedPreferences.getInstance();
      await sharedPrefs.setBool(setkey, true);
      await sharedPrefs.setString(setStringKey, userController);

      textController.clear();

      log("matching");

      if (context.mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (ctx) {
              return const BottomNavBar(text: "");
            },
          ),
        );
      }
    }
  }
}
