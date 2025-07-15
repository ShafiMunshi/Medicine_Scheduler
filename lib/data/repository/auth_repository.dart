import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository {
  final _auth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn.standard();
  void signInWithGoogle() {}

  Future<void> signInWithEmailPassword({
    required String email,
    required String pass,
  }) async {
    final response = await _auth.signInWithEmailAndPassword(email: email, password: pass);
  }
}
