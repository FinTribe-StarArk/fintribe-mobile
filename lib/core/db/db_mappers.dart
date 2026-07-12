/// Small helpers to bridge Dart types and SQLite storage types.
///
/// SQLite only stores `int`, `double`, `String`, `Uint8List`, and `null`.
/// These helpers keep the per-DAO `toDb`/`fromDb` mappers short and avoid
/// repeating the same `bool <-> int` / `DateTime <-> String` conversions.
abstract final class DbMap {
  DbMap._();

  /// `true`/`false` -> `1`/`0`. Pass-through for `null`.
  static int? boolToInt(bool? value) => value == null ? null : (value ? 1 : 0);

  /// `1` -> `true`, anything else -> `false`.
  static bool intToBool(Object? value) => value == 1 || value == true;

  /// [DateTime] -> ISO-8601 UTC string. Pass-through for `null`.
  ///
  /// Times are normalized to UTC on the way in and read back as UTC (see
  /// [isoToDate]) so a round-trip is lossless; convert to local at display time.
  static String? dateToIso(DateTime? value) => value?.toUtc().toIso8601String();

  /// ISO-8601 string -> UTC [DateTime]. Throws if [value] is not a `String`.
  static DateTime isoToDate(Object? value) =>
      DateTime.parse(value! as String).toUtc();

  /// ISO-8601 string -> UTC [DateTime], or `null` when absent.
  static DateTime? isoToDateOrNull(Object? value) =>
      value == null ? null : DateTime.parse(value as String).toUtc();
}
