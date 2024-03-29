import 'package:flutter/material.dart';
import 'package:verxr/features/auth/widgets/phone_auth/phone_auth_page.dart';
import 'package:verxr/features/auth/widgets/email_login_page.dart';
import 'package:verxr/features/dashboard/widgets/dashboard_page.dart';
import 'package:verxr/features/registration/widgets/registration_page.dart';
import 'package:verxr/main.dart';

Route onGenerateRoute(RouteSettings settings) {
  String name = settings.name ?? '';
  Widget widget = Container();
  switch (name) {
    case PhoneAuthPage.routeName:
      widget = PhoneAuthPage();
      break;
    case EmailLoginPage.routeName:
      widget = EmailLoginPage();
      break;
    case DashboardPage.routeName:
      widget = const DashboardPage();
      break;
    case Splash.routeName:
      widget = const Splash();
      break;
    case RegistrationPage.routeName:
      widget = RegistrationPage();
      break;
    default:
  }

  return MaterialPageRoute(builder: (_) => widget);
}
