import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import '../../../../Cores/cores.dart';
import '../../../../ads/ads.dart';
import 'package:another_telephony/telephony.dart';

class HomeSolicitacao extends StatefulWidget {
  const HomeSolicitacao({super.key});

  @override
  State<HomeSolicitacao> createState() => _HomeSolicitacaoState();
}

class _HomeSolicitacaoState extends State<HomeSolicitacao> {

  List<String> listItemsCidadeEstado = <String>[
   "Três Lagoas - MS",
  "Andradina - SP",
  "Ilha Solteira - SP",
  "Castilho - SP",
  "Tupã - SP",
  ];

  List<String> listItemsProfissional = <String>[
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

  String UID = FirebaseAuth.instance.currentUser!.uid.toString();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //Ler o conteudo
  Stream<List<DadosSolicitacaoCliente>> leiaDadosSolictacaoCliente() =>
      FirebaseFirestore.instance
          .collection('Cliente')
          .doc(UID)
          .collection('Solicitação')
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => DadosSolicitacaoCliente.fromJson(doc.data()))
              .toList());

  String _cidadeEstadoSelecionado = "";
  String _profissionalSelecionado = "";
  String _solicitacaoSelecionado = "";

  //
  final formKey = GlobalKey<FormState>();
  final TextEditingController _profissionalTextEditingController =
      TextEditingController();
  final TextEditingController _cidadeEstadoTextEditingController =
      TextEditingController();
  final TextEditingController _solicitacaoTextEditingController =
      TextEditingController();


