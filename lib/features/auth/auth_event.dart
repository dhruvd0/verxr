part of 'auth_bloc.dart';

///
@immutable
abstract class AuthEvent {}

///
class LoginEvent extends AuthEvent {
  ///
  final String phone;

  ///
  final String otp;

  ///
  LoginEvent(this.phone, this.otp);
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
