import 'dart:convert';

import 'package:http/http.dart' as http;

String baseUrl = 'https://showdigital.in/flutter-schedules';

Future<bool> getBackendStatusAPI() async {
  try {
    var url = Uri.parse('$baseUrl/list_schedule.php');
    final response = await http.get(url);
    return true;
  } catch (e) {
    return false;
  }
}

Future<List<Map<String, dynamic>>> getListOfSchedules() async {
  try {
    var url = Uri.parse('$baseUrl/list_schedule.php');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // Successful response
      List<dynamic> data = json.decode(response.body);

      // Return the list of maps
      return List<Map<String, dynamic>>.from(data);
    } else {
      // If the server did not return a 200 OK response,
      // throw an exception.
      throw Exception('Failed to load data');
    }
  } catch (e) {
    print('Error: $e');
    return [];
  }
}

Future<bool> createScheduleAPI(Map<String, dynamic> scheduleData) async {
  try {
    var url = Uri.parse('$baseUrl/create_schedule.php');
    final response = await http.post(
      url,
      body: jsonEncode(scheduleData),
      headers: {'Content-Type': 'application/json'},
    );

    print(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      // Successful response
      print('Create Schedule API call successful');
      return true;
    } else {
      // throw an exception.
      // print(response.body);
      print(response.statusCode);
      throw Exception('Failed to create schedule');
    }
  } catch (e) {
    print('Error: $e');
    return false;
  }
}

Future<bool> updateScheduleAPI(
    Map<String, dynamic> scheduleData, String id) async {
  try {
    var url = Uri.parse('$baseUrl/update_schedule.php');
    final response = await http.post(
      url,
      body: jsonEncode(scheduleData),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      // Successful response
      print('Update Schedule API call successful');
      print(response.body);
      return true;
    } else {
      // If the server did not return a 200 OK response,
      // throw an exception.
      throw Exception('Failed to update schedule');
    }
  } catch (e) {
    print('Error: $e');
    return false;
  }
}

Future<bool> deleteScheduleAPI(String id) async {
  try {
    var url = Uri.parse('$baseUrl/delete_schedule.php?id=$id');
    final response = await http.delete(url);

    if (response.statusCode == 200) {
      // Successful response
      print('Delete Schedule API call successful');
      print(response.body);
      return true;
    } else {
      // If the server did not return a 200 OK response,
      // throw an exception.
      throw Exception('Failed to delete schedule');
    }
  } catch (e) {
    print('Error: $e');
    return false;
  }
}