//Estrutura de envio de mensagem via SMS

       //final Telephony telephony = Telephony.instance;
  //String _message = "";

  //@override
  //void initState() {
  //  super.initState();
  //  initPlatformState();
  //}

  //Future<void> initPlatformState() async {
  //  final bool? result = await telephony.requestSmsPermissions;
  //  if (result != null && result) {
  //    setState(() {
  //      _message = "Permissão concedida";
  //    });
  //  } else {
  //    setState(() {
  //      _message = "Permissão negada";
  //    });
  //  }
  //}

  //void sendSms(String message, String number) async {
  //  await telephony.sendSms(
  //    to: number,
  //    message: message,
  //  );
  //  setState(() {
  //    _message = "SMS enviado para $number";
  //  });
  //}

  //

  void enviarEmailDireto(String para, String assunto, String mensagem) async {
  String username = 'suportestaircase@gmail.com'; 
  String password = "yreh mmca kaix xmsy"; 

  final smtpServer = gmail(username, password);

  final email = Message()
    ..from = Address(username, 'Suporte Staircase')
    ..recipients.add(para)
    ..subject = assunto
    ..text = mensagem;

  try {
    final sendReport = await send(email, smtpServer);
    print('Email enviado: ' + sendReport.toString());
  } on MailerException catch (e) {
    print('Erro ao enviar email: $e');
  }
}

  @override
  Widget build(BuildContext context) {
    Widget ListTileDadosSolictacaoCliente(
            DadosSolicitacaoCliente dadosSolicitacaoCliente) =>
        Padding(
          padding: const EdgeInsets.only(
            bottom: 10,
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: cinza,
            ),
            //
            child: ListTile(
              title: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: SizedBox(
                  height: 35,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: cinzaEscuro,
                          borderRadius: BorderRadius.circular(
                            50,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 15, right: 15, top: 5, bottom: 5),
                          child: Text(
                            dadosSolicitacaoCliente.profissional,
                            style: GoogleFonts.roboto(
                              fontSize: 16,
                              color: cinzaClaro,
                            ),
                          ),
                        ),
                      ),

                      ///
                      SizedBox(
                        width: 5,
                      ),

                      ///
                      Container(
                        decoration: BoxDecoration(
                          color: cinzaEscuro,
                          borderRadius: BorderRadius.circular(
                            50,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 15, right: 15, top: 5, bottom: 5),
                          child: Text(
                            dadosSolicitacaoCliente.cidadeEstado,
                            style: GoogleFonts.roboto(
                              fontSize: 16,
                              color: cinzaClaro,
                            ),
                          ),
                        ),
                      ),

                      ///
                    ],
                  ),
                ),
              ),
              subtitle: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      dadosSolicitacaoCliente.solicitacao,
                      style: GoogleFonts.roboto(fontSize: 16),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        dadosSolicitacaoCliente.data,
                        style: GoogleFonts.roboto(
                          fontSize: 16,
                          color: cinzaEscuro,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: vermelho,
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: cinzaClaro,
                          ),
                          onPressed: () {
                            String UID = FirebaseAuth.instance.currentUser!.uid
                                .toString();

                            //Deletar no banco
                            final solicitacaoCliente = FirebaseFirestore
                                .instance
                                .collection("Cliente")
                                .doc(UID)
                                .collection("Solicitação")
                                .doc(dadosSolicitacaoCliente.id);

                            solicitacaoCliente.delete();

                            final snackBar = SnackBar(
                              backgroundColor: azul,
                              content: Text('Solicitação excluido com sucesso'),
                            );

                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );

    return Scaffold(
      backgroundColor: cinzaClaro,
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: ListView(
          children: [
            Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10), color: azul),
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: cinzaClaro,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Solicitações",
                  style: GoogleFonts.roboto(
                    color: azul,
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                  ),
                ),
              ],
            ),

            SizedBox(
              height: 5,
            ),
            Text(
              "Aqui você pode enviar socitações para os profissionais",
              style: GoogleFonts.roboto(
                color: cinzaEscuro,
                fontSize: 15,
              ),
            ),
            getAd(),

            //Lista de solcitações - Leitura

            Container(
              color: cinzaClaro,
              height: MediaQuery.of(context).size.height * 0.60,
              child: StreamBuilder<List<DadosSolicitacaoCliente>>(
                stream: leiaDadosSolictacaoCliente(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text("Something went wong! ${snapshot.error}");
                  } else if (snapshot.hasData) {
                    final leiaDadosSolictacaoCliente = snapshot.data!;
                    return ListView.builder(
                      itemCount: leiaDadosSolictacaoCliente.length,
                      itemBuilder: (context, index) {
                        final dadosSolictacaoCliente =
                            leiaDadosSolictacaoCliente[index];
                        return ListTileDadosSolictacaoCliente(
                            dadosSolictacaoCliente);
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
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: azul,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        label: Text(
          "Enviar Solicitação",
          style: GoogleFonts.roboto(
            fontSize: 20,
            color: cinzaClaro,
          ),
        ),
        icon: Icon(
          Icons.list_alt_rounded,
          color: cinzaClaro,
        ),
        onPressed: () {
          popupEnviarFiltroSolcitacoesProfissional(context);
        },
      ),
    );
  }

//PopUp para enviar solicitação para o cliente
  Future popupEnviarFiltroSolcitacoesProfissional(context) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: cinzaClaro,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
          title: Text(
            "Enviar",
            style: GoogleFonts.roboto(
              fontSize: 25,
              color: cinzaEscuro,
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
                  //Solicitação

                  TextFormField(
                    style: GoogleFonts.roboto(
                      color: cinzaEscuro,
                      fontSize: 18,
                    ),
                    cursorColor: azul,
                    controller: _solicitacaoTextEditingController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _solicitacaoTextEditingController.clear();
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
                      hintText: "Solicitação",
                      hintStyle: GoogleFonts.roboto(
                        color: cinzaEscuro.withOpacity(0.6),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Selecione um profisional ou serviço';
                      } else if (value.length > 200) {
                        return 'Encurta o texto, peraê';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _solicitacaoSelecionado = value.toString();
                    },
                    onChanged: (value) {
                      _solicitacaoSelecionado = value.toString();
                    },
                  ),

                  SizedBox(
                    height: 10,
                  ),

                  ///Profissional
                  TypeAheadFormField<String>(
                    textFieldConfiguration: TextFieldConfiguration(
                      controller: _profissionalTextEditingController,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: cinza,
                          suffixIconColor: azul,
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _profissionalTextEditingController.clear();
                              });
                            },
                            icon: Icon(
                              Icons.close,
                            ),
                          ),
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
                          !listItemsProfissional.contains(value)) {
                        return 'Selecione um profisional ou serviço';
                      }
                      return null;
                    },
                    suggestionsCallback: (pattern) {
                      return listItemsProfissional.where((option) =>
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
                        _profissionalTextEditingController.text = suggestion;
                      });
                    },
                  ),

                  ///detalhes do profissional
                  SizedBox(
                    height: 10,
                  ),

                  ///Cidade
                  TypeAheadFormField<String>(
                    textFieldConfiguration: TextFieldConfiguration(
                      controller: _cidadeEstadoTextEditingController,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: cinza,
                          suffixIconColor: azul,
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _cidadeEstadoTextEditingController.clear();
                              });
                            },
                            icon: Icon(
                              Icons.close,
                            ),
                          ),
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
                          hintText: "Cidade"),
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          !listItemsCidadeEstado.contains(value)) {
                        return 'Selecione uma cidade';
                      }
                      return null;
                    },
                    suggestionsCallback: (pattern) {
                      return listItemsCidadeEstado.where((option) =>
                          option.toLowerCase().contains(pattern.toLowerCase()));
                    },
                    itemBuilder: (context, suggestion) {
                      return ListTile(
                        title: Text(suggestion),
                      );
                    },
                    onSaved: (value) {
                      _cidadeEstadoSelecionado = value.toString();
                    },
                    onSuggestionSelected: (suggestion) {
                      setState(() {
                        _cidadeEstadoSelecionado = suggestion;
                        _cidadeEstadoTextEditingController.text = suggestion;
                      });
                    },
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
                "Confirmar",
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
                DocumentSnapshot doc = await FirebaseFirestore.instance
                    .collection('Cliente')
                    .doc(UID)
                    .collection('Perfil')
                    .doc('Dados')
                    .get();

                String _nomeSelecionado = doc['Nome'];
                String _whatsAppSelecionado = doc['WhatsAppContato'];
                String _imagemPrincipalUrl = doc['ImagemPrincipalUrl'];

                //
                //data atual
                final DateTime now = DateTime.now();
                final DateFormat formatter = DateFormat('dd/MM/yyyy');
                final String dataFormatada = formatter.format(now);

                final isValidForm = formKey.currentState!.validate();

                if (isValidForm) {
                  //Adiconar no app Administrador
                  final docRef = _firestore
                      .collection('Administrador')
                      .doc('Solicitações')
                      .collection('Geral')
                      .doc();

                  final id = docRef.id;

                  await docRef.set({
                    'CidadeEstado': _cidadeEstadoSelecionado,
                    'Profissional': _profissionalSelecionado,
                    'Data': dataFormatada,
                    'Solicitação': _solicitacaoSelecionado,
                    'Nome': _nomeSelecionado,
                    'WhatsApp': _whatsAppSelecionado,
                    'Id': id,
                  }, SetOptions(merge: true));

                  final dadosSolicitacaoCliente = DadosSolicitacaoCliente(
                      cidadeEstado: _cidadeEstadoSelecionado,
                      profissional: _profissionalSelecionado,
                      data: dataFormatada,
                      solicitacao: _solicitacaoSelecionado,
                      nome: _nomeSelecionado,
                      whatsApp: _whatsAppSelecionado,
                      imagemPrincipalUrl: _imagemPrincipalUrl);
                  createEnvioSolicitacao(
                      _cidadeEstadoSelecionado,
                      _profissionalSelecionado,
                      _solicitacaoSelecionado,
                      _nomeSelecionado,
                      _imagemPrincipalUrl,
                      dataFormatada,
                      _whatsAppSelecionado);
                  createSolicitacaoCliente(dadosSolicitacaoCliente);

                  _solicitacaoTextEditingController.clear();
                  _profissionalTextEditingController.clear();
                  _cidadeEstadoTextEditingController.clear();

                  Navigator.pop(context);
                }
                //

                 },
            ),
          ],
        ),
      );

  Future createSolicitacaoCliente(
      DadosSolicitacaoCliente dadosSolictacaoCliente) async {
    String UID = FirebaseAuth.instance.currentUser!.uid.toString();

    //
    //Inserir ou criar informação no banco de dados em que o cliente consiguirá olhar no proprio app cliente em sua conta

    final docBuscar = FirebaseFirestore.instance
        .collection('Cliente')
        .doc(UID)
        .collection("Solicitação")
        .doc();

    dadosSolictacaoCliente.id = docBuscar.id;

    final json = dadosSolictacaoCliente.toJson();
    await docBuscar.set(json);
  }

