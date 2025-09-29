import 'package:equatable/equatable.dart';

enum TestResultStatus { pending, completed, failed }

class TestResultModel extends Equatable {
  final String id;
  final String userId;
  final String testId;
  final TestResultStatus status;
  final Map<String, dynamic> rawData;
  final Map<String, dynamic> processedData;
  final double? score;
  final String? grade;
  final int? percentile;
  final String? feedback;
  final List<String> recommendations;
  final DateTime startedAt;
  final DateTime? completedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const TestResultModel({
    required this.id,
    required this.userId,
    required this.testId,
    required this.status,
    required this.rawData,
    required this.processedData,
    this.score,
    this.grade,
    this.percentile,
    this.feedback,
    required this.recommendations,
    required this.startedAt,
    this.completedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TestResultModel.fromJson(Map<String, dynamic> json) {
    return TestResultModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      testId: json['testId'] as String,
      status: TestResultStatus.values[json['status'] as int],
      rawData: json['rawData'] as Map<String, dynamic>,
      processedData: json['processedData'] as Map<String, dynamic>,
      score: json['score'] as double?,
      grade: json['grade'] as String?,
      percentile: json['percentile'] as int?,
      feedback: json['feedback'] as String?,
      recommendations: List<String>.from(json['recommendations'] as List),
      startedAt: DateTime.parse(json['startedAt'] as String),
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'testId': testId,
      'status': status.index,
      'rawData': rawData,
      'processedData': processedData,
      'score': score,
      'grade': grade,
      'percentile': percentile,
      'feedback': feedback,
      'recommendations': recommendations,
      'startedAt': startedAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        testId,
        status,
        rawData,
        processedData,
        score,
        grade,
        percentile,
        feedback,
        recommendations,
        startedAt,
        completedAt,
        createdAt,
        updatedAt,
      ];
}
