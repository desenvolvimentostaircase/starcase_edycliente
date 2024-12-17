import 'package:edywasacliente/services/auth_service.dart';
import 'package:edywasacliente/Personalizados/BotaoStyle.dart';
import 'package:edywasacliente/Personalizados/CampoPersonalizado.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Cadastro/cadastro_page.dart';
import 'esqueci_senha/esqueci_senha.dart';
import 'Home/HomePrincipal/home_principal.dart';
import '../Cores/cores.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firebaseAuth = FirebaseAuth.instance;
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cinzaClaro,
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20.0), // Espaço superior
              child: Center(
                child: Image.asset(
                  'assets/logo.png', // Caminho do logo
                  width: 250, // Largura do logo
                  height: 100, // Altura do logo
                ),
              ),
            ),
            Center(
              child: Text(
                "Login",
                style: GoogleFonts.roboto(
                  color: azul,
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
            ),
            const SizedBox(height: 5),
            Center(
              child: Text(
                "Entre no app para conhecer os profissionais",
                style: GoogleFonts.roboto(
                  color: cinzaEscuro,
                  fontSize: 15,
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Campo E-mail
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
              ),
              validator: (value) {
                return null;
              },
            ),
            const SizedBox(height: 10),

            // Campo Senha 
            CampoPersonalizado(
              controller: _passwordController, // Controller do campo de senha
              hintText: "Senha", // Texto que aparece quando o campo está vazio
              obscureText: _obscureText, // Mostra ou oculta a senha
              onSuffixIconTap: () {
                setState(() {
                  _obscureText = !_obscureText; // Alterna a visibilidade da senha
                });
              },
              suffixIcon: _obscureText ? Icons.visibility : Icons.visibility_off, // Ícone de visibilidade da senha
              fillColor: cinza, // Cor de fundo do campo
              borderColor: cinza, // Cor da borda quando não está em foco
              focusedBorderColor: azul, // Cor da borda quando o campo está em foco
              hintStyle: GoogleFonts.roboto(
                color: cinzaEscuro.withOpacity(0.5),
              ),
              textStyle: GoogleFonts.roboto(
                // Estilo do texto dentro do campo
                color: cinzaEscuro,
                fontSize: 17,
              ),
              validator: (value) {
                return null;
              },
            ),

            const SizedBox(height: 30),

            // Botão "Entrar"
            Center(
              child: ElevatedButton(
                onPressed: login,
                style: buttonStyle(),
                child: Text(
                  "Entrar",
                  style: GoogleFonts.roboto(
                    color: cinzaClaro,
                  ),
                ),
              ),
            ),

            // Botão de "Esqueceu a senha"
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                child: Text(
                  "Esqueci a senha",
                  style: GoogleFonts.roboto(
                    color: azul,
                    fontSize: 16,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const EsqueceuSenha(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 30),

            // Botão "Criar conta"
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CadastroPage(),
                  ),
                );
              },
              child: Text(
                "Criar conta",
                style: GoogleFonts.roboto(
                  color: azul,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Texto "OU"
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    height: 1, // Espessura da linha
                    color: Colors.black, // Cor da linha
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    "Ou",
                    style: GoogleFonts.roboto(
                      color: azul,
                      fontSize: 17,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 1, // Espessura da linha
                    color: Colors.black, // Cor da linha
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Texto Conecte-se
            Align(
              alignment: Alignment.center,
              child: Text(
                "Conecte-se com",
                style: GoogleFonts.roboto(
                  color: azul,
                  fontSize: 17,
                ),
              ),
            ),
            const SizedBox(height: 60),

            // Ícones das redes sociais para logar
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    AuthService authService = AuthService();
                    

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomePrincipal(),
                      ),
                    );
                                    },
                  child: SvgPicture.asset(
                    'assets/google.svg', // Caminho do ícone do Google
                    width: 40,
                    height: 40,
                    semanticsLabel: 'Login com Google',
                  ),
                ),


                const SizedBox(width: 80),
                SvgPicture.asset(
                  'assets/facebook.svg', // Caminho do ícone do Facebook
                  width: 50,
                  height: 50,
                ),
                const SizedBox(width: 80),
                SvgPicture.asset(
                  'assets/x.svg', // Caminho do ícone do X (Twitter)
                  width: 40,
                  height: 40,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Função de login
  login() async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePrincipal(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Usuário não encontrado",
              style: GoogleFonts.roboto(
                color: cinzaClaro,
              ),
            ),
            backgroundColor: vermelho,
          ),
        );
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Sua senha está errada",
              style: GoogleFonts.roboto(
                color: cinzaClaro,
              ),
            ),
            backgroundColor: vermelho,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Preencha corretamente o e-mail ou a senha",
              style: GoogleFonts.roboto(
                color: cinzaClaro,
              ),
            ),
            backgroundColor: vermelho,
          ),
        );
      }
    }
  }
}
