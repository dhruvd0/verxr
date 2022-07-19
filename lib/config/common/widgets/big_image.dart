import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class BigAnimatedIllustration extends StatelessWidget {
  const BigAnimatedIllustration({
    Key? key,
    required this.asset,
    required this.collapseFactor, required this.height,
  }) : super(key: key);
  final String asset;
  final double collapseFactor;
  final double height;
  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(
      builder: (BuildContext context, bool isKeyboardVisible) {
        return Column(
          children: [
            SizedBox(
              height: 50/collapseFactor,
            ),
            AnimatedContainer(
              curve: Curves.easeIn,
              duration: Duration(milliseconds: 200),
              height: isKeyboardVisible
                  ? MediaQuery.of(context).size.height * (height/collapseFactor) / 830
                  : MediaQuery.of(context).size.height * height / 830,
              child: Image.asset(asset,key: ValueKey(asset),),
            ),
          ],
        );
      },
    );
  }
}
