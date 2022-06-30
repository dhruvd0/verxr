import 'package:verxr/constants/profile_fields.dart';
import 'package:verxr/constants/user_types.dart';
import 'package:verxr/models/profile/profile.dart';

///
class GroupProfile extends Profile {
  ///
  const GroupProfile({
    required super.firstName,
    required super.password,
    required super.email,
    required super.phone,
    required super.uid,
    required this.board,
  }) : super(userType: UserType.Group);

  /// CBSE, ICSE etc
  final String board;

  @override
  GroupProfile copyWith({
    String? firstName,
    String? password,
    String? email,
    String? phone,
    String? uid,
    String? board,
  }) {
    return GroupProfile(
      firstName: firstName ?? this.firstName,
      password: password ?? this.password,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      uid: uid ?? this.uid,
      board: board ?? this.board,
    );
  }

  @override
  List<Object> get props => super.props..addAll([board]);

  ///
  @override
  factory GroupProfile.fromMap(Map<String, dynamic> map) {
    return GroupProfile(
      firstName: (map[ProfileFields.firstName.name] ?? '') as String,
      password: (map[ProfileFields.password.name] ?? '') as String,
      email: (map['email'] ?? '') as String,
      phone: (map['phone'] ?? '') as String,
      uid: (map['uid'] ?? '') as String,
      board: (map['board'] ?? '') as String,
    );
  }
  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      ProfileFields.firstName.name: firstName,
      ProfileFields.password.name: password,
      'email': email,
      'phone': phone,
      'uid': uid,
      'board': board,
    };
  }
}
