import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'match_chat_screen.dart';

class MatchListScreen extends StatelessWidget {
  const MatchListScreen({super.key});

  Future<double> _calculateDistance(double lat, double lng) async {
    try {
      Position userPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      double meters = Geolocator.distanceBetween(
        userPosition.latitude,
        userPosition.longitude,
        lat,
        lng,
      );

      return meters / 1000;
    } catch (_) {
      return 0.0;
    }
  }

  Future<void> _joinMatch(String matchId, String uid) async {
    await FirebaseFirestore.instance
        .collection('matches')
        .doc(matchId)
        .set({
      'joinedPlayers': FieldValue.arrayUnion([uid])
    }, SetOptions(merge: true));
  }

  @override
  Widget build(BuildContext context) {
    final currentUid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Matches",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('matches')
            .snapshots(),
        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(
                child: CircularProgressIndicator(color: Colors.black));
          }

          final matches = snapshot.data!.docs;

          if (matches.isEmpty) {
            return const Center(
              child: Text(
                "No matches available",
                style: TextStyle(color: Colors.black54),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            itemCount: matches.length,
            itemBuilder: (context, index) {

              final doc = matches[index];
              final data = doc.data() as Map<String, dynamic>;
              final matchId = doc.id;

              final sport = data['sport'] ?? "Unknown";
              final skill = data['skillRequired'] ?? "N/A";

              int playersNeeded =
                  int.tryParse(data['playersNeeded'].toString()) ?? 0;

              final joinedPlayers =
              (data['joinedPlayers'] is List)
                  ? List<String>.from(data['joinedPlayers'])
                  : [];

              final joinedCount = joinedPlayers.length;

              final alreadyJoined =
              joinedPlayers.contains(currentUid);

              final isFull =
                  playersNeeded > 0 && joinedCount >= playersNeeded;

              final lat =
                  double.tryParse(data['latitude'].toString()) ?? 0.0;

              final lng =
                  double.tryParse(data['longitude'].toString()) ?? 0.0;

              return FutureBuilder<double>(
                future: _calculateDistance(lat, lng),
                builder: (context, distanceSnapshot) {

                  final distance =
                      distanceSnapshot.data ?? 0.0;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // Sport
                      Text(
                        sport,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),

                      const SizedBox(height: 6),

                      // Skill + Distance
                      Text(
                        "$skill • ${distance.toStringAsFixed(2)} km away",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Progress Bar (Minimal)
                      Container(
                        height: 4,
                        width: double.infinity,
                        color: Colors.black12,
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: playersNeeded == 0
                              ? 0
                              : joinedCount / playersNeeded,
                          child: Container(
                            color: Colors.black,
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        "$joinedCount / $playersNeeded players joined",
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Buttons
                      Row(
                        children: [

                          Expanded(
                            child: ElevatedButton(
                              onPressed:
                              (alreadyJoined || isFull)
                                  ? null
                                  : () => _joinMatch(
                                matchId,
                                currentUid,
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                foregroundColor: Colors.white,
                                disabledBackgroundColor: Colors.black12,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                alreadyJoined
                                    ? "Joined"
                                    : isFull
                                    ? "Full"
                                    : "Join",
                              ),
                            ),
                          ),

                          const SizedBox(width: 10),

                          Expanded(
                            child: OutlinedButton(
                              onPressed: alreadyJoined
                                  ? () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        MatchChatScreen(
                                            matchId: matchId),
                                  ),
                                );
                              }
                                  : null,
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.black,
                                side: const BorderSide(color: Colors.black),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              child: const Text("Chat"),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),

                      const Divider(color: Colors.black12, thickness: 1),

                      const SizedBox(height: 32),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}