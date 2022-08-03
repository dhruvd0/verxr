import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:verxr/config/common/widgets/big_image.dart';
import 'package:verxr/config/theme.dart';
import 'package:verxr/features/auth/auth_bloc.dart';
import 'package:verxr/features/auth/widgets/email_login_page.dart';
import 'package:verxr/features/dashboard/pages/home/widgets/home_content_widget.dart';
import 'package:verxr/features/dashboard/pages/home/widgets/home_content_widget.dart';
import 'package:verxr/features/registration/bloc/profile/profile_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is LogOutAuthState) {
              Navigator.pushReplacementNamed(context, EmailLoginPage.routeName);
            }
          },
          child: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 16, top: 10),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hello,',
                              style: getTextTheme(context)
                                  .button
                                  ?.copyWith(color: Colors.grey),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              (state as FetchedProfileState).profile.firstName,
                              style: getTextTheme(context).headline3,
                            ),
                            Text(
                              ' You are (${(state).profile.userType.name})',
                              style: getTextTheme(context)
                                  .button!
                                  .copyWith(color: Colors.grey),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.darkGrey()),
                          ),
                          child: const Iconify(
                            '<svg xmlns="http://www.w3.org/2000/svg" aria-hidden="true" role="img" width="1em" height="1em" preserveAspectRatio="xMidYMid meet" viewBox="0 0 32 32"><path fill="currentColor" d="M26 16.586V14h-2v3a1 1 0 0 0 .293.707L27 20.414V22H5v-1.586l2.707-2.707A1 1 0 0 0 8 17v-4a7.985 7.985 0 0 1 12-6.918V3.847a9.896 9.896 0 0 0-3-.796V1h-2v2.05A10.014 10.014 0 0 0 6 13v3.586l-2.707 2.707A1 1 0 0 0 3 20v3a1 1 0 0 0 1 1h7v1a5 5 0 0 0 10 0v-1h7a1 1 0 0 0 1-1v-3a1 1 0 0 0-.293-.707ZM19 25a3 3 0 0 1-6 0v-1h6Z"/><circle cx="26" cy="8" r="4" fill="currentColor"/></svg>"',
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        )
                      ],
                    ),
                  ),
                  BlocBuilder<ProfileBloc, ProfileState>(
                    builder: (context, state) {
                      return BigAnimatedIllustration(
                        asset: state is FetchedProfileState
                            ? state.profile.getAssetPathForUser()
                            : 'assets/splash.png',
                        collapseFactor: 1,
                        height: 137,
                      );
                    },
                  ),
                  const SizedBox(
                    height: 27,
                  ),
                  const Flexible(child: HomeContent()),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
