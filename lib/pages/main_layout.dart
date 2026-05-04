import 'package:flutter/material.dart';
import 'package:leaper/core/components/scaffold_background.dart';
import 'package:leaper/pages/dashboard/dashboard.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;
  // TODO: Add Notification, News, and Profile Pages
  final _pages = [Dashboard()];
  @override
  Widget build(BuildContext context) {
    return ScaffoldBackground(
      bottomBar: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: Color(0x1D000000),
              blurRadius: 4,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
            selectedItemColor: Color(0xFF454455),
            unselectedItemColor: Color(0xFF454455),
            backgroundColor: Color(0xC7FFFFFF),
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
              BottomNavigationBarItem(
                icon: Icon(Icons.notifications),
                label: "Notification",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: "Profile",
              ),
            ],
          ),
        ),
      ),
      child: _pages[_currentIndex],
    );
  }
}
