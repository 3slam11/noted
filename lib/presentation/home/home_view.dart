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
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with SingleTickerProviderStateMixin {
  int _bottomNavIndex = 0;
  late final AnimationController _hideBottomBarAnimationController;

  // Track scroll state to prevent redundant animations
  bool _isBottomBarVisible = true;
  bool _isAnimating = false;

  static const List<Widget> _pages = [
    MainView(),
    SearchView(),
    HistoryView(),
    SettingsView(),
  ];

  static const List<IconData> _pageIcons = [
    Icons.home_filled,
    Icons.search_rounded,
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

    // Listen to animation status to track when animations complete
    _hideBottomBarAnimationController.addStatusListener(_handleAnimationStatus);
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
      t.appName,
      t.search.search,
      t.history.history,
      t.settings.settings,
    ];

    return Scaffold(
      backgroundColor: colorScheme.primaryContainer,
      extendBody: true,
      appBar: AppBar(title: Text(pageTitles[_bottomNavIndex])),
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
            offset: Offset(0, _hideBottomBarAnimationController.value * 100),
            child: child,
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(
                  _pages.length,
                  (index) => Expanded(
                    child: _NavigationBarItem(
                      icon: _pageIcons[index],
                      label: pageTitles[index],
                      isActive: _bottomNavIndex == index,
                      onTap: () => setState(() => _bottomNavIndex = index),
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
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
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
                            ? FontWeight.w600
                            : FontWeight.normal,
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
