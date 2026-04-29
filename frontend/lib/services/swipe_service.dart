import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants.dart';
import 'api_service.dart';

class SwipeService {
  final ApiService _apiService = ApiService();

  Future<bool> swipeUser(String swipedId, String direction) async {
    try {
      final headers = await _apiService.getAuthHeaders();
      final response = await http.post(
        Uri.parse('${Constants.baseUrl}/swipe/\$direction'),
        headers: headers,
        body: json.encode({'swiped_id': swipedId, 'direction': direction}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['is_match'] == true;
      }
    } catch(e) {
      print("Swipe Error: \$e");
    }
    return false;
  }
}
