import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/defines.dart';
import '../../utils/translation.dart';

class LanguageNotifier extends StateNotifier<String> {
  LanguageNotifier() : super(ARABIC) {
    getAppLocale().then((value) {
      print('new lang ==> $value');
      state = value;
    });
  }

  Future<String> changeLanguage(String code) async {
    state = code;
    return await setAppLocale(code);
  }
}

final languageProvider = StateNotifierProvider<LanguageNotifier, String>(
  (ref) => LanguageNotifier(),
);
