import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:verxr/constants/profile_fields.dart';
import 'package:verxr/constants/user_types.dart';
import 'package:verxr/models/profile/profile.dart';

part 'profile_event.dart';
part 'profile_state.dart';

/// State management, to create,edit and fetch profile
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ///
  ProfileBloc() : super(ProfileInitial()) {
    on<ChangeProfile>(_onChangeProfile);
    on<EditNewProfile>(
      _onEditNewProfile,
    );
  }

  void _onEditNewProfile(event, Emitter emit) {
    emit(EditProfileState(Profile.fromMap(event.userType, const {})));
    assert(state is EditProfileState);
  }

  void _onChangeProfile(
    ChangeProfile changeProfileEvent,
    Emitter emit,
  ) {
    assert(state is EditProfileState);
    var createProfileState = state as EditProfileState;
    var profile = createProfileState.profile;
    var map = profile.toMap();
    var key = changeProfileEvent.field.name;
    map[key] = changeProfileEvent.value;
    profile = Profile.fromMap(profile.userType, map);
    emit(EditProfileState(profile));
  }
}
