import 'package:equatable/equatable.dart';

class AchievementModel extends Equatable {
  final String id;
  final String title;
  final String description;
  final String icon;
  final String category;
  final int points;
  final String rarity; // 'common', 'rare', 'epic', 'legendary'
  final Map<String, dynamic> criteria; // Conditions to unlock
  final bool isActive;

  const AchievementModel({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.category,
    required this.points,
    required this.rarity,
    required this.criteria,
    this.isActive = true,
  });

  factory AchievementModel.fromJson(Map<String, dynamic> json) {
    return AchievementModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      icon: json['icon'] as String,
      category: json['category'] as String,
      points: json['points'] as int,
      rarity: json['rarity'] as String,
      criteria: json['criteria'] as Map<String, dynamic>,
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'icon': icon,
      'category': category,
      'points': points,
      'rarity': rarity,
      'criteria': criteria,
      'isActive': isActive,
    };
  }

  @override
  List<Object?> get props => [id, title, description, icon, category, points, rarity, criteria, isActive];
}

class UserAchievementModel extends Equatable {
  final String id;
  final String userId;
  final String achievementId;
  final DateTime unlockedAt;
  final AchievementModel? achievement; // Populated when joined

  const UserAchievementModel({
    required this.id,
    required this.userId,
    required this.achievementId,
    required this.unlockedAt,
    this.achievement,
  });

  factory UserAchievementModel.fromJson(Map<String, dynamic> json) {
    return UserAchievementModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      achievementId: json['achievementId'] as String,
      unlockedAt: DateTime.fromMillisecondsSinceEpoch(json['unlockedAt'] as int),
      achievement: json['achievement'] != null
          ? AchievementModel.fromJson(json['achievement'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'achievementId': achievementId,
      'unlockedAt': unlockedAt.millisecondsSinceEpoch,
      'achievement': achievement?.toJson(),
    };
  }

  @override
  List<Object?> get props => [id, userId, achievementId, unlockedAt, achievement];
}
