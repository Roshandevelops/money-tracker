import 'package:flutter/material.dart';

class AmountIcon extends StatelessWidget {
  const AmountIcon({
    super.key,
    required this.amount,
    required this.image,
  });
  final num amount;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(image),
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
