// this is for all the packages dependecies
import 'package:flutter/material.dart';
import 'package:tab_container/tab_container.dart';
import "package:url_launcher/url_launcher.dart";
import "package:cloud_firestore/cloud_firestore.dart";

//this is for the component that we have created
import 'package:final_project_flutter/components/bottomNav.dart';
import 'package:final_project_flutter/components/drawer.dart';
import 'package:final_project_flutter/components/appBar.dart';
import 'package:final_project_flutter/l10n/app_localizations.dart';

class TrainingPage extends StatefulWidget {
  const TrainingPage({super.key});

  @override
  State<TrainingPage> createState() => _TrainingPageState();
}

class _TrainingPageState extends State<TrainingPage> {
  double imageHeight = 200;

  Map<String, Color> trainingTabs = {
    "Online": Colors.redAccent,
    'Physical': Colors.lightBlueAccent,
  };

  /* ───────────────────────── FIRESTORE DATA ───────────────────────── */
  final List<String> trainingCategory = [
    "All",
    "Technology",
    "Design",
    "Science",
    "Lifeskills",
    "Sustainability",
    "Languages",
  ];

  String selectedCategory = "All";
  String myPageCollection = "trainingEvent";

  /* ───────────────────────── FIRESTORE DATA ───────────────────────── */

  Stream<QuerySnapshot> _filterOnlineEvents({
    required String collectionToLookup,
    required String selectedCategory,
  }) {
    if (selectedCategory == 'All') {
      return FirebaseFirestore.instance
          .collection(collectionToLookup)
          .where('venue', isNotEqualTo: "Online")
          .snapshots();
    }
    return FirebaseFirestore.instance
        .collection(collectionToLookup)
        .where('category', isEqualTo: selectedCategory)
        .where('venue', isNotEqualTo: "Online")
        .snapshots();
  }

  Stream<QuerySnapshot> _filterPhysicalEvents({
    required String collectionToLookup,
    required String selectedCategory,
  }) {
    if (selectedCategory == 'All') {
      return FirebaseFirestore.instance
          .collection(collectionToLookup)
          .where('venue', isEqualTo: "Online")
          .snapshots();
    }
    return FirebaseFirestore.instance
        .collection(collectionToLookup)
        .where('category', isEqualTo: selectedCategory)
        .where('venue', isEqualTo: "Online")
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
          title: Text(AppLocalizations.of(context)!.urlErrorTitle),
          content: Text(AppLocalizations.of(context)!.urlErrorMessage),
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
      child: Text(headerText, style: Theme.of(context).textTheme.titleMedium!.copyWith(
        color: Colors.deepPurpleAccent
      ),),
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
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Color(0xFF36454F)
              ),
            ),

            // Event Description
            Text(myDescription, style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Color(0xFF36454F)
            ),),
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
                  ).textTheme.bodyMedium?.copyWith(color: Color(0xFF36454F)),
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
                AppLocalizations.of(context)!.trainingWhatLearnToday,
                style: Theme.of(context).textTheme.headlineMedium,// Use a large size; FittedBox scales it down
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
                trainingTabs.length,
                (int index) => trainingTabs.values.elementAt(index),
              ),
              tabs: List.generate(
                trainingTabs.length,
                (int index) => Text(trainingTabs.keys.elementAt(index)),
              ),

              children: [
                /* ───────────────────────── Online ───────────────────────── */
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
                        _buildHeader(headerText: AppLocalizations.of(context)!.volunteerFeatured),

                        SizedBox(height: 10),

                        // category buttons
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: List.generate(trainingCategory.length, (
                              index,
                            ) {
                              final item = trainingCategory[index];

                              if (index == trainingCategory.length - 1) {
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

                        // online events
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: StreamBuilder<QuerySnapshot>(
                            stream: _filterOnlineEvents(
                              collectionToLookup:
                                  myPageCollection, // your Firestore collection name
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
                                return Text("No events found", style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                  color: Color(0xFF36454F)
                                ),
                                );
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
                          // category buttons
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: List.generate(trainingCategory.length, (
                                index,
                              ) {
                                final item = trainingCategory[index];

                                if (index == trainingCategory.length - 1) {
                                  return FilledButton(
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

                          // online events
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: StreamBuilder<QuerySnapshot>(
                              stream: _filterPhysicalEvents(
                                collectionToLookup:
                                    myPageCollection, // your Firestore collection name
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