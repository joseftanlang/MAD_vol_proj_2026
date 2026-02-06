// this is for all the packages dependecies
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
  bool showMyQR = true; // toggle between scanner and QR
  String scannedResult = "";

  String userName = "User"; 

  void _openSettings() async {
    // 1. Wait for the result from SettingPage
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SettingPage()),
    );

    // 2. Check if the result is a string and not null
    if (result != null && result is String) {
      setState(() {
        userName = result; // Update the name displayed in the UI
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar(),
      drawer: const DrawerNav(),
      bottomNavigationBar: const AppBottomNav(),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  "$userName, QR Code", //need to pull name from profile
                  style: TextStyle(
                    fontSize: 35.0,

                    fontWeight: FontWeight.bold,
                  ), // Use a large size; FittedBox scales it down
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Show User QR
            if (showMyQR)
              Column(
                children: [
                  QrImageView(
                    data: "USER_ID_HERE", // replace later
                    size: 220,
                  ),
                  const SizedBox(height: 12),

                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "This QR code is unique to you",
                      style: TextStyle(
                        fontSize: 35.0,

                        fontWeight: FontWeight.bold,
                      ), // Use a large size; FittedBox scales it down
                    ),
                  ),
                ],
              ),

            // Show Scanner
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

            // Button toggles between QR Image and QR Scanner
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
    );
  }
}
