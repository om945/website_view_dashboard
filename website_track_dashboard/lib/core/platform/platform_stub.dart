import 'package:http/http.dart' as http;

http.Client createClient() => http.Client();
void openUrl(String url) {}
String? selectedSiteId() => null;
void setSelectedSiteId(String? id) {}

class PresenceSocket {
  Stream<void> get onOpen => const Stream<void>.empty();
  Stream<void> get onClose => const Stream<void>.empty();
  Stream<void> get onError => const Stream<void>.empty();
  void close() {}
}

PresenceSocket connectPresence(String url) => PresenceSocket();
