
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UserCredential> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final cleanName = name.trim();
    final cleanEmail = email.trim();

    if (cleanName.isEmpty) {
      throw Exception('Please enter your full name.');
    }

    final credential = await _auth.createUserWithEmailAndPassword(
      email: cleanEmail,
      password: password,
    );

    final user = credential.user;

    if (user == null) {
      throw Exception('Account creation failed. Please try again.');
    }

    await user.updateDisplayName(cleanName);

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('user_${user.uid}', jsonEncode({
      'uid': user.uid,
      'name': cleanName,
      'email': cleanEmail,
    }));

    await user.reload();

    return credential;
  }

  Future<UserCredential> login({
    required String email,
    required String password,
  }) {
    return _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  Future<void> sendPasswordReset(String email) async {
    final cleanEmail = email.trim();

    if (cleanEmail.isEmpty) {
      throw Exception('Please enter your email address.');
    }

    await _auth.sendPasswordResetEmail(email: cleanEmail);
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<void> updateProfile({
    required String name,
  }) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('Please log in again.');
    }

    final cleanName = name.trim();

    if (cleanName.isEmpty) {
      throw Exception('Please enter your name.');
    }

    await user.updateDisplayName(cleanName);

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('user_${user.uid}', jsonEncode({
      'uid': user.uid,
      'name': cleanName,
      'email': user.email ?? '',
    }));

    await user.reload();
  }

  Future<Map<String, dynamic>?> getLocalProfile() async {
    final user = _auth.currentUser;

    if (user == null) return null;

    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('user_${user.uid}');

    if (data == null) {
      return {
        'uid': user.uid,
        'name': user.displayName ?? '',
        'email': user.email ?? '',
      };
    }

    return Map<String, dynamic>.from(jsonDecode(data) as Map);
  }
}
