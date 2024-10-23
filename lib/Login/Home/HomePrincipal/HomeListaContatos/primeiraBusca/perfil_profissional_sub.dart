import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edywasacliente/Cores/cores.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import 'salvarContato/salvar_contato.dart';

class PerfilProfissional extends StatefulWidget {
  final String auxEmail;

  const PerfilProfissional(this.auxEmail, {Key? key}) : super(key: key);

  @override
  State<PerfilProfissional> createState() => _PerfilProfissionalState();
}

class _PerfilProfissionalState extends State<PerfilProfissional> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final formKey = GlobalKey<FormState>();
  final TextEditingController solicitacaoEditingController =
      TextEditingController();

  bool showWhatsAppOptions = false;

  void toggleWhatsAppOptions() {
    setState(() {
      showWhatsAppOptions = !showWhatsAppOptions;
    });
  }

  //Telefone expansão

  bool showTelefoneOptions = false;

  void toggleTelefoneOptions() {
    setState(() {
      showTelefoneOptions = !showTelefoneOptions;
    });
  }

  Future popupSalvarContato(PerfilDados dados) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: cinzaClaro,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text(
            "Salvar contato?",
            textAlign: TextAlign.center,
            style: GoogleFonts.roboto(
              fontSize: 25,
              color: azul,
              fontWeight: FontWeight.bold,
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton(
              child: Text(
                "Sim",
                style: GoogleFonts.roboto(
                  color: cinzaClaro,
                  fontSize: 20,
                ),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 10, bottom: 10),
                backgroundColor: azul,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              onPressed: () {
                String cidadeEstado = '';
                String profissional = '';

                final salvarContato = SalvarContato(
                    nome: dados.nome,
                    whatsAppContato: dados.whatsAppContato,
                    cidadeEstadoSelecionada: cidadeEstado,
                    profissionalSelecionada: profissional,
                    email: widget.auxEmail,
                    imagemPrincipalUrl: dados.imagemPrincipalUrl);
                createSalvarContato(salvarContato);
                Navigator.pop(context);
                final snackBar = SnackBar(
                  backgroundColor: azul,
                  content: Text('Contato salvo com sucesso'),
                );

                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
            ),
            //
            ElevatedButton(
              onPressed: () {},
              child: Text(
                "Não",
                style: GoogleFonts.roboto(
                  color: cinzaClaro,
                  fontSize: 20,
                ),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 10, bottom: 10),
                backgroundColor: azul,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    Stream<List<PerfilDados>> leiaPerfilDadosProfissional() =>
        FirebaseFirestore.instance
            .collection("Perfil Geral")
            .doc('Profissional')
            .collection(widget.auxEmail)
            .snapshots()
            .map((snapshot) => snapshot.docs
                .map((doc) => PerfilDados.fromJson(doc.data()))
                .toList());

    return Scaffold(
      backgroundColor: cinzaClaro,
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 5, right: 5),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.9,
                width: MediaQuery.of(context).size.width,
                child: StreamBuilder<List<PerfilDados>>(
                  stream: leiaPerfilDadosProfissional(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text("Something went wong! ${snapshot.error}");
                    } else if (snapshot.hasData) {
                      final leiaBuscar = snapshot.data!;
                      return ListView.builder(
                        itemCount: leiaBuscar.length,
                        itemBuilder: (context, index) {
                          final dados = leiaBuscar[index];
                          return columnDadosPerfilProfissional(dados);
                        },
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget columnDadosPerfilProfissional(dados) => Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: azul,
                ),
                height: 40,
                width: 40,
                child: GestureDetector(
                  child: Icon(
                    Icons.arrow_back,
                    color: cinzaClaro,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              SizedBox(
                width: 10,
              ),
              FilledButton.icon(
                label: Text(
                  "Salvar perfil",
                  style: GoogleFonts.roboto(
                    color: cinzaClaro,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                icon: Icon(Icons.bookmark_add_outlined),
                onPressed: () {
                  popupSalvarContato(dados);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.only(
                      left: 20, top: 10, right: 20, bottom: 10),
                  backgroundColor: azul,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          //Imagem
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                dados.imagemPrincipalUrl,
                fit: BoxFit.cover,
              ),
            ),
            height: MediaQuery.sizeOf(context).width * 0.9,
            width: MediaQuery.sizeOf(context).width * 0.9,
          ),
          SizedBox(
            height: 15,
          ),
          //

          Container(
            height: 120,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                //Enviar solicitação
                GestureDetector(
                  child: Container(
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: azul,
                          ),
                          height: 70,
                          width: 70,
                          child: Icon(
                            Icons.message,
                            color: cinzaClaro,
                            size: 32,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Enviar\nSolicitação",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.roboto(
                            color: azul,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    popupEnviarSolicitacaoDireta(context, dados);
                  },
                ),
                SizedBox(
                  width: 10,
                ),
                //Ligação
                GestureDetector(
                  child: Container(
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: azul,
                          ),
                          height: 70,
                          width: 70,
                          child: Icon(
                            showTelefoneOptions ? Icons.close : Icons.phone,
                            color: cinzaClaro,
                            size: 32,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Ligação",
                          style: GoogleFonts.roboto(
                            color: azul,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () async {
                    toggleTelefoneOptions();
                  },
                ),
                //
                SizedBox(
                  width: 10,
                ),

                if (showTelefoneOptions)
                  Row(
                    children: [
                      //01
                      dados.whatsAppContato != ''
                          ? GestureDetector(
                              child: Container(
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: azul,
                                      ),
                                      height: 70,
                                      width: 70,
                                      child: Icon(
                                        Icons.phone,
                                        color: cinzaClaro,
                                        size: 32,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "01",
                                      style: GoogleFonts.roboto(
                                        color: azul,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              onTap: () async {
                                final Uri phoneUri = Uri(
                                    scheme: 'tel', path: dados.whatsAppContato);
                                if (await canLaunchUrl(phoneUri)) {
                                  await launchUrl(phoneUri);
                                } else {
                                  throw 'Não foi possível abrir o app de ligações';
                                }
                              },
                            )
                          : SizedBox(),
                      SizedBox(
                        width: 10,
                      ),
                      //02
                      dados.whatsAppContato02 != ''
                          ? GestureDetector(
                              child: Container(
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: azul,
                                      ),
                                      height: 70,
                                      width: 70,
                                      child: Icon(
                                        Icons.phone,
                                        color: cinzaClaro,
                                        size: 32,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "02",
                                      style: GoogleFonts.roboto(
                                        color: azul,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              onTap: () async {
                                final Uri phoneUri = Uri(
                                    scheme: 'tel',
                                    path: dados.whatsAppContato02);
                                if (await canLaunchUrl(phoneUri)) {
                                  await launchUrl(phoneUri);
                                } else {
                                  throw 'Não foi possível abrir o app de ligações';
                                }
                              },
                            )
                          : SizedBox(),
                      SizedBox(
                        width: 10,
                      ),
                      //03
                      dados.whatsAppContato03 != ''
                          ? GestureDetector(
                              child: Container(
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: azul,
                                      ),
                                      height: 70,
                                      width: 70,
                                      child: Icon(
                                        Icons.phone,
                                        color: cinzaClaro,
                                        size: 32,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "03",
                                      style: GoogleFonts.roboto(
                                        color: azul,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              onTap: () async {
                                final Uri phoneUri = Uri(
                                    scheme: 'tel',
                                    path: dados.whatsAppContato03);
                                if (await canLaunchUrl(phoneUri)) {
                                  await launchUrl(phoneUri);
                                } else {
                                  throw 'Não foi possível abrir o app de ligações';
                                }
                              },
                            )
                          : SizedBox(),
                      SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                //WhatsApp
                GestureDetector(
                  child: Container(
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: azul,
                          ),
                          height: 70,
                          width: 70,
                          child: Icon(
                            showWhatsAppOptions
                                ? Icons.close
                                : FontAwesomeIcons.whatsapp,
                            color: cinzaClaro,
                            size: 32,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "WhatsApp",
                          style: GoogleFonts.roboto(
                            color: azul,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    toggleWhatsAppOptions();
                  },
                ),
                //
                SizedBox(
                  width: 10,
                ),

                if (showWhatsAppOptions)
                  Row(
                    children: [
                      //01
                      dados.whatsAppContato != ''
                          ? GestureDetector(
                              child: Container(
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: azul,
                                      ),
                                      height: 70,
                                      width: 70,
                                      child: Icon(
                                        FontAwesomeIcons.whatsapp,
                                        color: cinzaClaro,
                                        size: 32,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "01",
                                      style: GoogleFonts.roboto(
                                        color: azul,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              onTap: () async {
                                Uri whatsappUrl = Uri.parse(
                                    "whatsapp://send?phone=+55${dados.whatsAppContato}&text=Olá ${dados.nome}, venho da Staircase gostaria de saber se você está disponível para serviço?");

                                if (await canLaunchUrl(whatsappUrl)) {
                                  await launchUrl(whatsappUrl);
                                } else {
                                  throw 'Could not launch $whatsappUrl';
                                }
                              },
                            )
                          : SizedBox(),
                      SizedBox(
                        width: 10,
                      ),
                      //02
                      dados.whatsAppContato02 != ''
                          ? GestureDetector(
                              child: Container(
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: azul,
                                      ),
                                      height: 70,
                                      width: 70,
                                      child: Icon(
                                        FontAwesomeIcons.whatsapp,
                                        color: cinzaClaro,
                                        size: 32,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "02",
                                      style: GoogleFonts.roboto(
                                        color: azul,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              onTap: () async {
                                Uri whatsappUrl = Uri.parse(
                                    "whatsapp://send?phone=+55${dados.whatsAppContato02}&text=Olá ${dados.nome}, venho do Staircase gostaria de saber se você está disponível para serviço?");

                                if (await canLaunchUrl(whatsappUrl)) {
                                  await launchUrl(whatsappUrl);
                                } else {
                                  throw 'Could not launch $whatsappUrl';
                                }
                              },
                            )
                          : SizedBox(),
                      SizedBox(
                        width: 10,
                      ),
                      //03
                      dados.whatsAppContato03 != ''
                          ? GestureDetector(
                              child: Container(
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: azul,
                                      ),
                                      height: 70,
                                      width: 70,
                                      child: Icon(
                                        FontAwesomeIcons.whatsapp,
                                        color: cinzaClaro,
                                        size: 32,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "03",
                                      style: GoogleFonts.roboto(
                                        color: azul,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              onTap: () async {
                                Uri whatsappUrl = Uri.parse(
                                    "whatsapp://send?phone=+55${dados.whatsAppContato03}&text=Olá ${dados.nome}, venho do Staircase gostaria de saber se você está disponível para serviço?");

                                if (await canLaunchUrl(whatsappUrl)) {
                                  await launchUrl(whatsappUrl);
                                } else {
                                  throw 'Could not launch $whatsappUrl';
                                }
                              },
                            )
                          : SizedBox(),
                      SizedBox(
                        width: 10,
                      ),
                    ],
                  ),

                //Instagram
                GestureDetector(
                  child: Container(
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: azul,
                          ),
                          height: 70,
                          width: 70,
                          child: Icon(
                            FontAwesomeIcons.instagram,
                            color: cinzaClaro,
                            size: 32,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Instagram",
                          style: GoogleFonts.roboto(
                            color: azul,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () async {
                    Uri webUrl = Uri.parse("${dados.instagram}");
                    if (await canLaunchUrl(webUrl)) {
                      await launchUrl(webUrl);
                    } else {
                      print("can't open Instagram");
                    }
                  },
                ),
                //Facebook
                SizedBox(
                  width: 15,
                ),
                dados.facebook != ''
                    ? GestureDetector(
                        child: Container(
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: azul,
                                ),
                                height: 70,
                                width: 70,
                                child: Icon(
                                  FontAwesomeIcons.facebook,
                                  color: cinzaClaro,
                                  size: 32,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Facebook",
                                style: GoogleFonts.roboto(
                                  color: azul,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        onTap: () async {
                          Uri webUrl = Uri.parse("${dados.facebook}");
                          if (await canLaunchUrl(webUrl)) {
                            await launchUrl(webUrl);
                          } else {
                            print("can't open Facebook");
                          }
                        },
                      )
                    : SizedBox(),
                //TikTok
                SizedBox(
                  width: 15,
                ),
                dados.tikTok != ''
                    ? GestureDetector(
                        child: Container(
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: azul,
                                ),
                                height: 70,
                                width: 70,
                                child: Icon(
                                  FontAwesomeIcons.tiktok,
                                  color: cinzaClaro,
                                  size: 32,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Tiktok",
                                style: GoogleFonts.roboto(
                                  color: azul,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        onTap: () async {
                          Uri webUrl = Uri.parse("${dados.tikTok}");
                          if (await canLaunchUrl(webUrl)) {
                            await launchUrl(webUrl);
                          } else {
                            print("can't open TikTok");
                          }
                        },
                      )
                    : SizedBox(),
                //LinkedIn
                SizedBox(
                  width: 15,
                ),
                dados.linkedIn != ''
                    ? GestureDetector(
                        child: Container(
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: azul,
                                ),
                                height: 70,
                                width: 70,
                                child: Icon(
                                  FontAwesomeIcons.linkedin,
                                  color: cinzaClaro,
                                  size: 32,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "LinkedIn",
                                style: GoogleFonts.roboto(
                                  color: azul,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        onTap: () async {
                          Uri webUrl = Uri.parse("${dados.linkedIn}");
                          if (await canLaunchUrl(webUrl)) {
                            await launchUrl(webUrl);
                          } else {
                            print("can't open LinkedIn");
                          }
                        },
                      )
                    : SizedBox(),
                //Site
                SizedBox(
                  width: 15,
                ),
                dados.site != ''
                    ? GestureDetector(
                        child: Container(
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: azul,
                                ),
                                height: 70,
                                width: 70,
                                child: Icon(
                                  Icons.language,
                                  color: cinzaClaro,
                                  size: 32,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Site",
                                style: GoogleFonts.roboto(
                                  color: azul,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        onTap: () async {
                          Uri webUrl = Uri.parse("${dados.site}");
                          if (await canLaunchUrl(webUrl)) {
                            await launchUrl(webUrl);
                          } else {
                            print("can't open Site");
                          }
                        },
                      )
                    : SizedBox(),
                //Pinterest
                SizedBox(
                  width: 15,
                ),
                dados.pinterest != ''
                    ? GestureDetector(
                        child: Container(
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: azul,
                                ),
                                height: 70,
                                width: 70,
                                child: Icon(
                                  FontAwesomeIcons.pinterest,
                                  color: cinzaClaro,
                                  size: 32,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Pinterest",
                                style: GoogleFonts.roboto(
                                  color: azul,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        onTap: () async {
                          Uri webUrl = Uri.parse("${dados.pinterest}");
                          if (await canLaunchUrl(webUrl)) {
                            await launchUrl(webUrl);
                          } else {
                            print("can't open Pinterest");
                          }
                        },
                      )
                    : SizedBox(),
                //Youtube
                SizedBox(
                  width: 15,
                ),

                dados.youtube != ''
                    ? GestureDetector(
                        child: Container(
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: azul,
                                ),
                                height: 70,
                                width: 70,
                                child: Icon(
                                  FontAwesomeIcons.youtube,
                                  color: cinzaClaro,
                                  size: 32,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Youtube",
                                style: GoogleFonts.roboto(
                                  color: azul,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        onTap: () async {
                          Uri webUrl = Uri.parse("${dados.youtube}");
                          if (await canLaunchUrl(webUrl)) {
                            await launchUrl(webUrl);
                          } else {
                            print("can't open Youtube");
                          }
                        },
                      )
                    : SizedBox(),
              ],
            ),
          ),

          SizedBox(
            height: 5,
          ),

          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15), color: cinza),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          "${dados.nome}",
                          style: GoogleFonts.roboto(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: cinzaEscuro,
                          ),
                        ),
                      ),
                      FilledButton.icon(
                        label: Text(
                          "Localização",
                          style: GoogleFonts.roboto(
                            color: cinzaClaro,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        icon: Icon(Icons.location_on),
                        onPressed: () async {
                          Uri googleMapsUrl = Uri.parse(
                              "https://www.google.com/maps/search/?api=1&query=${dados.localizacaoDoEstabelecimentoLat},${dados.localizacaoDoEstabelecimentoLong}");

                          if (await canLaunchUrl(googleMapsUrl)) {
                            await launchUrl(googleMapsUrl);
                          } else {
                            throw 'Could not open the map.';
                          }
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
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "${dados.detalhes}",
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 36,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        dados.emiteNotaFiscal != ''
                            ? Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: cinzaClaro,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Emite nota fiscal"),
                                ),
                              )
                            : SizedBox()
                        //
                        ,
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: cinzaClaro,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(dados.cnpj),
                          ),
                        ),

                        //
                      ],
                    ),
                  ),
                  //
                ],
              ),
            ),
          ),
        ],
      );

  Future popupEnviarSolicitacaoDireta(context,PerfilDados dados) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: cinzaClaro,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
          title: Text(
            "Enviar",
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
                  Text("Digite ao profissional  o que você precisa"),
                  SizedBox(
                    height: 30,
                  ),
                  //O que faz?

                  TextFormField(
                    maxLines: 4,
                    style: GoogleFonts.roboto(
                      color: cinzaEscuro,
                      fontSize: 18,
                    ),
                    cursorColor: azul,
                    controller: solicitacaoEditingController,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            solicitacaoEditingController.clear();
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
                        borderSide: BorderSide(
                          color: vermelho,
                          width: 3,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(
                          color: vermelho,
                          width: 3,
                        ),
                      ),
                      hintText: "Escreva...",
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
                //Enviar para a solicitação para o profissional
                //data atual
                final DateTime now = DateTime.now();
                final DateFormat formatter = DateFormat('dd/MM/yyyy');
                final String dataFormatada = formatter.format(now);

                final isValidForm = formKey.currentState!.validate();

                if (isValidForm) {
                  final docRef = _firestore
                      .collection('Perfil Geral')
                      .doc('Profissional')
                      .collection(widget.auxEmail)
                      .doc("Solicitação")
                      .collection('Direta')
                      .doc();

                  final id = docRef.id;

                  DocumentSnapshot doc = await FirebaseFirestore.instance
                      .collection('Cliente')
                      .doc(UID)
                      .collection('Perfil')
                      .doc('Dados')
                      .get();

                  String nome = doc['Nome'];
                  String whatsAppContato = doc['WhatsAppContato'];

                  await docRef.set({
                    'Id': id,
                    'Solicitação': solicitacaoEditingController.text,
                    'WhatsAppContato': whatsAppContato,
                    'Data': dataFormatada,
                    'Nome': nome,
                  }, SetOptions(merge: true));

                  //Enviar a solicitação para o Administrador

                  final docRefer = _firestore
                      .collection('Administrador')
                      .doc("Solicitações")
                      .collection('Geral')
                      .doc();

                  final aux_Id = docRef.id;

                  await docRefer.set({
                    'Id': aux_Id,
                    'Solicitação': solicitacaoEditingController.text,
                    'WhatsAppContato': dados.whatsAppContato ,
                    'Data': dataFormatada,
                  }, SetOptions(merge: true));

                  //Enviar a solicitação para cliente

                  final docRefe = _firestore
                      .collection('Cliente')
                      .doc(UID)
                      .collection('Solicitação')
                      .doc();

                  final auxId = docRef.id;

                  await docRefe.set({
                    'Id': auxId,
                    'Solicitação': solicitacaoEditingController.text,
                    'WhatsAppContato': dados.whatsAppContato ,
                    'Data': dataFormatada,
           
                  }, SetOptions(merge: true));

                  //Passar a pagina
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: Duration(seconds: 5),
                      content: Text(
                        "Solicitação enviada.",
                        style: GoogleFonts.roboto(
                          color: cinzaClaro,
                        ),
                      ),
                      backgroundColor: azul,
                    ),
                  );
                  Navigator.pop(context);
                  //Limpar campo
                  setState(() {
                    solicitacaoEditingController.clear();
                  });
                  //
                }
                //
              },
            ),
          ],
        ),
      );
}

//Informações do cliente para leitura
class PerfilDados {
  String id;
  String idGeral;
  //Principal
  final String imagemPrincipalUrl;
  final String nome;
  final String detalhes;
  //Redes Sociais

  final String facebook;
  final String instagram;
  final String linkedIn;
  final String tikTok;
  final String pinterest;
  final String site;
  final String youtube;
  //Certificados e formações

  //Contato e Localização
  final String email;
  final String whatsAppContato;
  final String whatsAppContato02;
  final String whatsAppContato03;
  final String localizacaoDoEstabelecimentoLat;
  final String localizacaoDoEstabelecimentoLong;
  final String rua;
  final String bairro;
  final String numero;
  final String complemento;

  //Negócios
  final String emiteNotaFiscal;
  final String cnpj;

  PerfilDados({
    this.id = '',
    this.idGeral = '',
    //Principal
    this.imagemPrincipalUrl = '',
    required this.nome,
    this.detalhes = "",
    //Redes Socias
    this.facebook = "",
    this.instagram = "",
    this.linkedIn = "",
    this.tikTok = "",
    this.pinterest = "",
    this.site = "",
    this.youtube = "",
    //Contato e Localização
    this.email = "",
    this.whatsAppContato = "",
    this.whatsAppContato02 = "",
    this.whatsAppContato03 = "",
    this.localizacaoDoEstabelecimentoLat = "",
    this.localizacaoDoEstabelecimentoLong = "",
    this.rua = "",
    this.bairro = "",
    this.numero = "",
    this.complemento = "",
    //Negócios
    this.emiteNotaFiscal = "",
    this.cnpj = "",
  });

  Map<String, dynamic> toJson() => {
        'Id': id,
        'IdGeral': idGeral,
        //Principal
        'ImagemPrincipalUrl': imagemPrincipalUrl,
        'Nome': nome,
        'Detalhes': detalhes,
        //Redes Sociais
        'Facebook': facebook,
        'Instagram': instagram,
        'LinkedIn': linkedIn,
        'TikTok': tikTok,
        'Pinterest': pinterest,
        'Site': site,
        'Youtube': youtube,
        //Contato e Localização
        'Email': email,
        'WhatsAppContato': whatsAppContato,
        'WhatsAppContato02': whatsAppContato02,
        'WhatsAppContato03': whatsAppContato03,
        'LocalizacaoDoEstabelecimentoLat': localizacaoDoEstabelecimentoLat,
        'LocalizacaoDoEstabelecimentoLong': localizacaoDoEstabelecimentoLong,
        'Rua': rua,
        'Bairro': bairro,
        'Numero': numero,
        'Complemento': complemento,
        //Negócios
        'EmiteNotaFiscal': emiteNotaFiscal,
        'CNPJ': cnpj,
      };

  static PerfilDados fromJson(Map<String, dynamic> json) => PerfilDados(
        id: json["Id"] ?? '',
        idGeral: json["IdGeral"] ?? '',
        //Principal
        imagemPrincipalUrl: json["ImagemPrincipalUrl"] ?? '',
        nome: json['Nome'] ?? '',
        detalhes: json['Detalhes'] ?? '',
        //Redes Sociais
        facebook: json['Facebook'] ?? '',
        instagram: json['Instagram'] ?? '',
        linkedIn: json['LinkedIn'] ?? '',
        tikTok: json['TikTok'] ?? '',
        pinterest: json['Pinterest'] ?? '',
        site: json['Site'] ?? '',
        youtube: json['Youtube'] ?? '',
        //Contato e Localização
        email: json['Email'] ?? '',
        whatsAppContato: json['WhatsAppContato'] ?? '',
        whatsAppContato02: json['WhatsAppContato02'] ?? '',
        whatsAppContato03: json['WhatsAppContato03'] ?? '',
        localizacaoDoEstabelecimentoLat:
            json['LocalizacaoDoEstabelecimentoLat'] ?? '',
        localizacaoDoEstabelecimentoLong:
            json['LocalizacaoDoEstabelecimentoLong'] ?? '',
        rua: json['Rua'] ?? '',
        bairro: json['Bairro'] ?? '',
        numero: json['Numero'] ?? '',
        complemento: json['Complemento'] ?? '',
        //Negócios
        emiteNotaFiscal: json['EmiteNotaFiscal'] ?? '',
        cnpj: json['CNPJ'] ?? '',
      );
}
