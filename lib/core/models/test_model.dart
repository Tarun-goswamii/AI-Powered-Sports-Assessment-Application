import 'package:equatable/equatable.dart';

enum TestStatus { notStarted, inProgress, completed }
enum TestDifficulty { easy, medium, hard }
enum TestCategory { strength, speed, agility, endurance, flexibility, power }

class TestModel extends Equatable {
  final String id;
  final String title;
  final String description;
  final String instructions;
  final TestCategory category;
  final TestDifficulty difficulty;
  final int durationMinutes;
  final String iconName;
  final List<String> equipment;
  final Map<String, dynamic> parameters;
  final DateTime createdAt;
  final DateTime updatedAt;

  const TestModel({
    required this.id,
    required this.title,
    required this.description,
    required this.instructions,
    required this.category,
    required this.difficulty,
    required this.durationMinutes,
    required this.iconName,
    required this.equipment,
    required this.parameters,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TestModel.fromJson(Map<String, dynamic> json) {
    return TestModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      instructions: json['instructions'] as String,
      category: TestCategory.values[json['category'] as int],
      difficulty: TestDifficulty.values[json['difficulty'] as int],
      durationMinutes: json['durationMinutes'] as int,
      iconName: json['iconName'] as String,
      equipment: List<String>.from(json['equipment'] as List),
      parameters: json['parameters'] as Map<String, dynamic>,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'instructions': instructions,
      'category': category.index,
      'difficulty': difficulty.index,
      'durationMinutes': durationMinutes,
      'iconName': iconName,
      'equipment': equipment,
      'parameters': parameters,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        instructions,
        category,
        difficulty,
        durationMinutes,
        iconName,
        equipment,
        parameters,
        createdAt,
        updatedAt,
      ];
}
