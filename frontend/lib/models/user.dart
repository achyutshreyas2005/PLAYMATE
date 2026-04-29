class User {
  final String id;
  final String name;
  final String email;
  final int age;
  final String gender;
  final List<String> sportsInterests;
  final String skillLevel;
  final String? profilePhoto;
  final String? bio;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.age,
    required this.gender,
    required this.sportsInterests,
    required this.skillLevel,
    this.profilePhoto,
    this.bio,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      age: json['age'],
      gender: json['gender'],
      sportsInterests: List<String>.from(json['sports_interests'] ?? []),
      skillLevel: json['skill_level'],
      profilePhoto: json['profile_photo'],
      bio: json['bio'],
    );
  }
}
