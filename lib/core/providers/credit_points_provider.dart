import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/credit_points_model.dart';

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
  final SupabaseClient _supabase;

  CreditPointsNotifier(this._supabase)
      : super(const CreditPointsState(totalCredits: 0, transactions: []));

  Future<void> loadCreditPoints(String userId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final response = await _supabase
          .from('credit_transactions')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      final transactions = response
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
      final transaction = CreditPointsModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: userId,
        amount: amount,
        type: type,
        description: description,
        referenceId: referenceId,
        referenceType: referenceType,
        createdAt: DateTime.now(),
        expiresAt: DateTime.now().add(const Duration(days: 365)), // 1 year expiry
      );

      final transactionData = transaction.toJson();
      transactionData.remove('id'); // Let Supabase generate the ID

      await _supabase.from('credit_transactions').insert(transactionData);

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
  final supabase = Supabase.instance.client;
  return CreditPointsNotifier(supabase);
});

final totalCreditsProvider = Provider<int>((ref) {
  return ref.watch(creditPointsProvider).totalCredits;
});

final creditTransactionsProvider = Provider<List<CreditPointsModel>>((ref) {
  return ref.watch(creditPointsProvider).transactions;
});
