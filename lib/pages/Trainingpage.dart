import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // for opening links
import '../components/AppBar.dart';
import '../components/BottomNav.dart';
import 'QRpage.dart';
import '../main.dart';

class TrainingPage extends StatefulWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  _TrainingPageState createState() => _TrainingPageState();
}

class _TrainingPageState extends State<TrainingPage> {
  String selectedOption = 'Online';
  String selectedCategory = 'All';

  // Example Data
  final List<Map<String, String>> recommendedClasses = [
    {
      'name': 'Yoga Basics',
      'description': 'Learn the fundamentals of Yoga.',
      'image': 'https://images.unsplash.com/photo-1614107029508-7b2a0c7f7f0f?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      'link': 'https://example.com/yoga'
    },
    {
      'name': 'Cardio Fit',
      'description': 'High intensity cardio workout.',
      'image': 'https://images.unsplash.com/photo-1549924231-f129b911e442?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      'link': 'https://example.com/cardio'
    },
  ];

  final List<Map<String, String>> categories = [
    {'name': 'Tech', 'icon': '💻'},
    {'name': 'Speaking', 'icon': '🎙️'},
    {'name': 'Fitness', 'icon': '🏋️‍♀️'},
    {'name': 'Arts', 'icon': '🎨'},
    {'name': 'Languages', 'icon': '🗣️'},
  ];

  final List<Map<String, String>> allClasses = [
    {
      'name': 'Advanced Yoga',
      'description': 'Deepen your Yoga practice.',
      'link': 'https://example.com/advanced-yoga',
      'category': 'Fitness'
    },
    {
      'name': 'Public Speaking Mastery',
      'description': 'Become a confident speaker.',
      'link': 'https://example.com/speaking',
      'category': 'Speaking'
    },
    {
      'name': 'Tech Workshop',
      'description': 'Latest trends in tech.',
      'link': 'https://example.com/tech',
      'category': 'Tech'
    },
    {
      'name': 'Art Class',
      'description': 'Explore your creativity.',
      'link': 'https://example.com/art',
      'category': 'Arts'
    },
  ];

  List<Map<String, String>> get filteredClasses {
    if (selectedCategory == 'All') return allClasses;
    return allClasses.where((cls) => cls['category'] == selectedCategory).toList();
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open the link')),
      );
    }
  }

  Widget buildClassCard(Map<String, String> classData) {
    return GestureDetector(
      onTap: () => _launchURL(classData['link']!),
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        child: Container(
          padding: EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  'https://images.unsplash.com/photo-1614107029508-7b2a0c7f7f0f?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80', // placeholder
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      classData['name']!,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      classData['description']!,
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCategories() {
    return Container(
      height: 100,
      width: double.infinity,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (_, index) {
          final category = categories[index];
          final isSelected = category['name'] == selectedCategory || (selectedCategory == 'All' && index == 0);
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedCategory = category['name']!;
              });
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? Colors.blueAccent : Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    category['icon']!,
                    style: TextStyle(fontSize: 24),
                  ),
                  SizedBox(height: 4),
                  Text(
                    category['name']!,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildSection(String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Text(
          title,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
        ),
        SizedBox(height: 10),
        content,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: widget._scaffoldKey,
      appBar: CustomAppBar(scaffoldKey: widget._scaffoldKey),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 3,
        scaffoldKey: widget._scaffoldKey,
        onTap: (index) {
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => QRPage(userId: 'user-123')),
            );
          }
          else if (index != 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MainPage(),
              ),
            );
          }
        },
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Welcome text
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'What would you like to learn today, Benedict?',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            // Toggle buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ChoiceChip(
                  label: Text('Online'),
                  selected: selectedOption == 'Online',
                  onSelected: (selected) {
                    setState(() {
                      selectedOption = 'Online';
                    });
                  },
                  selectedColor: Colors.blueAccent,
                  backgroundColor: Colors.grey[200],
                  labelStyle: TextStyle(
                    color: selectedOption == 'Online' ? Colors.white : Colors.black,
                  ),
                ),
                SizedBox(width: 20),
                ChoiceChip(
                  label: Text('Physical'),
                  selected: selectedOption == 'Physical',
                  onSelected: (selected) {
                    setState(() {
                      selectedOption = 'Physical';
                    });
                  },
                  selectedColor: Colors.blueAccent,
                  backgroundColor: Colors.grey[200],
                  labelStyle: TextStyle(
                    color: selectedOption == 'Physical' ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            // Recommended Carousel
            buildSection(
              'Recommended',
              Container(
                height: 200,
                child: PageView.builder(
                  itemCount: recommendedClasses.length,
                  controller: PageController(viewportFraction: 0.8),
                  itemBuilder: (_, index) {
                    final item = recommendedClasses[index];
                    return GestureDetector(
                      onTap: () => _launchURL(item['link']!),
                      child: Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        margin: EdgeInsets.symmetric(horizontal: 8),
                        clipBehavior: Clip.antiAlias,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.network(
                              item['image']!,
                              fit: BoxFit.cover,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Colors.black54, Colors.transparent],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                ),
                              ),
                              padding: EdgeInsets.all(8),
                              child: Align(
                                alignment: Alignment.bottomLeft,
                                child: Text(
                                  item['name']!,
                                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            // Category icons
            buildSection('Categories', buildCategories()),
            // Output classes based on selected category
            buildSection(
              'Output of Classes',
              Column(
                children: filteredClasses.map((cls) => buildClassCard(cls)).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}