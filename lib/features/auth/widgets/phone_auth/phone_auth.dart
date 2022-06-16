import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:verxr/common/widgets/rounded_green_button.dart';
import 'package:verxr/common/widgets/rounded_text_field.dart';
import 'package:verxr/config/theme.dart';
import 'package:verxr/features/auth/auth_bloc.dart';
import 'package:verxr/features/home/widgets/home_page.dart';
import 'package:verxr/features/registration/bloc/profile_bloc.dart';
import 'package:verxr/features/registration/widgets/registration_page.dart';

class PhoneAuthPage extends StatelessWidget {
  PhoneAuthPage({Key? key}) : super(key: key);
  static const String routeName = 'phoneAuthPage';
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: BlocListener<ProfileBloc, ProfileState>(
          listener: (context, profileState) {
            if (profileState is FetchedProfileState) {
              Navigator.pushReplacementNamed(
                context,
                HomePage.routeName,
              );
            } else if (profileState is AuthenticatedProfileState) {
              Navigator.pushReplacementNamed(
                context,
                RegistrationPage.routeName,
              );
            }
          },
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is SuccessAuthState) {
                BlocProvider.of<ProfileBloc>(context).add(
                  GetProfileEvent(FirebaseAuth.instance.currentUser!.uid),
                );
              }
            },
            builder: (context, state) {
              return SingleChildScrollView(
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
                    ),
                    state is CodeSentState
                        ? Container(
                            margin: const EdgeInsets.symmetric(horizontal: 50),
                            child: RoundedTextField(
                              hintText: 'OTP',
                              textInputType: TextInputType.phone,
                              textAlign: TextAlign.center,
                              maxLength: 6,
                              controller: otpController,
                            ),
                          )
                        : const SizedBox(),
                    state is LoadingAuthState
                        ? Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primaryGreen(),
                            ),
                          )
                        : RoundedTextButton(
                            text:
                                state is CodeSentState ? 'Verify' : 'Send OTP',
                            onTap: () {
                              BlocProvider.of<AuthBloc>(context).add(
                                state is CodeSentState
                                    ? LoginEvent(
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
              );
            },
          ),
        ),
      ),
    );
  }
}
