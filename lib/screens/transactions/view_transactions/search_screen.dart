import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:money_tracker/models/category/category_model.dart';
import 'package:money_tracker/models/transaction/transaction_model.dart';
import 'package:money_tracker/provider/transaction_provider.dart';
import 'package:money_tracker/widgets/alertdialogue.dart';
import 'package:money_tracker/widgets/app_bar_widget.dart';
import 'package:money_tracker/widgets/edit_screen.dart';
import 'package:money_tracker/widgets/list_view_widget.dart';
import 'package:money_tracker/widgets/text_form_field_widget.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();

  List<TransactionModel> filteredList = [];
  @override
  void initState() {
    filteredList = Provider.of<TransactionProvider>(context, listen: false)
        .transactionList;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: const AppBarWidget(
          title: "Search ",
        ),
        body: SafeArea(
            child: Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 20,
                ),
                child: Consumer<TransactionProvider>(
                    builder: (context, newValue, child) {
                  return Column(
                    children: [
                      TextFormFieldWidget(
                          onChanged: (value) {
                            log(value);
                            setState(() {
                              filteredList =
                                  newValue.transactionList.where((element) {
                                return element.categoryModel.name
                                    .toLowerCase()
                                    .contains((value.toLowerCase()));
                              }).toList();
                            });
                          },
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                          textController: searchController,
                          hintText: "Search here"),
                      const SizedBox(
                        height: 20,
                      ),
                      Expanded(
                        child: filteredList.isNotEmpty
                            ? ListView.builder(
                                itemCount: filteredList.isEmpty
                                    ? newValue.transactionList.length
                                    : filteredList.length,
                                itemBuilder: (ctx, index) {
                                  final data = filteredList.isEmpty
                                      ? newValue.transactionList[index]
                                      : filteredList[index];
                                  return Slidable(
                                    key: Key(data.id!),
                                    endActionPane: ActionPane(
                                      motion: const DrawerMotion(),
                                      children: [
                                        SlidableAction(
                                          onPressed: (ctx) {
                                            editTransaction(newValue
                                                .transactionList[index]);
                                          },
                                          icon: Icons.edit,
                                          backgroundColor: Colors.green,
                                          label: "Edit",
                                        ),
                                        SlidableAction(
                                          onPressed: (context) {
                                            deleteTransaction(context, data);
                                          },
                                          icon: Icons.delete,
                                          backgroundColor: Colors.red,
                                          label: "Delete",
                                        ),
                                      ],
                                    ),
                                    child: TransactionCardWidget(
                                      iconColor:
                                          data.type == CategoryType.income
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
                            : const Center(
                                child: Text("No Transactions !"),
                              ),
                      ),
                    ],
                  );
                }))));
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
