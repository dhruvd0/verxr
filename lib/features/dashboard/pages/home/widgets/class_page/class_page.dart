import 'package:flutter/material.dart';
import 'package:verxr/config/common/back_button.dart';

import '../../../../../../config/theme.dart';

class ClassPage extends StatelessWidget {
  const ClassPage({Key? key, required this.className}) : super(key: key);

  final String className;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Title(
          color: Colors.white,
          child:
              Text('Class $className', style: getTextTheme(context).headline4),
        ),
        leading: BackIconButton(
          onTap: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
    );
  }
}
