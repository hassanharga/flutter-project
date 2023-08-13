import 'dart:convert';

import 'package:flutter/services.dart';

import '../model/quran_page.dart';

class PagesRepository {
  Future<List<QuranPage>> loadQuranPages() async {
    String jsonData = await rootBundle.loadString('assets/quran/pages.json');
    List<dynamic> jsonList = json.decode(jsonData);
    List<QuranPage> pages = [];

    for (dynamic jsonObj in jsonList) {
      pages.add(QuranPage.fromJson(jsonObj));
    }

    return pages;
  }
}
