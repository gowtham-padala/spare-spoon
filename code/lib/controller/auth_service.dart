import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Service class for authentication-related operations.
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Sign in with Google account.
  Future<UserCredential> signInWithGoogle() async {
    // Sign in with Google and obtain authentication details.
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    // Sign in using obtained credential.
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  /// Sign in with email and password.
  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    return result.user;
  }

  /// Register a new user with email and password.
  Future<User?> registerWithEmailAndPassword(
      String email, String password) async {
    UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    return result.user;
  }

  /// Get the current authenticated user's UID.
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  /// Send a password reset email.
  Future<void> passwordReset(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  /// Sign out the current user.
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
