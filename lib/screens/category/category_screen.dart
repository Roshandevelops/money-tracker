import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:money_tracker/db/category/category_db.dart';
import 'package:money_tracker/models/category/category_model.dart';
import 'package:money_tracker/widgets/app_bar_widget.dart';
import 'package:money_tracker/widgets/bottom_navigationbar_widget.dart';
import 'package:money_tracker/widgets/curved_navigation_bar.dart';
import 'package:money_tracker/widgets/income_expense_radio_button.dart';
import 'package:money_tracker/widgets/text_form_field_widget.dart';

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
    CategoryDB().categoryRefreshUI();
    super.initState();
  }

  int selectedCategoryGroupValue = 1;
  CategoryModel? selectedCategoryModel;
  CategoryType selectedCategoryType = CategoryType.income;

  @override
  Widget build(BuildContext context) {
    final TextEditingController alertBoxController = TextEditingController();
    return Scaffold(
      appBar: const AppBarWidget(
        title: "Categories",
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(
          top: 20,
          left: 20,
          right: 20,
        ),
        child: Column(
          children: [
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
            ValueListenableBuilder(
              valueListenable: (selectedCategoryGroupValue == 1
                  ? CategoryDB.instance.incomeCategoryListListener
                  : CategoryDB.instance.expenseCategoryListListener),
              builder: (context, newList, _) {
                return Expanded(
                  child: newList.isNotEmpty
                      ? GridView.builder(
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                          ),
                          itemBuilder: (ctx, index) {
                            final categoryList = newList[index];
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Stack(children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.grey,
                                  ),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      categoryList.name,
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
                                            title: const Text("Delete Item"),
                                            content: const Text(
                                                "Are you sure,you want to Delete ?"),
                                            actions: [
                                              MaterialButton(
                                                onPressed: () {
                                                  CategoryDB.instance
                                                      .deleteCategory(
                                                          categoryList.id);
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text("Yes"),
                                              ),
                                              MaterialButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text("No"),
                                              )
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    icon: const Icon(Icons.delete),
                                  ),
                                )
                              ]),
                            );
                          },
                          itemCount: newList.length,
                        )
                      : const Center(child: Text("No Categories !")),
                );
              },
            ),
          ],
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
      // bottomNavigationBar: CurvedNavigationWidget()
      // const BottomNavigationbarWidget(),
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
                          // ScaffoldMessenger.of(context).showSnackBar(
                          //   const SnackBar(
                          //     duration: Duration(seconds: 5),
                          //     padding: EdgeInsets.all(20),
                          //     backgroundColor: Colors.red,
                          //     behavior: SnackBarBehavior.floating,
                          //     content: Align(
                          //         alignment: Alignment.center,
                          //         child: Text("Already Exist")),
                          //   ),
                          // );
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
                      await CategoryDB.instance.insertCategory(category);
                      alertBoxController.clear();

                      if (context.mounted) {
                        Navigator.of(ctx).pop();
                      }
                    },
                    child: Row(
                      children: [
                        const Text("Add Item"),
                        MaterialButton(
                          onPressed: () {
                            Navigator.pop(context);
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
        ? CategoryDB.instance.incomeCategoryListListener.value
        : CategoryDB.instance.expenseCategoryListListener.value;

    for (final category in categoryExist) {
      if (category.name.toLowerCase() == categoryName.toLowerCase()) {
        return true;
      }
    }
    return false;
  }
}
