import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/data/latest.dart' as tz;

import './features/tabs/screens/tabs_screen.dart';
import './services/services.dart';
import './shared/language/providers/language_provider.dart';
import './shared/utils/utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  tz.initializeTimeZones();
  await NotificationService().init();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ScreenSize.width = MediaQuery.of(context).size.width;
    ScreenSize.hight = MediaQuery.of(context).size.height;

    final countryCode = ref.watch(languageProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale(countryCode),
      title: 'Rateel',
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.dightTheme(),
      // TODO change theme
      themeMode: ThemeMode.light,
      home: const TabsScreen(),
    );
  }
}
