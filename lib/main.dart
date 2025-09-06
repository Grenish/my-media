import 'package:flutter/material.dart';

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
  int _currentIndex = 0;

  static const List<_NavItem> _tabs = [
    _NavItem(label: 'Home', icon: Icons.home),
    _NavItem(label: 'Search', icon: Icons.search),
    _NavItem(label: 'Notifications', icon: Icons.notifications),
    _NavItem(label: 'Messages', icon: Icons.message),
    _NavItem(label: 'Profile', icon: Icons.person),
  ];

  late final List<Widget> _pages = _tabs
      .map((t) => TabPlaceholder(title: t.label))
      .toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MyMedia')),
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex, // preserves state per tab
          children: _pages,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: [
          for (final item in _tabs)
            BottomNavigationBarItem(
              icon: Icon(item.icon),
              label: item.label,
            ),
        ],
      ),
    );
  }
}

class TabPlaceholder extends StatelessWidget {
  const TabPlaceholder({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: -0.2,
        ) ??
        const TextStyle(fontSize: 28, fontWeight: FontWeight.w700);

    return Center(child: Text(title, style: style));
  }
}

class _NavItem {
  final String label;
  final IconData icon;
  const _NavItem({required this.label, required this.icon});
}