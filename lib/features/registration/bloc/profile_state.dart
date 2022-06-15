// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'profile_bloc.dart';

@immutable
abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

abstract class AuthenticatedProfileState extends ProfileState {
  final Profile profile;
  AuthenticatedProfileState(this.profile);
}

/// State for Registration Page
class EditProfileState extends AuthenticatedProfileState {
  EditProfileState(
    super.profile,
  );
}

/// State which has a registered profile, to be used in entire app
class FetchedProfileState extends AuthenticatedProfileState {
  FetchedProfileState(super.profile);
}

class ProfileLoadingState extends ProfileState {}

class ProfileErrorState extends ProfileState {
  final String errorMessage;
  ProfileErrorState(this.errorMessage);
}
