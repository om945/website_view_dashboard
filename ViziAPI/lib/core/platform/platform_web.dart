// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:html' as html;
import 'package:http/browser_client.dart';
import 'package:http/http.dart' as http;

http.Client createClient() => BrowserClient()..withCredentials = true;
void openUrl(String url) => html.window.location.href = url;
bool openExternalUrl(String url) {
  try {
    html.window.open(url, '_blank', 'noopener,noreferrer');
    return true;
  } catch (_) {
    return false;
  }
}

String? selectedSiteId() => html.window.localStorage['website_view_selected_site'];
void setSelectedSiteId(String? id) {
  if (id == null) {
    html.window.localStorage.remove('website_view_selected_site');
  } else {
    html.window.localStorage['website_view_selected_site'] = id;
  }
}
