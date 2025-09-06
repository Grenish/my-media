import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class BottomNavItem {
  final String label;
  final IconData icon;
  final IconData activeIcon;

  const BottomNavItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
  });
}

const List<BottomNavItem> bottomNavItems = [
  BottomNavItem(
    label: 'Home',
    icon: LucideIcons.home,
    activeIcon: LucideIcons.home,
  ),
  BottomNavItem(
    label: 'Search',
    icon: LucideIcons.compass,
    activeIcon: LucideIcons.compass,
  ),

  BottomNavItem(
    label: 'Friends',
    icon: LucideIcons.users,
    activeIcon: LucideIcons.users,
  ),
  BottomNavItem(
    label: 'Messages',
    icon: LucideIcons.send,
    activeIcon: LucideIcons.send,
  ),
  BottomNavItem(
    label: 'Profile',
    icon: LucideIcons.user,
    activeIcon: LucideIcons.user,
  ),
];
