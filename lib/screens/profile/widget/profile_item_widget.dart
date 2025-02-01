import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_tracker/db/category/category_db.dart';
import 'package:money_tracker/db/transaction/transaction_db.dart';
import 'package:money_tracker/main.dart';
import 'package:money_tracker/models/category/category_model.dart';
import 'package:money_tracker/models/transaction/transaction_model.dart';
import 'package:money_tracker/screens/profile/widget/profile_widget.dart';
import 'package:money_tracker/screens/profile/widget/statistics_screen.dart';
import 'package:money_tracker/screens/splash_screen.dart';
import 'package:money_tracker/theme/app_text_style.dart';
import 'package:money_tracker/widgets/text_form_field_widget.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

final TextEditingController userNameController = TextEditingController();

class ProfileItemWidget extends StatefulWidget {
  const ProfileItemWidget({
    super.key,
  });

  @override
  State<ProfileItemWidget> createState() => _ProfileItemWidgetState();
}

class _ProfileItemWidgetState extends State<ProfileItemWidget> {
  @override
  void initState() {
    fillUsername();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProfileWidget(
            text: "Change Username",
            onTap: () {
              changeUserName(context, userNameController);
            },
            iconData: Icons.person),
        const SizedBox(
          height: 20,
        ),
        ProfileWidget(
            text: "Statistics",
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) {
                    return const StatisticsScreen();
                  },
                ),
              );
            },
            iconData: Icons.format_indent_increase_rounded),
        const SizedBox(
          height: 20,
        ),
        ProfileWidget(
            text: "Help Centre",
            onTap: () async {
              String? encodeQueryParameters(Map<String, String> params) {
                return params.entries
                    .map((MapEntry<String, String> e) =>
                        '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
                    .join('&');
              }

              final Uri emailUri = Uri(
                scheme: "mailto",
                path: 'roshanudemy123@gmail.com',
                query: encodeQueryParameters(<String, String>{
                  // 'subject': 'Example Subject & Symbols are allowed!',
                  // 'body': 'enter matter',
                }),
              );

              if (await canLaunchUrl(emailUri)) {
                launchUrl(emailUri);
              } else {
                throw Exception('couldnt launch');
              }
            },
            iconData: Icons.help),
        const SizedBox(
          height: 20,
        ),
        ProfileWidget(
            text: "Reset",
            onTap: () {
              resetDialogueBox();
            },
            iconData: Icons.restore),
        const SizedBox(
          height: 20,
        ),
        ProfileWidget(
            text: "Share",
            onTap: () {
              shareText();
            },
            iconData: Icons.share),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }

  // CHANGE USERNAME................./////////////////////////////////////////

  void changeUserName(
      BuildContext context, TextEditingController userNameController) {
    fillUsername();
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text("Change username"),
          content: TextFormFieldWidget(
            inputFormatters: [LengthLimitingTextInputFormatter(20)],
            textController: userNameController,
            hintText: "Username ",
          ),
          actions: [
            MaterialButton(
              onPressed: () {
                editUsername();
              },
              child: const Text("Update"),
            ),
            MaterialButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            )
          ],
        );
      },
    );
  }

  void editUsername() async {
    if (userNameController.text.isNotEmpty) {
      SharedPreferences sharedprefs = await SharedPreferences.getInstance();
      await sharedprefs.remove(setStringKey);
      await sharedprefs.setString(setStringKey, userNameController.text);
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  void fillUsername() async {
    final sharedprefs = await SharedPreferences.getInstance();
    final username = sharedprefs.getString(setStringKey);
    if (username != null) {
      setState(() {
        userNameController.text = username;
      });
    }
  }

  ////////////////////////////////////////////////////////////////////////////////////

  //RESET APPLICATION.........................../////////////////////////////////////

  void resetDialogueBox() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("RESET !"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Are you sure ?",
                style: AppTextStyle.body1,
              ),
              const Text("Do you want to reset app ?"),
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () async {
                    resetApp();
                    if (ctx.mounted) {
                      Navigator.of(ctx).pop();
                    }
                  },
                  child: const Text(
                    "Yes",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: const Text(
                    "No",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  void resetApp() async {
    final transactions =
        await Hive.openBox<TransactionModel>(transactionDbName);
    transactions.clear();

    final categories = await Hive.openBox<CategoryModel>(categoryDbName);
    categories.clear();

    final sharedprefs = await SharedPreferences.getInstance();
    await sharedprefs.clear();

    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (ctx) {
            return const SplashScreen();
          },
        ),
        (route) {
          return false;
        },
      );
      await sharedprefs.clear();
    }
  }

  void shareText() async {
    await Share.share("hello Roshan");

    log("Text shared scuccessfully");
  }
}

/////////////////////////////////////////////////////////////////////////////////////////////////////
