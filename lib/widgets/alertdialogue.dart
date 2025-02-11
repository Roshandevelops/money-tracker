import 'package:flutter/material.dart';
import 'package:money_tracker/models/transaction/transaction_model.dart';

import 'package:money_tracker/theme/app_text_style.dart';

class AlertDialogWidget extends StatelessWidget {
  const AlertDialogWidget(
      {super.key,
      this.model,
      required this.title,
      required this.firsttext,
      required this.secondText,
      required this.onPressed});

  final TransactionModel? model;
  final String title;
  final String firsttext;
  final String secondText;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            firsttext,
            style: AppTextStyle.body1,
          ),
          Text(secondText)
        ],
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: onPressed,
              child: const Text(
                "Yes",
                style: TextStyle(color: Colors.black),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
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
  }
}
