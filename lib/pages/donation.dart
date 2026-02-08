import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project_flutter/components/appBar.dart';
import 'package:final_project_flutter/components/drawer.dart';
import 'package:final_project_flutter/components/bottomNav.dart';
import 'donation_detail.dart';
import 'package:final_project_flutter/l10n/app_localizations.dart';

class DonationPage extends StatefulWidget {
  const DonationPage({super.key});

  @override
  State<DonationPage> createState() => _DonationPageState();
}

class _DonationPageState extends State<DonationPage> {
  String selectedCategory = 'All';

  Map<String, String> get categories => {
    'All': AppLocalizations.of(context)!.categoryAll,
    'Children': AppLocalizations.of(context)!.categoryChildren,
    'Elderly': AppLocalizations.of(context)!.categoryElderly,
    'Environment': AppLocalizations.of(context)!.categoryEnvironment,
    'Education': AppLocalizations.of(context)!.categoryEducation,
    'Health': AppLocalizations.of(context)!.categoryHealth,
    'Migrants': AppLocalizations.of(context)!.categoryMigrants,
  };
  // final categories = [
  //   'All',
  //   'Children',
  //   'Elderly',
  //   'Environment',
  //   'Education',
  //   'Health',
  //   'Migrants',
  // ];


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
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        AppLocalizations.of(context)!.donationTitle,
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }

  Widget _categoryFilter() {
    return SizedBox(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: categories.entries.map((entry) {
        final cat = entry.key;
        final label = entry.value;
        final isSelected = selectedCategory == cat;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: ChoiceChip(
            label: Text(label),
        // children: categories.map((cat) {
        //   final isSelected = selectedCategory == cat;
        //   return Padding(
        //     padding: const EdgeInsets.symmetric(horizontal: 6),
        //     child: ChoiceChip(
        //       label: Text(cat),
              selected: isSelected,
              selectedColor: Colors.blueAccent,
              labelStyle: Theme.of(context).textTheme.titleMedium,
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
          return Center(child: Text(AppLocalizations.of(context)!.donationListError));
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final docs = snapshot.data!.docs;

        if (docs.isEmpty) {
          return Center(child: Text(AppLocalizations.of(context)!.donationListEmpty));
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
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                data['description'],
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Chip(
                label: Text(data['category'], style: Theme.of(context).textTheme.bodyMedium,),
                backgroundColor: (Theme.of(context).brightness == Brightness.light)?Colors.blue.shade100: Colors.deepPurpleAccent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
