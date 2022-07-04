import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:verxr/config/theme.dart';

class RoundedTextField extends StatelessWidget {
  RoundedTextField({
    Key? key,
    required this.hintText,
    this.textInputType,
    this.onChanged,
    this.controller,
    this.obscureText,
    this.isEnabled,
    this.textAlign,
    this.maxLength,
    this.borderColor,
    required this.validator,
  }) : super(key: key) {
    assert(onChanged != null || controller != null);
  }
  final String hintText;
  final TextInputType? textInputType;
  final Function(String)? onChanged;
  final int? maxLength;
  final TextAlign? textAlign;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool? isEnabled;
  final Color? borderColor;
  final bool? obscureText;
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 60, minHeight: 53),
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: const EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        border: Border.all(color: borderColor ?? AppColors.lightGray()),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextFormField(
        controller: controller,
        scrollPadding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom +
              (getTextTheme(context).bodyText2!.fontSize! * 4),
        ),
        onChanged: onChanged,
        obscureText: obscureText??false,
        enabled: isEnabled ?? true,
        validator: validator,
        style: getTextTheme(context).bodyText2!.copyWith(color: Colors.black),
        textAlign: textAlign ?? TextAlign.left,
        keyboardType: textInputType,
        inputFormatters: textInputType == TextInputType.phone
            ? [LengthLimitingTextInputFormatter(maxLength ?? 10)]
            : null,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: getTextTheme(context).bodyText2,
        ),
      ),
    );
  }
}
