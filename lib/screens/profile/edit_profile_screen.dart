import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {

  final _nameController = TextEditingController();

  String _selectedSport = "Cricket";
  final List<String> _sportOptions = [
    "Cricket",
    "Football",
    "Badminton",
    "Tennis",
  ];

  String _selectedSkillLevel = "Beginner";
  final List<String> _skillOptions = [
    "Beginner",
    "Intermediate",
    "Legendary",
  ];

  Future<void> updateProfile() async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .set({
        'name': _nameController.text.trim(),
        'sport': _selectedSport,
        'skillLevel': _selectedSkillLevel,
      }, SetOptions(merge: true));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile Updated")),
      );

      Navigator.pop(context);

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

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

  @override
  void dispose() {
    _nameController.dispose();
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
          "Edit Profile",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              "Name",
              style: TextStyle(color: Colors.white70),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: _nameController,
              style: const TextStyle(color: Colors.white),
              decoration: _inputDecoration("Enter your name"),
            ),

            const SizedBox(height: 30),

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
                return DropdownMenuItem<String>(
                  value: sport,
                  child: Text(
                    sport,
                    style: const TextStyle(color: Colors.white),
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
              "Skill Level",
              style: TextStyle(color: Colors.white70),
            ),

            const SizedBox(height: 8),

            DropdownButtonFormField<String>(
              value: _selectedSkillLevel,
              dropdownColor: Colors.black,
              style: const TextStyle(color: Colors.white),
              decoration: _inputDecoration("Select skill level"),
              items: _skillOptions.map((level) {
                return DropdownMenuItem<String>(
                  value: level,
                  child: Text(
                    level,
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedSkillLevel = value!;
                });
              },
            ),

            const SizedBox(height: 50),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: updateProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: const Text(
                  "Save",
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