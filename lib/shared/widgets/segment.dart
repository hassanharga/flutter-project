import 'package:flutter/material.dart';

import '../../../shared/constants/constants.dart';
import '../../../shared/utils/utils.dart';

class AppSegment extends StatelessWidget {
  final List<Tab> tabs;
  final List<Widget> tabsPages;
  final bool? shouldScroll;
  final Function(int index)? onTap;

  const AppSegment(
      {super.key,
      required this.tabs,
      required this.tabsPages,
      this.shouldScroll,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Column(
        children: [
          // tabs
          TabBar(
            indicatorColor: AppColors.primaryColor,
            labelColor: AppColors.primaryColor,
            unselectedLabelColor: AppColors.grayColor5,
            labelStyle: const TextStyle(
              color: AppColors.primaryColor,
              fontSize: 15,
              fontFamily: FONT_FAMILY,
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            isScrollable: shouldScroll ?? false,
            onTap: onTap,
            tabs: tabs,
          ),
          // tabs pages
          Expanded(
            child: TabBarView(
              children: tabsPages,
            ),
          ),
        ],
      ),
    );
  }
}
