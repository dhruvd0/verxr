import 'package:flutter/material.dart';
import 'package:verxr/config/theme.dart';
import 'package:verxr/features/dashboard/pages/home/widgets/class_page/class_page.dart';

class ClassTile extends StatelessWidget {
  const ClassTile({Key? key, required this.className}) : super(key: key);
  final String className;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ClassPage(
              className: className,
            ),
          ),
        );
      },
      child: Container(
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
      ),
    );
  }
}
