import 'package:regexed_validator/regexed_validator.dart';

String? passwordValidator(String? s) {
  return validator.mediumPassword(s ?? '')
      ? null
      : 'Create a stronger password';
}

String? emailValidator(String? s) {
  return validator.email(s ?? '') ? null : 'Invalid Email';
}

String? phoneValidator(String? s) {
  return validator.phone(s ?? '') ? null : 'Invalid Phone';
}

String? nameValidator(String? s) {
  return validator.name(s ?? '') ? null : 'Invalid Name';
}

String? otpValidator(String? s) {
  return s != null && s.length == 6 && int.tryParse(s) != null
      ? null
      : 'Invalid OTP';
}
