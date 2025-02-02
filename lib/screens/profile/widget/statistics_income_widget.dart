import 'package:flutter/material.dart';
import 'package:money_tracker/db/category/category_db.dart';
import 'package:money_tracker/db/transaction/transaction_db.dart';
import 'package:pie_chart/pie_chart.dart';

class StatisticsIncomeWidget extends StatefulWidget {
  const StatisticsIncomeWidget({super.key});

  @override
  State<StatisticsIncomeWidget> createState() => _StatisticsIncomeWidgetState();
}

class _StatisticsIncomeWidgetState extends State<StatisticsIncomeWidget> {
  Map<String, double> dataMap = {};
  @override
  void initState() {
    for (int i = 0;
        i < CategoryDB.instance.incomeCategoryListListener.value.length;
        i++) {
      final categoryName =
          CategoryDB.instance.incomeCategoryListListener.value[i].name;

      final transactions = TransactionDB.instance.transactionListNotifier.value
          .where((e) => e.categoryModel.name == categoryName)
          .toList();

      final amountList = transactions.map((e) => e.amount).toList();

      dataMap[categoryName] = amountList.fold(
        0,
        (previousValue, currentValue) => previousValue + currentValue,
      );
    }

    super.initState();
  }

  // alight motion

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
            // dataMap == {}
            //     ? Text("data")
            //     :
            dataMap.isEmpty
                ? const Center(child: Text("Empty Data !"))
                : PieChart(
                    // totalValue: 20,
                    ringStrokeWidth: 50,
                    chartRadius: 200,
                    animationDuration: const Duration(seconds: 2),
                    dataMap: dataMap,
                    colorList: const [
                      Colors.green,
                      Colors.yellow,
                      Colors.blueGrey,
                      Colors.orange,
                      Colors.pink,
                      Colors.tealAccent,
                      Colors.blueGrey,
                      Colors.brown,
                      Colors.purple,
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
                    chartType: ChartType.ring,
                  ),
          ],
        ),
      ),
    );
  }
}
