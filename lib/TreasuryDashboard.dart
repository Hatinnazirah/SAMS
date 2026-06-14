import 'package:flutter/material.dart';

class TreasuryDashboard extends StatelessWidget {
  const TreasuryDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Treasury Dashboard'),
      ),
      body: const Center(
        child: Text(
          'Treasury Dashboard',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}