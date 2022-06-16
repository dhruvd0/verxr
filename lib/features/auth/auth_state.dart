part of 'auth_bloc.dart';

@immutable
class AuthState {}

class LoadingAuthState extends AuthState {}

class CodeSentState extends AuthState {
  final String verificationId;
  CodeSentState(
    this.verificationId,
  );
}

class SuccessAuthState extends AuthState {}

class LogOutAuthState extends AuthState {}

class FailureAuthState extends AuthState {
  final Object error;
  FailureAuthState(this.error);
}
