String? normalizeDomain(String value) {
  final trimmed = value.trim();
  if (trimmed.isEmpty) return null;
  try {
    final parsed = Uri.parse(trimmed.contains('://') ? trimmed : 'https://$trimmed');
    final host = parsed.host.toLowerCase().replaceFirst(RegExp(r'^www\.'), '');
    if (host.isEmpty) return null;
    return host;
  } catch (_) {
    return null;
  }
}

bool domainOk(String value) {
  final hostname = normalizeDomain(value);
  if (hostname == null) return false;
  return hostname.contains('.') &&
      !hostname.contains(' ') &&
      !hostname.contains('/');
}
