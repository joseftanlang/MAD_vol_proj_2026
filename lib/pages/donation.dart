import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project_flutter/components/appBar.dart';
import 'package:final_project_flutter/components/drawer.dart';
import 'package:final_project_flutter/components/bottomNav.dart';
import 'donation_detail.dart';

class DonationPage extends StatefulWidget {
  const DonationPage({super.key});

  @override
  State<DonationPage> createState() => _DonationPageState();
}

class _DonationPageState extends State<DonationPage> {
  String selectedCategory = 'All';

  final categories = [
    'All',
    'Children',
    'Elderly',
    'Environment',
    'Education',
    'Health',
    'Migrants',
  ];

  Stream<QuerySnapshot> _donationStream() {
    if (selectedCategory == 'All') {
      return FirebaseFirestore.instance.collection('donations').snapshots();
    }
    return FirebaseFirestore.instance
        .collection('donations')
        .where('category', isEqualTo: selectedCategory)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar(),
      drawer: const DrawerNav(),
      bottomNavigationBar: const AppBottomNav(),
      body: Column(
        children: [
          _topper(),
          _categoryFilter(),
          Expanded(child: _donationList()),
        ],
      ),
    );
  }

  Widget _topper() {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Text(
        'What would you like to support today?',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _categoryFilter() {
    return SizedBox(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: categories.map((cat) {
          final isSelected = selectedCategory == cat;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: ChoiceChip(
              label: Text(cat),
              selected: isSelected,
              selectedColor: Colors.blueAccent,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
              ),
              onSelected: (_) {
                setState(() => selectedCategory = cat);
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _donationList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _donationStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Something went wrong'));
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final docs = snapshot.data!.docs;

        if (docs.isEmpty) {
          return const Center(child: Text('No donations found'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: docs.length,
          itemBuilder: (context, i) {
            final data = docs[i];
            return _donationCard(context, data);
          },
        );
      },
    );
  }

  Widget _donationCard(BuildContext context, QueryDocumentSnapshot data) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DonationDetailPage(donationData: data),
          ),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data['title'],
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                data['description'],
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Chip(
                label: Text(data['category']),
                backgroundColor: Colors.blue.shade100,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
