class User {
  final int id;
  final String username;
  final String fullName;
  final String email;
  final String role;
  final DateTime? createdAt;

  User({
    required this.id,
    required this.username,
    required this.fullName,
    required this.email,
    required this.role,
    this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? json['userId'],
      username: json['username'],
      fullName: json['fullName'] ?? json['username'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'USER',
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'fullName': fullName,
      'email': email,
      'role': role,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  bool get isAdmin => role == 'ADMIN';
}
