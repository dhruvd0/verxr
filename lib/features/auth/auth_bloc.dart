import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/foundation.dart';

part 'auth_event.dart';
part 'auth_state.dart';

/// Bloc to handle phone/otp login, logout and handle auth state changes
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  ///
  AuthBloc() : super(AuthState()) {
    on<LoginEvent>(_loginWithOtp);
    on<CheckLoginEvent>(_onCheckLogin);
    on<LogOutEvent>(_onLogOut);
    on<VerifyPhoneEvent>(_verifyPhoneNumber);
  }

  Future<void> _verifyPhoneNumber(
    VerifyPhoneEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(LoadingAuthState());
    try {
      /// See why there is a completer:
      ///
      /// https://github.com/felangel/bloc/issues/2961#issuecomment-1025144654
      Completer<AuthState> c = Completer<AuthState>();

      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: '+91${event.phone}',
        // ignore: no-empty-block
        verificationCompleted: (credential) {},
        verificationFailed: (authException) {
          c.complete(FailureAuthState(authException.code));
        },
        codeSent: (String verificationId, _) {
          c.complete(CodeSentState(verificationId));
        },
        // ignore: no-empty-block
        codeAutoRetrievalTimeout: (_) {},
      );
      final stateToReturn = await c.future;
      emit(stateToReturn);
    } on Exception catch (e) {
      emit(FailureAuthState(e.toString()));
    }
  }

  Future<void> _loginWithOtp(LoginEvent event, Emitter<AuthState> emit) async {
    try {
      assert(state is CodeSentState);

      try {
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: (state as CodeSentState).verificationId,
          smsCode: event.otp,
        );
        emit(LoadingAuthState());

        await _firebaseAuth.signInWithCredential(credential);
        emit(SuccessAuthState());
      } on FirebaseAuthException catch (e) {
        emit(FailureAuthState(e.code));
        rethrow;
      }
    } catch (e) {
      emit(FailureAuthState(e.toString()));
      rethrow;
    }
  }

  Future<void> _onCheckLogin(
    CheckLoginEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(LoadingAuthState());
      if (_firebaseAuth.currentUser != null) {
        emit(SuccessAuthState());
      } else {
        emit(LogOutAuthState());
      }
    } catch (e) {
      emit(FailureAuthState(e.toString()));
      rethrow;
    }
  }

  Future<void> _onLogOut(LogOutEvent event, Emitter<AuthState> emit) async {
    emit(LogOutAuthState());
  }
}
