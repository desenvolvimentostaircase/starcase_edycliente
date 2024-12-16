import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../../../Cores/cores.dart';
import '../Buscar/buscar.dart' as soli;
import 'perfil_profissional_sub.dart';
import 'salvarContato/salvar_contato.dart';

class PrimeiraBusca extends StatefulWidget {
  final String cidadeEstadoAux;
  final String profissionalAux;

  const PrimeiraBusca(this.cidadeEstadoAux, this.profissionalAux, {Key? key})
      : super(key: key);

  @override
  State<PrimeiraBusca> createState() => _PrimeiraBuscaState();
}

abrirWhatsApp(String whatsAppContato, String nomeContato) async {
  String mensagem = Uri.encodeComponent(
      "Olá $nomeContato, venho da Staircase, gostaria de saber se você está disponível para serviço?");
  Uri whatsappUrl = Uri.parse(
      "https://api.whatsapp.com/send?phone=55$whatsAppContato&text=$mensagem");

  if (await canLaunchUrl(whatsappUrl)) {
    await launchUrl(
      whatsappUrl,
      mode: LaunchMode.externalApplication, // Garante abertura no navegador
    );
  } else {
    throw 'Could not launch $whatsappUrl';
  }
}

Stream<List<soli.BuscarDadosGeral>> leiaBuscasProfissionais(
  profissional,
  cidadeEstado,
) =>
    FirebaseFirestore.instance
        .collection("Busca Geral")
        .doc(profissional)
        .collection(cidadeEstado)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => soli.BuscarDadosGeral.fromJson(doc.data()))
            .toList());

class _PrimeiraBuscaState extends State<PrimeiraBusca> {

