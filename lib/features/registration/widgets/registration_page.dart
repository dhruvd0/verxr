import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:verxr/config/common/back_button.dart';
import 'package:verxr/features/auth/widgets/phone_auth/phone_auth_page.dart';
import 'package:verxr/features/dashboard/widgets/dashboard_page.dart';
import 'package:verxr/features/registration/bloc/page_handler/cubit/registration_page_handler_cubit.dart';
import 'package:verxr/features/registration/bloc/page_handler/cubit/registration_page_handler_state.dart';
import 'package:verxr/features/registration/bloc/profile/profile_bloc.dart';
import 'package:verxr/features/registration/widgets/registration_field_page.dart';

class RegistrationPage extends StatelessWidget {
  RegistrationPage({Key? key}) : super(key: key);

  static const String routeName = "registrationPage";

  final PageController pageController = PageController();

  Future<void> onBack(BuildContext context) async {
    if ((pageController.page ?? 0) < 1) {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacementNamed(context, PhoneAuthPage.routeName);
    }
    await pageController.previousPage(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutBack,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await onBack(context);

        return false;
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            leading: BackIconButton(
              onTap: () {
                onBack(context);
              },
            ),
            backgroundColor: Colors.white,
            elevation: 0,
          ),
          body: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: BlocListener<ProfileBloc, ProfileState>(
              listener: (context, state) {
                if (state is FetchedProfileState) {
                  Navigator.pushReplacementNamed(
                    context,
                    DashboardPage.routeName,
                  );
                }
              },
              child: BlocBuilder<RegistrationPageHandlerCubit,
                  RegistrationPageHandlerState>(
                builder: (context, state) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: PageView.builder(
                          itemCount: state.pageFields.length,
                          controller: pageController,
                          physics: const NeverScrollableScrollPhysics(
                            parent: BouncingScrollPhysics(),
                          ),
                          onPageChanged: (value) {
                            BlocProvider.of<RegistrationPageHandlerCubit>(
                              context,
                              listen: false,
                            ).changeCurrentPageIndex(value);
                          },
                          itemBuilder: (_, index) {
                            return FieldPage(
                              field: state.pageFields[index],
                              pageController: pageController,
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
