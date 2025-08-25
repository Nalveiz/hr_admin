/// Payroll entity
class Payroll {
  final String id;
  final String employeeId;
  final String employeeName;
  final String payPeriod; // e.g., "2024-01"
  final DateTime payDate;
  final double basicSalary;
  final double overtime;
  final double bonus;
  final double allowances;
  final double grossPay;
  final double tax;
  final double insurance;
  final double retirement;
  final double otherDeductions;
  final double totalDeductions;
  final double netPay;
  final String status; // draft, approved, paid
  final String? approvedBy;
  final DateTime? approvedAt;
  final String? paymentMethod;
  final String? notes;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const Payroll({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.payPeriod,
    required this.payDate,
    required this.basicSalary,
    required this.overtime,
    required this.bonus,
    required this.allowances,
    required this.grossPay,
    required this.tax,
    required this.insurance,
    required this.retirement,
    required this.otherDeductions,
    required this.totalDeductions,
    required this.netPay,
    required this.status,
    this.approvedBy,
    this.approvedAt,
    this.paymentMethod,
    this.notes,
    required this.createdAt,
    this.updatedAt,
  });

  bool get isDraft => status == 'draft';
  bool get isApproved => status == 'approved';
  bool get isPaid => status == 'paid';
  bool get needsApproval => isDraft;
}