//
  Future<void> createEnvioSolicitacao(
      String cidadeEstado,
      String profissional,
      String solicitacao,
      String nome,
      String imagemPrincipalUrl,
      String data,
      String _whatsAppSelecionado) async {

    // Variável para armazenar os emails
    List<String> emailList = [];
    // Variável para armazenar os emails
    List<String> whatsAppContatoList = [];

    //Resgate dos emails que estão cadastrados em determinadas habilidades/profissionais
    try {
      // Resgata todos os documentos da subcoleção 'Profissional' com base em 'cidadeEstado'
      QuerySnapshot querySnapshot = await _firestore
          .collection('Envio Solicitação')
          .doc(
              cidadeEstado) // Usa a variável cidadeEstado para acessar o documento correto
          .collection(
              profissional) // Usa a variável Profissional para acessar a subcoleção
          .get();

      // Itera sobre os documentos e extrai o campo 'Email' e 'WhatsAppContato'
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        if (doc.exists && doc['Email'] != null) {
          // Adiciona o email à lista
          emailList.add(doc['Email']);
        }
        if (doc.exists && doc['WhatsAppContato'] != null) {
          // Adiciona o email à lista
          whatsAppContatoList.add(doc['WhatsAppContato']);
        }
      }

      // Índice para o while loop
      int i = 0;

      //Conexão Twilio

      // Loop while para iterar sobre os emails de profissionais e fazer a solicitação
      while (i < emailList.length) {
        print("valor de i: $i");

        String email = emailList[i];
        //String whatsAppContato = whatsAppContatoList[i];

        // Envia uma solicitação para outra parte do banco de dados usando o email - Inicio
        final docRef = _firestore
            .collection('Profissional')
            .doc(email)
            .collection('Solicitação')
            .doc();

        final id = docRef.id;

        await docRef.set({
          "Solicitação": solicitacao,
          "Nome": nome,
          "ImagemPrincipalUrl": imagemPrincipalUrl,
          "Data": data,
          "WhatsAppContato": _whatsAppSelecionado,
          "Id": id
        }, SetOptions(merge: true));
        // Envia uma solicitação para outra parte do banco de dados usando o email - Fim

        //sendSms("Solicitação - Staircase Profissional\n\nTemos uma solicitação para você abra o app Staircase Profissional e confira.", "+55$whatsAppContato");

        ///envia email para os respectivos profissionais que se cadastraram para receber notificações de solicitações
        enviarEmailDireto(email, "Solicitação - Staircase Profissional", "Temos uma solicitação para você abra o app Staircase Profissional e confira.");

            // Incrementa o índice
        i++;
      }
    } catch (e) {
      print('Erro ao buscar emails ou processar a solicitação: $e');
    }
  }
}

