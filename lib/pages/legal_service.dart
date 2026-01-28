import 'package:flutter/material.dart';

class LegalServicePage extends StatelessWidget {
  const LegalServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Legal Service Page'),
      ),
      body: const Center(
        child: Text('Welcome to the Legal Service Page!'),
      ),
    );
  }
}