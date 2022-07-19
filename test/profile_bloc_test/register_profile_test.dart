
import 'package:bloc_test/bloc_test.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:uuid/uuid.dart';
import 'package:verxr/features/auth/auth_bloc.dart';
import 'package:verxr/features/registration/bloc/profile/profile_bloc.dart';
import 'package:verxr/features/registration/controller/profile_api_controller.dart';
import 'package:verxr/models/profile/individual.dart';
import 'package:verxr/models/profile/profile.dart';

import 'edit_profile_test.dart';

var _authBloc = AuthBloc(mockAuth());

class MockProfileAPIController extends Mock implements ProfileAPIController {
  @override
  Future<Response> callRegisterAPI(Map<String, dynamic> map) async {
    int statusCode = 200;
    dynamic data = {};

    var profile = Profile.fromMap(map['userType'], map);
    if ((profile is IndividualProfile) && profile.dob.isEmpty) {
      statusCode = 400;
      data = {"message": "Bad Request", "error": "Invalid data format"};
    } else {
      data = {
        "message": "User created successfully",
        "token": "eyJhbLDwQtVCr-DmzKtoLHtGtj_Itw"
      };
      statusCode == 200;
    }
    return Response(
      requestOptions: RequestOptions(path: '/register'),
      data: data,
      statusCode: statusCode,
    );
  }
}

void main() {
  var s = _authBloc.firebaseAuth.currentUser!.uid;
  var firstName = 'test_name-$s';
  var fakeProfile = IndividualProfile(
    firstName: firstName,
    password: const Uuid().v4(),
    email: _authBloc.firebaseAuth.currentUser!.email!,
    phone: _authBloc.firebaseAuth.currentUser!.phoneNumber!,
    uid: _authBloc.firebaseAuth.currentUser!.uid,
    dob: DateTime.now().toIso8601String(),
    middleName: ' ',
    lastName: 'last_name',
  );

  final mockProfileAPIController = MockProfileAPIController();

  group('Test to register a profile for Individual', () {
    blocTest<ProfileBloc, ProfileState>(
      ':with correct fields',
      build: () {
        var mockProfileBloc = ProfileBloc(_authBloc, mockProfileAPIController);

        return mockProfileBloc;
      },
      seed: () => EditProfileState(fakeProfile),
      act: (bloc) {
        bloc.add(
          RegisterProfileEvent(
            (bloc.state as EditProfileState).profile,
            const Uuid().v4(),
          ),
        );
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

    blocTest<ProfileBloc, ProfileState>(
      ':with missing dob',
      build: () {
        return ProfileBloc(_authBloc, mockProfileAPIController);
      },
      seed: () {
        fakeProfile = fakeProfile.copyWith(dob: '');
        return EditProfileState(fakeProfile);
      },
      act: (bloc) {
        bloc.add(
          RegisterProfileEvent(
            (bloc.state as EditProfileState).profile,
            const Uuid().v4(),
          ),
        );
      },
      wait: const Duration(seconds: 1),
      verify: (bloc) {
        expect(
          (bloc.state as ProfileErrorState).errorMessage,
          'Invalid data format',
        );
      },
    );
  });
}
