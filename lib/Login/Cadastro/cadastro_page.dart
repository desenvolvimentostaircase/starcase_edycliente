import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edywasacliente/Personalizados/BotaoStyle.dart';
import '../../Personalizados/CampoPersonalizado.dart';
import 'NomeNumero/nomeNumero.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Cores/cores.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({Key? key}) : super(key: key);

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //
  bool _obscureText = true;
  //

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cinzaClaro,
      body: ListView(
        padding: const EdgeInsets.all(25),
        children: [
          const SizedBox(
            height: 60,
          ),
          Center(
            child: Text(
              "Cadastro",
              style: GoogleFonts.roboto(
                color: azul,
                fontWeight: FontWeight.bold,
                fontSize: 40,
              ),
            ),
          ),
          Center(
            child: Text(
              "Crie sua conta para acessar o app",
              style: GoogleFonts.roboto(
                color: cinzaEscuro,
                fontSize: 15,
              ),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          //E-mail
          CampoPersonalizado(
            controller: _emailController, // Controller do campo de e-mail
            hintText: "E-mail", // Texto que aparece quando o campo está vazio
            fillColor: cinza, // Cor de fundo do campo
            borderColor: cinza, // Cor da borda quando não está em foco
            focusedBorderColor:
                azul, // Cor da borda quando o campo está em foco
            hintStyle: GoogleFonts.roboto(
              // Estilo do texto de dica
              color: cinzaEscuro.withOpacity(0.5),
            ),
            textStyle: GoogleFonts.roboto(
              // Estilo do texto dentro do campo
              color: cinzaEscuro,
              fontSize: 17,
            ), validator: (value) {
              return null;
              },
          ),
          const SizedBox(
            height: 10,
          ),
          //Senha
          CampoPersonalizado(
            controller: _passwordController, // Controller do campo de senha
            hintText: "Senha", // Texto que aparece quando o campo está vazio
            obscureText: _obscureText, // Mostra ou oculta a senha
            onSuffixIconTap: () {
              setState(() {
                _obscureText = !_obscureText; // Alterna a visibilidade da senha
              });
            },
            suffixIcon: _obscureText
                ? Icons.visibility
                : Icons.visibility_off, // Ícone de visibilidade da senha
            fillColor: cinza, // Cor de fundo do campo
            borderColor: cinza, // Cor da borda quando não está em foco
            focusedBorderColor:
                azul, // Cor da borda quando o campo está em foco
            hintStyle: GoogleFonts.roboto(
              color: cinzaEscuro.withOpacity(0.5),
            ),
            textStyle: GoogleFonts.roboto(
              // Estilo do texto dentro do campo
              color: cinzaEscuro,
              fontSize: 17,
            ), validator: (value) {
              return null;
              },
          ),

          //
          const SizedBox(
            height: 30,
          ),

          Center(
            child: ElevatedButton(
              onPressed: () {
                cadastrar();
              },
              style: buttonStyle(),
              child: Text(
                "Continuar",
                style: GoogleFonts.roboto(
                  color: cinzaClaro,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          TextButton(
            child: Text(
              "Voltar",
              style: GoogleFonts.roboto(
                color: azul,
                fontSize: 16,
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  //Cadastrar
  cadastrar() async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const Nome(),
          ),
          (route) => false);
      String UID = FirebaseAuth.instance.currentUser!.uid.toString();

      await _firestore
          .collection('Cliente')
          .doc(UID)
          .collection('Perfil')
          .doc('Dados')
          .set({
        'Email': _emailController.text,
      }, SetOptions(merge: true));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 5),
            content: const Text(
              "Crie uma senha mais forte",
            ),
            backgroundColor: vermelho,
          ),
        );
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 5),
            content: const Text(
              "Este e-mail já foi cadastrado",
            ),
            backgroundColor: vermelho,
          ),
        );
      }
    }
  }
}
