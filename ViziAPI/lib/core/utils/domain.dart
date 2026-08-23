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
  final isLocalhost = hostname == 'localhost';
  final isIpv4 = RegExp(r'^(?:\d{1,3}\.){3}\d{1,3}$').hasMatch(hostname);
  return (hostname.contains('.') || isLocalhost || isIpv4) &&
      !hostname.contains(' ') &&
      !hostname.contains('/');
}
