import 'package:flutter/material.dart';
import 'package:final_project_flutter/l10n/app_localizations.dart';

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

      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.home),
          label: AppLocalizations.of(context)!.bottomNavHome,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.volunteer_activism),
          label: AppLocalizations.of(context)!.bottomNavVolunteer,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.qr_code_scanner_rounded),
          label: AppLocalizations.of(context)!.bottomNavQrCode,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.menu_book_sharp),
          label: AppLocalizations.of(context)!.bottomNavEducation,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.favorite),
          label: AppLocalizations.of(context)!.bottomNavDonation,
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
            Navigator.pushNamed(context, '/training');
            break;
          case 4:
            Navigator.pushNamed(context, '/donation');
            break;
        }
      },
    );
  }
}