import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/uuid.dart';
import 'package:verxr/features/auth/auth_bloc.dart';
import 'package:verxr/features/registration/bloc/profile/profile_bloc.dart';
import 'package:verxr/models/profile/individual.dart';

import 'edit_profile_test.dart';

void main() {
  var authBloc = AuthBloc(mockAuth());
  var s = authBloc.firebaseAuth.currentUser!.uid;
  var firstName = 'test_name-$s';
  var mockProfile = IndividualProfile(
    firstName: firstName,
    password: const Uuid().v4(),
    email: authBloc.firebaseAuth.currentUser!.email!,
    phone: authBloc.firebaseAuth.currentUser!.phoneNumber!,
    uid: authBloc.firebaseAuth.currentUser!.uid,
    dob: DateTime.now().toIso8601String(),
    middleName: ' ',
    lastName: 'last_name',
  );
  blocTest<ProfileBloc, ProfileState>(
    'Test to register a profile for Individual',
    build: () {
      return ProfileBloc(authBloc);
    },
    seed: () => EditProfileState(mockProfile),
    act: (bloc) {
      bloc.add(RegisterProfileEvent((bloc.state as EditProfileState).profile, const Uuid().v4()));
    },
    wait: const Duration(seconds: 1),
    verify: (bloc) {

      expect(
        ((bloc.state as FetchedProfileState).profile as IndividualProfile)
            .firstName,
        firstName,
      );
    },
  );
}
