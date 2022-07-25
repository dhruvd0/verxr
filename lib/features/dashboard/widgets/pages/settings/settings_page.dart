import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:verxr/config/common/widgets/rounded_green_button.dart';
import 'package:verxr/features/auth/auth_bloc.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
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
