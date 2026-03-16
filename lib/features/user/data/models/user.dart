class User {
  final int id;
  final String email;
  final String role;
  final String firstName;
  final String lastName;

  User({
    required this.id,
    required this.email,
    required this.role,
    required this.firstName,
    required this.lastName,
  });


  factory User.fromJson(Map <String, dynamic> json){
    return User(
      id: json['id'],
      email: json['email'],
      role: json['role'],
      firstName: json['firstName'],
      lastName: json['lastName'],
    );
  }

  @override
  String toString() {
    return 'User(id: $id, email: $email, role: $role, firstName: $firstName, lastName: $lastName)';
  }

  User copyWith ({
    int? id,
    String? email,
    String? role,
    String? firstName,
    String? lastName,
  }) {
    return User (
      id: id ?? this.id,
      email: email ?? this.email,
      role: role ?? this.role,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
    );
  }

  String get fullName => '$firstName $lastName';
}