import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:money_tracker/view/transactions/view_transactions/search_screen.dart';
import 'package:money_tracker/view/transactions/view_transactions/widget/all.dart';
import 'package:money_tracker/view/transactions/view_transactions/widget/custom.dart';
import 'package:money_tracker/view/transactions/view_transactions/widget/today.dart';
import 'package:money_tracker/theme/app_text_style.dart';
import 'package:money_tracker/widgets/app_bar_widget.dart';
import 'package:money_tracker/widgets/tab_bar_widget.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  bool isIncomeSelected = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarWidget(
        iconData: Icons.search,
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
            return const SearchScreen();
          }));
        },
        title: "Transactions",
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        isIncomeSelected = true;
                        // tabController.index = 0;
                      });
                      log("Income selected");
                    },
                    child: Text(
                      "Income",
                      style: AppTextStyle.body1.copyWith(
                          color: isIncomeSelected ? Colors.black : Colors.grey),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        isIncomeSelected = false;
                        // tabController.index = 0;
                      });
                      log("Expense selected");
                    },
                    child: Text(
                      "Expense",
                      style: AppTextStyle.body1.copyWith(
                          color: isIncomeSelected ? Colors.grey : Colors.black),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              TabBarWidget(
                newTabController: tabController,
                tab1: "All",
                tab2: "Today",
                tab3: "Custom",
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: TabBarView(
                  controller: tabController,
                  children: [
                    AllList(
                      isIncomeSelected: isIncomeSelected,
                    ),
                    TodayList(
                      isIncomeSelected: isIncomeSelected,
                    ),
                    CustomList(
                      isIncomeSelected: isIncomeSelected,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
