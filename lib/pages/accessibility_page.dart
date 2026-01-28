import 'package:flutter/material.dart';

class AccessibilityPage extends StatelessWidget {
  const AccessibilityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accessibility Page'),
      ),
      body: const Center(
        child: Text('Welcome to the Accessibility Page!'),
      ),
    );
  }
}