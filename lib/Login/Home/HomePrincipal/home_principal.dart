import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edywasacliente/Login/Home/HomePrincipal/DoacaoNosAjude/doacao_nos_ajude.dart';
import 'package:edywasacliente/Login/Home/HomePrincipal/HomeListaContatos/Buscar/buscar.dart';
import 'package:edywasacliente/Login/Home/HomePrincipal/HomeListaContatos/home_lista_contato.dart';
import 'package:edywasacliente/Login/Home/HomePrincipal/HomePerfil/home_perfil.dart';
import 'package:edywasacliente/Login/Home/HomePrincipal/HomeSolicitacao/home_solicitacao.dart';
import 'package:edywasacliente/Login/Home/HomePrincipal/HomeTutoriais/home_tutoriais.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../Cores/cores.dart';

class HomePrincipal extends StatefulWidget {
  const HomePrincipal({super.key});

  @override
  State<HomePrincipal> createState() => _HomePrincipalState();
}

class _HomePrincipalState extends State<HomePrincipal> {
  abrirInstagram() async {
    Uri instagram = Uri.parse("https://www.instagram.com/staircase.ofc/");

    if (await canLaunchUrl(instagram)) {
      await launchUrl(instagram);
    } else {
      throw 'Could not launch $instagram';
    }
  }

