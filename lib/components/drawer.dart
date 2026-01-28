import 'package:flutter/material.dart';

class DrawerNav extends StatelessWidget {
  const DrawerNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text(
              'Navigation Menu',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          _drawerItem(context, Icons.home, 'Home', '/'),
          _drawerItem(context, Icons.group, 'About us', '/aboutus'),
          _drawerItem(context, Icons.volunteer_activism, 'Volunteer', '/volunteer'),
          _drawerItem(context, Icons.menu_book_sharp, 'Training', '/training'),
          _drawerItem(context, Icons.lock_clock, 'Legal', '/legalservice'),
          _drawerItem(context, Icons.favorite_sharp, 'Donation', '/donation'),
          _drawerItem(context, Icons.qr_code, 'QR code', '/qrcode'),
          _drawerItem(context, Icons.settings, 'Setting', '/settings'),
          _drawerItem(context, Icons.accessibility, 'Accessibility', '/accessibility'),
          _drawerItem(context, Icons.login, 'Log out', '/login'),
        ],
      ),
    );
  }

  ListTile _drawerItem(
    BuildContext context,
    IconData icon,
    String title,
    String route,
  ) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        Navigator.pushNamedAndRemoveUntil(
          context,
          route,
          (route) => false,
        );
      },
    );
  }
}
