import 'package:flutter/material.dart';
import 'package:money_tracker/widgets/text_form_field_widget.dart';

abstract class ProfileFunctions {
  void changeUserName(BuildContext context, TextEditingController value);
}

class ProfileFunctionsImpl implements ProfileFunctions {
  @override
  void changeUserName(
      BuildContext context, TextEditingController userNameController) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text("Change username"),
          content: TextFormFieldWidget(
            textController: userNameController,
            hintText: "Enter new username ",
          ),
          actions: [
            MaterialButton(
              onPressed: () {},
              child: const Text("Add"),
            ),
            MaterialButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            )
          ],
        );
      },
    );
  }

  void showStatistis() {}
}
