import 'package:equatable/equatable.dart';

enum CreditTransactionType {
  earned,
  spent,
  bonus,
  refunded,
  expired
}

class CreditTransactionModel extends Equatable {
  final String id;
  final String userId;
  final int amount;
  final CreditTransactionType type;
  final String description;
  final String? referenceId; // ID of related entity (test, product, etc.)
  final String? referenceType; // Type of related entity
  final DateTime createdAt;
  final DateTime expiresAt;

  const CreditTransactionModel({
    required this.id,
    required this.userId,
    required this.amount,
    required this.type,
    required this.description,
    this.referenceId,
    this.referenceType,
    required this.createdAt,
    required this.expiresAt,
  });

  factory CreditTransactionModel.fromJson(Map<String, dynamic> json) {
    return CreditTransactionModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      amount: json['amount'] as int,
      type: CreditTransactionType.values[json['type'] as int],
      description: json['description'] as String,
      referenceId: json['referenceId'] as String?,
      referenceType: json['referenceType'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      expiresAt: DateTime.parse(json['expiresAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'amount': amount,
      'type': type.index,
      'description': description,
      'referenceId': referenceId,
      'referenceType': referenceType,
      'createdAt': createdAt.toIso8601String(),
      'expiresAt': expiresAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        amount,
        type,
        description,
        referenceId,
        referenceType,
        createdAt,
        expiresAt,
      ];
}
