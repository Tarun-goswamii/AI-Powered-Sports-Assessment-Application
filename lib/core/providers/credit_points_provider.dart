import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/credit_points_model.dart';
import '../services/service_manager.dart';

class CreditPointsState {
  final int totalCredits;
  final List<CreditPointsModel> transactions;
  final bool isLoading;
  final String? errorMessage;

  const CreditPointsState({
    required this.totalCredits,
    required this.transactions,
    this.isLoading = false,
    this.errorMessage,
  });

  CreditPointsState copyWith({
    int? totalCredits,
    List<CreditPointsModel>? transactions,
    bool? isLoading,
    String? errorMessage,
  }) {
    return CreditPointsState(
      totalCredits: totalCredits ?? this.totalCredits,
      transactions: transactions ?? this.transactions,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class CreditPointsNotifier extends StateNotifier<CreditPointsState> {
  final ConvexService _convexService;

  CreditPointsNotifier(this._convexService)
      : super(const CreditPointsState(totalCredits: 0, transactions: []));

  Future<void> loadCreditPoints(String userId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      // Fetch credit transactions from Convex
      final response = await _convexService.query('creditPoints:getByUser', {'userId': userId});
      
      final transactions = (response['transactions'] as List? ?? [])
          .map((json) => CreditPointsModel.fromJson(json))
          .toList();

      final totalCredits = transactions.fold<int>(
        0,
        (sum, transaction) => sum + transaction.amount,
      );

      state = CreditPointsState(
        totalCredits: totalCredits,
        transactions: transactions,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load credit points: $e',
      );
    }
  }

  Future<void> addCredits({
    required String userId,
    required int amount,
    required CreditTransactionType type,
    required String description,
    String? referenceId,
    String? referenceType,
  }) async {
    try {
      await _convexService.mutation('creditPoints:addTransaction', {
        'userId': userId,
        'amount': amount,
        'type': type.toString().split('.').last,
        'description': description,
        'referenceId': referenceId,
        'referenceType': referenceType,
      });

      // Reload credit points
      await loadCreditPoints(userId);
    } catch (e) {
      state = state.copyWith(errorMessage: 'Failed to add credits: $e');
    }
  }

  Future<void> spendCredits({
    required String userId,
    required int amount,
    required String description,
    String? referenceId,
    String? referenceType,
  }) async {
    if (state.totalCredits < amount) {
      state = state.copyWith(errorMessage: 'Insufficient credits');
      return;
    }

    await addCredits(
      userId: userId,
      amount: -amount,
      type: CreditTransactionType.spent,
      description: description,
      referenceId: referenceId,
      referenceType: referenceType,
    );
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}

final creditPointsProvider =
    StateNotifierProvider<CreditPointsNotifier, CreditPointsState>((ref) {
  final convexService = ServiceManager.instance.convexService;
  return CreditPointsNotifier(convexService);
});

final totalCreditsProvider = Provider<int>((ref) {
  return ref.watch(creditPointsProvider).totalCredits;
});

final creditTransactionsProvider = Provider<List<CreditPointsModel>>((ref) {
  return ref.watch(creditPointsProvider).transactions;
});
