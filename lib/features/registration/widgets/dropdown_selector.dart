import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:verxr/config/common/icons.dart';
import 'package:verxr/config/theme.dart';
import 'package:verxr/constants/profile_fields.dart';
import 'package:verxr/features/registration/bloc/profile/profile_bloc.dart';

class DropdownSelector extends StatelessWidget {
  const DropdownSelector({Key? key, required this.items, required this.fields})
      : super(key: key);
  final List<String> items;
  final ProfileFields fields;
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 70, minHeight: 53),
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.lightGray()),
        borderRadius: BorderRadius.circular(16),
      ),
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          var selectedVal =
              (state as UnregisteredProfileState).profile.toMap()[fields.name];

          return DropdownButton<String>(
            isExpanded: true,
            underline: const SizedBox(),
            value: (selectedVal ?? '').isEmpty ? items.first : selectedVal,
            items: items.map((e) {
              return DropdownMenuItem(
                value: e,
                child: Text(e),
              );
            }).toList(),
            icon: const Iconify(
              dropDownIcon,
              size: 20,
            ),
            onChanged: (value) {
              BlocProvider.of<ProfileBloc>(context)
                  .add(ChangeProfileEvent(fields, value.toString()));
            },
          );
        },
      ),
    );
  }
}
