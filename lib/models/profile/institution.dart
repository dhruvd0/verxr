import 'package:verxr/constants/profile_fields.dart';
import 'package:verxr/constants/user_types.dart';

import 'package:verxr/models/profile/profile.dart';

///
class InstitutionProfile extends Profile {
  ///
  const InstitutionProfile({
    required super.firstName,
    required super.password,
    required super.email,
    required super.phone,
    required super.uid,
    required this.board,
    required this.country,
    required this.state,
    required this.pincode,
    required this.telephone,
  }) : super(userType: UserType.Institution);

  /// CBSE, ICSE etc
  final String board;

  ///
  final String country;

  ///
  final String pincode;

  ///
  final String state;

  ///
  final String telephone;

  ///
  @override
  factory InstitutionProfile.fromMap(Map<String, dynamic> map) {
    return InstitutionProfile(
      firstName: (map[ProfileFields.firstName.name] ?? '') as String,
      password: (map[ProfileFields.password.name] ?? '') as String,
      email: (map['email'] ?? '') as String,
      phone: (map['phone'] ?? '') as String,
      uid: (map['uid'] ?? '') as String,
      board: (map['board'] ?? '') as String,
      country: (map['country'] ?? '') as String,
      state: (map['state'] ?? '') as String,
      telephone: (map['telephone'] ?? '') as String,
      pincode: (map['pincode'] ?? '') as String,
    );
  }
  @override
  InstitutionProfile copyWith({
    String? firstName,
    String? password,
    String? email,
    String? phone,
    String? uid,
    String? board,
    String? country,
    String? pincode,
    String? telephone,
    String? state,
  }) {
    return InstitutionProfile(
      firstName: firstName ?? this.firstName,
      password: password ?? this.password,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      uid: uid ?? this.uid,
      board: board ?? this.board,
      telephone: telephone ?? this.telephone,
      state: state ?? this.state,
      country: country ?? this.country,
      pincode: pincode ?? this.pincode,
    );
  }

  @override
  List<Object> get props =>
      super.props..addAll([board, country, state, pincode, telephone]);

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      ProfileFields.firstName.name: firstName,
      ProfileFields.password.name: password,
      'email': email,
      'phone': phone,
      'uid': uid,
      'board': board,
      'pincode': pincode,
      'country': country,
      'state': state,
      'telephone': telephone,
    };
  }
}
