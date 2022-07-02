import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:verxr/common/toast.dart';
import 'package:verxr/common/validators/validators.dart';
import 'package:verxr/common/widgets/rounded_green_button.dart';
import 'package:verxr/common/widgets/rounded_text_field.dart';
import 'package:verxr/config/theme.dart';
import 'package:verxr/constants/profile_fields.dart';
import 'package:verxr/constants/user_types.dart';
import 'package:verxr/features/auth/auth_bloc.dart';
import 'package:verxr/features/auth/widgets/email_login_page.dart';
import 'package:verxr/features/home/widgets/home_page.dart';
import 'package:verxr/features/registration/bloc/profile/profile_bloc.dart';
import 'package:verxr/features/registration/widgets/registration_page.dart';

class PhoneAuthPage extends StatelessWidget {
  PhoneAuthPage({Key? key}) : super(key: key);
  static const String routeName = 'phoneAuthPage';
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, EmailLoginPage.routeName);
        return false;
      },
      child: Scaffold(
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: BlocConsumer<ProfileBloc, ProfileState>(
            listener: (context, profileState) {
              if (profileState is FetchedProfileState) {
                Navigator.pushReplacementNamed(
                  context,
                  HomePage.routeName,
                );
              } else if (profileState is ProfileErrorState) {
                BlocProvider.of<ProfileBloc>(context, listen: false).add(
                  ChangeProfileEvent(
                    ProfileFields.userType,
                    UserType.Individual,
                  ),
                );
                Navigator.pushReplacementNamed(
                  context,
                  RegistrationPage.routeName,
                );
              }
            },
            builder: (_, profileState) => BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is SuccessAuthState) {
                  BlocProvider.of<ProfileBloc>(context).add(
                    GetProfileEvent(
                      BlocProvider.of<AuthBloc>(context)
                          .firebaseAuth
                          .currentUser!
                          .uid,
                    ),
                  );
                } else if (state is FailureAuthState) {
                  showToast(state.error.toString());
                }
              },
              builder: (context, state) {
                return SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 350,
                        ),
                        Text(
                          'Sign Up',
                          style: getTextTheme(context).headline4,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Verify Your Phone Number',
                          style: getTextTheme(context).bodyText2,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        RoundedTextField(
                          hintText: 'Phone',
                          textInputType: TextInputType.phone,
                          controller: phoneNumberController,
                          validator: phoneValidator,
                        ),
                        state is CodeSentState || state is FailureAuthState
                            ? Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 50),
                                child: RoundedTextField(
                                  hintText: 'OTP',
                                  textInputType: TextInputType.phone,
                                  validator: otpValidator,
                                  textAlign: TextAlign.center,
                                  maxLength: 6,
                                  controller: otpController,
                                ),
                              )
                            : const SizedBox(),
                        state is LoadingAuthState ||
                                profileState is ProfileLoadingState
                            ? Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.primaryGreen(),
                                ),
                              )
                            : RoundedTextButton(
                                text: state is CodeSentState
                                    ? 'Verify'
                                    : 'Send OTP',
                                onTap: () {
                                  if (!formKey.currentState!.validate()) {
                                    Future.delayed(const Duration(seconds: 3))
                                        .then(
                                      (value) => formKey.currentState!.reset(),
                                    );

                                    return;
                                  }
                                  BlocProvider.of<AuthBloc>(context).add(
                                    state is CodeSentState
                                        ? PhoneLoginEvent(
                                            phoneNumberController.text,
                                            otpController.text,
                                          )
                                        : VerifyPhoneEvent(
                                            phoneNumberController.text,
                                          ),
                                  );
                                },
                              ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
