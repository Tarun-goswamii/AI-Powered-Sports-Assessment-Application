import 'package:equatable/equatable.dart';

class MentorSessionModel extends Equatable {
  final String id;
  final String mentorId;
  final String userId;
  final String topic;
  final int scheduledAt;
  final String status;
  final String type;
  final DateTime? completedAt;
  final double? rating;
  final String? review;
  final DateTime createdAt;
  final DateTime updatedAt;

  // For UI display
  final String? mentorName;

  const MentorSessionModel({
    required this.id,
    required this.mentorId,
    required this.userId,
    required this.topic,
    required this.scheduledAt,
    required this.status,
    required this.type,
    this.completedAt,
    this.rating,
    this.review,
    required this.createdAt,
    required this.updatedAt,
    this.mentorName,
  });

  factory MentorSessionModel.fromJson(Map<String, dynamic> json) {
    return MentorSessionModel(
      id: json['id'] as String? ?? json['_id'] as String,
      mentorId: json['mentorId'] as String,
      userId: json['userId'] as String,
      topic: json['topic'] as String,
      scheduledAt: json['scheduledAt'] as int,
      status: json['status'] as String,
      type: json['type'] as String,
      completedAt: json['completedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['completedAt'] as int)
          : null,
      rating: json['rating'] != null ? (json['rating'] as num).toDouble() : null,
      review: json['review'] as String?,
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(json['updatedAt'] as int),
      mentorName: json['mentor']?['name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mentorId': mentorId,
      'userId': userId,
      'topic': topic,
      'scheduledAt': scheduledAt,
      'status': status,
      'type': type,
      'completedAt': completedAt?.millisecondsSinceEpoch,
      'rating': rating,
      'review': review,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  MentorSessionModel copyWith({
    String? id,
    String? mentorId,
    String? userId,
    String? topic,
    int? scheduledAt,
    String? status,
    String? type,
    DateTime? completedAt,
    double? rating,
    String? review,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? mentorName,
  }) {
    return MentorSessionModel(
      id: id ?? this.id,
      mentorId: mentorId ?? this.mentorId,
      userId: userId ?? this.userId,
      topic: topic ?? this.topic,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      status: status ?? this.status,
      type: type ?? this.type,
      completedAt: completedAt ?? this.completedAt,
      rating: rating ?? this.rating,
      review: review ?? this.review,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      mentorName: mentorName ?? this.mentorName,
    );
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
        completedAt,
        rating,
        review,
        createdAt,
        updatedAt,
        mentorName,
      ];
}
