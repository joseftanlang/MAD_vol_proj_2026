import 'package:flutter/material.dart';

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed, // IMPORTANT for more than 3 items
      backgroundColor: Colors.blueAccent,

      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white70,

      selectedFontSize: 14,
      unselectedFontSize: 12,

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
          icon: Icon(Icons.qr_code_scanner_rounded),
          label: 'QR Code',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.menu_book_sharp),
          label: 'EDucation',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          label: 'Donation',
        ),
      ],
      onTap: (i) {
        switch (i) {
          case 0:
            Navigator.pushNamed(context, '/home');
            break;
          case 1:
            Navigator.pushNamed(context, '/volunteer');
            break;
          case 2:
            Navigator.pushNamed(context, '/qrcode');
            break;
          case 3:
            Navigator.pushNamed(context, '/education');
            break;
        }
      },
    );
  }
}
