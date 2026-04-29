import 'package:flutter/material.dart';
import '../services/tournament_service.dart';
import '../models/tournament.dart';
import 'create_tournament_screen.dart';

class TournamentScreen extends StatefulWidget {
  const TournamentScreen({Key? key}) : super(key: key);

  @override
  _TournamentScreenState createState() => _TournamentScreenState();
}

class _TournamentScreenState extends State<TournamentScreen> {
  final TournamentService _tournamentService = TournamentService();
  List<Tournament> _tournamentList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTournaments();
  }

  Future<void> _loadTournaments() async {
    setState(() {
      _isLoading = true;
    });

    List<Tournament> items = await _tournamentService.getTournaments();

    if (mounted) {
      setState(() {
        _tournamentList = items;
        _isLoading = false;
      });
    }
  }

  Future<void> _joinTournament(String id) async {
    bool success = await _tournamentService.joinTournament(id);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(success ? "Successfully Joined Tournament!" : "Failed to join tournament."),
        backgroundColor: success ? Colors.green : Colors.red,
      ));
      if (success) _loadTournaments(); // refresh list
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'TOURNAMENTS',
          style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              _loadTournaments();
            },
          )
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _tournamentList.isEmpty
              ? const Center(child: Text("No tournaments available right now."))
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: _tournamentList.length,
                  itemBuilder: (context, index) {
                    final item = _tournamentList[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16.0),
                      color: Theme.of(context).cardColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  item.sport.toUpperCase(),
                                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: 1.0),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.primary.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: Theme.of(context).colorScheme.primary.withOpacity(0.5)),
                                  ),
                                  child: Text(
                                    "${item.numberOfTeams} TEAMS",
                                    style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold, fontSize: 12),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 16),
                            _buildInfoRow(Icons.location_on, item.venue, context),
                            const SizedBox(height: 8),
                            _buildInfoRow(Icons.calendar_today, item.date, context),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () => _joinTournament(item.id),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context).colorScheme.primary,
                                  foregroundColor: Colors.black,
                                ),
                                child: const Text("JOIN TOURNAMENT"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.black,
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreateTournamentScreen()),
          );
          if (result == true) {
            _loadTournaments();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Theme.of(context).colorScheme.secondary),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: const TextStyle(color: Colors.white70, fontSize: 15))),
      ],
    );
  }
}
