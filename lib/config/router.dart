import 'package:flutter/material.dart';
import 'package:verxr/features/auth/widgets/phone_auth/phone_auth.dart';

Route onGenerateRoute(RouteSettings settings) {
  String name = settings.name ?? '';
  Widget widget = Container();
  switch (name) {
    case PhoneAuthPage.routeName:
      widget = PhoneAuthPage();
      break;
    default:
  }

  return MaterialPageRoute(builder: (_) => widget);
}
