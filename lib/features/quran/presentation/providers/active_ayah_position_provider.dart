import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rateel/features/quran/data/model/ayah_position.dart';

final activeAyahProvider = StateNotifierProvider<ActiveAyahPositionNotifier, AyahPosition>((ref) {
  return ActiveAyahPositionNotifier();
});

class ActiveAyahPositionNotifier extends StateNotifier<AyahPosition> {
  ActiveAyahPositionNotifier() : super(AyahPosition(pageNumber: 1, ayahNumber: 1, surahNumer: 1));
}
