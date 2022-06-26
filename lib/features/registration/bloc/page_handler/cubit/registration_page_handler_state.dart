// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:verxr/constants/profile_fields.dart';

class RegistrationPageHandlerState extends Equatable {
  final int totalPages;
  final int currentPageIndex;
  final List<ProfileFields> pageFields;
  const RegistrationPageHandlerState({
    required this.totalPages,
    required this.currentPageIndex,
    required this.pageFields,
  });

  RegistrationPageHandlerState copyWith({
    int? totalPages,
    int? currentPageIndex,
    List<ProfileFields>? pageFields,
  }) {
    return RegistrationPageHandlerState(
      totalPages: totalPages ?? this.totalPages,
      currentPageIndex: currentPageIndex ?? this.currentPageIndex,
      pageFields: pageFields ?? this.pageFields,
    );
  }

  @override
  List<Object> get props => [totalPages, currentPageIndex, pageFields];
}
