import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:money_tracker/models/category/category_model.dart';
import 'package:money_tracker/models/transaction/transaction_model.dart';
import 'package:money_tracker/provider/transaction_provider.dart';
import 'package:money_tracker/widgets/alertdialogue.dart';
import 'package:money_tracker/widgets/edit_screen.dart';

import 'package:money_tracker/widgets/list_view_widget.dart';
import 'package:provider/provider.dart';

class TodayList extends StatefulWidget {
  const TodayList({super.key, required this.isIncomeSelected});
  final bool isIncomeSelected;

  @override
  State<TodayList> createState() => _TodayListState();
}

//  final todayDate=DateTime.now();

class _TodayListState extends State<TodayList> {
  List<TransactionModel> sampleListAll = [];
  @override
  Widget build(BuildContext context) {
    DateTime todayDate = DateTime.now();
    todayDate = DateTime(
      todayDate.year,
      todayDate.month,
      todayDate.day,
    );
    log(" test ${widget.isIncomeSelected}");
    return Consumer<TransactionProvider>(
      builder: (context, helloValue, child) {
        if (widget.isIncomeSelected == true) {
          sampleListAll = helloValue.transactionList.where((element) {
            return element.type == CategoryType.income &&
                element.dateTime == todayDate;
          }).toList();
        } else {
          sampleListAll = helloValue.transactionList.where((element) {
            return element.type == CategoryType.expense &&
                element.dateTime == todayDate;
          }).toList();
        }

        log("items ${sampleListAll.length}");
        return sampleListAll.isNotEmpty
            ? ListView.builder(
                itemCount: sampleListAll.length,
                itemBuilder: (ctx, index) {
                  final data = sampleListAll[index];
                  return Slidable(
                    key: Key(data.id!),
                    endActionPane: ActionPane(
                      motion: const DrawerMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (ctx) {
                            log("all edit");
                            editTransaction(sampleListAll[index]);
                          },
                          icon: Icons.edit,
                          backgroundColor: Colors.green,
                          label: "Edit",
                        ),
                        SlidableAction(
                          onPressed: (context) {
                            log("all delete");

                            deleteTransaction(context, data);
                          },
                          icon: Icons.delete,
                          backgroundColor: Colors.red,
                          label: "Delete",
                        ),
                      ],
                    ),
                    child: TransactionCardWidget(
                      iconColor: data.type == CategoryType.income
                          ? Colors.green
                          : Colors.red,
                      amount: data.amount,
                      dateTime: data.dateTime,
                      purposeText: data.categoryModel.name,
                      descriptionText: "(${data.description})",
                      iconData: data.type == CategoryType.income
                          ? Icons.arrow_circle_up_outlined
                          : Icons.arrow_circle_down_outlined,
                    ),
                  );
                },
              )
            : const Center(child: Text("No Transactions !"));
      },
    );
  }

  void editTransaction(TransactionModel transaction) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialogWidget(
          title: "Edit !",
          firsttext: "Are you sure ?",
          secondText: "Do you want to edit ?",
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (ctx) {
                  return EditScreen(
                    transactionModel: transaction,
                  );
                },
              ),
            ).then((e) {
              setState(() {});
            });
          },
        );
      },
    );
  }

  void deleteTransaction(BuildContext context, TransactionModel model) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialogWidget(
          model: model,
          firsttext: " Are you sure",
          secondText: " Do you want to delete ?",
          title: "Delete !",
          onPressed: () async {
            Provider.of<TransactionProvider>(ctx, listen: false)
                .deleteTransactionProvider(model);

            if (ctx.mounted) {
              Navigator.of(ctx).pop();
            }
          },
        );
      },
    );
  }
}
