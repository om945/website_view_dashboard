import 'package:http/http.dart' as http;

http.Client createClient() => http.Client();
void openUrl(String url) {}
bool openExternalUrl(String url) => false;
String? selectedSiteId() => null;
void setSelectedSiteId(String? id) {}
