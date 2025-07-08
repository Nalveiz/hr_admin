import 'package:flutter/material.dart';

class DepartmentDetailPage extends StatelessWidget {
  final String departmentId;

  const DepartmentDetailPage({super.key, required this.departmentId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Departman Detayı')),
      body: const Center(child: Text('Department Detail Page')),
    );
  }
}
