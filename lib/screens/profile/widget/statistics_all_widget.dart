import 'package:flutter/material.dart';
import 'package:money_tracker/db/transaction/transaction_db.dart';
import 'package:pie_chart/pie_chart.dart';

class StatisticsAllWidget extends StatefulWidget {
  const StatisticsAllWidget({super.key});

  @override
  State<StatisticsAllWidget> createState() => _StatisticsAllWidgetState();
}

class _StatisticsAllWidgetState extends State<StatisticsAllWidget> {
  Map<String, double> dataMap = {};

  @override
  void initState() {
    dataMap = {
      "Income": double.parse(
        "${TransactionDB.instance.totalIncome.value}",
      ),
      "Expense": double.parse(
        "${TransactionDB.instance.totalExpense.value}",
      ),
    };
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
            PieChart(
              ringStrokeWidth: 50,
              chartRadius: 200,
              animationDuration: const Duration(seconds: 2),
              dataMap: dataMap,
              // colorList: const [Colors.green, Colors.red],
              chartValuesOptions: const ChartValuesOptions(
                  showChartValues: true,
                  showChartValuesOutside: true,
                  showChartValuesInPercentage: false,
                  showChartValueBackground: false),
              legendOptions: const LegendOptions(
                  showLegends: true,
                  showLegendsInRow: true,
                  legendShape: BoxShape.rectangle,
                  legendPosition: LegendPosition.bottom),
              gradientList: const [
                [Colors.green, Color.fromRGBO(113, 173, 115, 1), Colors.green],
                [
                  Color.fromARGB(255, 182, 41, 31),
                  Color.fromARGB(255, 219, 99, 90),
                  Color.fromARGB(255, 170, 30, 20),
                ],
              ],
              chartType: ChartType.ring,
            ),
          ],
        ),
      ),
    );
  }
}
