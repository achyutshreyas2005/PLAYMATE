import 'package:flutter/material.dart';
import '../services/user_service.dart';
import '../models/user.dart';

class UserProvider extends ChangeNotifier {
  final UserService _userService = UserService();
  
  List<User> _nearbyUsers = [];
  bool _isLoading = false;

  List<User> get nearbyUsers => _nearbyUsers;
  bool get isLoading => _isLoading;

  Future<void> fetchNearbyUsers() async {
    _isLoading = true;
    notifyListeners();

    try {
      _nearbyUsers = await _userService.getNearbyUsers();
    } catch (e) {
      _nearbyUsers = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