class DadosSolicitacaoCliente {
  String id;
  final String imagemPrincipalUrl;
  final String profissional;
  final String cidadeEstado;
  final String solicitacao;
  final String nome;
  final String data;
  final String whatsApp;

  DadosSolicitacaoCliente({
    this.id = '',
    required this.imagemPrincipalUrl,
    required this.profissional,
    required this.cidadeEstado,
    required this.solicitacao,
    required this.nome,
    required this.data,
    required this.whatsApp,
  });

  Map<String, dynamic> toJson() => {
        'Id': id,
        'ImagemPrincipalUrl': imagemPrincipalUrl,
        'Profissional': profissional,
        'CidadeEstado': cidadeEstado,
        'Solicitação': solicitacao,
        'Nome': nome,
        'Data': data,
        'WhatsAppContato': whatsApp,
      };

  static DadosSolicitacaoCliente fromJson(Map<String, dynamic> json) =>
      DadosSolicitacaoCliente(
        id: json["Id"] ?? '',
        profissional: json['Profissional'] ?? '',
        imagemPrincipalUrl: json['ImagemPrincipalUrl'] ?? '',
        cidadeEstado: json['CidadeEstado'] ?? '',
        solicitacao: json['Solicitação'] ?? '',
        nome: json['Nome'] ?? '',
        data: json['Data'] ?? '',
        whatsApp: json['WhatsAppContato'] ?? '',
      );
}
