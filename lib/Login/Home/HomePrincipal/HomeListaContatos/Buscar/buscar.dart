import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../../../../Cores/cores.dart';
import '../primeiraBusca/primeira_busca.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class Buscar extends StatefulWidget {
  const Buscar({Key? key}) : super(key: key);

  @override
  State<Buscar> createState() => _BuscarState();
}

class _BuscarState extends State<Buscar> {
  ///
  final _cidadeEstado = [
    "Três Lagoas - MS",
    "Andradina - SP",
    "Ilha Solteira - SP",
    "Castilho - SP",
    "Tupã - SP",
  ];

  List<String> listItems = <String>[
    "Advogado",
    "Airfryer (Manutenção)",
    "Aquecedores de piscina (Manutenção e instalação)",
    "Ar condicionado (Manutenção e Instalação)",
    "Arcondicionado portatil (Manutenção)",
    "Aspirador de pó (Manutenção)",
    "Banho e Tosa",
    "Bebedouro (Manutenção)",
    "Cabeleireira",
    "Cabelereira (Domicilio)",
    "Caçamba",
    "Cafeteira eletrica (Manutenção)",
    "Calheiro",
    "Camera de segurança (Manutenção e Instalação)",
    "Carpinteiro",
    "Cerca eletrica (Manutenção e Instalação)",
    "Chapinha (Manutenção)",
    "Chaveiro",
    "Churrasqueira eletrica (Manutenção)",
    "Climatizador (Manutenção)",
    "Confeitera",
    "Contador",
    "Costureira",
    "Cuidadora",
    "Dedetizador",
    "Dentista",
    "Depilador",
    "Designer de sobrancelha  (domicilio)",
    "Designer de sobrancelha",
    "Eletricista",
    "Encanador",
    "Extensão de cilios",
    "Faxineira",
    "Ferro de passar (Manutenção)",
    "Fogão (Manutenção)",
    "Forno eletrico (Manutenção)",
    "Forro PVC (Manutenção e Instalação)",
    "Freezer (Manutenção)",
    "Fretista (Caminhão)",
    "Fretista (Carretinha)",
    "Geladeira (Manutenção)",
    "Geladeira Comecial (Manutenção)",
    "Gesseiro",
    "Grafica",
    "Guincho",
    "Jardineiro",
    "Lavador a seco (Estofados)",
    "Limpeza terreno",
    "Manicure",
    "Manicure (Domicilio)",
    "Maquiadora",
    "Maquina de lavar roupa (Manutenção)",
    "Marceneiro",
    "Marido de aluguel",
    "Mecanico",
    "Microondas (Manutenção)",
    "Montador de móveis",
    "Motorista (Carro)",
    "Motorista (Moto)",
    "Painel solar (Manutenção e Instalação)",
    "Panela eletrica (Manutenção)",
    "Pedicure",
    "Pedicure (Domicilio)",
    "Pedreiro",
    "Pintor",
    "Podador de arvores",
    "Processador de alimentos (Manutenção)",
    "Professora de reforço escolar (1 ao 5 ano)",
    "Salgadeira",
    "Sanduicheira (Manutenção)",
    "Sapateiro",
    "Secador de cabelo (Manutenção)",
    "Serralheiro",
    "Soldador",
    "Tapeceiro",
    "Tecnico de informatica",
    "Televisão (Manutenção)",
    "Motorista de van escolar",
    "Ventilador (Manutenção)",
    "Ventilador de teto (Manutenção)",
    "Vidraceiro",
  ];

  //
  String _cidadeEstadoSelecionada = "";
  String _profissionalSelecionado = "";

  final formKey = GlobalKey<FormState>();
  final TextEditingController _textEditingController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String UID = FirebaseAuth.instance.currentUser!.uid.toString();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cinzaClaro,
      body: Padding(
        padding:
            const EdgeInsets.only(left: 35, right: 35, bottom: 35, top: 20),
        child: Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            children: [
              Row(
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
                    "Buscar",
                    style: GoogleFonts.roboto(
                      color: cinzaEscuro,
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),

              ///Profissional
              TypeAheadFormField<String>(
                textFieldConfiguration: TextFieldConfiguration(
                  controller: _textEditingController,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: cinza,
                      suffixIcon: Icon(Icons.arrow_drop_down_sharp),
                      hintStyle: GoogleFonts.roboto(),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide(
                          color: vermelho,
                          width: 3,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide(
                          color: cinza,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide(
                          color: azul,
                          width: 3,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide(
                          color: vermelho,
                          width: 3,
                        ),
                      ),
                      hintText: "Profissional"),
                ),
                onSaved: (value) {
                  _profissionalSelecionado = value.toString();
                },
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      !listItems.contains(value)) {
                    return 'Selecione um profisional ou serviço';
                  }
                  return null;
                },
                suggestionsCallback: (pattern) {
                  return listItems.where((option) =>
                      option.toLowerCase().contains(pattern.toLowerCase()));
                },
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    title: Text(suggestion),
                  );
                },
                onSuggestionSelected: (suggestion) {
                  setState(() {
                    _profissionalSelecionado = suggestion;
                    _textEditingController.text = suggestion;
                  });
                },
              ),

