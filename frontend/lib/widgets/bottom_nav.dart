import 'package:flutter/material.dart';
import '../constants/colors.dart';

class BottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNav({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.voidNavy.withAlpha((0.95 * 255).round()),
        border: const Border(
          top: BorderSide(color: AppColors.holoCyan, width: 0.5),
        ),
      ),
      child: SafeArea(
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onTap,
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.holoCyan,
          unselectedItemColor: AppColors.mutedAsh,
          selectedLabelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(fontSize: 10),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined, size: 22),
              activeIcon: Icon(Icons.home, size: 22),
              label: 'HOME',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.track_changes_outlined, size: 22),
              activeIcon: Icon(Icons.track_changes, size: 22),
              label: 'QUESTS',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.store_outlined, size: 22),
              activeIcon: Icon(Icons.store, size: 22),
              label: 'STORE',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.group_outlined, size: 22),
              activeIcon: Icon(Icons.group, size: 22),
              label: 'GUILD',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline, size: 22),
              activeIcon: Icon(Icons.person, size: 22),
              label: 'PROFILE',
            ),
          ],
        ),
      ),
    );
  }
}
