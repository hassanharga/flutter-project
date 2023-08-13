import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../../shared/constants/assets_manager.dart';
import '../../../shared/utils/utils.dart';
import '../../../shared/widgets/widgets.dart';
import '../../azkar/screens/azkar_screen.dart';
import '../../home/screens/home_screen.dart';
import '../../library/screens/view/library_screen.dart';
import '../../more/screens/more_screen.dart';
import '../../quran/presentation/screens/quran_screen.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _currentIndex = 0;
  final _activeColorPrimary = AppColors.primaryColor;
  final _inactiveColorPrimary = AppColors.grayColor2;

  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  void _navigateToTab(int index) {
    _controller.jumpToTab(index);
    setState(() {
      _currentIndex = index;
    });
  }

  Color _getColor(int idx, [bool isQuran = false]) {
    const yellowColor = AppColors.yellowColor;
    return isQuran && _currentIndex == idx
        ? yellowColor
        : _currentIndex == idx
            ? _activeColorPrimary
            : _inactiveColorPrimary;
  }

  PersistentBottomNavBarItem _navItem(String label, String icon, int idx) {
    return PersistentBottomNavBarItem(
      icon: SizedBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            DynamicIcon(
              icon,
              color: _getColor(idx, idx == 2),
              size: 23,
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: _getColor(idx, idx == 2),
                decorationThickness: 0,
                fontFamily: 'STCForward',
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
      activeColorPrimary: _activeColorPrimary,
      inactiveColorPrimary: _inactiveColorPrimary,
    );
  }

  @override
  Widget build(BuildContext context) {
    final br = Theme.of(context).brightness;
    Color bgColor = Colors.white;
    if (br == Brightness.dark) {
      bgColor = Colors.grey[900]!;
    }
    // const bgColor = br == Brightness.light ? Colors.white : Colors.grey[700];
    return PersistentTabView(
      context,
      controller: _controller,
      confineInSafeArea: true,
      backgroundColor: bgColor, // Default is Colors.white.
      handleAndroidBackButtonPress: true, // Default is true.
      // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
      resizeToAvoidBottomInset: true,
      stateManagement: true, // Default is true.
      // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
      hideNavigationBarWhenKeyboardShows: true,
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(0),
        colorBehindNavBar: bgColor,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      // Navigation Bar's items animation properties.
      itemAnimationProperties: const ItemAnimationProperties(
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: const ScreenTransitionAnimation(
        // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle: NavBarStyle.style15,
      onItemSelected: (value) {
        setState(() {
          _currentIndex = value;
        });
      },
      items: [
        _navItem(translate(context).main, ImgAssets.home, 0),
        _navItem(translate(context).audioLib, ImgAssets.headphones, 1),
        _navItem(translate(context).quran, ImgAssets.quran, 2),
        _navItem(translate(context).azkarak, ImgAssets.azkar, 3),
        _navItem(translate(context).more, ImgAssets.moreHorizontalCircle, 4),
      ],
      screens: [
        HomeScreen(navigateToTab: (index) => _navigateToTab(index)),
        const LibraryScreen(),
        const QuranScreen(),
        const AzkarScreen(),
        const MoreScreen()
      ],
      popAllScreensOnTapAnyTabs: true,
    );
  }
}
