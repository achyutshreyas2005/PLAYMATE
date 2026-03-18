import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

class CreateMatchScreen extends StatefulWidget {
  const CreateMatchScreen({super.key});

  @override
  State<CreateMatchScreen> createState() => _CreateMatchScreenState();
}

class _CreateMatchScreenState extends State<CreateMatchScreen> {

  final _playersController = TextEditingController();

  String _selectedSport = "Cricket";
  final List<String> _sportOptions = [
    "Cricket",
    "Football",
    "Badminton",
    "Tennis",
  ];

  String _selectedSkill = "Beginner";
  final List<String> _skillOptions = [
    "Beginner",
    "Intermediate",
    "Legendary",
  ];

  bool _isLoading = false;

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white24),
        borderRadius: BorderRadius.circular(6),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }

  Future<void> _createMatch() async {
    setState(() => _isLoading = true);

    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;

      LocationPermission permission =
      await Geolocator.requestPermission();

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Location permission denied")),
        );

        setState(() => _isLoading = false);
        return;
      }

      Position position =
      await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      await FirebaseFirestore.instance
          .collection('matches')
          .add({
        'createdBy': uid,
        'sport': _selectedSport,
        'skillRequired': _selectedSkill,
        'playersNeeded':
        int.tryParse(_playersController.text) ?? 0,
        'latitude': position.latitude,
        'longitude': position.longitude,
        'createdAt': Timestamp.now(),
        'joinedPlayers': [],
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Match Created")),
      );

      Navigator.pop(context);

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }

    setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _playersController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          "Create Match",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
            horizontal: 24, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              "Sport",
              style: TextStyle(color: Colors.white70),
            ),

            const SizedBox(height: 8),

            DropdownButtonFormField<String>(
              value: _selectedSport,
              dropdownColor: Colors.black,
              style: const TextStyle(color: Colors.white),
              decoration: _inputDecoration("Select sport"),
              items: _sportOptions.map((sport) {
                return DropdownMenuItem(
                  value: sport,
                  child: Text(
                    sport,
                    style:
                    const TextStyle(color: Colors.white),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedSport = value!;
                });
              },
            ),

            const SizedBox(height: 30),

            const Text(
              "Skill Required",
              style: TextStyle(color: Colors.white70),
            ),

            const SizedBox(height: 8),

            DropdownButtonFormField<String>(
              value: _selectedSkill,
              dropdownColor: Colors.black,
              style: const TextStyle(color: Colors.white),
              decoration:
              _inputDecoration("Select skill level"),
              items: _skillOptions.map((level) {
                return DropdownMenuItem(
                  value: level,
                  child: Text(
                    level,
                    style:
                    const TextStyle(color: Colors.white),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedSkill = value!;
                });
              },
            ),

            const SizedBox(height: 30),

            const Text(
              "Players Needed",
              style: TextStyle(color: Colors.white70),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: _playersController,
              keyboardType: TextInputType.number,
              style:
              const TextStyle(color: Colors.white),
              decoration:
              _inputDecoration("Enter number of players"),
            ),

            const SizedBox(height: 50),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed:
                _isLoading ? null : _createMatch,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(6),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(
                  color: Colors.black,
                )
                    : const Text(
                  "Create Match",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}