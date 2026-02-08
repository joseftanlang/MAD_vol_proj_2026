import 'package:flutter/material.dart';
import 'package:final_project_flutter/l10n/app_localizations.dart';

class DrawerNav extends StatelessWidget {
  const DrawerNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text(
              AppLocalizations.of(context)!.drawerHeader,
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          _drawerItem(context, Icons.home, AppLocalizations.of(context)!.drawerHome, '/home'),
          _drawerItem(context, Icons.group, AppLocalizations.of(context)!.drawerAboutUs, '/aboutus'),
          _drawerItem(context, Icons.volunteer_activism, AppLocalizations.of(context)!.drawerVolunteer, '/volunteer'),
          _drawerItem(context, Icons.menu_book_sharp, AppLocalizations.of(context)!.drawerTraining, '/training'),
          _drawerItem(context, Icons.lock_clock, AppLocalizations.of(context)!.drawerLegal, '/legalservice'),
          _drawerItem(context, Icons.favorite_sharp, AppLocalizations.of(context)!.drawerDonation, '/donation'),
          _drawerItem(context, Icons.qr_code, AppLocalizations.of(context)!.drawerQrCode, '/qrcode'),
          _drawerItem(context, Icons.settings, AppLocalizations.of(context)!.drawerSettings, '/settings'),
          _drawerItem(context, Icons.accessibility, AppLocalizations.of(context)!.drawerAccessibility, '/accessibility'),
          _drawerItem(context, Icons.chat_bubble_outline, AppLocalizations.of(context)!.drawerChatbot, '/chatbot'),
          _drawerItem(context, Icons.login, AppLocalizations.of(context)!.drawerLogout, '/login'),
          _drawerItem(context, Icons.location_on, AppLocalizations.of(context)!.drawerLocationTracker, '/locationtrack'),
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