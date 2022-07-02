import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:verxr/common/toast.dart';
import 'package:verxr/common/validators/validators.dart';
import 'package:verxr/common/widgets/rounded_green_button.dart';
import 'package:verxr/common/widgets/rounded_text_field.dart';
import 'package:verxr/config/theme.dart';
import 'package:verxr/constants/profile_fields.dart';
import 'package:verxr/features/registration/bloc/page_handler/cubit/registration_page_handler_cubit.dart';
import 'package:verxr/features/registration/bloc/page_handler/cubit/registration_page_handler_state.dart';
import 'package:verxr/features/registration/bloc/profile/profile_bloc.dart';
import 'package:verxr/features/registration/widgets/choose_user_type.dart';
import 'package:verxr/features/registration/widgets/confirm_password_field.dart';
import 'package:verxr/features/registration/widgets/dob_selector.dart';
import 'package:verxr/features/registration/widgets/dropdown_selector.dart';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

class FieldPage extends StatefulWidget {
  const FieldPage({
    Key? key,
    required this.field,
    required this.pageController,
  }) : super(key: key);
  final ProfileFields field;
  final PageController pageController;

  @override
  State<FieldPage> createState() => _FieldPageState();
}

class _FieldPageState extends State<FieldPage> {
  var formKey = GlobalKey<FormState>();

  final TextEditingController controller = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool acceptedTermsAndConditions = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    formKey = GlobalKey<FormState>();
  }

  Widget _buildWidgetForProfileField(
    ProfileFields field,
    BuildContext context,
  ) {
    if (field != ProfileFields.password) {
      controller.text = getEnteredFieldValue(context, field);
    }

    switch (field) {
      case ProfileFields.userType:
        return const ChooseUserTypeWidget();
      case ProfileFields.dob:
        return DobSelector();
      case ProfileFields.board:
        return DropdownSelector(items: const ['CBSE', 'ICSE'], fields: field);
      case ProfileFields.country:
        return DropdownSelector(
          items: const ['India', 'US', 'China'],
          fields: field,
        );
      case ProfileFields.state:
        return DropdownSelector(
          items: const ['Delhi', 'Maharashtra'],
          fields: field,
        );
      case ProfileFields.password:
        return ConfirmPasswordField(
          confirmPasswordController: confirmPasswordController,
          passwordController: controller,
        );
      default:
        return _defaultWidgetForField(field);
    }
  }

  String getEnteredFieldValue(BuildContext context, ProfileFields field) {
    var state = BlocProvider.of<ProfileBloc>(context).state;
    if (state is! EditProfileState) {
      return '';
    }
    var map = (state as EditProfileState).profile.toMap();

    return map[field.name] ?? '';
  }

  RoundedTextField _defaultWidgetForField(ProfileFields field) {
    return RoundedTextField(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: BlocBuilder<RegistrationPageHandlerCubit,
          RegistrationPageHandlerState>(
        builder: (context, state) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                Text(
                  '${state.currentPageIndex + 1} of ${state.pageFields.length} ',
                  style: getTextTheme(context)
                      .button
                      ?.copyWith(color: AppColors.lightGray()),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  widget.field == ProfileFields.password
                      ? 'Complete Your Registration'
                      : widget.field == ProfileFields.userType
                          ? 'Get Started'
                          : 'Your ${widget.field.name.capitalize()}',
                  style: getTextTheme(context).headline4,
                ),
                const SizedBox(
                  height: 50,
                ),
                KeyboardVisibilityBuilder(
                  builder: (context, isKeyboardVisible) {
                    return SizedBox(
                      height: isKeyboardVisible
                          ? MediaQuery.of(context).size.height *
                              (widget.field == ProfileFields.password
                                  ? 50
                                  : 150) /
                              830
                          : MediaQuery.of(context).size.height * 200 / 830,
                    );
                  },
                ),
                Form(
                  key: formKey,
                  child: _buildWidgetForProfileField(widget.field, context),
                ),
                widget.field == ProfileFields.password
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FlutterSwitch(
                            activeColor: AppColors.primaryGreen(),
                            height: 20,
                            width: 50,
                            value: acceptedTermsAndConditions,
                            onToggle: (val) {
                              setState(() {
                                acceptedTermsAndConditions = val;
                              });
                            },
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            'I agree to the terms and conditions.',
                            style: getTextTheme(context).bodyText2,
                          )
                        ],
                      )
                    : const SizedBox(),
                const SizedBox(
                  height: 16,
                ),
                BlocBuilder<ProfileBloc, ProfileState>(
                  builder: (context, profileState) {
                    return profileState is ProfileLoadingState
                        ? const CircularProgressIndicator()
                        : RoundedTextButton(
                            text: widget.field == ProfileFields.password
                                ? 'Register'
                                : 'Next',
                            onTap: () {
                              if (widget.field == ProfileFields.password) {
                                if (controller.text !=
                                    confirmPasswordController.text) {
                                  showToast('Passwords Do Not Match');
                                  return;
                                }
                                if (!acceptedTermsAndConditions) {
                                  showToast('Accept T&C To Continue');
                                  return;
                                }
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                BlocProvider.of<ProfileBloc>(context).add(
                                  RegisterProfileEvent(
                                    (profileState as EditProfileState).profile,
                                    confirmPasswordController.text,
                                  ),
                                );
                                return;
                              }
                              if (formKey.currentState?.validate() ?? true) {
                                if (![
                                  ProfileFields.userType,
                                  ProfileFields.dob,
                                  ProfileFields.country,
                                  ProfileFields.state,
                                  ProfileFields.board,
                                ].contains(widget.field)) {
                                  BlocProvider.of<ProfileBloc>(context).add(
                                    ChangeProfileEvent(
                                      widget.field,
                                      controller.text,
                                    ),
                                  );
                                }

                                widget.pageController.nextPage(
                                  duration: const Duration(milliseconds: 250),
                                  curve: Curves.easeIn,
                                );
                              }
                            },
                          );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
