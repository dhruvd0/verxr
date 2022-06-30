import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:verxr/common/dio.dart';
import 'package:verxr/constants/profile_fields.dart';
import 'package:verxr/constants/user_types.dart';
import 'package:verxr/features/auth/auth_bloc.dart';
import 'package:verxr/models/profile/individual.dart';
import 'package:verxr/models/profile/profile.dart';

part 'profile_event.dart';
part 'profile_state.dart';

/// State management, to create,edit and fetch profile
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AuthBloc authBloc;

  ///
  ProfileBloc(this.authBloc) : super(ProfileInitial()) {
    on<ChangeProfileEvent>(_onChangeProfile);
    on<EditNewProfileEvent>(
      _onEditNewProfile,
    );
    on<GetProfileEvent>(_onGetProfile);
    on<RegisterProfileEvent>(registerProfile);
  }
  Future<void> registerProfile(
    RegisterProfileEvent event,
    Emitter emit,
  ) async {
    try {
      final profile = event.profile;
      if (authBloc.firebaseAuth is! MockFirebaseAuth) {
        final credential = EmailAuthProvider.credential(
          email: profile.email,
          password: profile.password,
        );

        await authBloc.firebaseAuth.currentUser!.linkWithCredential(credential);
      }
      var map = profile.toMap();
      log(jsonEncode(map));
      var formData = FormData.fromMap(map);
      final response = await dio.post('/register', data: formData);
      if (response.statusCode != 200) {
        emit(ProfileErrorState(jsonDecode(response.data)['message']));
        return;
      }
      emit(FetchedProfileState(profile));
    } on FirebaseAuthException catch (e) {
      emit(ProfileErrorState(e.message.toString()));
    } on DioError catch (e) {
      emit(ProfileErrorState(e.message));
    }
  }

  void _onEditNewProfile(event, Emitter emit) {
    emit(EditProfileState(Profile.fromMap(event.userType, const {})));
    assert(state is EditProfileState);
  }

  void _onChangeProfile(
    ChangeProfileEvent changeProfileEvent,
    Emitter emit,
  ) {
    assert(state is EditProfileState);
    var createProfileState = state as EditProfileState;
    var profile = createProfileState.profile;
    var map = profile.toMap();
    var key = changeProfileEvent.field.name;
    map[key] = changeProfileEvent.value;
    profile = Profile.fromMap(
      changeProfileEvent.value is UserType
          ? changeProfileEvent.value
          : profile.userType,
      map,
    );
    emit(EditProfileState(profile));
  }

  FutureOr<void> _onGetProfile(
    GetProfileEvent event,
    Emitter<ProfileState> emit,
  ) {
    /// TODO: call get profile api here
    ///

    emit(EditProfileState(IndividualProfile.fromMap(const {})));
  }
}
