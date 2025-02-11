import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_tracker/models/category/category_model.dart';

const String categoryDbName = "CATEGORY_DB_NAME";

abstract class CategoryDbFunctions {
  Future<void> insertCategory(CategoryModel categoryModelValue);
  Future<List<CategoryModel>> getCategories();
  Future<void> deleteCategory(String categoryID);
}

class CategoryDB extends ChangeNotifier implements CategoryDbFunctions {
  CategoryDB.internal();
  static CategoryDB instance = CategoryDB.internal();
  factory CategoryDB() {
    return CategoryDB.instance;
  }

  // ValueNotifier<List<CategoryModel>> incomeCategoryListListener =
  //     ValueNotifier([]);
  // ValueNotifier<List<CategoryModel>> expenseCategoryListListener =
  //     ValueNotifier([]);

  @override
  Future<void> insertCategory(CategoryModel categoryModelValue) async {
    final categoryDB = await Hive.openBox<CategoryModel>(categoryDbName);
    await categoryDB.put(categoryModelValue.id, categoryModelValue);
    await categoryRefreshUI();
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    final categoryDB = await Hive.openBox<CategoryModel>(categoryDbName);
    return categoryDB.values.toList();
  }

  @override
  Future<void> deleteCategory(String categoryID) async {
    final categoryDB = await Hive.openBox<CategoryModel>(categoryDbName);
    await categoryDB.delete(categoryID);
    categoryRefreshUI();
  }

  Future<List> categoryRefreshUI() async {
    final allCategories = await getCategories();
    return allCategories;
  }
}
