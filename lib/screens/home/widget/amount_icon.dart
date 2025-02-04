import 'package:flutter/material.dart';

class AmountCurrency extends StatelessWidget {
  const AmountCurrency({
    super.key,
    required this.amount,
    required this.currencySymbol,
  });
  final num amount;
  final String currencySymbol;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          currencySymbol,
          style: const TextStyle(fontSize: 25),
        ),
        const SizedBox(
          width: 5,
        ),
        Text(
          style: const TextStyle(
            fontSize: 20,
          ),
          amount.toString(),
        ),
      ],
    );
  }
}
