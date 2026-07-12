import 'package:fintribe/core/global_widgets/app_empty_widget.dart';
import 'package:fintribe/core/global_widgets/app_error_widget.dart';
import 'package:fintribe/core/global_widgets/app_loader.dart';
import 'package:fintribe/features/transactions/domain/model/transaction_model.dart';
import 'package:fintribe/features/transactions/ui/provider/transactions_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

/// Offline-first list of transactions with pull-to-refresh and quick-add.
final class TransactionsScreen extends ConsumerWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = ref.watch(transactionsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Transactions')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addSample(ref),
        child: const Icon(Icons.add),
      ),
      body: transactions.when(
        loading: () => const AppLoader(),
        error: (error, _) => AppErrorWidget(
          message: error.toString(),
          onRetry: () => ref.read(transactionsProvider.notifier).refresh(),
        ),
        data: (items) {
          if (items.isEmpty) {
            return const AppEmptyWidget(message: 'No transactions yet');
          }
          return RefreshIndicator(
            onRefresh: () => ref.read(transactionsProvider.notifier).refresh(),
            child: ListView.separated(
              itemCount: items.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (_, i) => _TransactionTile(transaction: items[i]),
            ),
          );
        },
      ),
    );
  }

  /// Demo helper — adds a placeholder transaction to exercise offline write.
  void _addSample(WidgetRef ref) {
    ref
        .read(transactionsProvider.notifier)
        .add(
          title: 'Coffee',
          amount: 4.5,
          type: TransactionType.expense,
          category: 'Food',
        );
  }
}

class _TransactionTile extends ConsumerWidget {
  const _TransactionTile({required this.transaction});

  final TransactionModel transaction;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isExpense = transaction.type == TransactionType.expense;
    final color = isExpense ? Colors.red : Colors.green;
    final money = NumberFormat.simpleCurrency().format(transaction.amount);

    return Dismissible(
      key: ValueKey(transaction.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) =>
          ref.read(transactionsProvider.notifier).remove(transaction),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: ListTile(
        title: Text(transaction.title),
        subtitle: Text(transaction.category),
        trailing: Text(
          '${isExpense ? '-' : '+'}$money',
          style: TextStyle(color: color, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
