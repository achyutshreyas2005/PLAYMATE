import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants.dart';
import '../models/equipment.dart';
import 'api_service.dart';

class EquipmentService {
  final ApiService _apiService = ApiService();

  Future<List<Equipment>> getEquipment() async {
    try {
      final headers = await _apiService.getAuthHeaders();
      final response = await http.get(Uri.parse('${Constants.baseUrl}/equipment/list'), headers: headers);
      if (response.statusCode == 200) {
        Iterable l = json.decode(response.body);
        return List<Equipment>.from(l.map((model) => Equipment.fromJson(model)));
      }
    } catch(e) {
      print("Error fetching equipment: $e");
    }
    return [];
  }

  Future<bool> buyEquipment(String equipmentId) async {
    try {
      final headers = await _apiService.getAuthHeaders();
      final response = await http.post(
        Uri.parse('${Constants.baseUrl}/equipment/buy/$equipmentId'),
        headers: headers,
      );
      return response.statusCode == 200;
    } catch(e) {
      print("Error buying equipment: $e");
    }
    return false;
  }

  Future<bool> addEquipment(Map<String, dynamic> equipmentData) async {
    try {
      final headers = await _apiService.getAuthHeaders();
      final response = await http.post(
        Uri.parse('${Constants.baseUrl}/equipment/add'),
        headers: headers,
        body: json.encode(equipmentData),
      );
      return response.statusCode == 200;
    } catch (e) {
      print("Error adding equipment: $e");
    }
    return false;
  }
}
