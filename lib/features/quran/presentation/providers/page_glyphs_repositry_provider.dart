import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/page_glyphs_repository.dart';

final pageGlyphsRepositryProvider = Provider<PageGlyphsRepository>((ref) {
  return PageGlyphsRepository();
});
