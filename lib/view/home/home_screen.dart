import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:money_tracker/main.dart';
import 'package:money_tracker/models/category/category_model.dart';
import 'package:money_tracker/models/transaction/transaction_model.dart';
import 'package:money_tracker/controller/category_controller.dart';
import 'package:money_tracker/controller/transaction_controller.dart';
import 'package:money_tracker/view/transactions/add_transaction/add_transaction.dart';
import 'package:money_tracker/view/transactions/view_transactions/transactions.dart';
import 'package:money_tracker/theme/app_text_style.dart';
import 'package:money_tracker/widgets/alertdialogue.dart';
import 'package:money_tracker/widgets/app_bar_widget.dart';
import 'package:money_tracker/view/transactions/add_transaction/edit_transaction.dart';
import 'package:money_tracker/widgets/list_view_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'widget/current_balance_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedCategoryGroupValue = 1;
  String newName = "";

  @override
  void initState() {
    Provider.of<TransactionProvider>(context, listen: false)
        .refreshTransactions();
    Provider.of<CategoryProvider>(context, listen: false).refreshCategory();
    showString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarWidget(
        title: newName,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
          ),
          child: Column(
            children: [
              const CurrentBalanceWidget(),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    " Recent Transactions",
                    style: AppTextStyle.body1,
                  ),
                  InkWell(
                      onTap: () {
                        goToViewMore(context);
                      },
                      child: const Icon(
                        Icons.format_list_bulleted_rounded,
                        size: 30,
                      )),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Consumer<TransactionProvider>(
                builder: (context, transactionConsumer, child) {
                  return Expanded(
                    child: transactionConsumer.transactionList.isNotEmpty
                        ? ListView.builder(
                            itemCount:
                                transactionConsumer.transactionList.length >= 4
                                    ? 4
                                    : transactionConsumer
                                        .transactionList.length,
                            itemBuilder: (ctx, index) {
                              final data =
                                  transactionConsumer.transactionList[index];
                              return Slidable(
                                key: Key(data.id!),
                                endActionPane: ActionPane(
                                  motion: const DrawerMotion(),
                                  children: [
                                    SlidableAction(
                                      onPressed: (ctx) {
                                        log("sample edit");
                                        editTransaction(
                                          transactionConsumer
                                              .transactionList[index],
                                        );
                                      },
                                      icon: Icons.edit,
                                      backgroundColor: Colors.green,
                                      label: "Edit",
                                    ),
                                    SlidableAction(
                                      onPressed: (context) {
                                        log("sample delete");

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
                        : const Center(
                            child: Text("No Transactions !"),
                          ),
                  );
                },
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF0B1C3B),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) {
                return const AddTransactionScreen();
              },
            ),
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  void goToViewMore(context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) {
          return const TransactionScreen();
        },
      ),
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
          firsttext: " Are you sure ?",
          secondText: " Do you want to delete ?",
          title: "Delete !",
          onPressed: () async {
            await Provider.of<TransactionProvider>(ctx, listen: false)
                .deleteTransactionProvider(model);

            if (ctx.mounted) {
              Navigator.of(ctx).pop();
            }
          },
        );
      },
    );
  }

  void showString() async {
    final sharedprefs = await SharedPreferences.getInstance();
    final userName = sharedprefs.getString(setStringKey);
    if (userName != null) {
      setState(() {
        newName = userName;
      });
    }
  }
}
