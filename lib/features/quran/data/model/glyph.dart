class Glyph {
  final int glyphId;
  final String fontFile;
  late int _glyphCode;
  final GlyphType glyphType;
  final int pageNumber;
  final int lineNumber;
  final LineType lineType;
  final int? suraNumber;
  final int? ayahNumber;
  late String glyphChar;
  late bool isHighlighted;

  Glyph(
      {required this.glyphId,
      required this.fontFile,
      required int glyphCode,
      required this.glyphType,
      required this.pageNumber,
      required this.lineNumber,
      required this.lineType,
      required this.suraNumber,
      required this.ayahNumber,
      this.isHighlighted = false}) {
    _glyphCode = glyphCode;
    glyphChar = String.fromCharCode(_glyphCode);
  }

  factory Glyph.fromJson(Map<String, dynamic> json) => Glyph(
        glyphId: json["glyph_id"],
        fontFile: json["font_file"],
        glyphCode: json["glyph_code"],
        glyphType: glyphTypeValues.map[json["glyph_type"]]!,
        pageNumber: json["page_number"],
        lineNumber: json["line_number"],
        lineType: lineTypeValues.map[json["line_type"]]!,
        suraNumber: json["sura_number"],
        ayahNumber: json["ayah_number"],
      );

  Map<String, dynamic> toJson() => {
        "glyph_id": glyphId,
        "font_file": fontFile,
        "glyph_code": _glyphCode,
        "glyph_type": glyphTypeValues.reverse[glyphType],
        "page_number": pageNumber,
        "line_number": lineNumber,
        "line_type": lineTypeValues.reverse[lineType],
        "sura_number": suraNumber,
        "ayah_number": ayahNumber,
      };
}

enum GlyphType {
  word,
  end,
  pause,
  hizb,
  sajdah,
  sura,
  juz,
  headerBox,
  sideBoxHalf,
  sideBoxFull,
  bismillah,
  bismillahSimple,
  ayah,
  labelTitle,
  ornament,
  bismillahDefault
}

final glyphTypeValues = EnumValues({
  "word": GlyphType.word,
  "end": GlyphType.end,
  "pause": GlyphType.pause,
  "hizb": GlyphType.hizb,
  "sajdah": GlyphType.sajdah,
  "sura": GlyphType.sura,
  "juz": GlyphType.juz,
  "header-box": GlyphType.headerBox,
  "side-box-half": GlyphType.sideBoxHalf,
  "side-box-full": GlyphType.sideBoxFull,
  "bismillah": GlyphType.bismillah,
  "bismillah-simple": GlyphType.bismillahSimple,
  "ayah": GlyphType.ayah,
  "label-title": GlyphType.labelTitle,
  "ornament": GlyphType.ornament,
  "bismillah-default": GlyphType.bismillahDefault,
});

enum LineType { sura, ayah, bismillah }

final lineTypeValues = EnumValues({"sura": LineType.sura, "ayah": LineType.ayah, "bismillah": LineType.bismillah});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
