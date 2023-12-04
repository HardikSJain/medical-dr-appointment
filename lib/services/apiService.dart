import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

String baseUrl = 'https://showdigital.in/flutter-schedules';

Future<bool> getBackendStatusAPI() async {
  try {
    var url = Uri.parse('$baseUrl/list_schedule.php');
    final response = await http.get(url);
    return true;
  } catch (e) {
    return true;
    // return false;
  }
}
