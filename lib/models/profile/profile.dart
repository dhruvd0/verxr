import 'package:equatable/equatable.dart';

import 'package:verxr/constants/user_types.dart';
import 'package:verxr/models/profile/group.dart';
import 'package:verxr/models/profile/individual.dart';
import 'package:verxr/models/profile/institution.dart';

/// Generic Profile class for Individual, Group and Institution, has 6 fields
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
  String getAssetPathForUser() => 'assets/${userType.name}.png';

  ///
  factory Profile.fromMap(String userType, Map<String, dynamic> map) {
    switch (userType) {
      case "Individual":
        return IndividualProfile.fromMap(map);
      case "Group":
        return GroupProfile.fromMap(map);

      case "Institution":
        return InstitutionProfile.fromMap(map);
      default:
        throw Exception('Invalid userType:$userType');
    }
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
