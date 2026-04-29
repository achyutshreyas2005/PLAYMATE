class Tournament {
  final String id;
  final String sport;
  final String venue;
  final String date;
  final int numberOfTeams;
  final String organizerId;

  Tournament({
    required this.id, required this.sport, required this.venue,
    required this.date, required this.numberOfTeams, required this.organizerId
  });

  factory Tournament.fromJson(Map<String, dynamic> json) => Tournament(
    id: json['id'], sport: json['sport'], venue: json['venue'],
    date: json['date'], numberOfTeams: json['number_of_teams'], organizerId: json['organizer_id']
  );
}
