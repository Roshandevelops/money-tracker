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
      this.amount});

  final String? purposeText;
  final String? descriptionText;
  final DateTime? dateTime;
  final IconData? iconData;
  final num? amount;
  final Color? iconColor;
  @override
  Widget build(BuildContext context) {
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
                style: AppTextStyle.body2,
              ),
            ),
            Text(
              amount.toString(),
              style: AppTextStyle.body3,
            ),
          ],
        ),
      ),
    );
  }
}
