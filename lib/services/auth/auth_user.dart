import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart';

@immutable
class AuthUser {
  final String id;
  final String email;
  final bool isEmailVerified;
  final String username;

  const AuthUser({
    required this.id,
    required this.email,
    required this.username,
    required this.isEmailVerified,
  });

  factory AuthUser.fromFirebase(User user) => AuthUser(
        id: user.uid,
        email: user.email!,
        username: user.displayName ?? "",
        isEmailVerified: user.emailVerified,
      );
}
