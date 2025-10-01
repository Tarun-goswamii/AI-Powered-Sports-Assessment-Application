import 'package:equatable/equatable.dart';

class MentorModel extends Equatable {
  final String id;
  final String name;
  final String subtitle;
  final String specialty;
  final String description;
  final double rating;
  final int sessionsCount;
  final String price;
  final List<String> categories;
  final bool isOnline;
  final String avatarUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  const MentorModel({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.specialty,
    required this.description,
    required this.rating,
    required this.sessionsCount,
    required this.price,
    required this.categories,
    required this.isOnline,
    required this.avatarUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MentorModel.fromJson(Map<String, dynamic> json) {
    return MentorModel(
      id: json['id'] as String,
      name: json['name'] as String,
      subtitle: json['subtitle'] as String,
      specialty: json['specialty'] as String,
      description: json['description'] as String,
      rating: (json['rating'] as num).toDouble(),
      sessionsCount: json['sessionsCount'] as int,
      price: json['price'] as String,
      categories: List<String>.from(json['categories'] as List),
      isOnline: json['isOnline'] as bool,
      avatarUrl: json['avatarUrl'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'subtitle': subtitle,
      'specialty': specialty,
      'description': description,
      'rating': rating,
      'sessionsCount': sessionsCount,
      'price': price,
      'categories': categories,
      'isOnline': isOnline,
      'avatarUrl': avatarUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  MentorModel copyWith({
    String? id,
    String? name,
    String? subtitle,
    String? specialty,
    String? description,
    double? rating,
    int? sessionsCount,
    String? price,
    List<String>? categories,
    bool? isOnline,
    String? avatarUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MentorModel(
      id: id ?? this.id,
      name: name ?? this.name,
      subtitle: subtitle ?? this.subtitle,
      specialty: specialty ?? this.specialty,
      description: description ?? this.description,
      rating: rating ?? this.rating,
      sessionsCount: sessionsCount ?? this.sessionsCount,
      price: price ?? this.price,
      categories: categories ?? this.categories,
      isOnline: isOnline ?? this.isOnline,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        subtitle,
        specialty,
        description,
        rating,
        sessionsCount,
        price,
        categories,
        isOnline,
        avatarUrl,
        createdAt,
        updatedAt,
      ];
}

class MentorSessionModel extends Equatable {
  final String id;
  final String mentorId;
  final String userId;
  final String topic;
  final DateTime scheduledAt;
  final String status; // 'upcoming', 'completed', 'cancelled'
  final String type; // 'video_call', 'chat_session'
  final double? rating;
  final String? review;
  final DateTime? completedAt;
  final String mentorName;
  final String category;
  final DateTime createdAt;
  final DateTime updatedAt;

  const MentorSessionModel({
    required this.id,
    required this.mentorId,
    required this.userId,
    required this.topic,
    required this.scheduledAt,
    required this.status,
    required this.type,
    this.rating,
    this.review,
    this.completedAt,
    required this.mentorName,
    required this.category,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MentorSessionModel.fromJson(Map<String, dynamic> json) {
    return MentorSessionModel(
      id: json['_id'] as String? ?? json['id'] as String,
      mentorId: json['mentorId'] as String,
      userId: json['userId'] as String,
      topic: json['topic'] as String,
      scheduledAt: DateTime.fromMillisecondsSinceEpoch((json['scheduledAt'] as num).toInt()),
      status: json['status'] as String,
      type: json['type'] as String,
      rating: json['rating'] != null ? (json['rating'] as num).toDouble() : null,
      review: json['review'] as String?,
      completedAt: json['completedAt'] != null 
        ? DateTime.fromMillisecondsSinceEpoch((json['completedAt'] as num).toInt())
        : null,
      mentorName: json['mentor']?['name'] as String? ?? json['mentorName'] as String? ?? 'Unknown Mentor',
      category: json['category'] as String? ?? 'General',
      createdAt: DateTime.fromMillisecondsSinceEpoch((json['createdAt'] as num).toInt()),
      updatedAt: DateTime.fromMillisecondsSinceEpoch((json['updatedAt'] as num).toInt()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mentorId': mentorId,
      'userId': userId,
      'topic': topic,
      'scheduledAt': scheduledAt.toIso8601String(),
      'status': status,
      'type': type,
      'rating': rating,
      'review': review,
      'completedAt': completedAt?.toIso8601String(),
      'mentorName': mentorName,
      'category': category,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        mentorId,
        userId,
        topic,
        scheduledAt,
        status,
        type,
        rating,
        review,
        completedAt,
        mentorName,
        category,
        createdAt,
        updatedAt,
      ];
}
