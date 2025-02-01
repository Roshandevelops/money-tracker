import 'package:flutter/material.dart';

class TabBarWidget extends StatelessWidget {
  const TabBarWidget(
      {super.key,
      required this.newTabController,
      required this.tab1,
      required this.tab2,
      required this.tab3});
  final TabController newTabController;
  final String tab1;
  final String tab2;
  final String tab3;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      // decoration: BoxDecoration(
      // borderRadius: BorderRadius.circular(10),
      // gradient: const LinearGradient(
      //   colors: [
      //     Color(0xFF0B1C3B),
      //     Color(0xFF781F3E),
      //     Color(0xFF011401),
      //   ],
      // ),
      // ),
      child: TabBar(
        indicator: BoxDecoration(
          color:
              //
              const Color(0xFF071935),
          borderRadius: BorderRadius.circular(10),
        ),
        dividerColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorColor: const Color(0xFF0B1C3B),
        isScrollable: false,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey,
        controller: newTabController,
        tabs: [
          Text(tab1),
          Text(tab2),
          Text(tab3),
        ],
      ),
    );
  }
}
