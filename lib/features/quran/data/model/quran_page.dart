import 'package:flutter/material.dart';
import 'package:rateel/features/quran/data/model/glyph.dart';

import '../../presentation/widgets/rich_text_page.dart';

class QuranPage {
  final int id;
  final int pageNumber;
  final String chapterCode;
  final int hizbNumber;
  final int juzNumber;
  final int rubNumber;
  late List<Glyph> glyphs;
  late List<InlineSpan> spans;
  late RichTextPage richTextPage;

  QuranPage({
    required this.id,
    required this.pageNumber,
    required this.chapterCode,
    required this.hizbNumber,
    required this.juzNumber,
    required this.rubNumber,
  });

  factory QuranPage.fromJson(Map<String, dynamic> json) => QuranPage(
        id: json["id"],
        pageNumber: json["pageNumber"],
        chapterCode: json["chapterCode"],
        hizbNumber: json["hizbNumber"],
        juzNumber: json["juzNumber"],
        rubNumber: json["rubNumber"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "pageNumber": pageNumber,
        "chapterCode": chapterCode,
        "hizbNumber": hizbNumber,
        "juzNumber": juzNumber,
        "rubNumber": rubNumber,
      };
}
