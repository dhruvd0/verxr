import 'package:equatable/equatable.dart';

import 'package:verxr/constants/user_types.dart';
import 'package:verxr/models/profile/group.dart';
import 'package:verxr/models/profile/individual.dart';
import 'package:verxr/models/profile/institution.dart';

/// Generic Profile class for Individual, Group and Institution
abstract class Profile extends Equatable {
  ///
  const Profile({
    required this.firstName,
    required this.password,
    required this.email,
    required this.phone,
    required this.uid,
    required this.userType,
  });

  ///
  factory Profile.fromMap(UserType userType, Map<String, dynamic> map) {
    switch (userType) {
      case UserType.individual:
        return IndividualProfile.fromMap(map);
      case UserType.group:
        GroupProfile.fromMap(map);
        break;
      case UserType.institution:
          InstitutionProfile.fromMap(map);
        break;
   
    }

    return IndividualProfile.fromMap(map);
  }

  /// Email
  final String email;

  /// FirstName
  final String firstName;

  ///
  final String password;

  ///
  final String phone;

  /// Firebase Auth UID
  final String uid;

  /// Defines which type of profile is extended from [Profile]
  final UserType userType;

  @override
  List<Object> get props {
    return [
      firstName,
      password,
      email,
      phone,
      uid,
    ];
  }

  ///
  Profile copyWith();

  ///
  Map<String, dynamic> toMap();
}
