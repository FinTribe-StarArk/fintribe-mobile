/// Convenience extensions on [DateTime].
extension DateTimeExtension on DateTime {
  /// Format as "dd MMM yyyy" (e.g., "05 Jul 2026").
  String get formatted => '$day ${_monthAbbr(month)} $year';

  /// Format as "dd MMM yyyy, HH:mm" (e.g., "05 Jul 2026, 14:30").
  String get formattedWithTime =>
      '$day ${_monthAbbr(month)} $year, ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';

  /// Whether this date is today.
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Whether this date is yesterday.
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  /// Human-readable relative time (e.g., "2 hours ago").
  String get timeAgo {
    final diff = DateTime.now().difference(this);
    if (diff.inDays > 365) return '${(diff.inDays / 365).floor()}y ago';
    if (diff.inDays > 30) return '${(diff.inDays / 30).floor()}mo ago';
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';
    return 'just now';
  }

  static String _monthAbbr(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }
}
