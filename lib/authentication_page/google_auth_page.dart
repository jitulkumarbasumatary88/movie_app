import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  // Always create a FRESH GoogleSignIn instance
  GoogleSignIn get googleSignIn =>
      GoogleSignIn(scopes: ['email'], forceCodeForRefreshToken: true);

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final gSignIn = googleSignIn;

      // force popup remove previous cached sessions
      try {
        await gSignIn.signOut();
      } catch (_) {}

      try {
        await gSignIn.disconnect();
      } catch (_) {}

      await FirebaseAuth.instance.signOut();

      // This will ALWAYS show popup
      final googleUser = await gSignIn.signIn();
      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      print("Google Sign-In Error: $e");
      return null;
    }
  }
}
