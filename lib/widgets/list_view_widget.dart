import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_tracker/theme/app_text_style.dart';

class TransactionCardWidget extends StatelessWidget {
  const TransactionCardWidget(
      {super.key,
      this.purposeText,
      this.descriptionText,
      this.iconData,
      this.dateTime,
      this.iconColor,
      // this.onPressed,
      this.amount});

  final String? purposeText;
  final String? descriptionText;
  final DateTime? dateTime;
  final IconData? iconData;
  final num? amount;
  final Color? iconColor;

  // final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    // log(DateTime.now().toString());
    return Card(
      color: Colors.white,
      shadowColor: Colors.black,
      elevation: 5,
      child: ListTile(
        leading: Icon(iconData, color: iconColor),
        title: Row(
          children: [
            Text(purposeText!, style: AppTextStyle.body1),
            Text(
              descriptionText!,
              style: AppTextStyle.body2,
            ),
          ],
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                DateFormat('MMM dd,yyyy').format(
                  dateTime!,
                ),
                // amount.toString(),
                style: AppTextStyle.body2,
              ),
            ),
            // Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // children: [
            // Text(
            //   DateFormat('MMM dd,yyyy').format(
            //     dateTime,
            //   ),
            //   style: AppTextStyle.body3,
            // ),

            // IconButton(
            //   onPressed: () {
            //     Navigator.of(context).push(
            //       MaterialPageRoute(
            //         builder: (ctx) {
            //           return const AddTransactionScreen();
            //         },
            //       ),
            //     );
            //   },
            //   icon: const Icon(
            //     Icons.edit,
            //     color: Colors.green,
            //   ),
            // ),
            // ],
            // ),
            Text(
              amount.toString(),
              style: AppTextStyle.body3,
            ),
          ],
        ),
        // trailing: Column(
        //   children: [
        //     Text(
        //       DateFormat('hh: mm,a').format(
        //         dateTime,
        //       ),
        //       style: AppTextStyle.body2,
        //     ),
        //     Expanded(
        //       child: IconButton(
        //         onPressed: () {
        //           deleteItem(context);
        //         },
        //         icon: const Icon(Icons.delete, color: Colors.red),
        //       ),
        //     ),
        //   ],
        // ),
      ),
    );
  }

  // void deleteItem(context) {
  //   showDialog(
  //     context: context,
  //     builder: (ctx) {
  //       return AlertDialog(
  //         backgroundColor: Colors.white,
  //         title: const Text("Delete Item"),
  //         content: const Text("Are you sure, Do you want to delete ?"),
  //         actions: [
  //           MaterialButton(
  //             onPressed: () {
  //               //  onPressed,
  //             },
  //             child: const Text("Yes"),
  //           ),
  //           MaterialButton(
  //             onPressed: () {
  //               Navigator.pop(context);
  //             },
  //             child: const Text("No"),
  //           )
  //         ],
  //       );
  //     },
  //   );
  // }
}
