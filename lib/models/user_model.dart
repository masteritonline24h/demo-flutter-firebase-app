import 'package:firebase_auth/firebase_auth.dart' as fb;

class UserModel {
  final String id;
  final String email;
  final String? displayName;
  final String? photoUrl;

  UserModel({
    required this.id,
    required this.email,
    this.displayName,
    this.photoUrl,
  });

  // ✅ បន្ថែម Factory Constructor នេះចូលក្នុង UserModel
  factory UserModel.fromFirebaseUser(fb.User user) {
    return UserModel(
      id: user.uid,
      email: user.email ?? '',
      displayName: user.displayName,
      photoUrl: user.photoURL,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
    };
  }
}

class AuthResult {
  final bool success;
  final String message;
  final UserModel? user;
  final String? token;

  AuthResult({
    required this.success,
    required this.message,
    this.user,
    this.token,
  });
}