import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../services/services.dart';
import '../constants/constants.dart';

AppLocalizations translate(BuildContext context) {
  // print(AppLocalizations.of(context));
  return AppLocalizations.of(context)!;
}

Future<String> setAppLocale(String languageCode) async {
  await StorageService.setStringValue(LAGUAGE_CODE, languageCode);
  return languageCode;
}

Future<String> getAppLocale() async {
  final code = await StorageService.getStringValue(LAGUAGE_CODE, ARABIC);
  return code!;
}

// Locale _locale(String languageCode) {
//   switch (languageCode) {
//     case ARABIC:
//       return const Locale(ARABIC);
//     case ENGLISH:
//       return const Locale(ENGLISH);
//     default:
//       return const Locale(ARABIC);
//   }
// }
