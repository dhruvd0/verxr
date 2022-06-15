import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:verxr/constants/profile_fields.dart';
import 'package:verxr/constants/user_types.dart';
import 'package:verxr/features/registration/bloc/profile_bloc.dart';
import 'package:verxr/models/profile/group.dart';
import 'package:verxr/models/profile/institution.dart';

void main() {
  group('Edit Profile Tests:', () {
    group('Change first Name', () {
      for (var type in UserType.values) {
        String name = 'firstName$type';
        blocTest<ProfileBloc, ProfileState>(
          '$type',
          build: () => ProfileBloc(),
          act: (bloc) {
            bloc.add(EditNewProfile(type));
            bloc.add(ChangeProfile(ProfileFields.firstName, name));
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
      build: () => ProfileBloc(),
      act: (bloc) {
        bloc.add(EditNewProfile(UserType.group));
        bloc.add(ChangeProfile(ProfileFields.board, 'test_board'));
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
      build: () => ProfileBloc(),
      act: (bloc) {
        bloc.add(EditNewProfile(UserType.institution));
        bloc.add(ChangeProfile(ProfileFields.telephone, '111'));
      },
      verify: (bloc) {
        expect(
          ((bloc.state as EditProfileState).profile as InstitutionProfile).telephone,
          '111',
        );
      },
    );
  });
}
