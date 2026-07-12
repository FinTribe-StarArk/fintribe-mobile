import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_model.freezed.dart';
part 'transaction_model.g.dart';

/// Whether money came in or went out.
enum TransactionType {
  @JsonValue('income')
  income,
  @JsonValue('expense')
  expense,
}

/// A single financial transaction — unified domain entity + JSON DTO.
///
/// Sync bookkeeping (`syncStatus`, `isDeleted`) lives in the local DB layer,
/// not here, so this model stays a clean representation of server data.
@freezed
abstract class TransactionModel with _$TransactionModel {
  const factory TransactionModel({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'title') required String title,
    @JsonKey(name: 'amount') required double amount,
    @JsonKey(name: 'type') required TransactionType type,
    @JsonKey(name: 'category') required String category,
    @JsonKey(name: 'note') String? note,
    @JsonKey(name: 'occurred_at') required DateTime occurredAt,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _TransactionModel;

  const TransactionModel._();

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionModelFromJson(json);

  /// Signed amount: negative for expenses, positive for income.
  double get signedAmount =>
      type == TransactionType.expense ? -amount : amount;
}
