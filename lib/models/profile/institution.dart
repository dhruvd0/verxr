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
  }) : super(userType: UserType.institution);

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
      'firstName': firstName,
      'password': password,
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
