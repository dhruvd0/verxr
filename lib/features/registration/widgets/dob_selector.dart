import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:verxr/config/common/widgets/rounded_text_field.dart';
import 'package:verxr/constants/profile_fields.dart';
import 'package:verxr/features/registration/bloc/profile/profile_bloc.dart';
import 'package:verxr/models/profile/individual.dart';

class DobSelector extends StatelessWidget {
  DobSelector({Key? key}) : super(key: key);
  var dobController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        var dob =
            ((state as UnregisteredProfileState).profile as IndividualProfile)
                .dob;
        dobController = TextEditingController(
          text: DateTime.tryParse(dob) == null
              ? ''
              : DateFormat(DateFormat.YEAR_ABBR_MONTH_DAY)
                  .format(DateTime.parse(dob)),
        );

        return GestureDetector(
          key: const ValueKey('dob-selector'),
          onTap: () {
            showDatePicker(
              context: context,
              initialDate: dob.isEmpty
                  ? DateTime.now()
                  : DateTime.tryParse(dob) ?? DateTime.now(),
              firstDate: DateTime(1950),
              lastDate: DateTime.now(),
            ).then((value) {
              if (value == null) {
                return;
              }
              BlocProvider.of<ProfileBloc>(context).add(
                ChangeProfileEvent(
                  ProfileFields.dob,
                  value.toIso8601String(),
                ),
              );
            });
          },
          child: RoundedTextField(
            controller: dobController,
            isEnabled: false,
            hintText: 'Select Your Date of Birth',
            validator: (s) {
              return null;
            },
          ),
        );
      },
    );
  }
}
