int asInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

String asString(dynamic value, [String fallback = '']) {
  if (value == null) return fallback;
  return value.toString();
}
