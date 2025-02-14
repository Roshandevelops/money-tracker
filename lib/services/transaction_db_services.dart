import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:money_tracker/models/transaction/transaction_model.dart';

const String transactionDbName = "TRANSACTION_DB_NAME";

abstract class TransactionDbFunctions {
  Future<void> addTransactions(TransactionModel transactionModelValue);
  Future<List<TransactionModel>> getAllTransactions();
  Future<void> deleteTransaction(TransactionModel model);
  Future<void> editTransactionsSample(
      TransactionModel editModel, TransactionModel oldTransactionModel);
  Future<List<TransactionModel>> transactionRefreshUI();
}

class TransactionDB extends ChangeNotifier implements TransactionDbFunctions {
  TransactionDB.internal();
  static TransactionDB instance = TransactionDB.internal();
  factory TransactionDB() {
    return instance;
  }

  @override
  Future<void> addTransactions(TransactionModel transactionModelValue) async {
    final transactionDB =
        await Hive.openBox<TransactionModel>(transactionDbName);
    await transactionDB.put(transactionModelValue.id, transactionModelValue);
  }

  @override
  Future<List<TransactionModel>> transactionRefreshUI() async {
    final transactionList = await getAllTransactions();
    transactionList.sort(
      (first, second) {
        if (first.dateTime.day == second.dateTime.day &&
            first.dateTime.month == second.dateTime.month &&
            first.dateTime.year == first.dateTime.year) {
          return 1;
        }
        return second.dateTime.compareTo(first.dateTime);
      },
    );

    return transactionList;
  }

  @override
  Future<List<TransactionModel>> getAllTransactions() async {
    final transactionDB =
        await Hive.openBox<TransactionModel>(transactionDbName);
    return transactionDB.values.toList();
  }

  @override
  Future<void> deleteTransaction(TransactionModel model) async {
    await model.deleteTransactionSample();
    await transactionRefreshUI();
  }

  @override
  Future<void> editTransactionsSample(
      TransactionModel newModel, TransactionModel oldTransactionModel) async {
    await oldTransactionModel.editTransaction(newModel);
    await transactionRefreshUI();
  }
}
