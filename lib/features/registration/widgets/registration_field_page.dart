import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:verxr/common/validators/validators.dart';
import 'package:verxr/common/widgets/rounded_green_button.dart';
import 'package:verxr/common/widgets/rounded_text_field.dart';
import 'package:verxr/config/theme.dart';
import 'package:verxr/constants/profile_fields.dart';
import 'package:verxr/features/registration/bloc/page_handler/cubit/registration_page_handler_cubit.dart';
import 'package:verxr/features/registration/bloc/page_handler/cubit/registration_page_handler_state.dart';
import 'package:verxr/features/registration/bloc/profile/profile_bloc.dart';
import 'package:verxr/features/registration/widgets/choose_user_type.dart';
import 'package:verxr/features/registration/widgets/dob_selector.dart';

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

  final controller = TextEditingController();
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
    controller.text =
        (BlocProvider.of<ProfileBloc>(context).state as EditProfileState)
                .profile
                .toMap()[field.name] ??
            '';
    switch (field) {
      case ProfileFields.userType:
        return const ChooseUserTypeWidget();
      case ProfileFields.dob:
        return DobSelector();
      default:
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
                  widget.field == ProfileFields.userType
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
                          ? MediaQuery.of(context).size.height * 150 / 830
                          : MediaQuery.of(context).size.height * 200 / 830,
                    );
                  },
                ),
                Form(
                  key: formKey,
                  child: _buildWidgetForProfileField(widget.field, context),
                ),
                const SizedBox(
                  height: 16,
                ),
                RoundedTextButton(
                  text: 'Next',
                  onTap: () {
                    if (formKey.currentState?.validate() ?? true) {
                      if (widget.field != ProfileFields.userType) {
                        BlocProvider.of<ProfileBloc>(context).add(
                          ChangeProfileEvent(widget.field, controller.text),
                        );
                      }

                      widget.pageController.nextPage(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeIn,
                      );
                    }
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
