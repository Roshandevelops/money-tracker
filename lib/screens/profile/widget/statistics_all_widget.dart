import 'package:flutter/material.dart';
import 'package:money_tracker/provider/transaction_provider.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

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
        "${Provider.of<TransactionProvider>(context, listen: false).totalIncome}",
      ),
      "Expense": double.parse(
        "${Provider.of<TransactionProvider>(context, listen: false).totalExpense
        // TransactionDB.instance.totalExpense.value
        }",
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
              gradientList: const [
                [Colors.green, Color.fromRGBO(113, 173, 115, 1), Colors.green],
                [
                  Color.fromARGB(255, 182, 41, 31),
                  Color.fromARGB(255, 219, 99, 90),
                  Color.fromARGB(255, 170, 30, 20),
                ],
              ],
              chartType: ChartType.disc,
            ),
          ],
        ),
      ),
    );
  }
}
