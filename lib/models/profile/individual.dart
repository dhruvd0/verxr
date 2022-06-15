import 'package:verxr/constants/user_types.dart';
import 'package:verxr/models/profile/profile.dart';

///
class IndividualProfile extends Profile {
  ///
  const IndividualProfile({
    required super.firstName,
    required super.password,
    required super.email,
    required super.phone,
    required super.uid,
    required this.dob,
    required this.middleName,
    required this.lastName,
  }) : super(userType: UserType.individual);

  ///
  @override
  factory IndividualProfile.fromMap(Map<String, dynamic> map) {
    return IndividualProfile(
      firstName: (map['firstName'] ?? '') as String,
      password: (map['password'] ?? '') as String,
      email: (map['email'] ?? '') as String,
      phone: (map['phone'] ?? '') as String,
      uid: (map['uid'] ?? '') as String,
      dob: (map['dob'] ?? '') as String,
      middleName: (map['middleName'] ?? '') as String,
      lastName: (map['lastName'] ?? '') as String,
    );
  }

  /// Date of birth
  final String dob;

  ///
  final String middleName;

  ///
  final String lastName;

  @override
  IndividualProfile copyWith({
    String? firstName,
    String? password,
    String? email,
    String? phone,
    String? uid,
    String? dob,
    String? middleName,
    String? lastName,
  }) {
    return IndividualProfile(
      firstName: firstName ?? this.firstName,
      password: password ?? this.password,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      uid: uid ?? this.uid,
      dob: dob ?? this.dob,
      middleName: middleName ?? this.middleName,
      lastName: lastName ?? this.lastName,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'firstName': firstName,
      'password': password,
      'email': email,
      'phone': phone,
      'uid': uid,
      'dob': dob,
      'middleName': middleName,
      'lastName': lastName,
    };
  }

  @override
  List<Object> get props => super.props..addAll([dob, middleName, lastName]);
}
