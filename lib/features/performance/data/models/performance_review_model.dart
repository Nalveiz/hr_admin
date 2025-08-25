import '../../domain/entities/performance_review.dart';

/// Performance review data model for API serialization
class PerformanceReviewModel {
  final String id;
  final String employeeId;
  final String employeeName;
  final String reviewPeriod;
  final String reviewType;
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
  final String status;
  final DateTime? completedAt;
  final DateTime? approvedAt;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const PerformanceReviewModel({
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

  factory PerformanceReviewModel.fromJson(Map<String, dynamic> json) {
    return PerformanceReviewModel(
      id: json['id']?.toString() ?? '',
      employeeId:
          json['employeeId']?.toString() ??
          json['employee_id']?.toString() ??
          '',
      employeeName:
          json['employeeName']?.toString() ??
          json['employee_name']?.toString() ??
          '',
      reviewPeriod:
          json['reviewPeriod']?.toString() ??
          json['review_period']?.toString() ??
          '',
      reviewType:
          json['reviewType']?.toString() ??
          json['review_type']?.toString() ??
          'annual',
      startDate:
          _parseDateTime(json['startDate'] ?? json['start_date']) ??
          DateTime.now(),
      endDate:
          _parseDateTime(json['endDate'] ?? json['end_date']) ?? DateTime.now(),
      reviewerId:
          json['reviewerId']?.toString() ?? json['reviewer_id']?.toString(),
      reviewerName:
          json['reviewerName']?.toString() ?? json['reviewer_name']?.toString(),
      overallRating: _parseDouble(
        json['overallRating'] ?? json['overall_rating'],
      ),
      categoryRatings: _parseCategoryRatings(
        json['categoryRatings'] ?? json['category_ratings'],
      ),
      goals: _parseStringList(json['goals']),
      achievements: _parseStringList(json['achievements']),
      areasForImprovement: _parseStringList(
        json['areasForImprovement'] ?? json['areas_for_improvement'],
      ),
      employeeComments:
          json['employeeComments']?.toString() ??
          json['employee_comments']?.toString(),
      reviewerComments:
          json['reviewerComments']?.toString() ??
          json['reviewer_comments']?.toString(),
      status: json['status']?.toString() ?? 'draft',
      completedAt: _parseDateTime(json['completedAt'] ?? json['completed_at']),
      approvedAt: _parseDateTime(json['approvedAt'] ?? json['approved_at']),
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
      'reviewPeriod': reviewPeriod,
      'reviewType': reviewType,
      'startDate': startDate.toIso8601String().split('T')[0],
      'endDate': endDate.toIso8601String().split('T')[0],
      'reviewerId': reviewerId,
      'reviewerName': reviewerName,
      'overallRating': overallRating,
      'categoryRatings': categoryRatings,
      'goals': goals,
      'achievements': achievements,
      'areasForImprovement': areasForImprovement,
      'employeeComments': employeeComments,
      'reviewerComments': reviewerComments,
      'status': status,
      'completedAt': completedAt?.toIso8601String(),
      'approvedAt': approvedAt?.toIso8601String(),
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

  static Map<String, double> _parseCategoryRatings(dynamic ratings) {
    if (ratings == null) return {};
    if (ratings is Map<String, dynamic>) {
      return ratings.map((key, value) => MapEntry(key, _parseDouble(value)));
    }
    return {};
  }

  static List<String> _parseStringList(dynamic list) {
    if (list == null) return [];
    if (list is List) {
      return list.map((item) => item.toString()).toList();
    }
    return [];
  }

  PerformanceReview toEntity() {
    return PerformanceReview(
      id: id,
      employeeId: employeeId,
      employeeName: employeeName,
      reviewPeriod: reviewPeriod,
      reviewType: reviewType,
      startDate: startDate,
      endDate: endDate,
      reviewerId: reviewerId,
      reviewerName: reviewerName,
      overallRating: overallRating,
      categoryRatings: categoryRatings,
      goals: goals,
      achievements: achievements,
      areasForImprovement: areasForImprovement,
      employeeComments: employeeComments,
      reviewerComments: reviewerComments,
      status: status,
      completedAt: completedAt,
      approvedAt: approvedAt,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  static PerformanceReviewModel fromEntity(PerformanceReview review) {
    return PerformanceReviewModel(
      id: review.id,
      employeeId: review.employeeId,
      employeeName: review.employeeName,
      reviewPeriod: review.reviewPeriod,
      reviewType: review.reviewType,
      startDate: review.startDate,
      endDate: review.endDate,
      reviewerId: review.reviewerId,
      reviewerName: review.reviewerName,
      overallRating: review.overallRating,
      categoryRatings: review.categoryRatings,
      goals: review.goals,
      achievements: review.achievements,
      areasForImprovement: review.areasForImprovement,
      employeeComments: review.employeeComments,
      reviewerComments: review.reviewerComments,
      status: review.status,
      completedAt: review.completedAt,
      approvedAt: review.approvedAt,
      createdAt: review.createdAt,
      updatedAt: review.updatedAt,
    );
  }
}
