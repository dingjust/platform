import 'dart:core';

DateTime dateTimefromMilliseconds(dynamic date) {
  if (date != null) {
    if (date is int) {
      return DateTime.fromMillisecondsSinceEpoch(date);
    } else if (date is String) {
      return DateTime.tryParse(date);
    }
  }
  return null;
}
// date == null ? null : DateTime.fromMillisecondsSinceEpoch(date);
