import 'package:flutter/material.dart';
import 'package:verxr/features/home/widgets/class_tile_widget.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 13,),
      child: ListView(
        shrinkWrap: true,
        children: [5, 6, 7, 8, 9, 10]
            .map((e) => ClassTile(className: e.toString()))
            .toList(),
      ),
    );
  }
}
