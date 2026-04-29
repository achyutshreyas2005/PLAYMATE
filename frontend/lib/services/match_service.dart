import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants.dart';
import '../models/match.dart';
import 'api_service.dart';

class MatchService {
  final ApiService _apiService = ApiService();

  Future<List<PlayMatch>> getMatches() async {
    try {
      final headers = await _apiService.getAuthHeaders();
      final response = await http.get(Uri.parse('${Constants.baseUrl}/matches/list'), headers: headers);
      if (response.statusCode == 200) {
        Iterable l = json.decode(response.body);
        return List<PlayMatch>.from(l.map((m) => PlayMatch.fromJson(m)));
      }
    } catch(e) { }
    return [];
  }

  Future<bool> createMatch(Map<String, dynamic> matchData) async {
    try {
      final headers = await _apiService.getAuthHeaders();
      final response = await http.post(
        Uri.parse('${Constants.baseUrl}/matches/create'),
        headers: headers,
        body: json.encode(matchData),
      );
      return response.statusCode == 200;
    } catch(e) {}
    return false;
  }

  Future<bool> joinMatch(String matchId) async {
    try {
      final headers = await _apiService.getAuthHeaders();
      final response = await http.post(
        Uri.parse('${Constants.baseUrl}/matches/join/$matchId'),
        headers: headers,
      );
      return response.statusCode == 200;
    } catch(e) {}
    return false;
  }
}
