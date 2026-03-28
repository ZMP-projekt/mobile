class Trainer {
  final String firstName;
  final String lastName;
  final String? photoUrl;

  Trainer({
    required this.firstName,
    required this.lastName,
    this.photoUrl,
  });

  String get fullName => '$firstName $lastName';

  factory Trainer.fromJson(Map<String, dynamic> json) {
    return Trainer(
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      photoUrl: json['photoUrl'],
    );
  }

  String get displayAvatarUrl => photoUrl ?? 'https://api.dicebear.com/9.x/thumbs/png?seed=$firstName&shapeColor=00d2d3,ff2a7a,b721ff&backgroundColor=0a0a14';
}