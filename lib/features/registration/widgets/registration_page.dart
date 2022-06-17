import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:verxr/common/widgets/rounded_green_button.dart';
import 'package:verxr/features/auth/auth_bloc.dart';
import 'package:verxr/main.dart';

class RegistrationPage extends StatelessWidget {
  const RegistrationPage({Key? key}) : super(key: key);
  static const String routeName = 'registrationPage';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is LogOutAuthState) {
            Navigator.pushReplacementNamed(context, Splash.routeName);
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