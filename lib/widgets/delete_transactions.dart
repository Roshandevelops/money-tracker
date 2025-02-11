// import 'package:flutter/material.dart';
// import 'package:money_tracker/models/transaction/transaction_model.dart';
// import 'package:money_tracker/provider/transaction_provider.dart';
// import 'package:money_tracker/theme/app_text_style.dart';
// import 'package:provider/provider.dart';

// class HelloVasu {
//   void deleteTransaction(BuildContext context, TransactionModel model) {
//     showDialog(
//       context: context,
//       builder: (ctx) {
//         return AlertDialog(
//           title: const Text("Delete !"),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 "Are you sure ?",
//                 style: AppTextStyle.body1,
//               ),
//               const Text("Do you want to Delete ?")
//             ],
//           ),
//           actions: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 TextButton(
//                   onPressed: () async {
//                     Provider.of<TransactionProvider>(ctx, listen: false)
//                         .deleteTransactionProvider(model);

//                     if (ctx.mounted) {
//                       Navigator.of(ctx).pop();
//                     }
//                   },
//                   child: const Text(
//                     "Yes",
//                     style: TextStyle(color: Colors.black),
//                   ),
//                 ),
//                 TextButton(
//                   onPressed: () {
//                     Navigator.of(ctx).pop();
//                   },
//                   child: const Text(
//                     "No",
//                     style: TextStyle(color: Colors.black),
//                   ),
//                 ),
//               ],
//             )
//           ],
//         );
//       },
//     );
//   }
// }
