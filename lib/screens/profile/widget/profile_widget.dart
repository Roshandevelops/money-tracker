import 'package:flutter/material.dart';
import 'package:money_tracker/theme/app_text_style.dart';

class ProfileWidget extends StatelessWidget {
  const ProfileWidget(
      {super.key,
      required this.text,
      required this.onTap,
      required this.iconData});
  final String text;
  final void Function()? onTap;
  final IconData iconData;
  // final TextEditingController userNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(iconData),
        const SizedBox(
          width: 20,
        ),
        InkWell(
          onTap: onTap,
          child: Text(
            text,
            style: AppTextStyle.body1,
          ),
        ),
      ],
    );
  }
}
