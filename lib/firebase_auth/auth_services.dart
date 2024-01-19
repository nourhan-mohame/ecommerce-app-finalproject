import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Validate email format
  bool isValidEmail(String email) {
    return RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$').hasMatch(email);
  }

  // Validate password format
  bool isValidPassword(String password) {
    // Password should contain at least one letter, one number, and be at least 10 characters long
    return RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{10,}$').hasMatch(password);
  }

  // Sign up with email and password with validation
  Future<User?> signUpEmailAndPassword(String email, String password) async {
    if (!isValidEmail(email)) {
      print("Invalid email format");
      return null;
    }

    if (!isValidPassword(password)) {
      print("Invalid password format");
      return null;
    }

    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } catch (e) {
      print("Error during sign up: $e");
      return null;
    }
  }

  // Sign in with email and password with validation
  Future<User?> signInEmailAndPassword(String email, String password) async {
    if (!isValidEmail(email)) {
      print("Invalid email format");
      return null;
    }

    if (!isValidPassword(password)) {
      print("Invalid password format");
      return null;
    }

    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } catch (e) {
      print("Error during sign in: $e");
      return null;
    }
  }

  // Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    if (!isValidEmail(email)) {
      print("Invalid email format");
      return;
    }

    try {
      await _auth.sendPasswordResetEmail(email: email);
      print("Password reset email sent to $email");
    } catch (e) {
      print("Error sending password reset email: $e");
    }
  }
}
