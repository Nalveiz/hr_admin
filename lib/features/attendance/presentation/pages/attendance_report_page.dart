import 'package:flutter/material.dart';

class AttendanceReportPage extends StatelessWidget {
  const AttendanceReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Yoklama Raporu')),
      body: const Center(child: Text('Attendance Report Page')),
    );
  }
}