   final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  final List<Widget> content = [
    //
    Container(
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(15), color: cinza),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 280,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ListTile(
                  title: Text(
                    "Staircase",
                    style: GoogleFonts.roboto(
                      color: cinzaEscuro,
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Container(
                    width: 250,
                    height: 80,
                    child: ListView(
                      children: [
                        Text(
                          "realizo pequenos reparos e serviços domésticos variados, que geralmente exigem habilidades práticas. As tarefas podem incluir consertos elétricos, hidráulicos, montagem de móveis, pintura, instalação de equipamentos, entre outros.",
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10, left: 15),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: FilledButton.icon(
                      label: Text(
                        "Entre em contato",
                        style: GoogleFonts.roboto(
                          color: cinzaClaro,
                        ),
                      ),
                      icon: Icon(
                        FontAwesomeIcons.whatsapp,
                        size: 14,
                      ),
                      onPressed: () async {
                        Uri webUrl = Uri.parse(
                            "https://play.google.com/store/apps/details?id=com.edy.edycliente&hl=pt_BR");
                        if (await canLaunchUrl(webUrl)) {
                          await launchUrl(webUrl);
                        } else {
                          print("can't open PlayStore Staircase Cliente");
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
                  ),
                ),
              ],
            ),
          ),
          
        ],
      ),
    ),
    //
    Container(
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(15), color: cinza),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //
          Container(
            width: 260,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ListTile(
                  title: Text(
                    "Staircase Profissional",
                    style: GoogleFonts.roboto(
                      color: cinzaEscuro,
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Container(
                    width: 250,
                    height: 80,
                    child: ListView(
                      children: [
                        Text(
                          "realizo pequenos reparos e serviços domésticos variados, que geralmente exigem habilidades práticas. As tarefas podem incluir consertos elétricos, hidráulicos, montagem de móveis, pintura, instalação de equipamentos, entre outros.",
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10, left: 15),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: FilledButton.icon(
                      label: Text(
                        "Entre em contato",
                        style: GoogleFonts.roboto(
                          color: cinzaClaro,
                        ),
                      ),
                      icon: Icon(
                        FontAwesomeIcons.whatsapp,
                        size: 14,
                      ),
                      onPressed: () async {
                        Uri webUrl = Uri.parse(
                            "https://play.google.com/store/apps/details?id=com.pro.profissional&hl=pt_BR");
                        if (await canLaunchUrl(webUrl)) {
                          await launchUrl(webUrl);
                        } else {
                          print("can't open PlayStore Staircase Cliente");
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
                  ),
                ),
              ],
            ),
          ),
          
        ],
      ),
    ),
    //
    Container(
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(15), color: cinza),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //
          Container(
            width: 250,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ListTile(
                  title: Text(
                    "Redes",
                    style: GoogleFonts.roboto(
                      color: cinzaEscuro,
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Container(
                    width: 250,
                    height: 80,
                    child: ListView(
                      children: [
                        Text(
                          "realizo pequenos reparos e serviços domésticos variados, que geralmente exigem habilidades práticas. As tarefas podem incluir consertos elétricos, hidráulicos, montagem de móveis, pintura, instalação de equipamentos, entre outros.",
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10, left: 15),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: FilledButton.icon(
                      label: Text(
                        "Entre em contato",
                        style: GoogleFonts.roboto(
                          color: cinzaClaro,
                        ),
                      ),
                      icon: Icon(
                        FontAwesomeIcons.whatsapp,
                        size: 14,
                      ),
                      onPressed: () async {
                        Uri webUrl = Uri.parse(
                            "https://play.google.com/store/apps/details?id=com.pro.profissional&hl=pt_BR");
                        if (await canLaunchUrl(webUrl)) {
                          await launchUrl(webUrl);
                        } else {
                          print("can't open PlayStore Staircase Cliente");
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
                  ),
                ),
              ],
            ),
          ),
          
        ],
      ),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(Duration(seconds: 5), (Timer timer) {
      if (_currentPage < content.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }





  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: cinzaClaro,
        body: ListView(
          children: [
            //
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Row(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: cinza,
                    ),
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        color: cinzaEscuro,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Buscas",
                    style: GoogleFonts.roboto(
                      color: cinzaEscuro,
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),

            //CidadeEstado e Profissional
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    30,
                  ),
                  color: cinza,
                ),
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8, bottom: 8, top: 8),
                  child: ListTile(
                    subtitle: Text(
                      widget.cidadeEstadoAux,
                      style: GoogleFonts.roboto(
                        color: cinzaEscuro,
                        fontSize: 16,
                      ),
                    ),
                    title: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        widget.profissionalAux,
                        style: GoogleFonts.roboto(
                          color: cinzaEscuro,
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25),
              child: Text(
                "Empresas destaques",
                style: GoogleFonts.roboto(
                  color: cinzaEscuro,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            //Anuncio do proprio app
            Padding(
              padding: const EdgeInsets.only(
                left: 25,
                right: 25,
              ),
              child: Container(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: content.length,
                  itemBuilder: (context, index) {
                    return content[index];
                  },
                ),

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: cinzaEscuro,
                ),
                width: 1, //
                height: 180,
              ),
            ),

            SizedBox(
              height: 15,
            ),

            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.8,
                width: MediaQuery.of(context).size.width,
                child: StreamBuilder<List<soli.BuscarDadosGeral>>(
                  stream: leiaBuscasProfissionais(
                    widget.profissionalAux,
                    widget.cidadeEstadoAux,
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text("Something went wong! ${snapshot.error}");
                    } else if (snapshot.hasData) {
                      final leiaBuscar = snapshot.data!;
                      return ListView.builder(
                          itemCount: leiaBuscar.length,
                          itemBuilder: (context, index) {
                            final buscar = leiaBuscar[index];
                            return columnSolicitacao(buscar,
                                widget.profissionalAux, widget.cidadeEstadoAux);
                          });
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
            ),

            //
          ],
        ),
      );

  Widget columnSolicitacao(buscar, profissional, cidadeEstado) => ListTile(
      trailing: IconButton(
        icon: Icon(Icons.bookmark_add_outlined),
        color: azul,
        onPressed: () {
          popupSalvarContato(
              buscar.whatsAppContato, buscar.nome, profissional, cidadeEstado);
        },
      ),
      leading: buscar.imagemPrincipalUrl.isNotEmpty
          ? Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  buscar.imagemPrincipalUrl,
                  fit: BoxFit.cover,
                ),
              ),
              height: 60,
              width: 60,
            )
          : SizedBox(),
      title: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Text(
          "${buscar.nome}",
          style: GoogleFonts.roboto(
            color: cinzaEscuro,
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      subtitle: buscar.imagemPrincipalUrl.isNotEmpty
          ? Row(
              children: [
                buscar.cnpj != ""
                    ? Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: cinza),
                        child: Padding(
                          padding: const EdgeInsets.all(6),
                          child: Text(
                            "CNPJ",
                          ),
                        ),
                      )
                    : SizedBox(),
                SizedBox(
                  width: 10,
                ),
                buscar.emiteNotaFiscal == "Sim"
                    ? Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: cinza),
                        child: Padding(
                          padding: const EdgeInsets.all(6),
                          child: Text(
                            "Emite nota fiscal",
                          ),
                        ),
                      )
                    : SizedBox(),
              ],
            )
          : Text(
              "${buscar.whatsAppContato}",
              style: GoogleFonts.roboto(
                color: cinzaEscuro,
                fontSize: 14,
              ),
            ),
      onTap: buscar.email.isNotEmpty
          ? () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => PerfilProfissional(
                    buscar.email,
                  ),
                ),
              );
            }
          : () {
              abrirWhatsApp(
                buscar.whatsAppContato,
                buscar.nome,
              );
            });

  Future popupSalvarContato(
          whatsAppContato, nome, profissional, cidadeEstado) =>
      showDialog(
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
              onPressed: () {
                final salvarContato = SalvarContato(
                  nome: nome,
                  whatsAppContato: whatsAppContato,
                  cidadeEstadoSelecionada: cidadeEstado,
                  profissionalSelecionada: profissional,
                );
                createSalvarContato(salvarContato);
                Navigator.pop(context);
                final snackBar = SnackBar(
                  backgroundColor: azul,
                  content: Text('Contato salvo com sucesso'),
                );

                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
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
}
