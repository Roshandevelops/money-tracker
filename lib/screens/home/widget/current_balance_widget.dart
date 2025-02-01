import 'package:flutter/material.dart';
import 'package:money_tracker/db/transaction/transaction_db.dart';
import 'amount_icon.dart';
import 'income_expense.dart';

class CurrentBalanceWidget extends StatelessWidget {
  const CurrentBalanceWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      height: 200,
      decoration: const BoxDecoration(
        color: Color(0xFF0B1C3B),
        borderRadius: BorderRadius.all(
          Radius.circular(
            20,
          ),
        ),
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            const Text(
              "Current Balance",
              style: TextStyle(
                letterSpacing: 1,
                fontSize: 25,
              ),
            ),
            ValueListenableBuilder(
              valueListenable: TransactionDB.instance.currentBalance,
              builder: (context, value, child) {
                return AmountIcon(
                  image: "assets/images/amounticon.jpg",
                  amount: value,
                );
              },
            ),
            const SizedBox(
              height: 20,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IncomeExpense(
                  color: Colors.green,
                  text: "Income",
                  iconData: Icons.arrow_circle_up_outlined,
                ),
                IncomeExpense(
                  text: "Expense",
                  iconData: Icons.arrow_circle_down_outlined,
                  color: Colors.red,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ValueListenableBuilder(
                    valueListenable: TransactionDB.instance.totalIncome,
                    builder: (context, value, child) {
                      return AmountIcon(
                        amount: value,
                        image: "assets/images/amounticon.jpg",
                      );
                    }),
                ValueListenableBuilder(
                    valueListenable: TransactionDB.instance.totalExpense,
                    builder: (context, value, child) {
                      return AmountIcon(
                        amount: value,
                        image: "assets/images/amounticon.jpg",
                      );
                    }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
