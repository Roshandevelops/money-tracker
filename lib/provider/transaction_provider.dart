import 'package:flutter/material.dart';
import 'package:money_tracker/db/transaction/transaction_db.dart';
import 'package:money_tracker/models/category/category_model.dart';
import 'package:money_tracker/models/transaction/transaction_model.dart';

class TransactionProvider extends ChangeNotifier {
  List<TransactionModel> transactionList = [];

  num totalIncome = 0;
  num totalExpense = 0;
  num currentBalance = 0;

  Future<void> refreshTransactions() async {
    final list = await TransactionDB.instance.transactionRefreshUI();
    transactionList.clear();
    transactionList.addAll(list);

    totalIncome = 0;
    totalExpense = 0;
    currentBalance = 0;

    for (int i = 0; i < transactionList.length; i++) {
      if (transactionList[i].type == CategoryType.income) {
        totalIncome = totalIncome + transactionList[i].amount;
      } else {
        totalExpense = totalExpense + transactionList[i].amount;
      }
    }
    currentBalance = totalIncome - totalExpense;
    notifyListeners();
  }

  Future<void> editTransactionProvider(TransactionModel newTransactionModel,
      TransactionModel oldTransactionModel) async {
    await TransactionDB.instance
        .editTransactionsSample(newTransactionModel, oldTransactionModel);
    await refreshTransactions();
  }

  Future<void> deleteTransactionProvider(TransactionModel model) async {
    await TransactionDB.instance.deleteTransaction(model);
    await refreshTransactions();
  }
}
