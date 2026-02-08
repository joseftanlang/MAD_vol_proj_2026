// this is for all the packages dependecies
import 'package:flutter/material.dart';
import 'package:tab_container/tab_container.dart';
import "package:url_launcher/url_launcher.dart";
import "package:cloud_firestore/cloud_firestore.dart";

//this is for the component that we have created
import 'package:final_project_flutter/components/bottomNav.dart';
import 'package:final_project_flutter/components/drawer.dart';
import 'package:final_project_flutter/components/appBar.dart';

class VolunteerPage extends StatefulWidget {
  const VolunteerPage({super.key});

  @override
  State<VolunteerPage> createState() => _VolunteerPageState();

  // @override
  // Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _VolunteerPageState extends State<VolunteerPage> {
  // int selectedUpcomingIndex = -1;
  // int selectedPastIndex = -1;
  double imageHeight = 200;
  String selectedCategory = "All";
  String myPageCollection = "volunteerEvent";

  Map<String, Color> volunteerTabs = {
    "Upcoming Events": Colors.redAccent,
    'Past Events': Colors.lightBlueAccent,
  };

  final List<String> volunteerCategory = [
    "All",
    "Children",
    "Elderly",
    "Migrant",
    "Healthcare",
    "Low Income",
    "Environmental",
  ];

  /* ───────────────────────── FIRESTORE DATA ───────────────────────── */

  Stream<QuerySnapshot> _filterEvents({
    required String collectionToLookup,
    required String selectedCategory,
  }) {
    if (selectedCategory == 'All') {
      return FirebaseFirestore.instance
          .collection(collectionToLookup)
          .orderBy('startTime')
          .snapshots();
    }
    return FirebaseFirestore.instance
        .collection(collectionToLookup)
        .where('category', isEqualTo: selectedCategory)
        .orderBy('startTime')
        .snapshots();
  }

  Stream<QuerySnapshot> _filterFeaturedEvents({
    required String collectionToLookup,
  }) {
    return FirebaseFirestore.instance
        .collection(collectionToLookup)
        .where('featured', isEqualTo: true)
        .orderBy('startTime')
        .snapshots();
  }

  Stream<QuerySnapshot> _filterPastEvents({
    required String collectionToLookup,
  }) {
    final now = Timestamp.now();

    return FirebaseFirestore.instance
        .collection(collectionToLookup)
        .where('startTime', isLessThan: now)
        .orderBy('startTime', descending: true)
        .snapshots();
  }

  TextStyle tabTextStyle(BuildContext context) {
    return Theme.of(context).textTheme.titleLarge!;
  }

