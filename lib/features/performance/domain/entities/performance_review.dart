/// Performance review entity
class PerformanceReview {
  final String id;
  final String employeeId;
  final String employeeName;
  final String reviewPeriod;
  final String reviewType; // annual, quarterly, monthly
  final DateTime startDate;
  final DateTime endDate;
  final String? reviewerId;
  final String? reviewerName;
  final double overallRating;
  final Map<String, double> categoryRatings;
  final List<String> goals;
  final List<String> achievements;
  final List<String> areasForImprovement;
  final String? employeeComments;
  final String? reviewerComments;
  final String status; // draft, completed, approved
  final DateTime? completedAt;
  final DateTime? approvedAt;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const PerformanceReview({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.reviewPeriod,
    required this.reviewType,
    required this.startDate,
    required this.endDate,
    this.reviewerId,
    this.reviewerName,
    required this.overallRating,
    required this.categoryRatings,
    required this.goals,
    required this.achievements,
    required this.areasForImprovement,
    this.employeeComments,
    this.reviewerComments,
    required this.status,
    this.completedAt,
    this.approvedAt,
    required this.createdAt,
    this.updatedAt,
  });

  bool get isDraft => status == 'draft';
  bool get isCompleted => status == 'completed';
  bool get isApproved => status == 'approved';
  bool get isOverdue => DateTime.now().isAfter(endDate) && !isCompleted;
}
