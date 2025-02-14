import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:money_tracker/db/category/category_db.dart';
import 'package:money_tracker/models/category/category_model.dart';

class CategoryProvider extends ChangeNotifier {
  List<CategoryModel> incomeCategoryList = [];
  List<CategoryModel> expenseCategoryList = [];
  Future<void> refreshCategory() async {
    final hello = await CategoryDB.instance.categoryRefreshUI();
    incomeCategoryList.clear();
    expenseCategoryList.clear();
    for (int i = 0; i < hello.length; i++) {
      if (hello[i].type == CategoryType.income) {
        incomeCategoryList.add(hello[i]);
      } else {
        expenseCategoryList.add(hello[i]);
      }
    }
    notifyListeners();
  }

  Future<void> insertCategoryProvider(CategoryModel categoryModelValue) async {
    await CategoryDB.instance.insertCategory(categoryModelValue);
    await refreshCategory();
  }

  Future<void> deleteCategoryProvider(String categoryID) async {
    await CategoryDB.instance.deleteCategory(categoryID);
    await refreshCategory();
  }
}
