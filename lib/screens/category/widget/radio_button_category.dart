import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:money_tracker/widgets/radio_button.dart';

class RadioButtonAddCategory extends StatefulWidget {
  const RadioButtonAddCategory({super.key});
  @override
  State<RadioButtonAddCategory> createState() => _RadioButtonAddCategoryState();
}

class _RadioButtonAddCategoryState extends State<RadioButtonAddCategory> {
  @override
  void initState() {
    setState(() {
      groupValue = 1;
    });
    super.initState();
  }

  int? groupValue;
  int? value;
  void Function(int?)? onChanged;
  String? radioValue;

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
          onChanged: (p0) {
            setState(
              () {
                groupValue = 1;
                radioValue = "Income Selected";
                log(
                  radioValue.toString(),
                );
              },
            );
          },
        ),
        RadioButton(
          activeColor: Colors.green,
          text: "Expense",
          groupValue: groupValue,
          value: 2,
          onChanged: (p0) {
            setState(
              () {
                groupValue = 2;

                radioValue = "Expense Selected";
                log(
                  radioValue.toString(),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
