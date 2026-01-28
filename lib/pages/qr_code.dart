import 'package:flutter/material.dart';

class QRCodePage extends StatelessWidget {
  const QRCodePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code Page'),
      ),
      body: const Center(
        child: Text('Welcome to the QR Code Page!'),
      ),
    );
  }
}