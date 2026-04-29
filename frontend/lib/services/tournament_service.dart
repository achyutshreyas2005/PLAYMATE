import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants.dart';
import '../models/tournament.dart';
import 'api_service.dart';

class TournamentService {
  final ApiService _apiService = ApiService();

  Future<List<Tournament>> getTournaments() async {
    try {
      final headers = await _apiService.getAuthHeaders();
      final response = await http.get(Uri.parse('${Constants.baseUrl}/tournaments/list'), headers: headers);
      if (response.statusCode == 200) {
        Iterable l = json.decode(response.body);
        return List<Tournament>.from(l.map((model) => Tournament.fromJson(model)));
      }
    } catch(e) {
      print("Error fetching tournaments: $e");
    }
    return [];
  }

  Future<bool> joinTournament(String tournamentId) async {
    try {
      final headers = await _apiService.getAuthHeaders();
      final response = await http.post(
        Uri.parse('${Constants.baseUrl}/tournaments/join/$tournamentId'),
        headers: headers,
      );
      return response.statusCode == 200;
    } catch(e) {
      print("Error joining tournament: $e");
    }
    return false;
  }

  Future<bool> createTournament(Map<String, dynamic> tournamentData) async {
    try {
      final headers = await _apiService.getAuthHeaders();
      final response = await http.post(
        Uri.parse('${Constants.baseUrl}/tournaments/create'),
        headers: headers,
        body: json.encode(tournamentData),
      );
      return response.statusCode == 200;
    } catch (e) {
      print("Error creating tournament: $e");
    }
    return false;
  }
}
