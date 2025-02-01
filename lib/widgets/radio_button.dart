import 'package:flutter/material.dart';
import 'package:money_tracker/theme/app_text_style.dart';

class RadioButton extends StatelessWidget {
  const RadioButton(
      {super.key,
      required this.groupValue,
      required this.value,
      required this.onChanged,
      required this.text,
      required this.activeColor});

  final int value;
  final int? groupValue;
  final void Function(int?)? onChanged;
  final String text;
  final Color activeColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Row(
          children: [
            Radio<int>(
              activeColor: activeColor,
              value: value,
              groupValue: groupValue,
              onChanged: onChanged,
            ),
            Text(
              text,
              style: AppTextStyle.body1,
            ),
          ],
        ),
      ],
    );
  }
}
