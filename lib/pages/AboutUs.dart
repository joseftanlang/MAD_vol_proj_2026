import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../components/AppBar.dart';
import '../components/BottomNav.dart';
import 'QRpage.dart';

class AboutUs extends StatelessWidget {
  // Helper method to launch URLs
  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.black,
      appBar: CustomAppBar(scaffoldKey: _scaffoldKey),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 3,
        scaffoldKey: _scaffoldKey,
        onTap: (index) {
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => QRPage(userId: 'user-123'),
              ),
            );
          }
        },
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            // Logo or Avatar
            CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(
                'https://images.unsplash.com/photo-1503023345310-bd7c1de61c7d?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
              ),
            ),
            SizedBox(height: 20),
            // Organization Name
            Text(
              'LearnHub Academy',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            SizedBox(height: 10),
            // Tagline or Mission Statement
            Text(
              'Empowering Learners Worldwide',
              style: TextStyle(fontSize: 18, color: Colors.grey[700]),
            ),
            SizedBox(height: 20),
            // About Section
            Text(
              'At LearnHub, we believe that education is the key to a brighter future. Our platform offers a wide range of courses and training programs designed to help you achieve your goals. Whether you want to improve your skills or explore new passions, we are here to support you every step of the way.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 30),
            // Our Vision & Mission
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      'Our Vision & Mission',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'To make quality education accessible to everyone, everywhere. We strive to create an engaging and inclusive learning environment that inspires growth and innovation.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30),
            // Contact Info
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Contact Us',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                SizedBox(height: 10),
                ListTile(
                  leading: Icon(Icons.email, color: Colors.deepPurple),
                  title: Text('contact@learnhub.com'),
                ),
                ListTile(
                  leading: Icon(Icons.phone, color: Colors.deepPurple),
                  title: Text('+1 234 567 8900'),
                ),
                ListTile(
                  leading: Icon(Icons.location_on, color: Colors.deepPurple),
                  title: Text('123 Learning St, Education City'),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Social Media Links
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.facebook, color: Colors.blue),
                  onPressed: () => _launchURL('https://facebook.com/learnhub'),
                ),
              ],
            ),
            SizedBox(height: 30),
            // Footer
            Text(
              '© 2024 LearnHub Academy. All rights reserved.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}