import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/uuid.dart';
import 'package:verxr/constants/profile_fields.dart';
import 'package:verxr/constants/user_types.dart';
import 'package:verxr/features/auth/auth_bloc.dart';
import 'package:verxr/features/registration/bloc/profile/profile_bloc.dart';
import 'package:verxr/models/profile/group.dart';
import 'package:verxr/models/profile/institution.dart';

void main() {
  group('Edit Profile Tests:', () {
    group('Change first Name', () {
      for (var type in UserType.values) {
        String name = 'firstName$type';
        blocTest<ProfileBloc, ProfileState>(
          '$type',
          build: () => ProfileBloc(AuthBloc(mockAuth())),
          act: (bloc) {
            bloc.add(EditNewProfileEvent(type));
            bloc.add(ChangeProfileEvent(ProfileFields.firstName, name));
          },
          verify: (bloc) {
            expect(bloc.state, isA<EditProfileState>());
            expect((bloc.state as EditProfileState).profile.firstName, name);
          },
        );
      }
    });

    blocTest<ProfileBloc, ProfileState>(
      'Change board for  group users ',
      build: () => ProfileBloc(AuthBloc(mockAuth())),
      act: (bloc) {
        bloc.add(EditNewProfileEvent(UserType.Group));
        bloc.add(ChangeProfileEvent(ProfileFields.board, 'test_board'));
      },
      verify: (bloc) {
        expect(
          ((bloc.state as EditProfileState).profile as GroupProfile).board,
          'test_board',
        );
      },
    );

    blocTest<ProfileBloc, ProfileState>(
      'Change telephone for institution users ',
      build: () => ProfileBloc(AuthBloc(mockAuth())),
      act: (bloc) {
        bloc.add(EditNewProfileEvent(UserType.Institution));
        bloc.add(ChangeProfileEvent(ProfileFields.telephone, '111'));
      },
      verify: (bloc) {
        expect(
          ((bloc.state as EditProfileState).profile as InstitutionProfile)
              .telephone,
          '111',
        );
      },
    );
  });
}

MockFirebaseAuth mockAuth([String? uid]) {
  uid = uid ?? const Uuid().v4();
  var phone = '+91$uid';
  var email = '$uid@gmail.com';
  return MockFirebaseAuth(
    signedIn: true,
    mockUser: MockUser(
      uid: uid,
      phoneNumber: phone,
      email: email,
    ),
  );
}
