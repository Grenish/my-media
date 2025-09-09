import 'package:flutter/material.dart';
import 'dart:ui' show ImageFilter;
import 'components/bottom_nav_item.dart';
import 'screens/post_home_screen.dart';
import 'screens/discover_screen.dart';
import 'screens/friends_screen.dart';
import 'screens/profile_screen.dart';

void main() => runApp(const MyMediaApp());

class MyMediaApp extends StatelessWidget {
  const MyMediaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyMedia',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),
      home: const MainShell(),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  static const double _kNavMargin = 50;
  static const double _kNavSide = 16;

  int _currentIndex = 0;

  late final List<Widget> _pages = const [
    PostHomeScreen(),
    DiscoverScreen(),
    FriendScreen(),
    _CenterPlaceholder(title: 'Messages'),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final mq = MediaQuery.of(context);
    final isKeyboardOpen = mq.viewInsets.bottom > 0; // hide bar while typing

    return Scaffold(
      // extendBody lets content draw behind the floating bar
      extendBody: true,
      appBar: _currentIndex == 0
          ? AppBar(
              backgroundColor: cs.surface,
              centerTitle: false,
              title: Text(
                'MyMedia',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.2,
                  fontSize: 15,
                ),
              ),
              actions: [
                IconButton(
                  tooltip: 'Settings',
                  icon: const Icon(Icons.settings_rounded),
                  iconSize: 20,
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Settings tapped')),
                    );
                  },
                ),
              ],
            )
          : null,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Edge-to-edge content. No SafeArea, no extra padding.
          IndexedStack(index: _currentIndex, children: _pages),

          // Floating glassy nav (overlay). Ignores any safe area.
          Positioned(
            left: _kNavSide,
            right: _kNavSide,
            bottom: _kNavMargin,
            child: AnimatedSlide(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOutCubic,
              offset: isKeyboardOpen ? const Offset(0, 1) : Offset.zero,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 150),
                curve: Curves.easeOut,
                opacity: isKeyboardOpen ? 0 : 1,
                child: IgnorePointer(
                  ignoring: isKeyboardOpen,
                  child: GlassBottomNavBar(
                    currentIndex: _currentIndex,
                    onTap: (i) => setState(() => _currentIndex = i),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GlassBottomNavBar extends StatelessWidget {
  const GlassBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(32), // pill shape
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18), // frosted blur
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                cs.surface.withOpacity(0.60),
                cs.surface.withOpacity(0.32),
              ],
            ),
            border: Border.all(
              color: cs.outlineVariant.withOpacity(0.55),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Material(
            type: MaterialType.transparency,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  for (int i = 0; i < bottomNavItems.length; i++)
                    Expanded(
                      child: _NavButton(
                        index: i,
                        currentIndex: currentIndex,
                        onTap: onTap,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.index,
    required this.currentIndex,
    required this.onTap,
  });

  final int index;
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isActive = index == currentIndex;

    return InkWell(
      onTap: () => onTap(index),
      borderRadius: BorderRadius.circular(24),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isActive ? cs.primary.withOpacity(0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Icon(
          isActive
              ? bottomNavItems[index].activeIcon
              : bottomNavItems[index].icon,
          size: isActive ? 28 : 26,
          color: isActive ? cs.primary : cs.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _CenterPlaceholder extends StatelessWidget {
  const _CenterPlaceholder({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    final style =
        Theme.of(context).textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: -0.2,
        ) ??
        const TextStyle(fontSize: 28, fontWeight: FontWeight.w700);

    return Center(child: Text(title, style: style));
  }
}
