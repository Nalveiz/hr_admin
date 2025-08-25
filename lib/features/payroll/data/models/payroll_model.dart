import '../../domain/entities/payroll.dart';

/// Payroll data model for API serialization
class PayrollModel {
  final String id;
  final String employeeId;
  final String employeeName;
  final String payPeriod;
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
  final String status;
  final String? approvedBy;
  final DateTime? approvedAt;
  final String? paymentMethod;
  final String? notes;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const PayrollModel({
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

  factory PayrollModel.fromJson(Map<String, dynamic> json) {
    return PayrollModel(
      id: json['id']?.toString() ?? '',
      employeeId:
          json['employeeId']?.toString() ??
          json['employee_id']?.toString() ??
          '',
      employeeName:
          json['employeeName']?.toString() ??
          json['employee_name']?.toString() ??
          '',
      payPeriod:
          json['payPeriod']?.toString() ?? json['pay_period']?.toString() ?? '',
      payDate:
          _parseDateTime(json['payDate'] ?? json['pay_date']) ?? DateTime.now(),
      basicSalary: _parseDouble(json['basicSalary'] ?? json['basic_salary']),
      overtime: _parseDouble(json['overtime']),
      bonus: _parseDouble(json['bonus']),
      allowances: _parseDouble(json['allowances']),
      grossPay: _parseDouble(json['grossPay'] ?? json['gross_pay']),
      tax: _parseDouble(json['tax']),
      insurance: _parseDouble(json['insurance']),
      retirement: _parseDouble(json['retirement']),
      otherDeductions: _parseDouble(
        json['otherDeductions'] ?? json['other_deductions'],
      ),
      totalDeductions: _parseDouble(
        json['totalDeductions'] ?? json['total_deductions'],
      ),
      netPay: _parseDouble(json['netPay'] ?? json['net_pay']),
      status: json['status']?.toString() ?? 'draft',
      approvedBy:
          json['approvedBy']?.toString() ?? json['approved_by']?.toString(),
      approvedAt: _parseDateTime(json['approvedAt'] ?? json['approved_at']),
      paymentMethod:
          json['paymentMethod']?.toString() ??
          json['payment_method']?.toString(),
      notes: json['notes']?.toString(),
      createdAt:
          _parseDateTime(json['createdAt'] ?? json['created_at']) ??
          DateTime.now(),
      updatedAt: _parseDateTime(json['updatedAt'] ?? json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employeeId': employeeId,
      'employeeName': employeeName,
      'payPeriod': payPeriod,
      'payDate': payDate.toIso8601String().split('T')[0],
      'basicSalary': basicSalary,
      'overtime': overtime,
      'bonus': bonus,
      'allowances': allowances,
      'grossPay': grossPay,
      'tax': tax,
      'insurance': insurance,
      'retirement': retirement,
      'otherDeductions': otherDeductions,
      'totalDeductions': totalDeductions,
      'netPay': netPay,
      'status': status,
      'approvedBy': approvedBy,
      'approvedAt': approvedAt?.toIso8601String(),
      'paymentMethod': paymentMethod,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  static DateTime? _parseDateTime(dynamic dateTime) {
    if (dateTime == null) return null;
    if (dateTime is String) {
      try {
        return DateTime.parse(dateTime);
      } catch (e) {
        return null;
      }
    } else if (dateTime is DateTime) {
      return dateTime;
    }
    return null;
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      try {
        return double.parse(value);
      } catch (e) {
        return 0.0;
      }
    }
    return 0.0;
  }

  Payroll toEntity() {
    return Payroll(
      id: id,
      employeeId: employeeId,
      employeeName: employeeName,
      payPeriod: payPeriod,
      payDate: payDate,
      basicSalary: basicSalary,
      overtime: overtime,
      bonus: bonus,
      allowances: allowances,
      grossPay: grossPay,
      tax: tax,
      insurance: insurance,
      retirement: retirement,
      otherDeductions: otherDeductions,
      totalDeductions: totalDeductions,
      netPay: netPay,
      status: status,
      approvedBy: approvedBy,
      approvedAt: approvedAt,
      paymentMethod: paymentMethod,
      notes: notes,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  static PayrollModel fromEntity(Payroll payroll) {
    return PayrollModel(
      id: payroll.id,
      employeeId: payroll.employeeId,
      employeeName: payroll.employeeName,
      payPeriod: payroll.payPeriod,
      payDate: payroll.payDate,
      basicSalary: payroll.basicSalary,
      overtime: payroll.overtime,
      bonus: payroll.bonus,
      allowances: payroll.allowances,
      grossPay: payroll.grossPay,
      tax: payroll.tax,
      insurance: payroll.insurance,
      retirement: payroll.retirement,
      otherDeductions: payroll.otherDeductions,
      totalDeductions: payroll.totalDeductions,
      netPay: payroll.netPay,
      status: payroll.status,
      approvedBy: payroll.approvedBy,
      approvedAt: payroll.approvedAt,
      paymentMethod: payroll.paymentMethod,
      notes: payroll.notes,
      createdAt: payroll.createdAt,
      updatedAt: payroll.updatedAt,
    );
  }
}
