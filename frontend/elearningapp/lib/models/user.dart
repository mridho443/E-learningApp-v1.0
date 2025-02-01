class User {
  final int id;
  final String name;
  final String email;
  final String? emailVerifiedAt; 
  final String role;
  final String? token; 

  User({
    required this.id,
    required this.name,
    required this.email,
    this.emailVerifiedAt,
    required this.role,
    this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      emailVerifiedAt: json['email_verified_at'],
      role: json['role'], 
      token: null, 
    );
  }
}
