import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RoundedTextField extends StatelessWidget {
  RoundedTextField({
    Key? key,
    required this.hintText,
    this.textInputType,
    this.onChanged,
    this.controller,
  }) : super(key: key) {
    assert(onChanged != null || controller != null);
  }
  final String hintText;
  final TextInputType? textInputType;
  final Function(String)? onChanged;
  final TextEditingController? controller;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 53,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        keyboardType: textInputType,
        inputFormatters: textInputType == TextInputType.phone
            ? [LengthLimitingTextInputFormatter(10)]
            : null,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
        ),
      ),
    );
  }
}
