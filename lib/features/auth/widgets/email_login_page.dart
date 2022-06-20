import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:verxr/common/validators/validators.dart';
import 'package:verxr/common/widgets/rounded_green_button.dart';
import 'package:verxr/common/widgets/rounded_text_field.dart';
import 'package:verxr/config/theme.dart';
import 'package:verxr/features/auth/auth_bloc.dart';
import 'package:verxr/features/auth/widgets/phone_auth/phone_auth_page.dart';
import 'package:verxr/features/home/widgets/home_page.dart';
import 'package:verxr/features/registration/bloc/profile_bloc.dart';
import 'package:verxr/features/registration/widgets/registration_page.dart';

class EmailLoginPage extends StatelessWidget {
  EmailLoginPage({Key? key}) : super(key: key);
  static const String routeName = 'emailLoginPage';
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: BlocConsumer<ProfileBloc, ProfileState>(
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
          builder: (context, profileState) {
            return BlocConsumer<AuthBloc, AuthState>(
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
                          'Welcome Back',
                          style: getTextTheme(context).headline4,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Resume where You left Off',
                          style: getTextTheme(context).bodyText2,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        RoundedTextField(
                          hintText: 'Email',
                          textInputType: TextInputType.emailAddress,
                          controller: emailController,
                          validator: emailValidator,
                        ),
                        RoundedTextField(
                          hintText: 'Password',
                          textInputType: TextInputType.visiblePassword,
                          controller: passwordController,
                          validator: passwordValidator,
                        ),
                        profileState is ProfileLoadingState ||
                                state is LoadingAuthState
                            ? Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.primaryGreen(),
                                ),
                              )
                            : RoundedTextButton(
                                text: 'Login',
                                onTap: () {
                                  if (!formKey.currentState!.validate()) {
                                    Future.delayed(const Duration(seconds: 3))
                                        .then(
                                      (value) => formKey.currentState!.reset(),
                                    );

                                    return;
                                  }
                                  BlocProvider.of<AuthBloc>(context).add(
                                    EmailLoginEvent(
                                      email: emailController.text,
                                      password: passwordController.text,
                                    ),
                                  );
                                },
                              ),
                        const SizedBox(
                          height: 16,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              PhoneAuthPage.routeName,
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Sign Up',
                                style: getTextTheme(context).caption,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
