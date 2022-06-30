// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'profile_bloc.dart';

@immutable
abstract class ProfileEvent {}

/// Event to change a profile users [field] to change [value]
class ChangeProfileEvent extends ProfileEvent {
  final ProfileFields field;
  final dynamic value;
  ChangeProfileEvent(
    this.field,
    this.value,
  );
}

class GetProfileEvent extends ProfileEvent {
  final String uid;

  GetProfileEvent(this.uid);
}

class RegisterProfileEvent extends ProfileEvent {
  final Profile profile;
  final String password;
  RegisterProfileEvent(this.profile, this.password);
}

class LogoutEvent extends ProfileEvent {}

class EditNewProfileEvent extends ProfileEvent {
  final UserType userType;
  EditNewProfileEvent(this.userType);
}
