// import 'package:flutter/material.dart';
// import 'package:money_tracker/widgets/bottom_navbar.dart';

// class BottomNavigationbarWidget extends StatelessWidget {
//   const BottomNavigationbarWidget({super.key});

//   // old one

//   @override
//   Widget build(BuildContext context) {
//     return ValueListenableBuilder(
//         valueListenable: seledtedIndexNotifier,
//         builder: (context, updatedIndex, child) {
//           return BottomNavigationBar(
//             backgroundColor: Colors.white,
//             enableFeedback: true,
//             selectedItemColor: const Color(0xFF0B1C3B),
//             selectedFontSize: 15,
//             onTap: (newIndex) {
//               seledtedIndexNotifier.value = newIndex;
//             },
//             currentIndex: updatedIndex,
//             items: const [
//               BottomNavigationBarItem(
//                 icon: Icon(
//                   Icons.home,
//                 ),
//                 label: "Home",
//               ),
//               BottomNavigationBarItem(
//                 icon: Icon(
//                   Icons.category,
//                 ),
//                 label: "Category",
//               ),
//               BottomNavigationBarItem(
//                 icon: Icon(
//                   Icons.person,
//                 ),
//                 label: "Profile",
//               ),
//             ],
//           );
//         });
//   }
// }
