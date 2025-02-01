import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWidget(
      {super.key,
      this.title,
      this.iconData,
      this.onPressed,
      List<IconButton>? actions,
      this.leading});

  final String? title;

  final IconData? iconData;
  final void Function()? onPressed;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: leading,
      actions: [IconButton(onPressed: onPressed, icon: Icon(iconData))],
      title: Text(title ?? ""),
      backgroundColor: const Color(0xFF0B1C3B),
      foregroundColor: Colors.white,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
