import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // User registration
  Future<User?> registerWithEmailAndPassword(String email, String password) async {
    try {
      final UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      print("Registration error: $e");
      rethrow;
    }
  }

  // User sign-in
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      final UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      print("Sign in error: $e");
      rethrow;
    }
  }

  // User sign-out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Change password
  Future<void> changePassword(String newPassword) async {
    final User? user = _auth.currentUser;
    if (user != null) {
      await user.updatePassword(newPassword);
    }
  }

  // Get current user
  User? get currentUser => _auth.currentUser;
}