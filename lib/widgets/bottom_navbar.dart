import 'dart:developer';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
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

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    log(selectedIndexNotifier.toString());
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        animationDuration: const Duration(milliseconds: 300),
        animationCurve: Curves.easeInCubic,
        backgroundColor: const Color(0xFF0B1C3B),
        items: const [
          Icon(
            Icons.home,
          ),
          Icon(
            Icons.category,
          ),
          Icon(
            Icons.person,
          ),
        ],
        index: selectedIndex,
        onTap: (value) {
          setState(() {
            selectedIndex = value;
          });
        },
      ),
      body: pages[selectedIndex],
    );
    // ValueListenableBuilder(
    //   valueListenable: selectedIndexNotifier,
    //   builder: (context, updatedIndex, child) {
    //     return pages[updatedIndex];
    //   },
    // );
  }
}
