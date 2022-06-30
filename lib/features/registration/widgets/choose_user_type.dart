import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:verxr/common/widgets/rounded_text_field.dart';
import 'package:verxr/config/theme.dart';
import 'package:verxr/constants/profile_fields.dart';
import 'package:verxr/constants/user_types.dart';
import 'package:verxr/features/registration/bloc/profile/profile_bloc.dart';
import 'package:verxr/features/registration/widgets/registration_field_page.dart';

class ChooseUserTypeWidget extends StatelessWidget {
  const ChooseUserTypeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (_, state) {
        if (state is! EditProfileState) {
          BlocProvider.of<ProfileBloc>(context, listen: false).add(
            ChangeProfileEvent(ProfileFields.userType, UserType.Individual),
          );
        }
      },
      builder: (context, state) {
        return state is! EditProfileState
            ? Container()
            : Column(
                children: List.generate(3, (index) {
                  var type = UserType.values[index];
                  String initText =
                      ' ${index + 1}.   ${type.name.capitalize()}  ';
                  final controller = TextEditingController(text: initText);

                  return GestureDetector(
                    onTap: () {
                      BlocProvider.of<ProfileBloc>(context, listen: false).add(
                        ChangeProfileEvent(ProfileFields.userType, type),
                      );
                    },
                    child: RoundedTextField(
                      hintText: '',
                      isEnabled: false,
                      borderColor: (state).profile.userType == type
                          ? AppColors.primaryGreen()
                          : null,
                      controller: controller,
                      validator: (s) {
                        return null;
                      },
                    ),
                  );
                }),
              );
      },
    );
  }
}
