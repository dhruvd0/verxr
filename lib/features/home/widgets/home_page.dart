import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:verxr/common/widgets/rounded_green_button.dart';
import 'package:verxr/features/auth/auth_bloc.dart';
import 'package:verxr/features/auth/widgets/email_login_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  static const String routeName = 'homePage';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is LogOutAuthState) {
            Navigator.pushReplacementNamed(context, EmailLoginPage.routeName);
          }
        },
        child: Center(
          child: RoundedTextButton(
            text: 'Logout',
            onTap: () {
              BlocProvider.of<AuthBloc>(context).add(LogOutEvent());
            },
          ),
        ),
      ),
    );
  }
}
