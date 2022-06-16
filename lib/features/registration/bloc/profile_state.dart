// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'profile_bloc.dart';

@immutable
abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class AuthenticatedProfileState extends ProfileState {
  final String uid;
  AuthenticatedProfileState(this.uid);
}

/// State for Registration Page
class EditProfileState extends ProfileState {
  final Profile profile;
  EditProfileState(
    this.profile,
  );
}

/// State which has a registered profile, to be used in entire app
class FetchedProfileState extends ProfileState {
  final Profile profile;
  FetchedProfileState(this.profile);
}

class ProfileLoadingState extends ProfileState {}

class ProfileErrorState extends ProfileState {
  final String errorMessage;
  ProfileErrorState(this.errorMessage);
}
