import 'dart:convert';
import 'package:http/http.dart' as http;

class RegistrationApi {
  static const String baseUrl = 'http://My_API_URL';

  static Future<bool> register(
    String name,
    String email,
    String password,e
  ) async {
    final url = Uri.parse('$baseUrl/register');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200 ||
        response.statusCode == 201) {
      return true;
    }

    return false;
  }
}