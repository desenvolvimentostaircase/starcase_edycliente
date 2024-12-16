import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../../../Cores/cores.dart';
import '../perfil_profissional_sub.dart';
import '../primeira_busca.dart';

class ContatosSalvos extends StatefulWidget {
  const ContatosSalvos({super.key});

  @override
  State<ContatosSalvos> createState() => _ContatosSalvosState();
}

class _ContatosSalvosState extends State<ContatosSalvos> {
  @override
  Widget build(BuildContext context) {

    //
    String UID = FirebaseAuth.instance.currentUser!.uid.toString();
//Ler o conteudo do banco de dados
    Stream<List<SalvarContato>> leiacontatosSalvos() =>
        FirebaseFirestore.instance
            .collection("Cliente")
            .doc(UID)
            .collection("ContatoSalvo")
            .snapshots()
            .map((snapshot) => snapshot.docs
                .map((doc) => SalvarContato.fromJson(doc.data()))
                .toList());

    return Scaffold(
      body: SizedBox(
        child: ListView(
          children: [
            SizedBox(height: 20,),
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
                    "Contatos Salvos",
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
            SizedBox(
              height: 25,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5, right: 5),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.9,
                width: MediaQuery.of(context).size.width,
                child: StreamBuilder<List<SalvarContato>>(
                  stream: leiacontatosSalvos(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text("Something went wong! ${snapshot.error}");
                    } else if (snapshot.hasData) {
                      final leiaBuscar = snapshot.data!;

                      // Verifica se o tamanho da lista mudou
             
                      return ListView.builder(
                        itemCount: leiaBuscar.length,
                        itemBuilder: (context, index) {
                          final contatosSalvos = leiaBuscar[index];
                          return listTileContatosSalvos(
                              context, contatosSalvos);
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
}

//Criar e inserir no banco de dados
Future createSalvarContato(SalvarContato salvarContato) async {
  String UID = FirebaseAuth.instance.currentUser!.uid.toString();

  //
  //Inserir ou criar informação no banco de dados
  final docBuscar = FirebaseFirestore.instance
      .collection("Cliente")
      .doc(UID)
      .collection("ContatoSalvo")
      .doc();

  salvarContato.id = docBuscar.id;

  final json = salvarContato.toJson();
  await docBuscar.set(json);
}

//Salvar o contato do profissional no fedd de Salvos
class SalvarContato {
  String id;
  final String profissionalSelecionada;
  final String cidadeEstadoSelecionada;
  final String whatsAppContato;
  final String nome;
  final String email;
  final String imagemPrincipalUrl;

  SalvarContato({
    this.id = '',
    this.profissionalSelecionada = '',
    this.cidadeEstadoSelecionada = '',
    this.whatsAppContato = '',
    this.nome = '',
    this.email = '',
    this.imagemPrincipalUrl = '',
  });

  Map<String, dynamic> toJson() => {
        'Id': id,
        'Profissional': profissionalSelecionada,
        'CidadeEstado': cidadeEstadoSelecionada,
        'WhatsAppContato': whatsAppContato,
        'Nome': nome,
        'Email': email,
        'ImagemPrincipalUrl': imagemPrincipalUrl,
      };

  static SalvarContato fromJson(Map<String, dynamic> json) => SalvarContato(
        id: json["Id"] ?? '',
        profissionalSelecionada: json['Profissional'] ?? '',
        cidadeEstadoSelecionada: json['CidadeEstado'] ?? '',
        whatsAppContato: json['WhatsAppContato'] ?? '',
        nome: json['Nome'] ?? '',
        email: json['Email'] ?? '',
        imagemPrincipalUrl: json['ImagemPrincipalUrl'] ?? '',
      );
}

//
Widget listTileContatosSalvos(
  context,
  contatosSalvos,
) =>
    Padding(
      padding: const EdgeInsets.only(bottom: 15, right: 10, left: 10),
      child: GestureDetector(
        onLongPress: () {
          popUpExcluirContatoSalvo(context, contatosSalvos.id);
        },
        child: Container(
          child: ListTile(
            leading: contatosSalvos.imagemPrincipalUrl.isNotEmpty
                ? Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        contatosSalvos.imagemPrincipalUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                    height: 60,
                    width: 60,
                  )
                : SizedBox(),
            onTap: contatosSalvos.imagemPrincipalUrl.isNotEmpty
                ? () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => PerfilProfissional(
                          contatosSalvos.email,
                        ),
                      ),
                    );
                  }
                : () {
                    abrirWhatsApp(
                      contatosSalvos.whatsAppContato,
                      contatosSalvos.nome,
                    );
                  },
            title: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                "${contatosSalvos.nome}",
                style: GoogleFonts.roboto(
                  color: cinzaEscuro,
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            subtitle: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "${contatosSalvos.whatsAppContato}",
                    style: GoogleFonts.roboto(
                      color: cinzaEscuro,
                      fontSize: 14,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                contatosSalvos.profissionalSelecionada != '' &&
                        contatosSalvos.cidadeEstadoSelecionada != ''
                    ? Container(
                        height: 35,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            contatosSalvos.profissionalSelecionada != ''
                                ? Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: azul,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15,
                                          right: 15,
                                          top: 8,
                                          bottom: 8),
                                      child: Text(
                                        contatosSalvos.profissionalSelecionada,
                                        style: GoogleFonts.roboto(
                                          color: cinzaClaro,
                                        ),
                                      ),
                                    ),
                                  )
                                : SizedBox(),
                            SizedBox(
                              width: 5,
                            ),
                            contatosSalvos.cidadeEstadoSelecionada != ''
                                ? Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: azul,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15,
                                          right: 15,
                                          top: 8,
                                          bottom: 8),
                                      child: Text(
                                        contatosSalvos.cidadeEstadoSelecionada,
                                        style: GoogleFonts.roboto(
                                          color: cinzaClaro,
                                        ),
                                      ),
                                    ),
                                  )
                                : SizedBox(),
                          ],
                        ),
                      )
                    : SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );

Future popUpExcluirContatoSalvo(context, id) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: cinzaClaro,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        title: Text(
          "Excluir contato salvo?",
          textAlign: TextAlign.center,
          style: GoogleFonts.roboto(
            fontSize: 18,
            color: azul,
            fontWeight: FontWeight.bold,
          ),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          //Sim
          ElevatedButton(
            onPressed: () {
              String UID = FirebaseAuth.instance.currentUser!.uid.toString();

              //Deletar no banco
              final contatosSalvos = FirebaseFirestore.instance
                  .collection("Cliente")
                  .doc(UID)
                  .collection("ContatoSalvo")
                  .doc(id);

              contatosSalvos.delete();
              Navigator.pop(context);

              final snackBar = SnackBar(
                backgroundColor: azul,
                content: Text('Contato excluido com sucesso'),
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
              padding: const EdgeInsets.all(10),
              backgroundColor: azul,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          ),
          //Não
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              "Não",
              style: GoogleFonts.roboto(
                color: cinzaClaro,
                fontSize: 20,
              ),
            ),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(10),
              backgroundColor: azul,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          ),
        ],
      ),
    );
