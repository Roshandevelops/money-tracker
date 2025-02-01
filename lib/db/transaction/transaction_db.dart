import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_tracker/models/category/category_model.dart';

import 'package:money_tracker/models/transaction/transaction_model.dart';

const String transactionDbName = "TRANSACTION_DB_NAME";

abstract class TransactionDbFunctions {
  Future<void> addTransactions(TransactionModel transactionModelValue);
  Future<List<TransactionModel>> getAllTransactions();
  Future<void> deleteTransaction(TransactionModel model);
  Future<void> editTransactionsSample(
      TransactionModel editModel, TransactionModel oldTransactionModel);
}

class TransactionDB extends ChangeNotifier implements TransactionDbFunctions {
  TransactionDB.internal();
  static TransactionDB instance = TransactionDB.internal();
  factory TransactionDB() {
    return instance;
  }

  ValueNotifier<List<TransactionModel>> transactionListNotifier =
      ValueNotifier([]);

  ValueNotifier<num> totalIncome = ValueNotifier(0);
  ValueNotifier<num> totalExpense = ValueNotifier(0);
  ValueNotifier<num> currentBalance = ValueNotifier(0);

  @override
  Future<void> addTransactions(TransactionModel transactionModelValue) async {
    final transactionDB =
        await Hive.openBox<TransactionModel>(transactionDbName);
    await transactionDB.put(transactionModelValue.id, transactionModelValue);
  }

  Future<void> transactionRefreshUI() async {
    final transactionList = await getAllTransactions();
    transactionList.sort((first, second) {
      if (first.dateTime.day == second.dateTime.day &&
          first.dateTime.month == second.dateTime.month &&
          first.dateTime.year == first.dateTime.year) {
        return 1;
      }
      return second.dateTime.compareTo(first.dateTime);
    });
    transactionListNotifier.value.clear();
    transactionListNotifier.value.addAll(transactionList);
    transactionListNotifier.notifyListeners();

    totalIncome.value = 0;
    totalExpense.value = 0;
    currentBalance.value = 0;

    for (int i = 0; i < transactionList.length; i++) {
      if (transactionList[i].type == CategoryType.income) {
        totalIncome.value = totalIncome.value + transactionList[i].amount;
      } else {
        totalExpense.value = totalExpense.value + transactionList[i].amount;
      }
    }
    currentBalance.value = totalIncome.value - totalExpense.value;

    totalIncome.notifyListeners();
    totalExpense.notifyListeners();
    currentBalance.notifyListeners();

    // transactionList.map(
    //   (e) {
    //     if (e.type == CategoryType.income) {
    //       totalIncome.value = totalIncome.value + e.amount;
    //     } else {
    //       totalExpense.value = totalExpense.value + e.amount;
    //     }
    //     return e;
    //   },
    // );

    // totalIncome.notifyListeners();
    // totalExpense.notifyListeners();
  }

  @override
  Future<List<TransactionModel>> getAllTransactions() async {
    final transactionDB =
        await Hive.openBox<TransactionModel>(transactionDbName);
    return transactionDB.values.toList();
  }

  @override
  Future<void> deleteTransaction(
    TransactionModel model,
  ) async {
    await model.deleteTransactionSample();
    await transactionRefreshUI();
  }

  @override
  Future<void> editTransactionsSample(
      TransactionModel newModel, TransactionModel oldTransactionModel) async {
    await oldTransactionModel.editTransaction(newModel);
    await transactionRefreshUI();

    // final transactionDB =
    //     await Hive.openBox<TransactionModel>(transactionDbName);
    // await transactionDB.putAt(index, editModel);
    // await transactionRefreshUI();
  }
}
