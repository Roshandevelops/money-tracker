import 'package:flutter/material.dart';
import 'package:money_tracker/controller/transaction_controller.dart';
import 'package:provider/provider.dart';
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
            Consumer<TransactionProvider>(
              builder: (context, helloValue, child) {
                return AmountCurrency(
                  currencySymbol: "₹",
                  amount: helloValue.currentBalance,
                );
              },
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    const IncomeExpense(
                      color: Colors.green,
                      text: "Income",
                      iconData: Icons.arrow_circle_up_outlined,
                    ),
                    Consumer<TransactionProvider>(
                        builder: (context, helloValue, child) {
                      return AmountCurrency(
                        amount: helloValue.totalIncome,
                        currencySymbol: "₹",
                      );
                    }),
                  ],
                ),
                Column(
                  children: [
                    const IncomeExpense(
                      text: "Expense",
                      iconData: Icons.arrow_circle_down_outlined,
                      color: Colors.red,
                    ),
                    Consumer<TransactionProvider>(
                        builder: (context, helloValue, child) {
                      return AmountCurrency(
                        amount: helloValue.totalExpense,
                        currencySymbol: "₹",
                      );
                    }),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
