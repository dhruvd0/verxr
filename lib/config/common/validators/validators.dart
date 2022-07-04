import 'package:regexed_validator/regexed_validator.dart';

String? passwordValidator(String? s) {
  return (s??'').isNotEmpty ? null : 'Password is required';
}

String? emailValidator(String? s) {
  return validator.email(s ?? '') ? null : 'Invalid Email';
}

String? phoneValidator(String? s) {
  return validator.phone(s ?? '') && (s ?? '').length == 10
      ? null
      : 'Invalid Phone';
}

String? nameValidator(String? s) {
  return validator.name(s ?? '') ? null : 'Invalid Name';
}

String? otpValidator(String? s) {
  return s != null && s.length == 6 && int.tryParse(s) != null
      ? null
      : 'Invalid OTP';
}
