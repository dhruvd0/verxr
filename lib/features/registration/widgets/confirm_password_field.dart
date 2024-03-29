import 'package:flutter/material.dart';
import 'package:verxr/config/common/validators/validators.dart';
import 'package:verxr/config/common/widgets/rounded_text_field.dart';

class ConfirmPasswordField extends StatelessWidget {
  const ConfirmPasswordField({
    Key? key,
    required this.confirmPasswordController,
    required this.passwordController,
  }) : super(key: key);
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RoundedTextField(
          key: const ValueKey('password-text-field'),
          controller: passwordController,
          obscureText: true,
          hintText: 'Password',
          validator: (string) {
            return passwordValidator(string);
          },
        ),
        RoundedTextField(
          key: const ValueKey('confirm-password-text-field'),
          controller: confirmPasswordController,
          obscureText: true,
          hintText: 'Confirm Password',
          validator: (string) {
            return passwordValidator(string);
          },
        ),
      ],
    );
  }
}
