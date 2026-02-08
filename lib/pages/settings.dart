import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

import 'package:final_project_flutter/components/bottomNav.dart';
import 'package:final_project_flutter/components/drawer.dart';
import 'package:final_project_flutter/components/appBar.dart';
import 'package:final_project_flutter/l10n/app_localizations.dart';


class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController bloodTypeController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController citizenshipController = TextEditingController();

  File? _image;
  String? profileImageUrl;

  @override
  void initState() {
    super.initState();
    loadSettings();
  }

  Future<void> loadSettings() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    if (!doc.exists) return;

    final data = doc.data()!;
    usernameController.text = data['username'] ?? '';
    nameController.text = data['name'] ?? '';
    emailController.text = data['email'] ?? '';
    phoneController.text = data['phone'] ?? '';
    addressController.text = data['address'] ?? '';
    bloodTypeController.text = data['bloodType'] ?? '';
    dobController.text = data['dob'] ?? '';
    citizenshipController.text = data['citizenship'] ?? '';
    profileImageUrl = data['profileImage'];

    setState(() {});
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    setState(() {
      _image = File(pickedFile.path);
    });

    // If Firebase Storage is not available, you can save image locally or skip
    // For Web, consider using Firebase Storage later
  }

  Future<void> saveSettings() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'username': usernameController.text,
      'name': nameController.text,
      'email': emailController.text,
      'phone': phoneController.text,
      'address': addressController.text,
      'bloodType': bloodTypeController.text,
      'dob': dobController.text,
      'citizenship': citizenshipController.text,
      'profileImage': profileImageUrl ?? '',
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.settingsSavedSuccess, style: Theme.of(context).textTheme.bodyMedium,)),
    );
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  final List<String> _bloodTypes = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar(),
      drawer: const DrawerNav(),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          GestureDetector(
            onTap: pickImage,
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey),
              ),
              child: _image != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(_image!, fit: BoxFit.cover),
                    )
                  : (profileImageUrl != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              profileImageUrl!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.camera_alt,
                                size: 50,
                                color: Colors.grey,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                AppLocalizations.of(context)!.settingsUploadPhoto,
                                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                  color: Colors.grey
                                ),
                              ),
                            ],
                          )),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: usernameController,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.settingsUsername,
              labelStyle: Theme.of(context).textTheme.bodyMedium,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.settingsFullName,
              labelStyle: Theme.of(context).textTheme.bodyMedium,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: emailController,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.settingsEmail,
              labelStyle: Theme.of(context).textTheme.bodyMedium,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: phoneController,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.settingsPhone,
              labelStyle: Theme.of(context).textTheme.bodyMedium,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: addressController,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.settingsAddress,
              labelStyle: Theme.of(context).textTheme.bodyMedium,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: bloodTypeController,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.settingsBloodType,
              labelStyle: Theme.of(context).textTheme.bodyMedium,
              border: OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(Icons.arrow_drop_down),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return ListView.builder(
                        itemCount: _bloodTypes.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(_bloodTypes[index]),
                            onTap: () {
                              bloodTypeController.text = _bloodTypes[index];
                              Navigator.pop(context);
                            },
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ),
          // const SizedBox(height: 10),
          // TextField(controller: bloodTypeController, decoration: const InputDecoration(labelText: 'Blood Type', border: OutlineInputBorder())),
          const SizedBox(height: 10),
          TextField(
            controller: dobController,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.settingsDateOfBirth,
              labelStyle: Theme.of(context).textTheme.bodyMedium,
              border: const OutlineInputBorder(),
            ),
            readOnly: true, // prevent manual editing
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(), // default date
                firstDate: DateTime(1900), // earliest date
                lastDate: DateTime.now(), // latest date (today)
              );

              if (pickedDate != null) {
                //This code formats the selected date (pickedDate) into a specific string format (YYYY-MM-DD) and then sets this formatted string into the TextEditingController (dobController), which updates the text displayed in the TextField.
                String formattedDate =
                    "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                dobController.text = formattedDate;
              }
            },
          ),
          const SizedBox(height: 10),
          TextField(
            controller: citizenshipController,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.settingsCitizenship,
              labelStyle: Theme.of(context).textTheme.bodyMedium,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: saveSettings,
                child: Text(AppLocalizations.of(context)!.settingsSaveButton, style: Theme.of(context).textTheme.bodyMedium,),
              ),
              ElevatedButton(
                onPressed: logout,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: Text(AppLocalizations.of(context)!.settingsLogoutButton, style: Theme.of(context).textTheme.bodyMedium,),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: const AppBottomNav(),
    );
  }
}
