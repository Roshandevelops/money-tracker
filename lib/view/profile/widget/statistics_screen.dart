// import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:money_tracker/view/profile/widget/statistics_all_widget.dart';
import 'package:money_tracker/view/profile/widget/statistics_expense_widget.dart';
import 'package:money_tracker/view/profile/widget/statistics_income_widget.dart';
import 'package:money_tracker/widgets/app_bar_widget.dart';
import 'package:money_tracker/widgets/tab_bar_widget.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({
    super.key,
  });

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen>
    with SingleTickerProviderStateMixin {
  late TabController pieChartController;
  @override
  void initState() {
    pieChartController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final Map<String, double> dataMap = {"Income": 18, "Expense": 5};
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AppBarWidget(
        title: "Statistics",
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // SizedBox(
            //   height: 20,
            // ),
            TabBarWidget(
              newTabController: pieChartController,
              tab1: "All",
              tab2: "Income",
              tab3: "Expense",
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: TabBarView(
                controller: pieChartController,
                children: const [
                  StatisticsAllWidget(),
                  StatisticsIncomeWidget(),
                  StatisticsExpenseWidget()
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }
}
