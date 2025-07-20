import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:noted/gen/strings.g.dart';
import 'package:noted/presentation/history/view/history_view.dart';
import 'package:noted/presentation/main/view/main_view.dart';
import 'package:noted/presentation/search/view/search_view.dart';
import 'package:noted/presentation/settings/view/settings_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  int _bottomNavIndex = 0;
  late final AnimationController _hideBottomBarAnimationController;

  late final List<Widget> _pages;
  late final List<IconData> _pageIcons;

  @override
  void initState() {
    super.initState();
    _hideBottomBarAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
      reverseDuration: const Duration(milliseconds: 200),
    );

    _pages = const [MainView(), SearchView(), HistoryView(), SettingsView()];

    _pageIcons = [
      Icons.home_filled,
      Icons.search_rounded,
      Icons.history_rounded,
      Icons.settings_rounded,
    ];
  }

  @override
  void dispose() {
    _hideBottomBarAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = Translations.of(context);

    final pageTitles = [
      t.appName,
      t.search.search,
      t.history.history,
      t.settings.settings,
    ];

    return Scaffold(
      backgroundColor: theme.colorScheme.primaryContainer,
      appBar: AppBar(
        title: Text(pageTitles[_bottomNavIndex]),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
      ),
      body: NotificationListener<UserScrollNotification>(
        onNotification: (notification) {
          if (notification.direction == ScrollDirection.reverse &&
              _hideBottomBarAnimationController.isDismissed) {
            _hideBottomBarAnimationController.forward();
          } else if (notification.direction == ScrollDirection.forward &&
              _hideBottomBarAnimationController.isCompleted) {
            _hideBottomBarAnimationController.reverse();
          }
          return true;
        },
        child: IndexedStack(index: _bottomNavIndex, children: _pages),
      ),
      bottomNavigationBar: AnimatedBottomNavigationBar.builder(
        leftCornerRadius: 32,
        rightCornerRadius: 32,

        itemCount: _pages.length,
        tabBuilder: (int index, bool isActive) {
          final color = isActive
              ? theme.colorScheme.primary
              : theme.colorScheme.onSurface.withValues(alpha: 0.6);
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(_pageIcons[index], color: color),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  pageTitles[index],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(color: color),
                ),
              ),
            ],
          );
        },
        activeIndex: _bottomNavIndex,
        onTap: (index) => setState(() => _bottomNavIndex = index),
        hideAnimationController: _hideBottomBarAnimationController,
        backgroundColor: theme.colorScheme.surface,
        gapLocation: GapLocation.none,
        notchSmoothness: NotchSmoothness.smoothEdge,
      ),
    );
  }
}
