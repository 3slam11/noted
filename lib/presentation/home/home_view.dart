import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:noted/app/app_events.dart';
import 'package:noted/app/app_prefs.dart';
import 'package:noted/app/di.dart';
import 'package:noted/gen/strings.g.dart';
import 'package:noted/presentation/history/history_view.dart';
import 'package:noted/presentation/main/main_view.dart';
import 'package:noted/presentation/search/search_view.dart';
import 'package:noted/presentation/saved/saved_view.dart';
import 'package:noted/presentation/settings/settings_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with SingleTickerProviderStateMixin {
  int _bottomNavIndex = 0;
  late final AnimationController _hideBottomBarAnimationController;

  // Track scroll state to prevent redundant animations
  bool _isBottomBarVisible = true;
  bool _isAnimating = false;
  bool _showFilterToggle = true;

  final AppPrefs _appPrefs = instance<AppPrefs>();
  final DataGlobalNotifier _dataGlobalNotifier = instance<DataGlobalNotifier>();

  // GlobalKeys to trigger QOL actions on active tabs
  late final GlobalKey<MainViewState> _mainKey = GlobalKey();
  late final GlobalKey<SearchViewState> _searchKey = GlobalKey();
  late final GlobalKey<SavedViewState> _savedKey = GlobalKey();
  late final GlobalKey<HistoryViewState> _historyKey = GlobalKey();

  late final List<Widget> _pages = [
    MainView(key: _mainKey),
    SearchView(key: _searchKey),
    SavedView(key: _savedKey),
    HistoryView(key: _historyKey),
    const SettingsView(),
  ];

  static const List<IconData> _pageIcons = [
    Icons.home_filled,
    Icons.search_rounded,
    Icons.bookmark_rounded,
    Icons.history_rounded,
    Icons.settings_rounded,
  ];

  @override
  void initState() {
    super.initState();
    _hideBottomBarAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
      reverseDuration: const Duration(milliseconds: 200),
    );

    _hideBottomBarAnimationController.addStatusListener(_handleAnimationStatus);
    _loadSettings();
    _dataGlobalNotifier.addListener(_loadSettings);
  }

  void _loadSettings() async {
    final showToggle = await _appPrefs.getShowFilterToggle();
    if (mounted) {
      setState(() {
        _showFilterToggle = showToggle;
      });
    }
  }

  void _handleAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed ||
        status == AnimationStatus.dismissed) {
      setState(() {
        _isAnimating = false;
      });
    }
  }

  void _handleScrollNotification(ScrollNotification notification) {
    if (_isAnimating) return;

    if (notification is UserScrollNotification) {
      final direction = notification.direction;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;

        if (direction == ScrollDirection.reverse && _isBottomBarVisible) {
          setState(() {
            _isBottomBarVisible = false;
            _isAnimating = true;
          });
          _hideBottomBarAnimationController.forward();
        } else if (direction == ScrollDirection.forward &&
            !_isBottomBarVisible) {
          setState(() {
            _isBottomBarVisible = true;
            _isAnimating = true;
          });
          _hideBottomBarAnimationController.reverse();
        }
      });
    }
  }

  @override
  void dispose() {
    _dataGlobalNotifier.removeListener(_loadSettings);
    _hideBottomBarAnimationController.removeStatusListener(
      _handleAnimationStatus,
    );
    _hideBottomBarAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final pageTitles = [
      t.home.home,
      t.search.search,
      t.home.savedList,
      t.history.history,
      t.settings.settings,
    ];

    return Scaffold(
      backgroundColor: colorScheme.primaryContainer,
      extendBody: true, // Crucial for the glass effect to show content behind
      appBar: AppBar(
        title: Text(pageTitles[_bottomNavIndex]),
        actions: [
          if (_showFilterToggle &&
              (_bottomNavIndex == 0 ||
                  _bottomNavIndex == 2 ||
                  _bottomNavIndex == 3))
            IconButton(
              icon: const Icon(Icons.filter_list_rounded),
              tooltip: t.sort.sort,
              onPressed: () {
                if (_bottomNavIndex == 0) {
                  _mainKey.currentState?.toggleFilter();
                } else if (_bottomNavIndex == 2) {
                  _savedKey.currentState?.toggleFilter();
                } else if (_bottomNavIndex == 3) {
                  _historyKey.currentState?.toggleFilter();
                }
              },
            ),
        ],
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          _handleScrollNotification(notification);
          return false;
        },
        child: IndexedStack(index: _bottomNavIndex, children: _pages),
      ),
      bottomNavigationBar: AnimatedBuilder(
        animation: _hideBottomBarAnimationController,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _hideBottomBarAnimationController.value * 120),
            child: child,
          );
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 24.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(32),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
              child: Container(
                decoration: BoxDecoration(
                  // transparent surface color to let the blur show through
                  color: colorScheme.surface.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(
                    color: colorScheme.outline.withValues(alpha: 0.1),
                    width: 1.5,
                  ),
                ),
                child: SafeArea(
                  top: false,
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(
                        _pages.length,
                        (index) => Expanded(
                          child: _NavigationBarItem(
                            icon: _pageIcons[index],
                            label: pageTitles[index],
                            isActive: _bottomNavIndex == index,
                            onTap: () {
                              if (_bottomNavIndex == index) {
                                // QOL: Trigger actions when tapping the active tab
                                switch (index) {
                                  case 0:
                                    _mainKey.currentState?.scrollToTop();
                                    break;
                                  case 1:
                                    _searchKey.currentState?.focusSearchField();
                                    break;
                                  case 2:
                                    _savedKey.currentState?.scrollToTop();
                                    break;
                                  case 3:
                                    _historyKey.currentState?.scrollToTop();
                                    break;
                                }
                              } else {
                                setState(() => _bottomNavIndex = index);
                              }
                            },
                            activeColor: colorScheme.primary,
                            inactiveColor: colorScheme.onSurface.withValues(
                              alpha: 0.6,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavigationBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final Color activeColor;
  final Color inactiveColor;

  const _NavigationBarItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
    required this.activeColor,
    required this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? activeColor : inactiveColor;
    final theme = Theme.of(context);

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        splashColor: activeColor.withValues(alpha: 0.1),
        highlightColor: activeColor.withValues(alpha: 0.05),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                transform: Matrix4.diagonal3Values(
                  isActive ? 1.15 : 1.0,
                  isActive ? 1.15 : 1.0,
                  isActive ? 1.15 : 1.0,
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: 4),
              Flexible(
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style:
                      theme.textTheme.bodySmall?.copyWith(
                        color: color,
                        fontWeight: isActive
                            ? FontWeight.w700
                            : FontWeight.w500,
                        fontSize: isActive ? 12 : 11,
                      ) ??
                      TextStyle(color: color, fontSize: 12),
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
