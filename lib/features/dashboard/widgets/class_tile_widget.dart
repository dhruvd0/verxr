import 'package:flutter/material.dart';
import 'package:verxr/config/theme.dart';

class ClassTile extends StatelessWidget {
  const ClassTile({Key? key, required this.className}) : super(key: key);
  final String className;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16)
          .copyWith(top: 38, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Class $className",
            style: getTextTheme(context).headline4,
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            "Class Description",
            style: getTextTheme(context).bodyText2,
          ),
        ],
      ),
    );
  }
}
