// ignore_for_file: deprecated_member_use, avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:http/browser_client.dart';
import 'package:http/http.dart' as http;

http.Client createClient() => BrowserClient()..withCredentials = true;
void openUrl(String url) => html.window.location.href = url;

class PresenceSocket {
  PresenceSocket(this.socket);
  final html.WebSocket socket;
  Stream<void> get onOpen => socket.onOpen.map((_) {});
  Stream<void> get onClose => socket.onClose.map((_) {});
  Stream<void> get onError => socket.onError.map((_) {});
  void close() => socket.close();
}

PresenceSocket connectPresence(String url) => PresenceSocket(html.WebSocket(url));