              SizedBox(
                height: 15,
              ),

              ///Localização

              DropdownButtonFormField(
                validator: (value) {
                  if (value == null || value != _cidadeEstadoSelecionada) {
                    return 'Seleciona uma cidade';
                  } else {
                    return null;
                  }
                },
                menuMaxHeight: 240,
                items: _cidadeEstado
                    .map((e) => DropdownMenuItem(
                          child: Text(
                            e,
                            style: GoogleFonts.roboto(
                              color: cinzaEscuro,
                              fontSize: 17,
                            ),
                          ),
                          value: e,
                        ))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    _cidadeEstadoSelecionada = val as String;
                  });
                },
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: cinzaEscuro,
                ),
                dropdownColor: cinzaClaro,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: cinza,
                  hintText: "Cidade e Estado",
                  hintStyle: GoogleFonts.roboto(),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(
                      color: cinza,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(
                      color: azul,
                      width: 3,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(
                      color: vermelho,
                      width: 3,
                    ),
                  ),
                ),
                ),
            ],
          ),
        ),
      ),
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
          Icons.search,
          color: cinzaClaro,
        ),
        onPressed: () async {
          final isValidForm = formKey.currentState!.validate();

          if (isValidForm) {
            //Resgatar algumas informações do banco de dados
            DocumentSnapshot doc = await FirebaseFirestore.instance
                .collection('Cliente')
                .doc(UID)
                .collection('Perfil')
                .doc('Dados')
                .get();
            String email = doc['Email'];
            String nome = doc['Nome'];
            String whatsAppContato = doc['WhatsAppContato'];

            final buscar = BuscarDados(
              cidadeEstadoSelecionada: _cidadeEstadoSelecionada,
              profissionalSelecionada: _profissionalSelecionado,
            );
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            );
            await Future.delayed(Duration(seconds: 3));

            //Adiconar no app Administrador

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
              'CidadeEstado': _cidadeEstadoSelecionada,
              'Profissional': _profissionalSelecionado,
              'Email': email,
              'Nome': nome,
              'WhatsAppContato': whatsAppContato,
              'Id': id,
              'Data': dataFormatada
            }, SetOptions(merge: true));

            Navigator.pop(context);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => PrimeiraBusca(
                  _cidadeEstadoSelecionada,
                  _profissionalSelecionado,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
//

//Busca interna
class BuscarDados {
  String id;
  final String profissionalSelecionada;
  final String cidadeEstadoSelecionada;

  BuscarDados({
    this.id = '',
    this.profissionalSelecionada = '',
    this.cidadeEstadoSelecionada = '',
  });

  Map<String, dynamic> toJson() => {
        'Id': id,
        'Profissional': profissionalSelecionada,
        'CidadeEstado': cidadeEstadoSelecionada,
      };

  static BuscarDados fromJson(Map<String, dynamic> json) => BuscarDados(
        id: json["Id"] ?? '',
        profissionalSelecionada: json['Profissional'] ?? '',
        cidadeEstadoSelecionada: json['CidadeEstado'] ?? '',
      );
}

//Busca Geral -- Ler
class BuscarDadosGeral {
  String id;
  final String nome;
  final String whatsAppContato;
  final String email;
  final String imagemPrincipalUrl;

  final String cnpj;
  final String emiteNotaFiscal;

  BuscarDadosGeral({
    this.id = '',
    required this.nome,
    required this.whatsAppContato,
    required this.email,
    this.imagemPrincipalUrl = '',
    this.cnpj = '',
    this.emiteNotaFiscal = '',
  });

  Map<String, dynamic> toJson() => {
        'Id': id,
        'Nome': nome,
        'whatsAppContato': whatsAppContato,
        'Email': email,
        'ImagemPrincipalUrl': imagemPrincipalUrl,
        'CNPJ': cnpj,
        'EmiteNotaFiscal': emiteNotaFiscal,
      };

  static BuscarDadosGeral fromJson(Map<String, dynamic> json) =>
      BuscarDadosGeral(
        id: json["Id"] ?? '',
        nome: json['Nome'] ?? '',
        whatsAppContato: json['WhatsAppContato'] ?? '',
        email: json['Email'] ?? '',
        imagemPrincipalUrl: json['ImagemPrincipalUrl'] ?? '',
        cnpj: json['CNPJ'] ?? '',
        emiteNotaFiscal: json['EmiteNotaFiscal'] ?? '',
      );
}
