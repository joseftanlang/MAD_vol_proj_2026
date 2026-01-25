import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRPage extends StatefulWidget {
  final String userId;

  const QRPage({super.key, required this.userId});

  @override
  State<QRPage> createState() => _QRPageState();
}

class _QRPageState extends State<QRPage> {
  bool showScanner = false;
  bool showMyQR = true; // toggle between scanner and QR
  String scannedResult = "";

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Toggle Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    showMyQR = true;
                    showScanner = false;
                  });
                },
                child: const Text("Show My QR"),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    showScanner = true;
                    showMyQR = false;
                  });
                },
                child: const Text("Scan QR Code"),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Show User QR
          if (showMyQR)
            Column(
              children: [
                QrImageView(
                  data: widget.userId,
                  size: 220,
                ),
                const SizedBox(height: 12),
                const Text(
                  "This QR code is unique to you",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),

          // Show Scanner
          if (showScanner)
            Column(
              children: [
                SizedBox(
                  height: 300,
                  child: MobileScanner(
                    onDetect: (capture) {
                      final barcode = capture.barcodes.first;
                      final code = barcode.rawValue;

                      if (code != null) {
                        setState(() {
                          scannedResult = code;
                          showScanner = false;
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
        ],
      ),
    );
  }
}
