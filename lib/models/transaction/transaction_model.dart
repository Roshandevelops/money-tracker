import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_tracker/models/category/category_model.dart';
part 'transaction_model.g.dart';

@HiveType(typeId: 3)
class TransactionModel extends HiveObject {
  @HiveField(0)
  CategoryType type;

  @HiveField(1)
  CategoryModel categoryModel;

  @HiveField(2)
  String description;

  @HiveField(3)
  double amount;

  @HiveField(4)
  DateTime dateTime;

  @HiveField(5)
  String? id;

  TransactionModel({
    required this.type,
    required this.categoryModel,
    required this.description,
    required this.amount,
    required this.dateTime,
  }) {
    id = DateTime.now().millisecondsSinceEpoch.toString();
  }

  Future<void> deleteTransactionSample() async {
    await delete();
  }

  Future<void> editTransaction(TransactionModel newTransaction) async {
    amount = newTransaction.amount;
    categoryModel = newTransaction.categoryModel;
    dateTime = newTransaction.dateTime;
    type = newTransaction.type;
    description = newTransaction.description;
    await save();
  }
}
