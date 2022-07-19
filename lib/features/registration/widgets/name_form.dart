import 'package:flutter/material.dart';
import 'package:verxr/config/common/validators/validators.dart';
import 'package:verxr/config/common/widgets/rounded_text_field.dart';

class NameForm extends StatelessWidget {
  const NameForm({
    Key? key,
    required this.firstNameController,
    required this.middleNameController,
    required this.lastNameController,
  }) : super(key: key);
  final TextEditingController firstNameController;
  final TextEditingController middleNameController;
  final TextEditingController lastNameController;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RoundedTextField(
          controller: firstNameController,
          hintText: 'First Name',
          validator: (string) {
            return nameValidator(string);
          },
        ),
        RoundedTextField(
          controller: middleNameController,
          hintText: 'Middle Name',
          validator: (string) {
            return null;
          },
        ),
        RoundedTextField(
          controller: lastNameController,
          hintText: 'Last Name',
          validator: (string) {
            return nameValidator(string);
          },
        ),
      ],
    );
  }
}
