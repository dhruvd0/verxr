import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:verxr/config/common/toast.dart';
import 'package:verxr/config/common/validators/validators.dart';
import 'package:verxr/config/common/widgets/big_image.dart';
import 'package:verxr/config/common/widgets/rounded_green_button.dart';
import 'package:verxr/config/common/widgets/rounded_text_field.dart';
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

  final TextEditingController defaultController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool acceptedTermsAndConditions = false;

  final TextEditingController middleNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
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
      defaultController.text = getEnteredFieldValue(context, field);
    }

    switch (field) {
      case ProfileFields.userType:
        return const ChooseUserTypeWidget();
      case ProfileFields.firstName:
        return Column(
          children: [
            RoundedTextField(
              controller: defaultController,
              hintText: 'First Name',
              validator: (string) {
                return nameValidator(string);
              },
            ),
            RoundedTextField(
              controller: middleNameController,
              hintText: 'Middle Name',
              validator: (string) {
                return null;
              },
            ),
            RoundedTextField(
              controller: lastNameController,
              hintText: 'Last Name',
              validator: (string) {
                return nameValidator(string);
              },
            ),
          ],
        );
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
          passwordController: defaultController,
        );
      case ProfileFields.email:
        return _textFieldForEmail(field);
      default:
        throw Exception('Invalid Profile Field for this form');
    }
  }

  String getEnteredFieldValue(BuildContext context, ProfileFields field) {
    var state = BlocProvider.of<ProfileBloc>(context).state;
    if (state is! EditProfileState) {
      return '';
    }
    var map = (state).profile.toMap();

    return map[field.name] ?? '';
  }

  RoundedTextField _textFieldForEmail(ProfileFields field) {
    return RoundedTextField(
      controller: defaultController,
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
                  height: 5,
                ),
                Text(
                  widget.field == ProfileFields.password
                      ? 'Complete Your Registration'
                      : widget.field == ProfileFields.userType
                          ? 'Get Started'
                          : 'Your ${widget.field.name.capitalize()}',
                  style: getTextTheme(context).headline4,
                ),
                BlocBuilder<ProfileBloc, ProfileState>(
                  builder: (context, profileState) {
                    return BigAnimatedIllustration(
                      asset: state.currentPageIndex == 0
                          ? 'assets/splash.png'
                          : 'assets/${profileState is EditProfileState ? profileState.profile.userType.name : 'splash'}.png',
                      collapseFactor: widget.field == ProfileFields.firstName ||
                              widget.field == ProfileFields.password
                          ? 2.6
                          : 1.5,
                      height: 300,
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
                          Text.rich(
                            TextSpan(
                              style: TextStyle(
                                fontSize: 27,
                              ),
                              children: [
                                TextSpan(
                                  text: 'I agree to the ',
                                  style: getTextTheme(context).bodyText2,
                                ),
                                TextSpan(
                                  style: getTextTheme(context)
                                      .bodyText2
                                      ?.copyWith(color: Colors.blue),
                                  //make link blue and underline
                                  text: "terms and conditions.",
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () async {
                                      launchUrlString("http://verxr.io/about/",mode: LaunchMode.externalApplication);
                                    },
                                ),

                                //more text paragraph, sentences here.
                              ],
                            ),
                          ),
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
                                if (defaultController.text !=
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
                                  ProfileFields.firstName,
                                  ProfileFields.country,
                                  ProfileFields.state,
                                  ProfileFields.board,
                                ].contains(widget.field)) {
                                  BlocProvider.of<ProfileBloc>(context).add(
                                    ChangeProfileEvent(
                                      widget.field,
                                      defaultController.text,
                                    ),
                                  );
                                } else if (widget.field ==
                                    ProfileFields.firstName) {
                                  BlocProvider.of<ProfileBloc>(context).add(
                                    ChangeProfileEvent(
                                      ProfileFields.firstName,
                                      defaultController.text,
                                    ),
                                  );
                                  BlocProvider.of<ProfileBloc>(context).add(
                                    ChangeProfileEvent(
                                      ProfileFields.middleName,
                                      middleNameController.text,
                                    ),
                                  );
                                  BlocProvider.of<ProfileBloc>(context).add(
                                    ChangeProfileEvent(
                                      ProfileFields.lastName,
                                      lastNameController.text,
                                    ),
                                  );
                                }

                                widget.pageController.nextPage(
                                  duration: const Duration(milliseconds: 250),
                                  curve: Curves.easeIn,
                                );
                              }
                              debugPrint('inavlid');
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
