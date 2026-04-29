import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../services/user_service.dart';
import 'home_swipe_screen.dart';
import 'match_screen.dart';
import 'tournament_screen.dart';
import 'equipment_marketplace_screen.dart';
import 'profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;
  final UserService _userService = UserService();

  final List<Widget> _screens = [
    const HomeSwipeScreen(),
    const MatchScreen(),
    const TournamentScreen(),
    const EquipmentMarketplaceScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _determineAndSendLocation();
  }

  Future<void> _determineAndSendLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    if (permission == LocationPermission.deniedForever) return;

    try {
      Position position = await Geolocator.getCurrentPosition();
      await _userService.updateLocation(position.latitude, position.longitude);
    } catch (e) {
      print("Error fetching location: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          border: Border(top: BorderSide(color: Colors.white.withOpacity(0.05))),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Colors.grey[600],
          showSelectedLabels: true,
          showUnselectedLabels: false,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.style), label: "Discover"),
            BottomNavigationBarItem(icon: Icon(Icons.sports), label: "Matches"),
            BottomNavigationBarItem(icon: Icon(Icons.emoji_events), label: "Tourneys"),
            BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Gear"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          ],
        ),
      ),
    );
  }
}
