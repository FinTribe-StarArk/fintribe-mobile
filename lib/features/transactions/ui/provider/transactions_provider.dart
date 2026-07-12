import 'dart:async';

import 'package:fintribe/core/network/network_exceptions.dart';
import 'package:fintribe/core/providers.dart';
import 'package:fintribe/features/transactions/data/repo/transaction_repo.dart';
import 'package:fintribe/features/transactions/domain/model/transaction_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Offline-first list of transactions.
///
/// [build] returns cached rows immediately, then kicks off a best-effort
/// server refresh — so the UI has data even offline. Mutations write locally
/// (instantly reflected) and trigger a background sync.
final class TransactionsNotifier extends AsyncNotifier<List<TransactionModel>> {
  TransactionRepo get _repo => ref.read(transactionRepoProvider);

  @override
  Future<List<TransactionModel>> build() async {
    final cached = await _repo.getAll();
    // Fire-and-forget remote refresh; failures leave cached data in place.
    unawaited(_refreshInBackground());
    return cached;
  }

  Future<void> _refreshInBackground() async {
    try {
      final fresh = await _repo.refresh();
      state = AsyncData(fresh);
    } on NetworkException {
      // Offline or server error — keep showing the cache silently.
    }
  }

  /// Pull-to-refresh: surface errors to the UI via [AsyncValue.guard].
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_repo.refresh);
  }

  /// Adds a transaction, then optimistically reloads the local list.
  Future<void> add({
    required String title,
    required double amount,
    required TransactionType type,
    required String category,
    String? note,
  }) async {
    await _repo.create(
      title: title,
      amount: amount,
      type: type,
      category: category,
      note: note,
    );
    await _reload();
    unawaited(ref.read(syncEngineProvider).sync());
  }

  /// Deletes a transaction and reloads the local list.
  Future<void> remove(TransactionModel transaction) async {
    await _repo.delete(transaction);
    await _reload();
    unawaited(ref.read(syncEngineProvider).sync());
  }

  Future<void> _reload() async {
    state = AsyncData(await _repo.getAll());
  }
}

/// The transactions list provider.
final transactionsProvider =
    AsyncNotifierProvider<TransactionsNotifier, List<TransactionModel>>(
      TransactionsNotifier.new,
    );
