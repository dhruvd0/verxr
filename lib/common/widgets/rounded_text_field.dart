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
    this.textAlign,
    this.maxLength,
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
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 53,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: const EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.lightGray()),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextFormField(
        controller: controller,
        onChanged: onChanged,
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
