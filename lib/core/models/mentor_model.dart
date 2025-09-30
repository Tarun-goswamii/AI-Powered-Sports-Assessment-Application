import 'package:equatable/equatable.dart';

class MentorModel extends Equatable {
  final String id;
  final String name;
  final String title;
  final String specialty;
  final String bio;
  final String imageUrl;
  final double rating;
  final int sessionsCount;
  final int experienceYears;
  final List<String> expertise;
  final bool isAvailable;
  final double hourlyRate;
  final String location;
  final DateTime createdAt;
  final DateTime updatedAt;

  const MentorModel({
    required this.id,
    required this.name,
    required this.title,
    required this.specialty,
    required this.bio,
    required this.imageUrl,
    required this.rating,
    required this.sessionsCount,
    required this.experienceYears,
    required this.expertise,
    required this.isAvailable,
    required this.hourlyRate,
    required this.location,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MentorModel.fromJson(Map<String, dynamic> json) {
    return MentorModel(
      id: json['id'] as String,
      name: json['name'] as String,
      title: json['title'] as String,
      specialty: json['specialty'] as String,
      bio: json['bio'] as String,
      imageUrl: json['imageUrl'] as String,
      rating: (json['rating'] as num).toDouble(),
      sessionsCount: json['sessionsCount'] as int,
      experienceYears: json['experienceYears'] as int,
      expertise: List<String>.from(json['expertise'] as List),
      isAvailable: json['isAvailable'] as bool,
      hourlyRate: (json['hourlyRate'] as num).toDouble(),
      location: json['location'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'title': title,
      'specialty': specialty,
      'bio': bio,
      'imageUrl': imageUrl,
      'rating': rating,
      'sessionsCount': sessionsCount,
      'experienceYears': experienceYears,
      'expertise': expertise,
      'isAvailable': isAvailable,
      'hourlyRate': hourlyRate,
      'location': location,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  MentorModel copyWith({
    String? id,
    String? name,
    String? title,
    String? specialty,
    String? bio,
    String? imageUrl,
    double? rating,
    int? sessionsCount,
    int? experienceYears,
    List<String>? expertise,
    bool? isAvailable,
    double? hourlyRate,
    String? location,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MentorModel(
      id: id ?? this.id,
      name: name ?? this.name,
      title: title ?? this.title,
      specialty: specialty ?? this.specialty,
      bio: bio ?? this.bio,
      imageUrl: imageUrl ?? this.imageUrl,
      rating: rating ?? this.rating,
      sessionsCount: sessionsCount ?? this.sessionsCount,
      experienceYears: experienceYears ?? this.experienceYears,
      expertise: expertise ?? this.expertise,
      isAvailable: isAvailable ?? this.isAvailable,
      hourlyRate: hourlyRate ?? this.hourlyRate,
      location: location ?? this.location,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Computed properties for compatibility
  String get subtitle => specialty;
  double get price => hourlyRate;
  bool get isOnline => isAvailable;
  List<String> get categories => expertise;
  String get avatarUrl => imageUrl;
  int get sessionCount => sessionsCount;

  @override
  List<Object?> get props => [
        id,
        name,
        title,
        specialty,
        bio,
        imageUrl,
        rating,
        sessionsCount,
        experienceYears,
        expertise,
        isAvailable,
        hourlyRate,
        location,
        createdAt,
        updatedAt,
      ];
}
