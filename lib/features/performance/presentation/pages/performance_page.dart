import 'package:flutter/material.dart';

class PerformancePage extends StatelessWidget {
  const PerformancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Performance Page')));
  }
}

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
