// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'package:flutter_dotenv/flutter_dotenv.dart';

// languages code
const String ENGLISH = 'en';
const String ARABIC = 'ar';

// app font family
const FONT_FAMILY = 'STCForward';

// google maps api key
final API_KEY = dotenv.env['API_KEY'] ?? '';
