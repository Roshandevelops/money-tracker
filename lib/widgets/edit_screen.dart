import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:money_tracker/db/transaction/transaction_db.dart';
import 'package:money_tracker/models/category/category_model.dart';
import 'package:money_tracker/models/transaction/transaction_model.dart';
import 'package:money_tracker/provider/transaction_provider.dart';
import 'package:money_tracker/screens/transactions/add_transaction/widget/dropdown_widget.dart.dart';

import 'package:money_tracker/widgets/app_bar_widget.dart';
import 'package:money_tracker/widgets/button_widget.dart';
import 'package:money_tracker/widgets/income_expense_radio_button.dart';
import 'package:money_tracker/widgets/text_form_field_widget.dart';
import 'package:provider/provider.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({
    super.key,
    required this.transactionModel,
  });
  final TransactionModel transactionModel;

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  int selectedCategoryGroupValue = 1;

  CategoryType? selectedTransactionCategrory;

  final TextEditingController descriptionController = TextEditingController();

  final TextEditingController amountController = TextEditingController();

  final TextEditingController dateController = TextEditingController();

  DateTime? selectedDate;
  String? categoryId;
  CategoryModel? selectedCategoryModel;

  @override
  void initState() {
    categoryId = widget.transactionModel.categoryModel.id;
    descriptionController.text = widget.transactionModel.description;
    amountController.text = widget.transactionModel.amount.toString();
    dateController.text =
        widget.transactionModel.dateTime.toString().split(" ")[0];
    selectedDate = widget.transactionModel.dateTime;

    setState(() {
      selectedCategoryModel = widget.transactionModel.categoryModel;
      log("checking ${widget.transactionModel.categoryModel.type}");
    });

    selectedCategoryModel?.type == CategoryType.income
        ? selectedCategoryGroupValue = 1
        : selectedCategoryGroupValue = 2;

    selectedTransactionCategrory == CategoryType.income
        ? selectedCategoryGroupValue == 1
        : selectedCategoryGroupValue == 2;

    super.initState();
  }

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    log(selectedCategoryModel!.name);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AppBarWidget(
        title: "Edit Transaction",
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  IncomeExpenseRadioButton(
                    groupValue: selectedCategoryGroupValue,
                    onChanged: (groupValue) {
                      setState(() {
                        categoryId = null;
                        selectedCategoryGroupValue = groupValue!;
                        log(categoryId.toString());
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  DropDownWidget(
                    validator: (p0) {
                      if (categoryId == null || categoryId!.isEmpty) {
                        return "Choose Category";
                      }
                      return null;
                    },
                    selectedCategoryItem: categoryId,
                    selectedCategoryType: selectedCategoryGroupValue == 1
                        ? CategoryType.income
                        : CategoryType.expense,
                    onChanged: (newValue) {
                      setState(() {
                        categoryId = newValue;

                        log(categoryId.toString());
                      });
                    },
                    onMenuItemTap: (categoryItem) {
                      selectedCategoryModel = categoryItem;
                      log(selectedCategoryModel.toString());
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormFieldWidget(
                      inputFormatters: [LengthLimitingTextInputFormatter(20)],
                      validator: (p0) {
                        if (descriptionController.text.isNotEmpty) {
                          log("Description data matching");
                          return null;
                        } else {
                          log("description Data not matching");
                          return "Field Required";
                        }
                      },
                      textController: descriptionController,
                      hintText: "Description"),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormFieldWidget(
                      validator: (p0) {
                        if (amountController.text.isNotEmpty) {
                          log("Amount data matching");
                          return null;
                        } else {
                          log("Amount Data not matching");
                          return "Field Required";
                        }
                      },
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(8)
                      ],
                      textController: amountController,
                      hintText: "Amount"),
                  const SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () async {
                      await selectDate(context);
                    },
                    child: TextFormFieldWidget(
                        validator: (p0) {
                          if (dateController.text.isNotEmpty) {
                            return null;
                          } else {
                            return "Field Required";
                          }
                        },
                        suffixIcon: const Icon(Icons.calendar_month),
                        textController: dateController,
                        enabled: false,
                        hintText: " Select Date"),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ButtonWidget(
                    color: const Color(0xFF0B1C3B),
                    text: "Update",
                    onTap: () {
                      if (formKey.currentState!.validate()) {
                        setState(() {
                          editScreenTransaction(widget.transactionModel);
                        });
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
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
        dateController.text = datePicked.toString().split(" ")[0];
        selectedDate = datePicked;
      });
    }
  }

  Future<void> editScreenTransaction(
      TransactionModel oldTransactionModel) async {
    final descriptionText = descriptionController.text;
    final amountText = amountController.text;

    // if (categoryId == null) {
    //   return;
    // }

    // if (selectedCategoryModel == null) {
    //   return;
    // }
    // if (descriptionText.isEmpty) {
    //   return;
    // }
    // if (amountText.isEmpty) {
    //   return;
    // }

    final amountParsed = double.tryParse(amountText);
    if (amountParsed == null) {
      return;
    }

    // if (selectedDate == null) {
    //   return;
    // }
    final newTransaction = TransactionModel(
        type: selectedCategoryGroupValue == 1
            ? CategoryType.income
            : CategoryType.expense,
        categoryModel: selectedCategoryModel!,
        description: descriptionText,
        amount: amountParsed,
        dateTime: selectedDate!);

    await Provider.of<TransactionProvider>(context, listen: false)
        .editTransactionProvider(newTransaction, oldTransactionModel);

    // await TransactionDB.instance
    //     .editTransactionsSample(newTransaction, oldTransactionModel);
  }
}
