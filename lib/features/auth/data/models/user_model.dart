// lib/features/auth/data/models/user_model.dart
class UserModel {
  final String id;
  final String email;
  final String? displayName;
  final String? avatarUrl;
  final String? phoneNumber;
  final DateTime? dateOfBirth;
  final String? gender;
  final double? heightCm;
  final double? weightKg;
  final List<String>? sportInterests;
  final String? fitnessLevel;
  final Map<String, dynamic>? location;
  final int creditPoints;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserModel({
    required this.id,
    required this.email,
    this.displayName,
    this.avatarUrl,
    this.phoneNumber,
    this.dateOfBirth,
    this.gender,
    this.heightCm,
    this.weightKg,
    this.sportInterests,
    this.fitnessLevel,
    this.location,
    this.creditPoints = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'] as String)
          : null,
      gender: json['gender'] as String?,
      heightCm: json['heightCm'] as double?,
      weightKg: json['weightKg'] as double?,
      sportInterests: json['sportInterests'] != null
          ? List<String>.from(json['sportInterests'] as List)
          : null,
      fitnessLevel: json['fitnessLevel'] as String?,
      location: json['location'] as Map<String, dynamic>?,
      creditPoints: json['creditPoints'] as int? ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'avatarUrl': avatarUrl,
      'phoneNumber': phoneNumber,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'gender': gender,
      'heightCm': heightCm,
      'weightKg': weightKg,
      'sportInterests': sportInterests,
      'fitnessLevel': fitnessLevel,
      'location': location,
      'creditPoints': creditPoints,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? displayName,
    String? avatarUrl,
    String? phoneNumber,
    DateTime? dateOfBirth,
    String? gender,
    double? heightCm,
    double? weightKg,
    List<String>? sportInterests,
    String? fitnessLevel,
    Map<String, dynamic>? location,
    int? creditPoints,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      sportInterests: sportInterests ?? this.sportInterests,
      fitnessLevel: fitnessLevel ?? this.fitnessLevel,
      location: location ?? this.location,
      creditPoints: creditPoints ?? this.creditPoints,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
