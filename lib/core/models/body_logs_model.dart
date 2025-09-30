import 'package:equatable/equatable.dart';

class BodyLogsModel extends Equatable {
  final String id;
  final String userId;
  final double? weight; // in kg
  final double? height; // in cm
  final double? bodyFat; // percentage
  final double? muscleMass; // in kg
  final double? bmi;
  final String? notes;
  final DateTime loggedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const BodyLogsModel({
    required this.id,
    required this.userId,
    this.weight,
    this.height,
    this.bodyFat,
    this.muscleMass,
    this.bmi,
    this.notes,
    required this.loggedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BodyLogsModel.fromJson(Map<String, dynamic> json) {
    return BodyLogsModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      weight: json['weight'] as double?,
      height: json['height'] as double?,
      bodyFat: json['bodyFat'] as double?,
      muscleMass: json['muscleMass'] as double?,
      bmi: json['bmi'] as double?,
      notes: json['notes'] as String?,
      loggedAt: DateTime.parse(json['loggedAt'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'weight': weight,
      'height': height,
      'bodyFat': bodyFat,
      'muscleMass': muscleMass,
      'bmi': bmi,
      'notes': notes,
      'loggedAt': loggedAt.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        weight,
        height,
        bodyFat,
        muscleMass,
        bmi,
        notes,
        loggedAt,
        createdAt,
        updatedAt,
      ];
}

class BodyGoalsModel extends Equatable {
  final String id;
  final String userId;
  final double? targetWeight; // in kg
  final double? targetBodyFat; // percentage
  final double? targetMuscleMass; // in kg
  final DateTime? targetDate;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const BodyGoalsModel({
    required this.id,
    required this.userId,
    this.targetWeight,
    this.targetBodyFat,
    this.targetMuscleMass,
    this.targetDate,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BodyGoalsModel.fromJson(Map<String, dynamic> json) {
    return BodyGoalsModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      targetWeight: json['targetWeight'] as double?,
      targetBodyFat: json['targetBodyFat'] as double?,
      targetMuscleMass: json['targetMuscleMass'] as double?,
      targetDate: json['targetDate'] != null ? DateTime.parse(json['targetDate'] as String) : null,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'targetWeight': targetWeight,
      'targetBodyFat': targetBodyFat,
      'targetMuscleMass': targetMuscleMass,
      'targetDate': targetDate?.toIso8601String(),
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        targetWeight,
        targetBodyFat,
        targetMuscleMass,
        targetDate,
        notes,
        createdAt,
        updatedAt,
      ];
}
