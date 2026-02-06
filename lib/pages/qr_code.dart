// this is for all the packages dependecies
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

// this is for the component files we have created
import 'package:project_1/components/bottomNav.dart';
import 'package:project_1/components/drawer.dart';
import 'package:project_1/components/appBar.dart';

// imported page
import 'package:project_1/pages/settings.dart';

class QRCodePage extends StatefulWidget {
  const QRCodePage({super.key});

  @override
  State<QRCodePage> createState() => _QRCodePageState();
}

class _QRCodePageState extends State<QRCodePage> {
  bool showMyQR = true;
  String scannedResult = "";
  // String userName = "User";

  void _openSettings() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SettingPage()),
    );

    // if (result != null && result is String) {
    //   setState(() {
    //     userName = result;
    //   });
    // }
  }

  // ───────────────────── WELCOME USER ─────────────────────
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
            child: Text(
              'Welcome back, $username!',
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.headlineMedium?.fontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }
      },
    );
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
              const SizedBox(height: 24),

              // Center(
              //   child: FittedBox(
              //     fit: BoxFit.scaleDown,
              //     child: Text(
              //       "\$userName, QR Code",
              //       style: const TextStyle(
              //         fontSize: 35.0,
              //         fontWeight: FontWeight.bold,
              //       ),
              //     ),
              //   ),
              // ),
              const SizedBox(height: 24),

              if (showMyQR)
                Column(
                  children: [
                    QrImageView(data: "USER_ID_HERE", size: 220),
                    const SizedBox(height: 12),
                    const Text(
                      "This QR code is unique to you",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

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
                            setState(() {
                              scannedResult = value;
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
