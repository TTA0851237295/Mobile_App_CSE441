class User {
  final int id;
  final String username;
  final String fullName;
  final String? displayName;
  final String email;
  final String role;
  final bool isActive;
  final String themeMode;
  final DateTime? createdAt;

  User({
    required this.id,
    required this.username,
    required this.fullName,
    this.displayName,
    required this.email,
    required this.role,
    this.isActive = true,
    this.themeMode = 'LIGHT',
    this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? json['userId'] ?? 0,
      username: json['username'] ?? '',
      fullName: json['fullName'] ?? json['displayName'] ?? json['username'] ?? '',
      displayName: json['displayName'],
      email: json['email'] ?? '',
      role: json['role'] ?? 'USER',
      isActive: json['isActive'] ?? true,
      themeMode: json['themeMode'] ?? 'LIGHT',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'fullName': fullName,
      'displayName': displayName,
      'email': email,
      'role': role,
      'isActive': isActive,
      'themeMode': themeMode,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  bool get isAdmin => role == 'ADMIN';

  String get displayNameOrUsername => displayName ?? (fullName.isNotEmpty ? fullName : username);
}
