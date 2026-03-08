class User {
  final int id;
  final String email;
  final String role;
  final String? name;

  User({
    required this.id,
    required this.email,
    required this.role,
    this.name,
  });


  factory User.fromJson(Map <String, dynamic> json){
    return User(
      id: json['id'],
      email: json['email'],
      role: json['role'],
      name: json['name'],
    );
  }

  @override
  String toString() {
    return 'User(id: $id, email: $email, role: $role, name: $name)';
  }

  User copyWith ({
    int? id,
    String? email,
    String? role,
    String? name,
  }) {
    return User (
      id: id ?? this.id,
      email: email ?? this.email,
      role: role ?? this.role,
      name: name ?? this.name,
    );
  }
}