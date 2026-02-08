// this is for all the packages dependecies
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

// this is for the component files we have created
import 'package:final_project_flutter/components/bottomNav.dart';
import 'package:final_project_flutter/components/drawer.dart';
import 'package:final_project_flutter/components/appBar.dart';

class QRCodePage extends StatefulWidget {
  const QRCodePage({super.key});

  @override
  State<QRCodePage> createState() => _QRCodePageState();
}

class _QRCodePageState extends State<QRCodePage> {
  bool showMyQR = true;
  String scannedResult = "";
  final Map<String, dynamic> dataToEncode = {};

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (doc.exists && doc.data() != null) {
      final fullData = doc.data()!;

      // Only keep the fields you want
      final filteredData = {
        "username": fullData['username'] ?? "",
        "name": fullData['name'] ?? "",
        "email": fullData['email'] ?? "",
        "dob": fullData['dob'] ?? "",
        "citizenship": fullData['citizenship'] ?? "",
      };

      if (doc.exists && doc.data() != null) {
        setState(() {
          dataToEncode
            ..clear()
            ..addAll(filteredData);
          dataToEncode["failed"] = false;
        });
      } else {
        setState(() {
          dataToEncode["failed"] = true;
        });
      }
    }
  }

  Widget _buildQRCode() {
    return Column(
      children: [
        QrImageView(
          data: jsonEncode(
            dataToEncode.isNotEmpty ? dataToEncode : {"failed": true},
          ),
          version: QrVersions.auto,
          size: 220.0,
          gapless: false,
          backgroundColor: Colors.white,
        ),
        const SizedBox(height: 12),
        const Text(
          "This QR code is unique to you",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _welcomeUser() {
    return FutureBuilder<String>(
      future: _fetchUsername(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return const Text('Error loading welcome message');
        } else {
          final username = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  'Welcome back, $username!',
                  style: TextStyle(
                    fontSize: Theme.of(
                      context,
                    ).textTheme.headlineMedium?.fontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  (showMyQR) ? "QR Code" : "QR Scanner",
                  style: TextStyle(
                    fontSize: Theme.of(
                      context,
                    ).textTheme.headlineMedium?.fontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  /* ───────────────────── WELCOME USER ───────────────────── */
  Future<String> _fetchUsername() async {
    String username = "SP!";
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (doc.exists) {
        username = doc.data()?['username'] ?? username;
      }
    }
    return username;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar(),
      drawer: const DrawerNav(),
      bottomNavigationBar: const AppBottomNav(),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _welcomeUser(), // display welcome message
              const SizedBox(height: 10),

              if (showMyQR) _buildQRCode(),

              if (!showMyQR)
                Column(
                  children: [
                    SizedBox(
                      height: 300,
                      child: MobileScanner(
                        onDetect: (capture) {
                          final barcode = capture.barcodes.first;
                          final value = barcode.rawValue;

                          if (value != null) {
                            Map<String, dynamic> scannedData = jsonDecode(
                              value,
                            );
                            setState(() {
                              scannedResult = scannedData.toString();
                              showMyQR = false;
                            });
                          }
                        },
                      ),
                    ),
                    if (scannedResult.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Text(
                          "Scanned: $scannedResult",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                  ],
                ),

              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: () {
                  setState(() {
                    showMyQR = !showMyQR;
                  });
                },
                child: Text(showMyQR ? "Scan QR Code" : "QR Code Image"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
