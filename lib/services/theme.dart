import 'package:flutter/material.dart';

import '../../shared/utils/utils.dart';
import '../../shared/constants/constants.dart';

class AppTheme {
  static ThemeData lightTheme() {
    return ThemeData(
      fontFamily: FONT_FAMILY,
      brightness: Brightness.light,
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryColor,
        background: AppColors.grayColor,
      ),
    );
  }

  static ThemeData dightTheme() {
    return ThemeData(
      fontFamily: FONT_FAMILY,
      brightness: Brightness.dark,
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryColor,
        brightness: Brightness.dark,
      ),
    );
  }
}
