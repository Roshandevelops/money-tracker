import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:money_tracker/screens/category/category_screen.dart';
import 'package:money_tracker/screens/home/home_screen.dart';
import 'package:money_tracker/screens/profile/profile_screen.dart';

ValueNotifier<int> selectedIndexNotifier = ValueNotifier(0);

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key, required this.text});

  final String text;

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  final pages = [
    const HomeScreen(),
    const CategoryScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    selectedIndexNotifier = ValueNotifier(0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    log(selectedIndexNotifier.toString());
    return ValueListenableBuilder(
      valueListenable: selectedIndexNotifier,
      builder: (context, updatedIndex, child) {
        return pages[updatedIndex];
      },
    );
  }
}
