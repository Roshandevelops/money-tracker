import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:money_tracker/models/category/category_model.dart';
import 'package:money_tracker/models/transaction/transaction_model.dart';
import 'package:money_tracker/provider/transaction_provider.dart';
import 'package:money_tracker/widgets/alertdialogue.dart';
import 'package:money_tracker/widgets/edit_screen.dart';
import 'package:money_tracker/widgets/list_view_widget.dart';
import 'package:money_tracker/widgets/text_form_field_widget.dart';
import 'package:provider/provider.dart';

class CustomList extends StatefulWidget {
  const CustomList({super.key, required this.isIncomeSelected});

  final bool isIncomeSelected;

  @override
  State<CustomList> createState() => _CustomListState();
}

class _CustomListState extends State<CustomList> {
  final TextEditingController dateController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  List<TransactionModel> sampleListAll = [];
  List<TransactionModel> filteredList = [];

  @override
  void initState() {
    dateController.text = DateFormat('MMM dd,yyyy').format(selectedDate);

    filteredList = sampleListAll;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () async {
            await selectDate(context);
          },
          child: TextFormFieldWidget(
            suffixIcon: const Icon(Icons.calendar_month),
            textController: dateController,
            enabled: false,
            hintText: "check date",
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Consumer<TransactionProvider>(
          builder: (context, helloValue, child) {
            if (widget.isIncomeSelected == true) {
              sampleListAll = helloValue.transactionList.where((element) {
                return element.type == CategoryType.income;
              }).toList();
            } else {
              sampleListAll = helloValue.transactionList.where((element) {
                return element.type == CategoryType.expense;
              }).toList();
            }
            filteredList = sampleListAll.where((element) {
              return DateFormat('MMM dd,yyyy').format(element.dateTime) ==
                  dateController.text;
            }).toList();

            return Expanded(
              child: filteredList.isNotEmpty
                  ? ListView.builder(
                      itemCount: filteredList.length,
                      itemBuilder: (ctx, index) {
                        final data = filteredList[index];
                        return Slidable(
                          key: Key(data.id!),
                          endActionPane: ActionPane(
                            motion: const DrawerMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (ctx) {
                                  // log("all edit");
                                  editTransaction(
                                    filteredList[index],
                                  );
                                },
                                icon: Icons.edit,
                                backgroundColor: Colors.green,
                                label: "Edit",
                              ),
                              SlidableAction(
                                onPressed: (context) {
                                  // log("all delete");

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
                  : const Center(child: Text("No Transactions !")),
            );
          },
        )
      ],
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
          title: "Delete !",
          firsttext: " Are you sure",
          secondText: " Do you want to delete ?",
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

  Future<void> selectDate(BuildContext context) async {
    final DateTime? datePicked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (datePicked == null) {
      return;
    } else {
      log(datePicked.toString());
      setState(() {
        selectedDate = datePicked;

        dateController.text = DateFormat('MMM dd,yyyy').format(datePicked);
        filteredList = sampleListAll.where((e) {
          return DateFormat('MMM dd,yyyy').format(e.dateTime) ==
              dateController.text;
        }).toList();
      });
    }
    log(filteredList.toString());
  }
}
