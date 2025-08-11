import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BottomNavWidget extends StatefulWidget {
  final Function(int) onTabSelected;
  final int selectedIndex;

  const BottomNavWidget({
    super.key,
    required this.onTabSelected,
    required this.selectedIndex,
  });

  @override
  State<BottomNavWidget> createState() => _BottomNavWidgetState();
}

class _BottomNavWidgetState extends State<BottomNavWidget> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Color(0xff42c83c),
      currentIndex: widget.selectedIndex,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white70,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_rounded),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          label: 'Favorites',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
      onTap: (index) {
        widget.onTabSelected(index); // Call parent function to update screen
      },
    );
  }
}
