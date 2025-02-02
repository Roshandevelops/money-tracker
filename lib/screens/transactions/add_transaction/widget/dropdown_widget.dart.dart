import 'package:flutter/material.dart';
import 'package:money_tracker/db/category/category_db.dart';
import 'package:money_tracker/models/category/category_model.dart';

class DropDownWidget extends StatelessWidget {
  const DropDownWidget({
    super.key,
    required this.selectedCategoryType,
    required this.selectedCategoryItem,
    required this.onChanged,
    required this.onMenuItemTap,
    this.validator,
  });

  final CategoryType selectedCategoryType;
  final String? selectedCategoryItem;
  final void Function(String? newValue)? onChanged;
  final void Function(CategoryModel)? onMenuItemTap;
  final String? Function(String?)? validator;

  // final List<DropdownMenuItem<String>>? items;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: DropdownButtonFormField(
        validator: validator,
        value: selectedCategoryItem,
        hint: const Text(
          "Choose Category",
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        items: (selectedCategoryType == CategoryType.income
                ? CategoryDB.instance.incomeCategoryListListener
                : CategoryDB.instance.expenseCategoryListListener)
            .value
            .map(
          (e) {
            return DropdownMenuItem(
              onTap: () {
                onMenuItemTap?.call(e);
              },
              value: e.id,
              child: Text(e.name),
            );
          },
        ).toList(),
        onChanged: onChanged,
      ),
    );
  }
}
