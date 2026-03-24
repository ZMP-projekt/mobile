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
}