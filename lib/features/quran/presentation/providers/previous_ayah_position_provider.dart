import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rateel/features/quran/data/model/ayah_position.dart';

final previousAyahProvider = StateNotifierProvider<PreviousAyahPositionNotifier, AyahPosition>((ref) {
  return PreviousAyahPositionNotifier();
});

class PreviousAyahPositionNotifier extends StateNotifier<AyahPosition> {
  PreviousAyahPositionNotifier() : super(AyahPosition(pageNumber: 1, ayahNumber: 1, surahNumer: 1));
}
