import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rateel/features/quran/presentation/providers/page_glyphs_repositry_provider.dart';
import 'package:rateel/features/quran/presentation/providers/pages_repositry_provider.dart';
import 'package:rateel/shared/utils/app_colors.dart';

import '../../../../shared/constants/assets_manager.dart';
import '../../../../shared/utils/fonts_mapper.dart';
import '../../../../shared/utils/screen_sizes.dart';
import '../../data/model/glyph.dart';
import '../../data/model/quran_page.dart';
import '../../data/repositories/page_glyphs_repository.dart';
import '../../data/repositories/pages_repository.dart';
import '../widgets/rich_text_page.dart';

final pagesProvider = StateNotifierProvider<PagesNotifier, List<QuranPage>>((ref) {
  return PagesNotifier(ref.watch(pagesRepositryProvider), ref.watch(pageGlyphsRepositryProvider));
});

class PagesNotifier extends StateNotifier<List<QuranPage>> {
  PagesNotifier(this.pageRepository, this.pageGlyphsRepository) : super([]) {
    _loadQuranPages();
  }

  PagesRepository pageRepository;
  PageGlyphsRepository pageGlyphsRepository;

  late List<QuranPage> pages;

  Future<void> _loadQuranPages() async {
    pages = await pageRepository.loadQuranPages();

    for (QuranPage page in pages) {
      final List<Glyph> glyphs = await pageGlyphsRepository.loadPageGlyphsFromJsonFile(pageNo: page.pageNumber);
      List<InlineSpan> spans = _buildTextSpansFromGlyphs(glyphs: glyphs);

      page.glyphs = glyphs;
      page.spans = spans;
      page.richTextPage = RichTextPage(pageNumber: page.pageNumber, spans: page.spans);
    }

    state = pages;
  }

  List<InlineSpan> _buildTextSpansFromGlyphs({required List<Glyph> glyphs}) {
    List<InlineSpan> textSpans = [];
    int lineNo = 1; //every page start with line number 1
    int surahNameWords = 0;
    late Glyph surahGlyph; //'سورة'

    for (Glyph glyph in glyphs) {
      if (glyph.glyphType == GlyphType.sura) {
        surahNameWords++;
        if (surahNameWords == 1) {
          // only first time to store سورة word
          surahGlyph = glyph;
        }
      }

      TextSpan wordSpan = TextSpan(
        text: glyph.glyphType != GlyphType.sura ? glyph.glyphChar : null,
        style: TextStyle(
          fontFamily: fontFileToFamily[glyph.fontFile.toLowerCase()],
          backgroundColor: glyph.isHighlighted ? AppColors.ayahHighlightColor : null,
        ),
        children: glyph.glyphType == GlyphType.sura && surahNameWords % 2 == 0 // skip سورة word
            ? [
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(ImgAssets.surahNameFrame),
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    child: Text(
                      surahGlyph.glyphChar + glyph.glyphChar,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: fontFileToFamily[glyph.fontFile.toLowerCase()],
                        fontSize: ScreenSize.width / ScreenSize.fontRatioQuranWords,
                      ),
                    ),
                  ),
                ),
              ]
            : null,
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            // skip tap on sura line and bismillah
            if (glyph.glyphType != GlyphType.sura &&
                glyph.glyphType != GlyphType.bismillahSimple &&
                glyph.glyphType != GlyphType.bismillahDefault) {
              glyphs.map((g) {
                g.isHighlighted = g.ayahNumber == glyph.ayahNumber && g.suraNumber == glyph.suraNumber ? true : false;
              }).toList();

              List<InlineSpan> spans = _buildTextSpansFromGlyphs(glyphs: glyphs);
              pages[glyph.pageNumber - 1].spans = spans;
              pages[glyph.pageNumber - 1].richTextPage =
                  RichTextPage(pageNumber: glyph.pageNumber, spans: pages[glyph.pageNumber - 1].spans);

              state = pages.map((e) => e).toList();
            }
          },
      );

      if (glyph.lineNumber != lineNo) {
        textSpans.add(const TextSpan(text: '\n'));
        lineNo = glyph.lineNumber;
      }

      textSpans.add(wordSpan);
    }

    return textSpans;
  }

  void _highlightAyah({required int pageNumber, required int surahNumber, required int ayahNumber}) {
    pages[pageNumber - 1].glyphs.map((glyph) {
      glyph.isHighlighted = glyph.suraNumber == surahNumber && glyph.ayahNumber == ayahNumber;
    });

    state = pages.map((page) => page).toList();
  }

  void clearHightlight({required int pageNumber}) {
    // List<Glyph> glyphs = pages[pageNumber - 1].glyphs.map((glyph) {
    //   glyph.isHighlighted = false;
    //   return glyph;
    // }).toList();

    pages[pageNumber - 1].glyphs.map((glyph) {
      glyph.isHighlighted = false;
    });

    List<InlineSpan> spans = _buildTextSpansFromGlyphs(glyphs: pages[pageNumber - 1].glyphs);
    pages[pageNumber - 1].spans = spans;
    pages[pageNumber - 1].richTextPage = RichTextPage(pageNumber: pageNumber, spans: pages[pageNumber].spans);

    state = pages.map((page) => page).toList();
  }
}
