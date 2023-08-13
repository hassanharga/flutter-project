import 'package:flutter/material.dart';
import 'package:rateel/shared/utils/utils.dart';

import '../../../shared/widgets/widgets.dart';

class AppSearchBar extends StatelessWidget {
  final TextEditingController? controller;
  final Function(String value)? onChange;
  final dynamic leadingIcon;
  final String placeHolder;

  const AppSearchBar({
    super.key,
    required this.leadingIcon,
    required this.placeHolder,
    this.controller,
    this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.whiteColor,
          hintText: placeHolder,
          hintStyle: const TextStyle(
            fontSize: 14,
            color: AppColors.grayColor3,
          ),
          prefixIcon: DynamicIcon(
            leadingIcon,
            color: AppColors.grayColor3,
            size: 25,
          ),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
            borderSide: BorderSide(color: AppColors.whiteColor, width: 1),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.whiteColor, width: 1),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.whiteColor, width: 1),
          ),
        ),
        cursorColor: AppColors.grayColor3,
        style: const TextStyle(
          fontSize: 14,
          color: AppColors.grayColor3,
          decorationThickness: 0,
        ),
        onChanged: onChange,
      ),
    );
  }
}
