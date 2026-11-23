import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginApi {
  static const String baseUrl = 'http://My_API_URL';

  static Future<bool> login(
    String email,
    String password,
  ) async {
    final url = Uri.parse('$baseUrl/login');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return true;
    }

    return false;
  }
}