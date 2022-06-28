import 'package:bloc/bloc.dart';
import 'package:verxr/constants/profile_fields.dart';
import 'package:verxr/constants/user_types.dart';
import 'package:verxr/features/registration/bloc/page_handler/cubit/registration_page_handler_state.dart';
import 'package:verxr/features/registration/bloc/profile/profile_bloc.dart';

class RegistrationPageHandlerCubit extends Cubit<RegistrationPageHandlerState> {
  final ProfileBloc profileBloc;
  RegistrationPageHandlerCubit(this.profileBloc)
      : super(
          const RegistrationPageHandlerState(
            totalPages: 1,
            currentPageIndex: 0,
            pageFields: [
              ProfileFields.userType,
            ],
          ),
        ) {
    profileBloc.stream.listen((event) {
      userTypeHandler(event);
    });
  }
  void userTypeHandler(ProfileState profileState) {
    if (profileState is EditProfileState) {
      var fields = [ProfileFields.userType];

      switch (profileState.profile.userType) {
        case UserType.individual:
          fields.addAll([
            ProfileFields.firstName,
            ProfileFields.middleName,
            ProfileFields.lastName,
            ProfileFields.dob,
          ]);
          break;
        case UserType.group:
          fields.addAll([
            ProfileFields.firstName,
            ProfileFields.board,
          ]);
          break;
        case UserType.institution:
          fields.addAll(profileFieldsForInstitution);
          break;
      }

      fields.addAll([ProfileFields.email, ProfileFields.password]);
      emit(state.copyWith(pageFields: fields));
    }
  }

  List<ProfileFields> get profileFieldsForInstitution {
    return [
      ProfileFields.firstName,
      ProfileFields.country,
      ProfileFields.state,
      ProfileFields.pincode,
      ProfileFields.board,
      ProfileFields.telephone,
    ];
  }

  void changeCurrentPageIndex(int value) {
    emit(state.copyWith(currentPageIndex: value));
  }
}
