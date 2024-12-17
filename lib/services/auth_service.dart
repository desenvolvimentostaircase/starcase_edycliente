import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<User?> signInWithGoogle(BuildContext context) async {
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

      // Se o nome do usuário não estiver disponível, solicite que o usuário forneça um nome
      if (userCredential.user?.displayName == null || userCredential.user?.displayName?.isEmpty == true) {
        final displayName = await _showNameInputDialog(context);
        if (displayName != null && displayName.isNotEmpty) {
          await userCredential.user?.updateProfile(displayName: displayName);
        } else {
          print("Nome não fornecido, e perfil não atualizado.");
        }
      }

      print("Login com Google bem-sucedido: ${userCredential.user?.email}");
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print("Erro no login com Google: ${e.message}");
      return null;
    } catch (e) {
      print("Erro inesperado no login com Google: $e");
      return null;
    }
  }

  Future<String?> _showNameInputDialog(BuildContext context) async {
    String? name;
    return await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Informe seu nome"),
          content: TextField(
            onChanged: (value) {
              name = value;
            },
            decoration: const InputDecoration(hintText: "Nome"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (name != null && name!.isNotEmpty) {
                  Navigator.of(context).pop(name);
                } else {
                  print("Nome inválido");
                }
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      return await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      print("Erro ao logar com e-mail e senha: ${e.message}");
      rethrow;
    } catch (e) {
      print("Erro inesperado no login com e-mail e senha: $e");
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();
  }
}
