import 'package:edywasacliente/Cores/cores.dart';
import 'package:edywasacliente/Personalizados/BotaoStyle.dart';
import 'package:edywasacliente/Personalizados/CampoPersonalizado.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';

class EsqueceuSenha extends StatefulWidget {
  const EsqueceuSenha({Key? key}) : super(key: key);

  @override
  State<EsqueceuSenha> createState() => _EsqueceuSenhaState();
}

class _EsqueceuSenhaState extends State<EsqueceuSenha> {
  //
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cinzaClaro,

      //
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: ListView(
          children: [
            const SizedBox(
              height: 60,
            ),
            Center(
              child: Text(
                "Esqueci senha",
                style: GoogleFonts.roboto(
                  color: azul,
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Text(
                "Digite o seu e-mail e a solicitção para redefinir a senha será enviada em seu e-mail",
                style: GoogleFonts.roboto(
                  color: cinzaEscuro,
                  fontSize: 15,
                ),
              ),
            ),

            const SizedBox(
              height: 50,
            ),
            // Campo de E-mail utilizando o widget CampoPersonalizado
            CampoPersonalizado(
              controller: emailController, // Controller do campo de e-mail
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

            //
            const SizedBox(
              height: 30,
            ),
            
           Align(
           alignment: Alignment.center,//Botão "Esqueceu a senha"
           child:ElevatedButton(
              onPressed: esqueceuSenha,
              style: buttonStyle(),
              child: Text(
                "Enviar",
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
      ),
    );
  }

  Future esqueceuSenha() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 5),
          content: const Text(
            "Redefinição de senha enviada",
          ),
          backgroundColor: verde,
        ),
      );
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 5),
            content: const Text(
              "Email não cadastro",
            ),
            backgroundColor: vermelho,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 5),
            content: const Text(
              "Digite corretamente o e-mail",
            ),
            backgroundColor: vermelho,
          ),
        );
      }
    }
  }
}
