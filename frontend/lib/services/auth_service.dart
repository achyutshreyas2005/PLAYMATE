import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants.dart';
import 'api_service.dart';

class AuthService {
  final ApiService _apiService = ApiService();

  Future<bool> login(String email, String password) async {
    try {
        final response = await http.post(
        Uri.parse('${Constants.baseUrl}/auth/login'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
            'username': email,
            'password': password,
        },
        );

        if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        await _apiService.saveToken(jsonResponse['access_token']);
        return true;
        }
    } catch(e) {
        print("Login Error: \$e");
    }
    return false;
  }
  
  Future<void> logout() async {
      await _apiService.clearToken();
  }

  Future<bool> register(Map<String, dynamic> userData) async {
    try {
      final response = await http.post(
        Uri.parse('${Constants.baseUrl}/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(userData),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        await _apiService.saveToken(jsonResponse['access_token']);
        return true;
      } else {
        print("Register failed: ${response.body}");
      }
    } catch(e) {
      print("Register Error: $e");
    }
    return false;
  }
}
