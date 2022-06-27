import 'package:flutter/material.dart';

class BackIconButton extends StatelessWidget {
  const BackIconButton({
    Key? key,
    this.onTap,
  }) : super(key: key);
  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(30),
        ),
        child: const Icon(
          Icons.arrow_back_ios_new,
          size: 10,
          color: Colors.black,
        ),
      ),
    );
  }
}
