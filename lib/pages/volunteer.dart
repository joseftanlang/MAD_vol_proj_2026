// this is for all the packages dependecies
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:tab_container/tab_container.dart';

//this is for the component that we have created
import 'package:project_1/components/bottomNav.dart';
import 'package:project_1/components/drawer.dart';
import 'package:project_1/components/appBar.dart';

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

  final List<String> volunteerCategory = [
    "All",
    "Children",
    "Elderly",
    "Migrant",
    "Healthcare",
    "Low Income",
    "Environmental",
  ];

  final List<String> trainingCategory = [
    "All",
    "Technology",
    "Design",
    "Science",
    "Lifeskills",
    "Sustainability",
    "Languages",
  ];

  Map<String, Color> volunteerTabs = {
    "Upcoming Events": Colors.redAccent,
    'Past Events': Colors.lightBlueAccent,
  };

  final List<Map<String, String>> myFeaturedEvents = [
    {
      "title": "SP Cares",
      "description":
          "More than 4,100 SP freshmen planted 700 trees across six sites from 15 to 17 April 2025. This event cements the Polytechnic's deep commitment to sustainability.",
      "imagePath": "../../lib/assets/sp-cares-grp.jpeg",
    },
    {
      "title": "myTitle",
      "description": "myDescription",
      "imagePath": "myImagePath",
    },
    {
      "title": "myTitle",
      "description": "myDescription",
      "imagePath": "myImagePath",
    },
  ];

  final List<Map<String, String>> allEvents = [
    {
      "title": "SP Cares",
      "description":
          "More than 4,100 SP freshmen planted 700 trees across six sites from 15 to 17 April 2025. This event cements the Polytechnic's deep commitment to sustainability.",
      "imagePath": "../../lib/assets/sp-cares-grp.jpeg",
    },
    {
      "title": "myTitle",
      "description": "myDescription",
      "imagePath": "myImagePath",
    },
    {
      "title": "myTitle",
      "description": "myDescription",
      "imagePath": "myImagePath",
    },
  ];

  TextStyle tabTextStyle(BuildContext context) {
    return Theme.of(context).textTheme.titleLarge!;
  }

  Widget selectableCard({
    required String title,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Card(
        elevation: selected ? 8 : 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: selected
              ? const BorderSide(color: Colors.blue, width: 2)
              : BorderSide.none,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader({required String headerText}) {
    return Container(
      alignment: Alignment.topLeft,
      child: Text(headerText, style: TextStyle(fontSize: 20.0)),
    );
  }

  Widget _buildFeaturedEvents({
    required String myTitle,
    required String myDescription,
    required String imagePath,
  }) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text(myTitle, style: TextStyle(fontSize: 15.0)),
            content: SizedBox(
              width: 300,
              child: Text(myDescription, style: TextStyle(fontSize: 15.0)),
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
      child: SizedBox(
        height: imageHeight,
        child: Image(image: AssetImage(imagePath)),
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
            height: 600,
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

                // upcoming tab
                Padding(
                  padding: EdgeInsets.all(15),

                  child: Container(
                    padding: EdgeInsets.all(10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.amber.shade100,
                      borderRadius: BorderRadius.circular(5),
                    ),

                    child: Column(
                      children: [
                        _buildHeader(headerText: "Featured"),

                        SizedBox(height: 10),

                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: myFeaturedEvents
                                  .map(
                                    (value) => _buildFeaturedEvents(
                                      myTitle:
                                          value["title"] ?? "Untitled Event",
                                      myDescription:
                                          value["description"] ??
                                          "Event Description",
                                      imagePath:
                                          value["imagePath"] ??
                                          "assets/placeholder.jpg",
                                    ),
                                  )
                                  .toList(),
                            ),
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

                        // volunter category buttons
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: List.generate(volunteerCategory.length, (
                              index,
                            ) {
                              final item = volunteerCategory[index];

                              if (index == volunteerCategory.length-1) {
                                return FilledButton(
                                    onPressed: () {
                                      print("Selected: $item");
                                    },
                                    child: Text(item),
                                  );
                              } else {
                                return Padding(
                                  padding: EdgeInsets.only(right: 20),
                                  child: FilledButton(
                                    onPressed: () {
                                      print("Selected: $item");
                                    },
                                    child: Text(item),
                                  ),
                                );
                              }
                            }),
                          ),
                        ),
                      ],

                    ),
                  ),
                ),

                // Container(
                //   padding: const EdgeInsets.all(16),
                //   child: Column(
                //     children: List.generate(3, (index) {
                //       return selectableCard(
                //         title: "Upcoming Event ${index + 1}",
                //         selected: selectedUpcomingIndex == index,
                //         onTap: () {
                //           setState(() {
                //             selectedUpcomingIndex = index;
                //           });
                //         },
                //       );
                //     }),
                //   ),
                // ),

                // past tab
                Container(child: Text("Test2")),
              ],
            ),
          ),

          // Container(child: ColoredBox(color: Colors.red), height: 500),
        ],
      ),
    );
  }
}
