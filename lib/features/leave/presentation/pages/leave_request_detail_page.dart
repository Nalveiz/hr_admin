import 'package:flutter/material.dart';

class LeaveRequestDetailPage extends StatelessWidget {
  final String requestId;
  const LeaveRequestDetailPage({super.key, required this.requestId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('İzin Talebi Detayı')),
      body: const Center(child: Text('Leave Request Detail Page')),
    );
  }
}
