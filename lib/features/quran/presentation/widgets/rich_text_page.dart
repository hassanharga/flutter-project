import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:flutter/material.dart';

import '../../../../shared/utils/app_colors.dart';
import '../../../../shared/utils/screen_sizes.dart';

class RichTextPage extends StatefulWidget {
  final List<InlineSpan> spans;
  final int pageNumber;

  const RichTextPage({super.key, required this.pageNumber, required this.spans});

  @override
  State<RichTextPage> createState() => _RichTextPageState();
}

class _RichTextPageState extends State<RichTextPage> {
  @override
  Widget build(BuildContext context) {
    final arabicNumber = ArabicNumbers();

    return CustomScrollView(slivers: [
      SliverFillRemaining(
        hasScrollBody: false,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Juz number and surah name at top
            Container(
              padding: const EdgeInsets.only(
                left: 25,
                right: 25,
                top: 5,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "الجزء الأول",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: AppColors.quranSurahNameJuzNumberColor,
                        fontSize: ScreenSize.width / ScreenSize.fontRatioQuranSurahNameJuzNumber,
                        fontFamily: 'KFGQPC HAFS Uthmanic Script',
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "الجزء الأول",
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        color: AppColors.quranSurahNameJuzNumberColor,
                        fontSize: ScreenSize.width / ScreenSize.fontRatioQuranSurahNameJuzNumber,
                        fontFamily: 'KFGQPC HAFS Uthmanic Script',
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // page words
            RichText(
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
              text: TextSpan(
                style: TextStyle(
                  color: AppColors.quranWordColor,
                  fontSize: ScreenSize.width / ScreenSize.fontRatioQuranWords,
                ),
                children: widget.spans,
              ),
            ),

            // page number at bottom
            Container(
              padding: const EdgeInsets.only(left: 25, right: 25),
              alignment: widget.pageNumber % 2 == 1 ? Alignment.centerRight : Alignment.bottomLeft,
              child: Text(
                arabicNumber.convert(widget.pageNumber),
                style: TextStyle(
                  color: AppColors.quranPageNumberColor,
                  fontSize: ScreenSize.width / ScreenSize.fontRatioQuranPageNumber,
                  //fontFamily: 'KFGQPC HAFS Uthmanic Script',
                ),
              ),
            ),
          ],
        ),
      ),
    ]);
  }
}
