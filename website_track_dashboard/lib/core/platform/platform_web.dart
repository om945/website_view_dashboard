// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:html' as html;
import 'package:http/browser_client.dart';
import 'package:http/http.dart' as http;

http.Client createClient() => BrowserClient()..withCredentials = true;
void openUrl(String url) => html.window.location.href = url;

String? selectedSiteId() => html.window.localStorage['website_view_selected_site'];
void setSelectedSiteId(String? id) {
  if (id == null) {
    html.window.localStorage.remove('website_view_selected_site');
  } else {
    html.window.localStorage['website_view_selected_site'] = id;
  }
}

class PresenceSocket {
  PresenceSocket(this._socket);
  final html.WebSocket? _socket;

  Stream<void> get onOpen =>
      _socket?.onOpen.map((_) {}) ?? const Stream<void>.empty();
  Stream<void> get onClose =>
      _socket?.onClose.map((_) {}) ?? const Stream<void>.empty();
  Stream<void> get onError =>
      _socket?.onError.map((_) {}) ?? const Stream<void>.empty();

  void close() {
    try {
      _socket?.close();
    } catch (_) {}
  }
}

PresenceSocket connectPresence(String url) {
  try {
    return PresenceSocket(html.WebSocket(url));
  } catch (_) {
    return PresenceSocket(null);
  }
}
