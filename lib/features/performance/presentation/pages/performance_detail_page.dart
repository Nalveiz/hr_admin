import 'package:flutter/material.dart';

class PerformanceDetailPage extends StatelessWidget {
  final String performanceId;
  const PerformanceDetailPage({super.key, required this.performanceId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Performans Detayı')),
      body: const Center(child: Text('Performance Detail Page')),
    );
  }
}
