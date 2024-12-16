import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';



class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        print("Login cancelado pelo usuário");
        return null; // O usuário cancelou o login
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Realizando o login no Firebase
      final UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
      print("Login com Google bem-sucedido: ${userCredential.user?.email}");
      return userCredential.user;
    } catch (e) {
      print("Erro no login com Google: $e");  // Exibe o erro completo
      return null;
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();
  }

  
}
