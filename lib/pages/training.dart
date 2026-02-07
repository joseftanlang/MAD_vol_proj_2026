import 'package:flutter/material.dart';

class TrainingPage extends StatelessWidget {
  const TrainingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Training Page'),
      ),
      body: const Center(
        child: Text('Welcome to the Training Page!'),
      ),
    );
  }
}