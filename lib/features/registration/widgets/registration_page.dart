import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:verxr/features/registration/bloc/page_handler/cubit/registration_page_handler_cubit.dart';
import 'package:verxr/features/registration/bloc/page_handler/cubit/registration_page_handler_state.dart';
import 'package:verxr/features/registration/widgets/registration_field_page.dart';

class RegistrationPage extends StatelessWidget {
  RegistrationPage({Key? key}) : super(key: key);
  static const String routeName = "registrationPage";
  final PageController pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<RegistrationPageHandlerCubit,
          RegistrationPageHandlerState>(
        builder: (context, state) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 100,
              ),
              Flexible(
                child: PageView.builder(
                  itemCount: state.pageFields.length,
                  controller: pageController,
                  onPageChanged: (value) {
                    log('test');
                    BlocProvider.of<RegistrationPageHandlerCubit>(
                      context,
                      listen: false,
                    ).changeCurrentPageIndex(value);
                  },
                  itemBuilder: (_, index) {
                    return FieldPage(
                      field: state.pageFields[state.currentPageIndex],
                      pageController: pageController,
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
