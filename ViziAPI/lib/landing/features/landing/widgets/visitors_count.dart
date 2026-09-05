import 'dart:convert';
import 'package:http/http.dart' as http;

class VisitorCount {
  final int totalVisitors;

  const VisitorCount({
    required this.totalVisitors,
  });

  factory VisitorCount.fromJson(Map<String, dynamic> json) {
    return VisitorCount(
      totalVisitors: (json['totalVisitors'] as num?)?.toInt() ?? 0,
    );
  }
}

Future<VisitorCount> fetchVisitorCount() async {
  final response = await http.get(
    Uri.parse(
      'https://viziapi.onrender.com/api/v1/public/sites/site_9b8598d3b4524feb879d5c27ac76bb8c/visitor-count',
    ),
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to load visitor count (${response.statusCode})');
  }

  final json = jsonDecode(response.body) as Map<String, dynamic>;

  return VisitorCount.fromJson(json);
}
