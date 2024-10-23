import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edywasacliente/Cores/cores.dart';
import 'package:edywasacliente/Login/Home/HomePrincipal/HomeListaContatos/primeiraBusca/primeira_busca.dart';
import 'package:edywasacliente/Login/Home/HomePrincipal/HomeListaContatos/primeiraBusca/salvarContato/salvar_contato.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../ads/ads.dart';
import 'Buscar/buscar.dart' as soli;

class HomeListaContato extends StatefulWidget {
  const HomeListaContato({super.key});

  @override
  State<HomeListaContato> createState() => _HomeListaContatoState();
}

String auxProfissional = '';
String auxCidadeEstado = '';
String auxId = '';

class _HomeListaContatoState extends State<HomeListaContato> {
  String UID = FirebaseAuth.instance.currentUser!.uid.toString();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //PopUp de aviso que determina o litime de
  Future popupSolicitacaoLimite() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: cinzaClaro,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text(
            "Limite máximo",
            style: GoogleFonts.roboto(
              fontSize: 25,
              color: cinzaEscuro,
            ),
            textAlign: TextAlign.center,
          ),
          content: SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
            width: 1,
            child: Text(
              "Para que possa fazer mais solicitações, terá que excluir solicitações já realizadas.",
              style: GoogleFonts.roboto(
                fontSize: 17,
                color: cinzaEscuro,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            Padding(
              padding: const EdgeInsets.only(
                bottom: 15,
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.only(
                    left: 40,
                    right: 40,
                    top: 12,
                    bottom: 12,
                  ),
                  backgroundColor: vermelho,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "Fechar",
                  style: GoogleFonts.roboto(
                    fontSize: 20,
                    color: cinzaClaro,
                  ),
                  textAlign: TextAlign.center,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      );

  /// Le o conteudo local (App Edy Profissional)
  Stream<List<soli.BuscarDados>> leiaBuscar() => FirebaseFirestore.instance
      .collection('Cliente')
      .doc(UID)
      .collection("Buscar")
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => soli.BuscarDados.fromJson(doc.data()))
          .toList());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25, right: 25),
            child: Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: azul,
                  ),
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: cinzaClaro,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Contato",
                  style: GoogleFonts.roboto(
                    color: azul,
                    fontWeight: FontWeight.bold,
                    fontSize: 45,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25, right: 25),
            child: Text(
              "Aqui é onde ficam os contatos dos profissionais, se precisar de mais tipos de profissionais aperte em buscar",
              style: GoogleFonts.roboto(
                color: cinzaEscuro,
                fontSize: 15,
              ),
            ),
          ),
          getAd(),

          //Localização dos pré filtros
          Padding(
            padding: const EdgeInsets.only(left: 25),
            child: Row(
              children: [
                Icon(
                  Icons.location_on,
                ),
                Text(
                  "Três Lagoas - MS",
                  style: GoogleFonts.roboto(
                    color: cinzaEscuro,
                    fontSize: 15,
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),

          //Lista de pré filtros
          Container(
            height: 150,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                SizedBox(
                  width: 25,
                ),
                //Filtro de fretista Caminhão
                GestureDetector(
                  onTap: () async {
                    //Buscar dados no perfil do usuario
                    DocumentSnapshot doc = await FirebaseFirestore.instance
                        .collection('Cliente')
                        .doc(UID)
                        .collection('Perfil')
                        .doc('Dados')
                        .get();

                    String nome = doc['Nome'];
                    String whatsAppContato = doc['WhatsAppContato'];
                    String email = doc['Email'];

                    // Resgistar no app Administrativo

                    //data atual
                    final DateTime now = DateTime.now();
                    final DateFormat formatter = DateFormat('dd/MM/yyyy');
                    final String dataFormatada = formatter.format(now);

                    final docRef = _firestore
                        .collection('Administrador')
                        .doc('Buscas')
                        .collection('Geral')
                        .doc();

                    final id = docRef.id;

                    await docRef.set({
                      'CidadeEstado': "Três Lagoas - MS",
                      'Profissional': "Fretista (Caminhão)",
                      'Email': email,
                      'Nome': nome,
                      'WhatsAppContato': whatsAppContato,
                      'Id': id,
                      'Data': dataFormatada
                    }, SetOptions(merge: true));

                    //Passar a pagina
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PrimeiraBusca(
                            "Três Lagoas - MS", "Fretista (Caminhão)"),
                      ),
                    );
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
                              Icons.local_shipping,
                              size: 40,
                              color: cinzaClaro,
                            ),
                          ),
                        ),
                        Text(
                          "Fretista Caminhão",
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
                //Filtro de fretista Carretinha
                GestureDetector(
                  onTap: () async {
                    //Buscar dados no perfil do usuario
                    DocumentSnapshot doc = await FirebaseFirestore.instance
                        .collection('Cliente')
                        .doc(UID)
                        .collection('Perfil')
                        .doc('Dados')
                        .get();

                    String nome = doc['Nome'];
                    String whatsAppContato = doc['WhatsAppContato'];
                    String email = doc['Email'];

                    // Resgistar no app Administrativo

                    //data atual
                    final DateTime now = DateTime.now();
                    final DateFormat formatter = DateFormat('dd/MM/yyyy');
                    final String dataFormatada = formatter.format(now);

                    final docRef = _firestore
                        .collection('Administrador')
                        .doc('Buscas')
                        .collection('Geral')
                        .doc();

                    final id = docRef.id;

                    await docRef.set({
                      'CidadeEstado': "Três Lagoas - MS",
                      'Profissional': "Fretista (Carretinha)",
                      'Email': email,
                      'Nome': nome,
                      'WhatsAppContato': whatsAppContato,
                      'Id': id,
                      'Data': dataFormatada
                    }, SetOptions(merge: true));

                    //

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PrimeiraBusca(
                            "Três Lagoas - MS", "Fretista (Carretinha)"),
                      ),
                    );
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
                              Icons.drive_eta,
                              size: 40,
                              color: cinzaClaro,
                            ),
                          ),
                        ),
                        Text(
                          "Fretista Carretinha",
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
                //Filtro de Arcondicionado (Manutenção)
                GestureDetector(
                  onTap: () async {
                    //Buscar dados no perfil do usuario
                    DocumentSnapshot doc = await FirebaseFirestore.instance
                        .collection('Cliente')
                        .doc(UID)
                        .collection('Perfil')
                        .doc('Dados')
                        .get();

                    String nome = doc['Nome'];
                    String whatsAppContato = doc['WhatsAppContato'];
                    String email = doc['Email'];

                    // Resgistar no app Administrativo

                    //data atual
                    final DateTime now = DateTime.now();
                    final DateFormat formatter = DateFormat('dd/MM/yyyy');
                    final String dataFormatada = formatter.format(now);

                    final docRef = _firestore
                        .collection('Administrador')
                        .doc('Buscas')
                        .collection('Geral')
                        .doc();

                    final id = docRef.id;

                    await docRef.set({
                      'CidadeEstado': "Três Lagoas - MS",
                      'Profissional':
                          "Ar condicionado (Manutenção e Instalação)",
                      'Email': email,
                      'Nome': nome,
                      'WhatsAppContato': whatsAppContato,
                      'Id': id,
                      'Data': dataFormatada
                    }, SetOptions(merge: true));

                    //
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PrimeiraBusca(
                            "Três Lagoas - MS",
                            "Ar condicionado (Manutenção e Instalação)"),
                      ),
                    );
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
                              Icons.ac_unit_rounded,
                              size: 40,
                              color: cinzaClaro,
                            ),
                          ),
                        ),
                        Text(
                          "Ar condic. Manuten.",
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
                //Filtro de Marido de Aluguel
                GestureDetector(
                  onTap: () async {
                    //Buscar dados no perfil do usuario
                    DocumentSnapshot doc = await FirebaseFirestore.instance
                        .collection('Cliente')
                        .doc(UID)
                        .collection('Perfil')
                        .doc('Dados')
                        .get();

                    String nome = doc['Nome'];
                    String whatsAppContato = doc['WhatsAppContato'];
                    String email = doc['Email'];

                    // Resgistar no app Administrativo

                    //data atual
                    final DateTime now = DateTime.now();
                    final DateFormat formatter = DateFormat('dd/MM/yyyy');
                    final String dataFormatada = formatter.format(now);

                    final docRef = _firestore
                        .collection('Administrador')
                        .doc('Buscas')
                        .collection('Geral')
                        .doc();

                    final id = docRef.id;

                    await docRef.set({
                      'CidadeEstado': "Três Lagoas - MS",
                      'Profissional': "Marido de aluguel",
                      'Email': email,
                      'Nome': nome,
                      'WhatsAppContato': whatsAppContato,
                      'Id': id,
                      'Data': dataFormatada
                    }, SetOptions(merge: true));

                    //
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PrimeiraBusca(
                            "Três Lagoas - MS", "Marido de aluguel"),
                      ),
                    );
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
                              Icons.handyman_rounded,
                              size: 40,
                              color: cinzaClaro,
                            ),
                          ),
                        ),
                        Text(
                          "Marido de aluguel",
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

                //Filtro de Jardineiro
                GestureDetector(
                  onTap: () async {
                    //Buscar dados no perfil do usuario
                    DocumentSnapshot doc = await FirebaseFirestore.instance
                        .collection('Cliente')
                        .doc(UID)
                        .collection('Perfil')
                        .doc('Dados')
                        .get();

                    String nome = doc['Nome'];
                    String whatsAppContato = doc['WhatsAppContato'];
                    String email = doc['Email'];

                    // Resgistar no app Administrativo

                    //data atual
                    final DateTime now = DateTime.now();
                    final DateFormat formatter = DateFormat('dd/MM/yyyy');
                    final String dataFormatada = formatter.format(now);

                    final docRef = _firestore
                        .collection('Administrador')
                        .doc('Buscas')
                        .collection('Geral')
                        .doc();

                    final id = docRef.id;

                    await docRef.set({
                      'CidadeEstado': "Três Lagoas - MS",
                      'Profissional': "Jardineiro",
                      'Email': email,
                      'Nome': nome,
                      'WhatsAppContato': whatsAppContato,
                      'Id': id,
                      'Data': dataFormatada
                    }, SetOptions(merge: true));

                    //
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PrimeiraBusca(
                            "Três Lagoas - MS", "Jardineiro"),
                      ),
                    );
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
                              Icons.grass_rounded,
                              size: 40,
                              color: cinzaClaro,
                            ),
                          ),
                        ),
                        Text(
                          "Jardineiro",
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
                //Filtro de Banho e Tosa
                GestureDetector(
                  onTap: () async {
                    //Buscar dados no perfil do usuario
                    DocumentSnapshot doc = await FirebaseFirestore.instance
                        .collection('Cliente')
                        .doc(UID)
                        .collection('Perfil')
                        .doc('Dados')
                        .get();

                    String nome = doc['Nome'];
                    String whatsAppContato = doc['WhatsAppContato'];
                    String email = doc['Email'];

                    // Resgistar no app Administrativo

                    //data atual
                    final DateTime now = DateTime.now();
                    final DateFormat formatter = DateFormat('dd/MM/yyyy');
                    final String dataFormatada = formatter.format(now);

                    final docRef = _firestore
                        .collection('Administrador')
                        .doc('Buscas')
                        .collection('Geral')
                        .doc();

                    final id = docRef.id;

                    await docRef.set({
                      'CidadeEstado': "Três Lagoas - MS",
                      'Profissional': "Banho e Tosa",
                      'Email': email,
                      'Nome': nome,
                      'WhatsAppContato': whatsAppContato,
                      'Id': id,
                      'Data': dataFormatada
                    }, SetOptions(merge: true));

                    //
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PrimeiraBusca(
                            "Três Lagoas - MS", "Banho e Tosa"),
                      ),
                    );
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
                              Icons.pets,
                              size: 40,
                              color: cinzaClaro,
                            ),
                          ),
                        ),
                        Text(
                          "Banho e Tosa",
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
                  width: 25,
                ),
              ],
            ),
          ),
          getAd(),

          Container(
            child: Row(
              children: [
                SizedBox(
                  width: 25,
                ),
                Icon(
                  Icons.turned_in_rounded,
                  color: azul,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Text(
                    "Contatos salvos",
                    style: GoogleFonts.roboto(
                      color: azul,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.help,
                  ),
                  onPressed: () {
                    //
                  },
                )
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),
          //Lista de contaos salvos
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.4,
              child: StreamBuilder<List<SalvarContato>>(
                stream: leiaContatoSalvos(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text("Something went wong! ${snapshot.error}");
                  } else if (snapshot.hasData) {
                    final leiaContato = snapshot.data!;
                    return ListView.builder(
                      itemCount: leiaContato.length,
                      itemBuilder: (context, index) {
                        final contatoSalvos = leiaContato[index];
                        return listTileContatoSalvos(context, contatoSalvos);
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
      backgroundColor: cinzaClaro,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: azul,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        label: Text(
          "Buscar",
          style: GoogleFonts.roboto(
            fontSize: 20,
            color: cinzaClaro,
          ),
        ),
        icon: Icon(
          Icons.search_rounded,
          color: cinzaClaro,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const soli.Buscar(),
            ),
          );
        },
      ),
    );
  }
}
