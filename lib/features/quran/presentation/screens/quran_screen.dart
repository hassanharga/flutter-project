import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rateel/shared/language/providers/language_provider.dart';

import '../../../../shared/constants/defines.dart';
import '../providers/quran_pages_provider.dart';

class QuranScreen extends StatefulWidget {
  const QuranScreen({super.key});

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  int pageIndex = 600;
  int oldPageIndex = 600;
  late PageController controller;

  @override
  void initState() {
    super.initState();
    controller = PageController(initialPage: pageIndex);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      var pages = ref.watch(pagesProvider);
      var appLanguage = ref.watch(languageProvider);

      return SafeArea(
        child: Container(
          alignment: Alignment.center,
          child: pages.isEmpty
              ? const CircularProgressIndicator()
              : PageView(
                  reverse: appLanguage == ENGLISH ? true : false,
                  controller: controller,
                  onPageChanged: (index) {
                    oldPageIndex = pageIndex;
                    pageIndex = index;
                  },
                  children: pages.map((page) => page.richTextPage).toList(),
                ),
        ),
      );
    });
  }
}