  //website url launch function
  Future<void> myUrlLauncher({required String websiteUrl}) async {
    final Uri myUrl = Uri.parse(websiteUrl);

    try {
      await launchUrl(myUrl);
    } catch (err) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Error"),
          content: const Text("Error redirecting. Please try again."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            ),
          ],
        ),
      );
    }
  }

  /* ───────────────────────── Widgets ───────────────────────── */
  Widget _buildHeader({required String headerText}) {
    return Container(
      alignment: Alignment.topLeft,
      child: Text(headerText, style: TextStyle(fontSize: 20.0)),
    );
  }

  Widget _buildFeatured({
    required String myTitle,
    required String myDescription,
    required String imagePath,
  }) {
    return GestureDetector(
      // pop-up box on tap with title and description of event
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text(myTitle, style: TextStyle(fontSize: 25.0)),
            content: SizedBox(
              width: 300,
              child: Text(
                myDescription,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => {Navigator.pop(context)},
                child: Text("Close"),
              ),
            ],
          ),
        );
      },
      // image of event
      child: SizedBox(
        height: imageHeight,
        child: Image.network(imagePath, fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildCard({
    required String myTitle,
    required String myDescription,
    required String mySignupLink,
    required String myCategory,
  }) {
    return GestureDetector(
      onTap: () {
        // pop-up box on tap with title and description of event
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text(myTitle, style: TextStyle(fontSize: 25.0)),
            content: SizedBox(
              width: 300,
              child: Text(
                myDescription,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  myUrlLauncher(websiteUrl: mySignupLink);
                  Navigator.pop(context);
                },
                child: Text("Sign Up"),
              ),
              TextButton(
                onPressed: () => {Navigator.pop(context)},
                child: Text("Close"),
              ),
            ],
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event Title
            Text(
              myTitle,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            // Event Description
            Text(myDescription, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 10),

            Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 255, 201, 172),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  "Click to register",
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar(),
      drawer: const DrawerNav(),
      bottomNavigationBar: const AppBottomNav(),

      body: ListView(
        padding: const EdgeInsets.all(30),

        children: [
          Center(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                "How would you make an impact today?",
                style: TextStyle(
                  fontSize: 35.0,
                  fontWeight: FontWeight.bold,
                ), // Use a large size; FittedBox scales it down
              ),
            ),
          ),

          const SizedBox(height: 24),

          SizedBox(
            child: TabContainer(
              selectedTextStyle: tabTextStyle(
                context,
              ).copyWith(color: Colors.white),
              unselectedTextStyle: tabTextStyle(context),
              colors: List.generate(
                volunteerTabs.length,
                (int index) => volunteerTabs.values.elementAt(index),
              ),
              tabs: List.generate(
                volunteerTabs.length,
                (int index) => Text(volunteerTabs.keys.elementAt(index)),
              ),

              children: [
                /* ───────────────────────── Upcoming ───────────────────────── */
                Padding(
                  padding: EdgeInsets.all(15),

                  child: Container(
                    padding: EdgeInsets.all(10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 246, 240, 228),
                      borderRadius: BorderRadius.circular(5),
                    ),

                    child: Column(
                      children: [
                        _buildHeader(headerText: "Featured"),

                        SizedBox(height: 10),

                        // Featured events
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: StreamBuilder<QuerySnapshot>(
                            stream: _filterFeaturedEvents(
                              collectionToLookup: myPageCollection,
                            ),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

                              if (snapshot.hasError) {
                                return const Text("Something went wrong");
                              }

                              if (!snapshot.hasData) {
                                return const Text("No data yet");
                              }

                              if (snapshot.data!.docs.isEmpty) {
                                return const Text("No events found");
                              }
                            
                              final docs = snapshot.data!.docs;

                              return SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: docs.map((doc) {
                                    final data =
                                        doc.data() as Map<String, dynamic>;

                                    return Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: _buildFeatured(
                                        myTitle:
                                            data["title"] ?? "Untitled Event",
                                        myDescription:
                                            data["description"] ??
                                            "Event Description",
                                        imagePath:
                                            data["imagePath"] ??
                                            "assets/Singapore_poly.png",
                                      ),
                                    );
                                  }).toList(),
                                ),
                              );
                            },
                          ),
                        ),

                        Divider(
                          color: Colors.black,
                          thickness: 1.5,
                          height:
                              40, // Total height of the box containing the line
                        ),

                        _buildHeader(headerText: "Category"),

                        SizedBox(height: 10),

                        // category buttons
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: List.generate(volunteerCategory.length, (
                              index,
                            ) {
                              final item = volunteerCategory[index];

                              if (index == volunteerCategory.length - 1) {
                                return FilledButton(
                                  onPressed: () {
                                    setState(() {
                                      selectedCategory = item;
                                    });
                                  },
                                  style: FilledButton.styleFrom(
                                    backgroundColor: ((selectedCategory == item)
                                        ? Colors.blue
                                        : Colors.grey),
                                  ),
                                  child: Text(item),
                                );
                              } else {
                                return Padding(
                                  padding: EdgeInsets.only(right: 20),
                                  child: FilledButton(
                                    onPressed: () {
                                      setState(() {
                                        selectedCategory = item;
                                      });
                                    },
                                    style: FilledButton.styleFrom(
                                      backgroundColor:
                                          ((selectedCategory == item)
                                          ? Colors.blue
                                          : Colors.grey),
                                    ),
                                    child: Text(item),
                                  ),
                                );
                              }
                            }),
                          ),
                        ),

                        SizedBox(height: 15),

                        // all events
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: StreamBuilder<QuerySnapshot>(
                            stream: _filterEvents(
                              collectionToLookup:
                                  myPageCollection,
                              selectedCategory: selectedCategory,
                            ),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

                              if (snapshot.hasError) {
                                return const Text("Something went wrong");
                              }

                              if (!snapshot.hasData) {
                                return const Text("No data yet");
                              }

                              if (snapshot.data!.docs.isEmpty) {
                                return const Text("No events found");
                              }
                              final docs = snapshot.data!.docs;

                              return Column(
                                children: docs.map((doc) {
                                  final data =
                                      doc.data() as Map<String, dynamic>;

                                  return Column(
                                    children: [
                                      _buildCard(
                                        myTitle:
                                            data["title"] ?? "Untitled Event",
                                        myDescription:
                                            data["description"] ??
                                            "Event Description",
                                        mySignupLink: data["signupLink"] ?? "",
                                        myCategory: data["category"] ?? "All",
                                      ),
                                      const SizedBox(height: 20),
                                    ],
                                  );
                                }).toList(),
                              );
                            },
                          ),
                        ),

                        SizedBox(height: 5),
                      ],
                    ),
                  ),
                ),

                /* ───────────────────────── Past ───────────────────────── */
                SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(15),

                    child: Container(
                      padding: EdgeInsets.all(10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 246, 240, 228),
                        borderRadius: BorderRadius.circular(5),
                      ),

                      child: Column(
                        children: [
                          _buildHeader(
                            headerText: "Thank you for volunteering!",
                          ),

                          SizedBox(height: 10),

                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: StreamBuilder<QuerySnapshot>(
                              stream: _filterPastEvents(
                                collectionToLookup:
                                    myPageCollection, // your Firestore collection name
                              ),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }

                                if (snapshot.hasError) {
                                  return const Text("Something went wrong");
                                }

                                if (!snapshot.hasData) {
                                  return const Text("No data yet");
                                }

                                if (snapshot.data!.docs.isEmpty) {
                                  return const Text("No events found");
                                }
                                final docs = snapshot.data!.docs;

                                return Column(
                                  children: docs.map((doc) {
                                    final data =
                                        doc.data() as Map<String, dynamic>;

                                    return Column(
                                      children: [
                                        _buildCard(
                                          myTitle:
                                              data["title"] ?? "Untitled Event",
                                          myDescription:
                                              data["description"] ??
                                              "Event Description",
                                          mySignupLink:
                                              data["signupLink"] ?? "",
                                          myCategory: data["category"] ?? "All",
                                        ),
                                        const SizedBox(height: 20),
                                      ],
                                    );
                                  }).toList(),
                                );
                              },
                            ),
                          ),

                          SizedBox(height: 5),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}