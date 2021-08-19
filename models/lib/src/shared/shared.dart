import 'dart:core';

DateTime? dateTimefromMilliseconds(dynamic date) {
  if (date != null) {
    if (date is int) {
      return DateTime.fromMillisecondsSinceEpoch(date);
    } else if (date is String) {
      return DateTime.tryParse(date);
    }
  }
  return null;
}

int dateTimetoMilliseconds(DateTime? date) => date?.millisecondsSinceEpoch ?? 0;
