import 'package:flutter/material.dart';
import 'package:money_tracker/view/profile/widget/profile_item_widget.dart';
import 'package:money_tracker/widgets/app_bar_widget.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      // bottomNavigationBar: CurvedNavigationWidget(),
      // BottomNavigationbarWidget(),
      appBar: AppBarWidget(
        title: "Profile ",
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(20),
        child: ProfileItemWidget(),
      ),
    );
  }
}
