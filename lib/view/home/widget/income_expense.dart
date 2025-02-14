import 'package:flutter/material.dart';
import 'package:money_tracker/theme/app_text_style.dart';

class IncomeExpense extends StatelessWidget {
  const IncomeExpense({
    super.key,
    this.text,
    this.iconData,
    this.color,
  });
  final String? text;
  final IconData? iconData;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(text ?? "", style: AppTextStyle.body1),
        const SizedBox(
          width: 5,
        ),
        Icon(
          iconData,
          color: color,
        ),
      ],
    );
  }
}
