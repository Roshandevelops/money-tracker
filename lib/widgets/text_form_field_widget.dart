import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFormFieldWidget extends StatelessWidget {
  const TextFormFieldWidget(
      {super.key,
      required this.textController,
      this.hintText,
      this.suffixIcon,
      this.enabled,
      this.prefixIcon,
      this.readOnly,
      this.keyboardType,
      this.initialValue,
      this.onChanged,
      this.validator,
      this.inputFormatters,
      this.textStyle});

  final TextEditingController textController;
  final String? hintText;
  final Widget? suffixIcon;
  final bool? enabled;
  final Widget? prefixIcon;
  final bool? readOnly;
  final TextInputType? keyboardType;
  final String? initialValue;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: TextFormField(
        inputFormatters: inputFormatters,
        validator: validator,
        onChanged: onChanged,
        keyboardType: keyboardType,
        readOnly: false,
        enabled: enabled,
        controller: textController,
        decoration: InputDecoration(
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          hintText: hintText,
          hintStyle: textStyle,
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
