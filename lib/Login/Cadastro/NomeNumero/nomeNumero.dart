import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edywasacliente/Personalizados/BotaoStyle.dart';
import 'package:edywasacliente/Personalizados/CampoPersonalizado.dart';
import '../../Home/HomePrincipal/home_principal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../Cores/cores.dart';
import '../../../firebase_analytics_registro_login.dart';

class Nome extends StatefulWidget {
  const Nome({super.key});

  @override
  State<Nome> createState() => _NomeState();
}

class _NomeState extends State<Nome> {
  bool _isLoading = false;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _whatsAppContatoController = TextEditingController();

  String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cinzaClaro,
      body: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: ListView(
          padding: const EdgeInsets.all(25),
          children: [
            const SizedBox(
              height: 20,
            ),
            Text(
              "Cadastro",
              style: GoogleFonts.roboto(
                color: azul,
                fontWeight: FontWeight.bold,
                fontSize: 40,
              ),
            ),
            Text(
              "Digite o seu nome completo e numero do seu WhatsApp",
              style: GoogleFonts.roboto(
                color: cinzaEscuro,
                fontSize: 15,
              ),
            ),
            const SizedBox(
              height: 50,
            ),

            // Campo Nome

            CampoPersonalizado(
              controller: _nomeController, // Controller do campo de nome
              hintText: "Nome", // Texto que aparece quando o campo está vazio
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
                if (value == null || value.isEmpty) {
                  return "Preencha o seu nome, meu chapa";
                } else if (value.length > 30) {
                  return "Reduza seu nome, por favor. Está muito grande.";
                }
                return null;
              },
            ),
            const SizedBox(
              height: 10,
            ),
            //WhatsAppContato
             CampoPersonalizado(
              controller: _whatsAppContatoController, // Controller do campo de nome
              hintText: "Whatsapp", // Texto que aparece quando o campo está vazio
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
                    if (value!.length != 11) {
                      return 'Numero de zap tem 11 digitos irmão';
                    } else {
                      null;
                    }
                    return null;
                  },
            ),
            const SizedBox(
              height: 30,
            ),
            _isLoading
                ? const SizedBox(
                    height: 50,
                    width: 50,
                    child: CircularProgressIndicator(),
                  )
                : Center(
              child: ElevatedButton(
                onPressed: _handleFinalizar,
                style: buttonStyle(),
                child: Text(
                  "Finalizar",
                  style: GoogleFonts.roboto(
                    color: cinzaClaro,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future createPerfil(PerfilDados perfil) async {
    String UID = FirebaseAuth.instance.currentUser!.uid.toString();

    //Perfil Local
    final docPerfil = FirebaseFirestore.instance
        .collection("Cliente")
        .doc(UID)
        .collection("Perfil")
        .doc("Dados");

    perfil.id = docPerfil.id;

    final json = perfil.toJson();
    await docPerfil.set(json);
  }

  void _handleFinalizar() async {
    final isValidForm = formKey.currentState!.validate();
    if (isValidForm) {
      String UID = FirebaseAuth.instance.currentUser!.uid.toString();
//Pegar o numero do WhatsApp no banco de dados
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('Cliente')
          .doc(UID)
          .collection('Perfil')
          .doc('Dados')
          .get();
      String email = doc['Email'];

      setState(() {
        _isLoading = true;
      });

      final perfil = PerfilDados(
        email: email,
        nome: _nomeController.text,
        whatsAppContato: _whatsAppContatoController.text,
      );
      createPerfil(perfil);
      //data atual
      final DateTime now = DateTime.now();
      final DateFormat formatter = DateFormat('dd/MM/yyyy');
      final String dataFormatada = formatter.format(now);

      //Adiconar no app Administrador
      final docRef = _firestore
          .collection('Administrador')
          .doc('Usuarios')
          .collection('Geral')
          .doc();

      final id = docRef.id;

      await docRef.set({
        'Email': email,
        'Nome': _nomeController.text,
        'WhatsAppContato': _whatsAppContatoController.text,
        'Id': id,
        'Data': dataFormatada,
      }, SetOptions(merge: true));

      //Adicionar no app Profissional
      final docReference = _firestore
          .collection('Profissional')
          .doc(UID)
          .collection('Perfil')
          .doc('Dados');

      await docReference.set({
        'ImagemPrincipalUrl': '',
        'Email': email,
        'Nome': _nomeController.text,
        'Id': 'Dados',
        'Detalhes': '',
        //Redes Sociais
        'WhatsAppContato': _whatsAppContatoController.text,
        'Facebook': '',
        'Instagram': '',
        'LinkedIn': '',
        'TikTok': '',
        'Pinterest': '',
        'Site': '',
        'Youtube': '',
      }, SetOptions(merge: true));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePrincipal(),
        ),
      );

      logLoginEvent();
    }
  }
}

//Informações do cliente
class PerfilDados {
  String id;
  String idGeral;
  final String imagemPrincipalUrl;
  final String nome;
  final String detalhes;
  final String email;
  //Redes Sociais
  final String whatsAppContato;
  final String facebook;
  final String instagram;

  final String linkedIn;
  final String tikTok;
  final String pinterest;
  final String site;
  final String youtube;

  PerfilDados({
    this.id = '',
    this.idGeral = '',
    this.imagemPrincipalUrl = '',
    required this.nome,
    this.detalhes = "",
    required this.email,
    //Redes Socias
    required this.whatsAppContato,
    this.facebook = "",
    this.instagram = "",
    this.linkedIn = "",
    this.tikTok = "",
    this.pinterest = "",
    this.site = "",
    this.youtube = "",
  });

  Map<String, dynamic> toJson() => {
        'Id': id,
        'IdGeral': idGeral,
        'ImagemPrincipalUrl': imagemPrincipalUrl,
        'Nome': nome,
        'Detalhes': detalhes,
        'Email': email,
        //Redes Sociais
        'WhatsAppContato': whatsAppContato,
        'Facebook': facebook,
        'Instagram': instagram,
        'LinkedIn': linkedIn,
        'TikTok': tikTok,
        'Pinterest': pinterest,
        'Site': site,
        'Youtube': youtube,
      };

  static PerfilDados fromJson(Map<String, dynamic> json) => PerfilDados(
        id: json["Id"] ?? '',
        idGeral: json["IdGeral"] ?? '',
        imagemPrincipalUrl: json['ImagemPrincipalUrl'] ?? '',
        nome: json['Nome'] ?? '',
        detalhes: json['Detalhes'] ?? '',
        email: json['Email'] ?? '',
        //Redes Sociais
        whatsAppContato: json['WhatsAppContato'] ?? '',
        facebook: json['Facebook'] ?? '',
        instagram: json['Instagram'] ?? '',
        linkedIn: json['LinkedIn'] ?? '',
        tikTok: json['TikTok'] ?? '',
        pinterest: json['Pinterest'] ?? '',
        site: json['Site'] ?? '',
        youtube: json['Youtube'] ?? '',
      );
}
