import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap, required GlobalKey<ScaffoldState> scaffoldKey,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.volunteer_activism),
          label: 'Volunteer',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.qr_code),
          label: 'WR Code',
          
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.school),
          label: 'Training',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          label: 'Donation',
        ),
      ],
    );
  }
}
