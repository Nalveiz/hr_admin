import 'package:flutter/material.dart';

class PayrollPage extends StatelessWidget {
  const PayrollPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: const Center(child: Text('Payroll Page')));
  }
}

class PayrollDetailPage extends StatelessWidget {
  final String payrollId;
  const PayrollDetailPage({super.key, required this.payrollId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bordro Detayı')),
      body: const Center(child: Text('Payroll Detail Page')),
    );
  }
}
