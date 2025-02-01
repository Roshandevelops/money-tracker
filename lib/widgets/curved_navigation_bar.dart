// import 'package:curved_navigation_bar/curved_navigation_bar.dart';
// import 'package:flutter/material.dart';
// import 'package:money_tracker/widgets/bottom_navbar.dart';

// class CurvedNavigationWidget extends StatelessWidget {
//   const CurvedNavigationWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ValueListenableBuilder(
//       valueListenable: selectedIndexNotifier,
//       builder: (context, updatedIndex, child) {
//         return CurvedNavigationBar(
//             // animationDuration: Duration(milliseconds: 400),
//             backgroundColor: const Color(0xFF0B1C3B),
//             onTap: (newIndex) {
//               selectedIndexNotifier.value = newIndex;
//             },
//             index: selectedIndexNotifier.value,
//             animationCurve: Curves.easeInOut,
//             animationDuration: const Duration(milliseconds: 300),
//             items: const [
//               Icon(
//                 Icons.home,
//               ),
//               Icon(
//                 Icons.category,
//               ),
//               Icon(
//                 Icons.person,
//               ),
//             ]);
//       },
//     );
//   }
// }
