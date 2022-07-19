import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/foundation.dart';
import 'package:verxr/config/common/dio.dart';
import 'package:verxr/config/common/toast.dart';
import 'package:verxr/constants/profile_fields.dart';
import 'package:verxr/constants/user_types.dart';
import 'package:verxr/features/auth/auth_bloc.dart';
import 'package:verxr/features/registration/controller/profile_api_controller.dart';
import 'package:verxr/models/profile/individual.dart';
import 'package:verxr/models/profile/profile.dart';

part 'profile_event.dart';
part 'profile_state.dart';

/// State management, to create,edit and fetch profile
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AuthBloc authBloc;
  final ProfileAPIController profileAPIController;

  ///
  ProfileBloc(this.authBloc, this.profileAPIController, [ProfileState? state])
      : super(state ?? ProfileInitial()) {
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
      log(profile.toString());
      if (authBloc.firebaseAuth is! MockFirebaseAuth) {
        try {
          final credential = EmailAuthProvider.credential(
            email: profile.email,
            password: event.password,
          );
          emit(ProfileLoadingState());
          await authBloc.firebaseAuth.currentUser!.reload();
          await authBloc.firebaseAuth.currentUser!
              .linkWithCredential(credential);
        } on FirebaseAuthException catch (e) {
          if (e.code != 'provider-already-linked') {
            showToast(e.message.toString());

            emit(EditProfileState(event.profile));
            if (kDebugMode) {
              throw Exception(e.message.toString());
            }
          }
        }
      }
      var map = profile.toMap();
      map['uid'] = authBloc.firebaseAuth.currentUser!.uid;
      map['phone'] = authBloc.firebaseAuth.currentUser!.phoneNumber;
      map.remove('password');
      var response = await profileAPIController.callRegisterAPI(map);
      var responseData = (response.data);
      if (response.statusCode != 200) {
        emit(ProfileErrorState(responseData['error']));
        return;
      }

      emit(FetchedProfileState(profile, responseData['token']));
    } on DioError catch (e) {
      if (e.response != null) {
        if (e.response!.statusCode == 409) {
          showToast('This profile is already registered, welcome back!');
          add(GetProfileEvent(authBloc.firebaseAuth.currentUser!.uid));
          return;
        } else if (e.response!.statusCode == 400) {
          emit(ProfileErrorState(e.response!.data['error']));
        }
      }
      emit(EditProfileState(event.profile));
      showToast(e.message);
    }
  }

  void _onEditNewProfile(EditNewProfileEvent event, Emitter emit) {
    emit(EditProfileState(Profile.fromMap(event.userType.name, const {})));
    assert(state is EditProfileState);
  }

  void _onChangeProfile(
    ChangeProfileEvent changeProfileEvent,
    Emitter emit,
  ) {
    var createProfileState = state is EditProfileState
        ? state as EditProfileState
        : (EditProfileState(IndividualProfile.fromMap(const {})));

    var profile = createProfileState.profile;
    var map = profile.toMap();
    var key = changeProfileEvent.field.name;
    map[key] = changeProfileEvent.value;
    profile = Profile.fromMap(
      changeProfileEvent.value is UserType
          ? (changeProfileEvent.value as UserType).name
          : profile.userType.name,
      map,
    );
    emit(EditProfileState(profile));
  }

  Future<String?> getJWT(Emitter emit) async {
    try {
      final response = await dio.post(
        '/login',
        data: {
          "uid": authBloc.firebaseAuth.currentUser!.uid,
        },
      );

      if (response.statusCode == 200) {
        var body = (response.data);
        return body['token'];
      }
    } on DioError catch (e) {
      log(e.toString());
      emit(ProfileErrorState('Not Registered'));
    }
    return null;
  }

  FutureOr<void> _onGetProfile(
    GetProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(ProfileLoadingState());
      final token = await getJWT(emit);
      if (token == null) {
        emit(ProfileErrorState('Not Registered'));
        return;
      }
      dio.options.headers = {'Authorization': 'Bearer $token'};
      final response = await dio.get(
        '/profile',
      );

      if (response.statusCode == 200) {
        var body = (response.data);

        var profileMap = body['data'];
        final profile = Profile.fromMap(profileMap['userType'], profileMap);
        emit(FetchedProfileState(profile, token));
      } else {
        emit(ProfileErrorState(response));
      }
    } on DioError catch (e) {
      emit(ProfileErrorState(e));
    }
  }
}
