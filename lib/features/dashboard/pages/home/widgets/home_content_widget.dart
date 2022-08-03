import 'package:flutter/material.dart';
import 'package:verxr/features/dashboard/pages/home/widgets/class_tile_widget.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 13,
      ),
      child: ListView(
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        children: ([5, 6, 7, 8, 9, 10, 11, 12]
                    .map((int e) => ClassTile(className: e.toString()))
                as Iterable<Widget>)
            .toList(),
      ),
    );
  }
}
