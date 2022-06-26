import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:verxr/common/validators/validators.dart';
import 'package:verxr/common/widgets/rounded_green_button.dart';
import 'package:verxr/common/widgets/rounded_text_field.dart';
import 'package:verxr/config/theme.dart';
import 'package:verxr/constants/profile_fields.dart';
import 'package:verxr/constants/user_types.dart';
import 'package:verxr/features/registration/bloc/page_handler/cubit/registration_page_handler_cubit.dart';
import 'package:verxr/features/registration/bloc/page_handler/cubit/registration_page_handler_state.dart';
import 'package:verxr/features/registration/bloc/profile/profile_bloc.dart';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

class FieldPage extends StatelessWidget {
  FieldPage({
    Key? key,
    required this.field,
    required this.pageController,
  }) : super(key: key);
  final ProfileFields field;
  final PageController pageController;
  final formKey = GlobalKey<FormState>();
  final controller = TextEditingController();
  Widget _buildWidgetForProfileField(ProfileFields field) {
    switch (field) {
      case ProfileFields.userType:
        return const ChooseUserTypeWidget();

      default:
        return Form(
          key: formKey,
          child: RoundedTextField(
            controller: controller,
            hintText: field.name.capitalize(),
            validator: (string) {
              switch (field) {
                case ProfileFields.email:
                  return emailValidator(string);
                case ProfileFields.password:
                  return passwordValidator(string);
                default:
                  return string != null && string.isNotEmpty
                      ? null
                      : 'This is required';
              }
            },
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegistrationPageHandlerCubit,
        RegistrationPageHandlerState>(
      builder: (context, state) {
        return Container(
          child: Column(
            children: [
              Text(
                '${state.currentPageIndex + 1} of ${state.pageFields.length} ',
                style: getTextTheme(context)
                    .button
                    ?.copyWith(color: AppColors.lightGray()),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                'Get Started',
                style: getTextTheme(context).headline4,
              ),
              const SizedBox(
                height: 50,
              ),
              const SizedBox(
                height: 200,
              ), // Image,

              _buildWidgetForProfileField(field),

              RoundedTextButton(
                text: 'Next',
                onTap: () {
                  pageController.nextPage(
                    duration: const Duration(seconds: 500),
                    curve: Curves.easeIn,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class ChooseUserTypeWidget extends StatelessWidget {
  const ChooseUserTypeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (_, state) {
        if (state is! EditProfileState) {
          BlocProvider.of<ProfileBloc>(context, listen: false).add(
            ChangeProfileEvent(ProfileFields.userType, UserType.individual),
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
