import 'package:flutter/material.dart';
import 'package:money_tracker/widgets/radio_button.dart';

class IncomeExpenseRadioButton extends StatelessWidget {
  const IncomeExpenseRadioButton({
    super.key,
    required this.groupValue,
    required this.onChanged,
  });

  final void Function(int? groupValue)? onChanged;
  final int groupValue;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        RadioButton(
          activeColor: Colors.green,
          text: "Income",
          groupValue: groupValue,
          value: 1,
          onChanged: onChanged,
        ),
        RadioButton(
          activeColor: Colors.green,
          text: "Expense",
          groupValue: groupValue,
          value: 2,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
