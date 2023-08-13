import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/pages_repository.dart';

final pagesRepositryProvider = Provider<PagesRepository>((ref) {
  return PagesRepository();
});
