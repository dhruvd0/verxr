// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'profile_bloc.dart';

@immutable
abstract class ProfileEvent {}

/// Event to change a profile users [field] to change [value]
class ChangeProfile extends ProfileEvent {
  final ProfileFields field;
  final dynamic value;
  ChangeProfile(
    this.field,
    this.value,
  );
}

class GetProfileEvent extends ProfileEvent {
  final String uid;

  GetProfileEvent(this.uid);
}

class RegisterProfile extends ProfileEvent {}

class Logout extends ProfileEvent {}

class EditNewProfile extends ProfileEvent {
  final UserType userType;
  EditNewProfile(this.userType);
}
