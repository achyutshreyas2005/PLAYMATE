class PlayMatch {
  final String id;
  final String sport;
  final String location;
  final String time;
  final int numberOfPlayers;
  final String skillLevel;
  final String organizerId;

  PlayMatch({
    required this.id, required this.sport, required this.location,
    required this.time, required this.numberOfPlayers,
    required this.skillLevel, required this.organizerId
  });

  factory PlayMatch.fromJson(Map<String, dynamic> json) => PlayMatch(
    id: json['id'], sport: json['sport'], location: json['location'],
    time: json['time'], numberOfPlayers: json['number_of_players'],
    skillLevel: json['skill_level'], organizerId: json['organizer_id']
  );
}
