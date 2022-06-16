// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:verxr/config/theme.dart';

class RoundedTextButton extends StatelessWidget {
  RoundedTextButton({
    Key? key,
    required this.text,
    required this.onTap,
  }) : super(key: key);
  final String text;
  final Function() onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 53,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.all(20),
        padding: EdgeInsets.only(left: 10),
        decoration: BoxDecoration(
            color: AppColors.primaryGreen(),
            border: Border.all(color: AppColors.primaryGreen()),
            borderRadius: BorderRadius.circular(16)),
        child: Center(
          child: Text(
            text,
            style: getTextTheme(context).button,
          ),
        ),
      ),
    );
  }
}
