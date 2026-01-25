import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'DonationDetailPage.dart';

class DonationPage extends StatelessWidget {
  const DonationPage({super.key});

  final List<Map<String, dynamic>> categories = const [
    {
      "title": "Education",
      "icon": Icons.school,
      "color": Color(0xFF6A5AE0),
    },
    {
      "title": "Healthcare",
      "icon": Icons.local_hospital,
      "color": Color(0xFFE85D75),
    },
    {
      "title": "Environment",
      "icon": Icons.eco,
      "color": Color(0xFF2EC4B6),
    },
    {
      "title": "Disaster Relief",
      "icon": Icons.volunteer_activism,
      "color": Color(0xFFFF9F1C),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        title: Text(
          "Donate",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: GridView.builder(
          itemCount: categories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemBuilder: (context, index) {
            final item = categories[index];

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DonationDetailPage(
                      cause: item["title"],
                      color: item["color"],
                    ),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: LinearGradient(
                    colors: [
                      item["color"],
                      item["color"].withOpacity(0.6),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(item["icon"], size: 48, color: Colors.white),
                    const SizedBox(height: 12),
                    Text(
                      item["title"],
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              )
                  .animate()
                  .fadeIn(duration: 500.ms)
                  .slideY(begin: 0.3),
            );
          },
        ),
      ),
    );
  }
}
