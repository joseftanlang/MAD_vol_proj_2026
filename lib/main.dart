import 'package:flutter/material.dart';
import 'components/AppBar.dart';
import 'components/BottomNav.dart';
import 'pages/QRpage.dart';
import 'pages/SignUp.dart';
import 'pages/Trainingpage.dart';
import 'pages/AboutUs.dart';
import 'pages/DonationPage.dart';
import 'pages/LegalChatService.dart';
import 'pages/Translator.dart';


void main() {
  runApp(MaterialApp(home: MainPage()));
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final List<String> carouselImages = [
    'assets/pic1.jpg',
    'assets/pic2.jpg',
    'assets/pic3.jpg',
    'assets/pic4.jpg',
    'assets/pic5.jpg',
  ];

  final List<String> categories = [
    'All',
    'Environment',
    'Migrant workers',
    'Elderly',
    'Children',
    'Animal',
    'Religious',
  ];

  // Sample data for items with detailed info
  final List<Map<String, String>> items = [
    {
      'name': 'Beach Cleanup',
      'category': 'Environment',
      'description': 'Join us to clean the beach.',
      'date': '2024-12-01',
      'time': '10:00 AM',
      'location': 'Beach Side Park',
      'image': 'assets/pic1.jpg',
      'link': 'https://example.com/event1',
    },
    {
      'name': 'Support Migrant Workers',
      'category': 'Migrant workers',
      'description': 'Help us support migrant workers.',
      'date': '2024-11-20',
      'time': '2:00 PM',
      'location': 'Community Center',
      'image': 'assets/pic2.jpg',
      'link': 'https://example.com/event2',
    },
    {
      'name': 'Elderly Care Program',
      'category': 'Elderly',
      'description': 'Providing care for the elderly.',
      'date': '2024-12-05',
      'time': '9:00 AM',
      'location': 'Old Town Hall',
      'image': 'assets/pic3.jpg',
      'link': 'https://example.com/event3',
    },
    // Add more items as needed
  ];

  String selectedCategory = 'All';

  void selectCategory(String category) {
    setState(() {
      selectedCategory = category;
    });
  }

  List<Map<String, String>> get filteredItems {
    if (selectedCategory == 'All') {
      return items;
    } else {
      return items
          .where((item) => item['category'] == selectedCategory)
          .toList();
    }
  }

  void showItemDetails(BuildContext context, Map<String, String> item) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(item['image']!, fit: BoxFit.cover),
              SizedBox(height: 10),
              Text(
                item['name']!,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('Description: ${item['description']}'),
              SizedBox(height: 8),
              Text('Date: ${item['date']}'),
              SizedBox(height: 8),
              Text('Time: ${item['time']}'),
              SizedBox(height: 8),
              Text('Location: ${item['location']}'),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  // You might want to use url_launcher to open links
                  // launch(item['link']!);
                },
                child: Text('More Info'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: scaffoldKey,
      appBar: CustomAppBar(scaffoldKey: scaffoldKey),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(child: Text('Drawer Header')),
            ListTile(
              title: Text('Log Out'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpPage()),
                );
              },
            ),
            ListTile(
              title: Text('About Us'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutUs()),
                );
              },
            ),
            ListTile(
              title: Text('Legal Chat Service'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LegalChatPage()),
                );
              },
            ),
            ListTile(
              title: Text('Translator'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TranslatePage()),
                );
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //Welcome message
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Welcome back, Benedict Low',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            // Image carousel of featured
            Stack(
              children: [
                Container(
                  height: 200,
                  child: PageView.builder(
                    itemCount: carouselImages.length,
                    controller: PageController(viewportFraction: 0.8),
                    itemBuilder: (_, index) {
                      return Padding(
                        padding: EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            carouselImages[index],
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Positioned widget for the "Featured" word
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Featured',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Categories as filter buttons
            Container(
              height: 50,
              margin: EdgeInsets.symmetric(vertical: 10),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (_, index) {
                  String category = categories[index];
                  bool isSelected = category == selectedCategory;
                  return GestureDetector(
                    onTap: () {
                      selectCategory(category);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blue : Colors.grey[300],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          category,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            // Display filtered items
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: filteredItems.length,
              itemBuilder: (_, index) {
                final item = filteredItems[index];
                return GestureDetector(
                  onTap: () => showItemDetails(context, item),
                  child: Container(
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 4)],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Image.asset(item['image']!, width: 80, height: 80),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['name']!,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text('Description of item'),
                                Text('Date & Time'),
                                Text('Location'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 0,
        onTap: (index) {
          // Handle navigation tap
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => QRPage(userId: 'user-unique-id-12345'),
              ),
            );
          }
          else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TrainingPage(),
              ),
            );
          }
          else if (index == 4) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DonationPage(),
              ),
            );
          }
        }, scaffoldKey: scaffoldKey,
      ),
    );
  }
}
