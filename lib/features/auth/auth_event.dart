// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'auth_bloc.dart';

///
@immutable
abstract class AuthEvent {}

///
class PhoneLoginEvent extends AuthEvent {
  ///
  final String phone;

  ///
  final String otp;

  ///
  PhoneLoginEvent(this.phone, this.otp);
}

///
class EmailLoginEvent extends AuthEvent {
  ///
  final String email;

  ///
  final String password;
  EmailLoginEvent({
    required this.email,
    required this.password,
  });

  ///

}

///
class VerifyPhoneEvent extends AuthEvent {
  final String phone;
  VerifyPhoneEvent(this.phone);
}

///
class CheckLoginEvent extends AuthEvent {}

///
class LogOutEvent extends AuthEvent {}
