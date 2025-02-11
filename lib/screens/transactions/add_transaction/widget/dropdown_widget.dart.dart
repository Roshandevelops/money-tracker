import 'package:flutter/material.dart';
import 'package:money_tracker/models/category/category_model.dart';
import 'package:money_tracker/provider/category_provider.dart';
import 'package:provider/provider.dart';

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
                ? Provider.of<CategoryProvider>(context).incomeCategoryList
                : Provider.of<CategoryProvider>(context).expenseCategoryList)
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
