import 'package:flutter/material.dart';
import 'package:money_tracker/db/category/category_db.dart';
import 'package:money_tracker/provider/transaction_provider.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

class StatisticsExpenseWidget extends StatefulWidget {
  const StatisticsExpenseWidget({super.key});

  @override
  State<StatisticsExpenseWidget> createState() =>
      _StatisticsExpenseWidgetState();
}

class _StatisticsExpenseWidgetState extends State<StatisticsExpenseWidget> {
  final Map<String, double> dataMap = {};

  @override
  void initState() {
    for (int i = 0;
        i < CategoryDB.instance.expenseCategoryListListener.value.length;
        i++) {
      final categoryName =
          CategoryDB.instance.expenseCategoryListListener.value[i].name;
      final transactions =
          Provider.of<TransactionProvider>(context, listen: false)
              .transactionList
              .where(
        (e) {
          return e.categoryModel.name == categoryName;
        },
      ).toList();

      final amountList = transactions.map(
        (e) {
          return e.amount;
        },
      ).toList();

      dataMap[categoryName] = amountList.fold(
        0,
        (previousValue, currentValue) {
          return previousValue + currentValue;
        },
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 100,
            ),
            dataMap.isEmpty
                ? const Center(
                    child: Text("Empty Data !"),
                  )
                : PieChart(
                    ringStrokeWidth: 50,
                    chartRadius: 200,
                    animationDuration: const Duration(seconds: 2),
                    dataMap: dataMap,
                    colorList: const [
                      Colors.green,
                      Colors.yellow,
                      Colors.blueGrey,
                      Colors.orange,
                      Colors.tealAccent,
                      Colors.brown,
                      Colors.purple,
                      Color(0xFF2C452D),
                      Color(0xFFBFB562),
                      Color(0xFF293237),
                      Colors.pink,
                      Color(0xFF7E5517),
                      Color(0xFF0F5F4C),
                      Color(0xFF9D4E31),
                      Color(0xFF601B6C),
                    ],
                    chartValuesOptions: const ChartValuesOptions(
                        showChartValues: true,
                        showChartValuesOutside: true,
                        showChartValuesInPercentage: false,
                        showChartValueBackground: false),
                    legendOptions: const LegendOptions(
                        showLegends: true,
                        showLegendsInRow: true,
                        legendShape: BoxShape.circle,
                        legendPosition: LegendPosition.bottom),
                    chartType: ChartType.disc,
                  ),
          ],
        ),
      ),
    );
  }
}
