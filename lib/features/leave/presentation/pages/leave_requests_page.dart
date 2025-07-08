import 'package:flutter/material.dart';

class LeaveRequestsPage extends StatelessWidget {
  const LeaveRequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Leave Requests Page')));
  }
}

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

class AddLeaveRequestPage extends StatelessWidget {
  const AddLeaveRequestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Yeni İzin Talebi')),
      body: const Center(child: Text('Add Leave Request Page')),
    );
  }
}
