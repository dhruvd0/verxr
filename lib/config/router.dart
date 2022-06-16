import 'package:flutter/material.dart';
import 'package:verxr/features/auth/widgets/phone_auth/phone_auth.dart';
import 'package:verxr/features/registration/widgets/registration_page.dart';

Route onGenerateRoute(RouteSettings settings) {
  String name = settings.name ?? '';
  Widget widget = Container();
  switch (name) {
    case PhoneAuthPage.routeName:
      widget = PhoneAuthPage();
      break;
    case RegistrationPage.routeName:
      widget = const RegistrationPage();
      break;
    default:
  }

  return MaterialPageRoute(builder: (_) => widget);
}
