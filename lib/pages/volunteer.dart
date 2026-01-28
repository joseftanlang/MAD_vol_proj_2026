import 'package:flutter/material.dart';

class VolunteerPage extends StatelessWidget {
  const VolunteerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Volunteer Page'),
      ),
      body: const Center(
        child: Text('Welcome to the Volunteer Page!'),
      ),
    );
  }
}