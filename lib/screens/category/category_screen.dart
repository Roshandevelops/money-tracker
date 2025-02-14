import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:money_tracker/db/category/category_db.dart';
import 'package:money_tracker/db/transaction/transaction_db.dart';
import 'package:money_tracker/models/category/category_model.dart';
import 'package:money_tracker/provider/category_provider.dart';
import 'package:money_tracker/theme/app_text_style.dart';
import 'package:money_tracker/widgets/app_bar_widget.dart';
import 'package:money_tracker/widgets/income_expense_radio_button.dart';
import 'package:money_tracker/widgets/text_form_field_widget.dart';
import 'package:provider/provider.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({
    super.key,
  });

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  void initState() {
    Provider.of<CategoryProvider>(context, listen: false).refreshCategory();
    super.initState();
  }

  int selectedCategoryGroupValue = 1;
  CategoryModel? selectedCategoryModel;
  CategoryType selectedCategoryType = CategoryType.income;

  @override
  Widget build(BuildContext context) {
    final TextEditingController alertBoxController = TextEditingController();
    return Scaffold(
      appBar: const AppBarWidget(title: "Categories"),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(
          top: 20,
          left: 20,
          right: 20,
        ),
        child: Column(children: [
          IncomeExpenseRadioButton(
            groupValue: selectedCategoryGroupValue,
            onChanged: (groupValue) {
              setState(
                () {
                  selectedCategoryGroupValue = groupValue!;
                },
              );
            },
          ),
          const SizedBox(
            height: 30,
          ),
          Consumer<CategoryProvider>(
            builder: (context, categoryConsumer, child) {
              final newCategoryList = selectedCategoryGroupValue == 1
                  ? categoryConsumer.incomeCategoryList
                  : categoryConsumer.expenseCategoryList;
              log(newCategoryList.toString());
              return Expanded(
                child: newCategoryList.isNotEmpty
                    ? GridView.builder(
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                        ),
                        itemBuilder: (ctx, index) {
                          final categoryList = newCategoryList[index];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Stack(children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: const Color(0xFF0B1C3B),
                                ),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    categoryList.name,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: -5,
                                right: -5,
                                child: IconButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (ctx) {
                                        return AlertDialog(
                                          backgroundColor: Colors.white,
                                          title: const Text("Delete Item !"),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                "Are you sure ?",
                                                style: AppTextStyle.body1,
                                              ),
                                              const Text(
                                                  "Do you want to Delete ?")
                                            ],
                                          ),
                                          actions: [
                                            MaterialButton(
                                              onPressed: () async {
                                                bool hasTransaction =
                                                    await checkIfCategoryHasTransactions(
                                                        categoryList.id);
                                                if (hasTransaction) {
                                                  if (context.mounted) {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                        showCloseIcon: true,
                                                        duration:
                                                            const Duration(
                                                                seconds: 4),
                                                        backgroundColor:
                                                            const Color
                                                                .fromARGB(255,
                                                                46, 45, 45),
                                                        content: Column(
                                                          children: [
                                                            Text(
                                                              "Can't delete    '${categoryList.name}' ",
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          18),
                                                            ),
                                                            Text(
                                                                "Delete  '${categoryList.name}'  transaction first !!")
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  }

                                                  if (ctx.mounted) {
                                                    Navigator.of(ctx).pop();
                                                    return;
                                                  }
                                                }

                                                if (ctx.mounted) {
                                                  await Provider.of<
                                                              CategoryProvider>(
                                                          ctx,
                                                          listen: false)
                                                      .deleteCategoryProvider(
                                                          categoryList.id);

                                                  if (ctx.mounted) {
                                                    Navigator.of(ctx).pop();
                                                  }
                                                }
                                              },
                                              child: const Text("Yes"),
                                            ),
                                            MaterialButton(
                                              onPressed: () {
                                                Navigator.pop(ctx);
                                              },
                                              child: const Text("No"),
                                            )
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Color(0xFFC8C5C5),
                                  ),
                                ),
                              )
                            ]),
                          );
                        },
                        itemCount: newCategoryList.length,
                      )
                    : const Center(
                        child: Text("No Categories !"),
                      ),
              );
            },
          )
        ]
            //   },
            // ),

            ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF0B1C3B),
        onPressed: () {
          showDialogueBox(context, alertBoxController,
              selectedCategoryGroupValue == 1 ? "Add Income" : "Add Expense");
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  void showDialogueBox(BuildContext context,
      TextEditingController alertBoxController, String title) {
    showDialog(
      context: context,
      builder: (ctx) {
        String errorMessage = '';
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text(title),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormFieldWidget(
                  inputFormatters: [LengthLimitingTextInputFormatter(15)],
                  textController: alertBoxController,
                  hintText: "Add Item",
                ),
                if (errorMessage.isNotEmpty)
                  Text(
                    errorMessage,
                    style: const TextStyle(color: Colors.red, fontSize: 18),
                  ),
              ],
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MaterialButton(
                    onPressed: () async {
                      final alertController = alertBoxController.text;

                      if (alertController.isEmpty) {
                        return;
                      }
                      bool isCategoryExist =
                          await checkIfCatgoryExists(alertController);

                      if (isCategoryExist) {
                        if (context.mounted) {
                          setState(
                            () {
                              errorMessage =
                                  "Category   '$alertController'   already exists!";
                            },
                          );
                        }

                        return;
                      }

                      final type = selectedCategoryGroupValue == 1
                          ? CategoryType.income
                          : CategoryType.expense;
                      final category = CategoryModel(
                        name: alertController,
                        type: type,
                        id: DateTime.now().microsecondsSinceEpoch.toString(),
                      );
                      if (context.mounted) {
                        await Provider.of<CategoryProvider>(context,
                                listen: false)
                            .insertCategoryProvider(category);
                      }

                      alertBoxController.clear();

                      if (context.mounted) {
                        Provider.of<CategoryProvider>(context, listen: false)
                            .refreshCategory();

                        Navigator.of(ctx).pop();
                      }
                    },
                    child: Row(
                      children: [
                        const Text("Add Item"),
                        MaterialButton(
                          onPressed: () {
                            if (context.mounted) {
                              Navigator.pop(context);
                            }

                            alertBoxController.clear();
                          },
                          child: const Text("Cancel"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        });
      },
    );
  }

  Future<bool> checkIfCatgoryExists(String categoryName) async {
    final categoryExist = selectedCategoryGroupValue == 1
        ? Provider.of<CategoryProvider>(context, listen: false)
            .incomeCategoryList
        : Provider.of<CategoryProvider>(context, listen: false)
            .expenseCategoryList;

    for (final category in categoryExist) {
      if (category.name.toLowerCase() == categoryName.toLowerCase()) {
        return true;
      }
    }
    return false;
  }

  Future<bool> checkIfCategoryHasTransactions(String categoryId) async {
    final transactions = await TransactionDB.instance.getAllTransactions();
    return transactions
        .any((transaction) => transaction.categoryModel.id == categoryId);
  }
}
