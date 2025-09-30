import 'package:equatable/equatable.dart';

class BodyLogModel extends Equatable {
  final String id;
  final String userId;
  final DateTime date;
  final double? weight; // in kg
  final double? height; // in cm
  final double? bodyFat; // percentage
  final double? muscleMass; // in kg
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const BodyLogModel({
    required this.id,
    required this.userId,
    required this.date,
    this.weight,
    this.height,
    this.bodyFat,
    this.muscleMass,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BodyLogModel.fromJson(Map<String, dynamic> json) {
    return BodyLogModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      date: DateTime.fromMillisecondsSinceEpoch(json['date'] as int),
      weight: json['weight'] as double?,
      height: json['height'] as double?,
      bodyFat: json['bodyFat'] as double?,
      muscleMass: json['muscleMass'] as double?,
      notes: json['notes'] as String?,
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(json['updatedAt'] as int),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'date': date.millisecondsSinceEpoch,
      'weight': weight,
      'height': height,
      'bodyFat': bodyFat,
      'muscleMass': muscleMass,
      'notes': notes,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  // Calculated properties
  double? get bmi {
    if (weight != null && height != null && height! > 0) {
      final heightInMeters = height! / 100;
      return weight! / (heightInMeters * heightInMeters);
    }
    return null;
  }

  String get bmiCategory {
    if (bmi == null) return 'Not available';

    if (bmi! < 18.5) return 'Underweight';
    if (bmi! < 25) return 'Normal';
    if (bmi! < 30) return 'Overweight';
    return 'Obese';
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        date,
        weight,
        height,
        bodyFat,
        muscleMass,
        notes,
        createdAt,
        updatedAt
      ];
}
