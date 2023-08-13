import 'dart:convert';

import 'package:flutter/services.dart';

import '../../quran_helper.dart';
import '../model/glyph.dart';

class PageGlyphsRepository {
  Future<List<Glyph>> loadPageGlyphsFromJsonFile({required int pageNo}) async {
    String jsonData = await rootBundle.loadString('assets/quran/v1/${getPageNoAsThreeDisgits(pageNo)}.json');
    List<dynamic> jsonList = json.decode(jsonData);
    List<Glyph> glyphs = [];

    for (dynamic jsonObj in jsonList) {
      glyphs.add(Glyph.fromJson(jsonObj));
    }

    return glyphs;
  }
}
