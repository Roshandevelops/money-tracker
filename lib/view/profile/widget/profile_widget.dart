import 'package:flutter/material.dart';
import 'package:money_tracker/theme/app_text_style.dart';

class ProfileWidget extends StatelessWidget {
  const ProfileWidget(
      {super.key,
      required this.text,
      required this.onPressed,
      required this.iconData});
  final String text;
  final void Function()? onPressed;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TextButton.icon(
          onPressed: onPressed,
          label: Text(
            text,
            style: AppTextStyle.body1,
          ),
          icon: Icon(
            iconData,
            color: Colors.black,
          ),
        ),

        // Icon(iconData),
        // const SizedBox(
        //   width: 20,
        // ),
        // InkWell(
        //   onTap: onTap,
        //   child: Text(
        //     text,
        //     style: AppTextStyle.body1,
        //   ),
        // ),
      ],
    );
  }
}
