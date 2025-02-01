import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:money_tracker/db/category/category_db.dart';
import 'package:money_tracker/db/transaction/transaction_db.dart';
import 'package:money_tracker/main.dart';
import 'package:money_tracker/models/category/category_model.dart';
import 'package:money_tracker/models/transaction/transaction_model.dart';
import 'package:money_tracker/screens/transactions/add_transaction/add_transaction.dart';
import 'package:money_tracker/screens/transactions/view_transactions/transactions.dart';
import 'package:money_tracker/theme/app_text_style.dart';
import 'package:money_tracker/widgets/app_bar_widget.dart';
import 'package:money_tracker/widgets/bottom_navigationbar_widget.dart';
import 'package:money_tracker/widgets/curved_navigation_bar.dart';
import 'package:money_tracker/widgets/edit_screen.dart';
import 'package:money_tracker/widgets/list_view_widget.dart';
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
    showString();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TransactionDB.instance.transactionRefreshUI();
    CategoryDB.instance.categoryRefreshUI();
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
              ValueListenableBuilder(
                valueListenable: TransactionDB.instance.transactionListNotifier,
                builder:
                    (BuildContext context, List<TransactionModel> newList, _) {
                  return Expanded(
                      child: newList.isNotEmpty
                          ? ListView.builder(
                              itemCount:
                                  newList.length >= 4 ? 4 : newList.length,
                              itemBuilder: (ctx, index) {
                                final data = newList[index];
                                return Slidable(
                                  key: Key(data.id!),
                                  endActionPane: ActionPane(
                                    motion: const DrawerMotion(),
                                    children: [
                                      SlidableAction(
                                        onPressed: (ctx) {
                                          log("sample edit");
                                          editTransaction(
                                            newList[index],
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
                              })
                          : const Center(child: Text("No Transactions !")));
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
      // bottomNavigationBar: CurvedNavigationWidget()
      // const BottomNavigationbarWidget(),
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
        return AlertDialog(
          title: const Text("Edit !"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Are you sure ?",
                style: AppTextStyle.body1,
              ),
              const Text("Do you want to edit ?"),
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
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
                  child: const Text(
                    "Yes",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    "No",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  void deleteTransaction(BuildContext context, TransactionModel model) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("Delete !"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Are you sure ?",
                style: AppTextStyle.body1,
              ),
              const Text("Do you want to Delete ?")
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () async {
                    await TransactionDB.instance.deleteTransaction(model);
                    if (ctx.mounted) {
                      Navigator.of(ctx).pop();
                    }
                  },
                  child: const Text(
                    "Yes",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: const Text(
                    "No",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            )
          ],
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