  abrirWhatsApp() async {
    Uri whatsappUrl = Uri.parse("whatsapp://send?phone=+5567991415217&text=");

    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl);
    } else {
      throw 'Could not launch $whatsappUrl';
    }
  }

  abrirFacebook() async {
    Uri facebookUrl = Uri.parse(
        "https://www.facebook.com/people/Staircaseofc/61551667209406/");

    if (await canLaunchUrl(facebookUrl)) {
      await launchUrl(facebookUrl);
    } else {
      throw 'Could not launch $facebookUrl';
    }
  }

  //
  final formKey = GlobalKey<FormState>();
  final TextEditingController _oQueFazTextEditingController =
      TextEditingController();
  final TextEditingController _whatsAppContatoTextEditingController =
      TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cinzaClaro,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Home",
                    style: GoogleFonts.roboto(
                      color: azul,
                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                    ),
                  ),
                  FilledButton.icon(
                    label: Text(
                      "Perfil",
                      style: GoogleFonts.roboto(
                        color: cinzaClaro,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    icon: Icon(Icons.person),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => const HomePerfil()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.only(
                          left: 20, top: 10, right: 20, bottom: 10),
                      backgroundColor: azul,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
                ],
              ),

              Text(
                "Aqui ficam os atalhos para que você possa conhecer o nosso app, seja bem vindo :)",
                style: GoogleFonts.roboto(
                  color: cinzaEscuro,
                  fontSize: 15,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              

              
              
              //Nos ajude
              Container(
                decoration: BoxDecoration(
                  color: cinza,
                  borderRadius: BorderRadius.circular(15),
                ),
                height: 100,
                width: 100,
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text("Nos ajude a manter este projeto de pé"),
                    SizedBox(
                      height: 10,
                    ),
                    FilledButton.icon(
                      label: Text(
                        "Saiba mais",
                        style: GoogleFonts.roboto(
                          color: cinzaClaro,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      icon: Icon(Icons.info),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => const DoacaoNosAjude()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.only(
                            left: 20, top: 10, right: 20, bottom: 10),
                        backgroundColor: azul,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              //
              SizedBox(
                height: 10,
              ),
              
              //
              Container(
                height: 170,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: cinza),
                      height: 200,
                      width: 230,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Text(
                              "Solicitações",
                              style: GoogleFonts.roboto(
                                color: azul,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              "Agora temos uma aba dedicada para envio de solicitações a profissionais",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.roboto(
                                  color: cinzaEscuro, fontSize: 15),
                            ),
                            //
                            SizedBox(
                              height: 10,
                            ),
                            FilledButton.icon(
                              label: Text(
                                "Enviar solicitação",
                                style: GoogleFonts.roboto(
                                  color: cinzaClaro,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              icon: Icon(Icons.list_alt_outlined),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const HomeSolicitacao()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.only(
                                    left: 20, top: 10, right: 20, bottom: 10),
                                backgroundColor: azul,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),

                    //Indikai
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: cinza,
                      ),
                      height: 200,
                      width: 230,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Text(
                              "Indikai",
                              style: GoogleFonts.roboto(
                                  color: azul,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                            Text(
                              "Se você conhece algum profissional de qualquer area nos indique",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.roboto(
                                  color: cinzaEscuro, fontSize: 15),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            FilledButton.icon(
                              label: Text(
                                "Contato",
                                style: GoogleFonts.roboto(
                                  color: cinzaClaro,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              icon: Icon(Icons.forum),
                              onPressed: () {
                                popupEnviarIndiKaiMensagem(context);
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.only(
                                    left: 20, top: 10, right: 20, bottom: 10),
                                backgroundColor: azul,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),

              //Nos ajude
              Container(
                decoration: BoxDecoration(
                  color: cinza,
                  borderRadius: BorderRadius.circular(15),
                ),
                height: 160,
                width: 100,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Text(
                        "Lista de contatos",
                        style: GoogleFonts.roboto(
                          color: azul,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        textAlign: TextAlign.center,
                        "Agora você pode pesquisar por diversos contatos em nosso app",
                        style: GoogleFonts.roboto(
                          color: cinzaEscuro,
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      FilledButton.icon(
                        label: Text(
                          "Vamos lá",
                          style: GoogleFonts.roboto(
                            color: cinzaClaro,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        icon: Icon(Icons.contact_phone_rounded),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => const HomeListaContato()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.only(
                              left: 20, top: 10, right: 20, bottom: 10),
                          backgroundColor: azul,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              //
              Text(
                "Não fique de fora !!!",
                style: GoogleFonts.roboto(
                  color: azul,
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),

              Text(
                "Nos siga!!! Estamos sempre postando algo novo em nossas redes.",
                style: GoogleFonts.roboto(
                  color: cinzaEscuro,
                  fontSize: 15,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 180,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    //WhatsApp
                    GestureDetector(
                      onTap: () {
                        abrirWhatsApp();
                      },
                      child: Container(
                        width: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: azul,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Icon(
                                  FontAwesomeIcons.whatsapp,
                                  size: 40,
                                  color: cinzaClaro,
                                ),
                              ),
                            ),
                            Text(
                              "WhatsApp",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.roboto(
                                color: azul,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            //
                          ],
                        ),
                      ),
                    ),
                    //
                    SizedBox(
                      width: 10,
                    ),
                    //Facebook
                    GestureDetector(
                      onTap: () {
                        abrirFacebook();
                      },
                      child: Container(
                        width: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: azul,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Icon(
                                  FontAwesomeIcons.facebook,
                                  size: 40,
                                  color: cinzaClaro,
                                ),
                              ),
                            ),
                            Text(
                              "Facebook",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.roboto(
                                color: azul,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            //
                          ],
                        ),
                      ),
                    ),
                    //
                    SizedBox(
                      width: 10,
                    ),
                    //Instagram
                    GestureDetector(
                      onTap: () {
                        abrirInstagram();
                      },
                      child: Container(
                        width: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: azul,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Icon(
                                  FontAwesomeIcons.instagram,
                                  size: 40,
                                  color: cinzaClaro,
                                ),
                              ),
                            ),
                            Text(
                              "Instagram",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.roboto(
                                color: azul,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            //
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    //
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  //
  Future popupEnviarIndiKaiMensagem(context) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: cinzaClaro,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
          title: Text(
            "IndiKai",
            style: GoogleFonts.roboto(
              fontSize: 40,
              color: azul,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Container(
            height: MediaQuery.sizeOf(context).width * 0.8,
            width: MediaQuery.sizeOf(context).width * 0.9,
            child: Form(
              key: formKey,
              child: ListView(
                children: [
                  Text(
                      "na mensagem escreva o numero de contato e o que o profissional realiza como atividade"),
                  SizedBox(
                    height: 30,
                  ),
                  //O que faz?

                  TextFormField(
                    style: GoogleFonts.roboto(
                      color: cinzaEscuro,
                      fontSize: 18,
                    ),
                    cursorColor: azul,
                    controller: _oQueFazTextEditingController,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _oQueFazTextEditingController.clear();
                          });
                        },
                        icon: Icon(
                          Icons.close,
                          color: azul,
                        ),
                      ),
                      filled: true,
                      fillColor: cinza,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(
                          color: cinza,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(
                          color: azul,
                          width: 3,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: vermelho, width: 3),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: vermelho, width: 3),
                      ),
                      hintText: "O que faz?",
                      hintStyle: GoogleFonts.roboto(
                        color: cinzaEscuro.withOpacity(0.6),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Preencha o campo';
                      } else if (value.length > 200) {
                        return 'Muito longo';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  //WhatsAppContato

                  TextFormField(
                    style: GoogleFonts.roboto(
                      color: cinzaEscuro,
                      fontSize: 18,
                    ),
                    cursorColor: azul,
                    controller: _whatsAppContatoTextEditingController,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _whatsAppContatoTextEditingController.clear();
                          });
                        },
                        icon: Icon(
                          Icons.close,
                          color: azul,
                        ),
                      ),
                      filled: true,
                      fillColor: cinza,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(
                          color: cinza,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(
                          color: azul,
                          width: 3,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: vermelho, width: 3),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: vermelho, width: 3),
                      ),
                      hintText: "WhatsAppContato",
                      hintStyle: GoogleFonts.roboto(
                        color: cinzaEscuro.withOpacity(0.6),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Digite algo ';
                      } else if (value.length <= 9 || value.length >= 12) {
                        return 'WhatsApp contêm 10 ou 11 digitos';
                      }
                      return null;
                    },
                  ),

                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            ///Voltar
            ElevatedButton(
              child: Text(
                "Voltar",
                style: GoogleFonts.roboto(
                  color: azul,
                ),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 10, bottom: 10),
                backgroundColor: cinzaClaro,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),

            ///Confirmar
            FilledButton(
              child: Text(
                "Enviar",
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 10, bottom: 10),
                backgroundColor: azul,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              onPressed: () async {
                //data atual
                final DateTime now = DateTime.now();
                final DateFormat formatter = DateFormat('dd/MM/yyyy');
                final String dataFormatada = formatter.format(now);

                final isValidForm = formKey.currentState!.validate();

                if (isValidForm) {
                  final docRef = _firestore
                      .collection('Administrador')
                      .doc('IndiKai')
                      .collection('Contatos')
                      .doc();

                  final id = docRef.id;

                  await docRef.set({
                    'Id': id,
                    'OQueFaz': _oQueFazTextEditingController.text,
                    'WhatsAppContato':
                        _whatsAppContatoTextEditingController.text,
                    'Data': dataFormatada
                  }, SetOptions(merge: true));

                  //Passar a pagina
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: Duration(seconds: 5),
                      content: Text(
                        "Mensagem enviada. Agradecemos pela indicação",
                        style: GoogleFonts.roboto(
                          color: cinzaClaro,
                        ),
                      ),
                      backgroundColor: azul,
                    ),
                  );
                  Navigator.pop(context);
                }
                //
              },
            ),
          ],
        ),
      );
}
