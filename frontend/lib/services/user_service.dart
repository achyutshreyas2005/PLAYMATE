import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants.dart';
import '../models/user.dart';
import 'api_service.dart';

class UserService {
  final ApiService _apiService = ApiService();

  Future<List<User>> getNearbyUsers() async {
    try {
      final headers = await _apiService.getAuthHeaders();
      final response = await http.get(
        Uri.parse('${Constants.baseUrl}/users/nearby'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        Iterable jsonList = json.decode(response.body);
        return List<User>.from(jsonList.map((model) => User.fromJson(model)));
      }
    } catch(e) {
      print("Error fetching nearby users: $e");
    }
    return [];
  }

  Future<User?> getProfile() async {
    try {
      final headers = await _apiService.getAuthHeaders();
      final response = await http.get(
        Uri.parse('${Constants.baseUrl}/users/profile'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return User.fromJson(json.decode(response.body));
      }
    } catch(e) {
      print("Error fetching profile: $e");
    }
    return null;
  }

  Future<void> updateLocation(double lat, double lon) async {
    try {
      final headers = await _apiService.getAuthHeaders();
      await http.put(
        Uri.parse('${Constants.baseUrl}/users/location?lat=$lat&lon=$lon'),
        headers: headers,
      );
    } catch(e) {
      print("Error updating location: $e");
    }
  }
}
