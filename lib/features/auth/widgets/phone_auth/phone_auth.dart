import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:verxr/common/widgets/rounded_green_button.dart';
import 'package:verxr/common/widgets/rounded_text_field.dart';
import 'package:verxr/config/theme.dart';
import 'package:verxr/features/auth/auth_bloc.dart';

class PhoneAuthPage extends StatelessWidget {
  PhoneAuthPage({Key? key}) : super(key: key);
  static const String routeName = 'phoneAuthPage';
  final TextEditingController phoneNumberController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: BlocBuilder<AuthBloc, AuthState>(
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
                  const SizedBox(
                    height: 10,
                  ),
                  state is LoadingAuthState
                      ? Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primaryGreen(),
                          ),
                        )
                      : RoundedTextButton(
                          text: state is CodeSentState ? 'Verify' : 'Send OTP',
                          onTap: () {
                            BlocProvider.of<AuthBloc>(context).add(
                              VerifyPhoneEvent(
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
    );
  }
}
