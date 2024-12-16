import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edywasacliente/Login/Home/HomePrincipal/NosIndiqueProfissionais/nos_indique_profissionais.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../AppBar/Custom_AppBarDrawer.dart';
import 'HomeListaContatos/Buscar/buscar.dart';
import 'HomeListaContatos/primeiraBusca/salvarContato/salvar_contato.dart';
import 'HomePerfil/home_perfil.dart';
import 'HomeSolicitacao/home_solicitacao.dart';
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
   final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String? _userName; // Variável para armazenar o nome do usuário

   @override
  void initState() {
    super.initState();
    _getUserDetails(); // Carrega o nome do usuário ao inicializar o estado
  }

   Future<void> _getUserDetails() async {
    try {
      final User? user = _firebaseAuth.currentUser;
      if (user != null) {
        setState(() {
          _userName = user.displayName ?? user.email?.split('@')[0] ?? 'Usuário'; // Primeiro tenta obter o nome do displayName, depois tenta usar o primeiro nome do e-mail
        });
      } else {
        setState(() {
          _userName = 'Usuário não encontrado';
        });
      }
    } catch (e) {
      setState(() {
        _userName = 'Erro ao carregar usuário';
      });
      debugPrint('Erro ao obter detalhes do usuário: $e');
    }
  }

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
  final TextEditingController _cidadeEstadoTextEditingController =
      TextEditingController();

  List<String> listItemsCidadeEstado = <String>[
    "Três Lagoas - MS",
    "Andradina - SP",
    "Ilha Solteira - SP",
    "Castilho - SP",
    "Tupã - SP",
  ];

  String cidadeEstadoSelecionado = "";

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context),
      drawer: customDrawer(context),
      backgroundColor: cinzaClaro,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 25,
                right: 25,
                top: 25,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  //Exibir nome do usuário
                  Text(
                     'Olá, $_userName!', // Nome do usuário
                    style: GoogleFonts.roboto(
                      color: azul,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  FilledButton.icon(
                    label: Text(
                      "Perfil",
                      style: GoogleFonts.roboto(
                        color: cinzaEscuro,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    icon: Icon(
                      Icons.person,
                      color: cinzaEscuro,
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const HomePerfil(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.only(
                          left: 20, top: 10, right: 20, bottom: 10),
                      backgroundColor: cinza,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 10,
            ),

            //Lista de contato
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: ListTile(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const Buscar(),
                    ),
                  );
                },
                title: Text(
                  "Lista de contatos",
                  style: GoogleFonts.roboto(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Column(
                  children: [
                    const Text(
                      "Agora você pode pesquisar por diversos contatos em nosso app",
                    ),
                    const SizedBox(height: 10,),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: FilledButton.icon(
                      label: Text(
                        "Contatos salvos ",
                        style: GoogleFonts.roboto(
                          color: cinzaEscuro,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      icon: Icon(
                        Icons.contact_phone_rounded,
                        color: cinzaEscuro,
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const ContatosSalvos(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.only(
                            left: 20, top: 10, right: 20, bottom: 10),
                        backgroundColor: cinza,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                                        ),
                    ),
                  ],
                ),
                trailing: const Icon(
                  Icons.navigate_next_rounded,
                ),
              ),
            ),

            const Divider(),
            //Solicitações

            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: ListTile(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const HomeSolicitacao(),
                    ),
                  );
                },
                title: Text(
                  "Solicitações",
                  style: GoogleFonts.roboto(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: const Text(
                    "Temos uma aba dedicada para o envio de solicitações a profissionais "),
                trailing: const Icon(
                  Icons.navigate_next_rounded,
                ),
              ),
            ),
            const Divider(),
            //Divulgue o seu empreendimento
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: ListTile(
                onTap: () {
                  ///pagina explicando o que é o aplicativo Staircase Profissional
                },
                title: Text(
                  "Divulgue o seu empreendimento!!!",
                  style: GoogleFonts.roboto(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: const Text(
                    "Entrando em uma lista de contatos gratuitamente é possivel que o cliente possa te procurar facilmente. O Staircase Profissiional não para por ai, venha nos conhecer"),
                trailing: const Icon(
                  Icons.navigate_next_rounded,
                ),
              ),
            ),
            const Divider(),
            //Nos indique profissionais
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: ListTile(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const NosIndiqueProfissionais(),
                    ),
                  );
                },
                title: Text(
                  "Nos indique profissionais",
                  style: GoogleFonts.roboto(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: const Text(
                    "Se você conhece alguem que seja profissional ou tenha uma empresa de serviços, nos indique"),
                trailing: const Icon(
                  Icons.navigate_next_rounded,
                ),
              ),
            ),
            const Divider(),
            //
            //Suporte
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: ListTile(
                onTap: () {
                  abrirWhatsApp();
                },
                title: Text(
                  "Suporte",
                  style: GoogleFonts.roboto(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle:
                    const Text("Está com dificuldade em algo? entre em contato"),
                trailing: const Icon(
                  Icons.navigate_next_rounded,
                ),
              ),
            ),
            const Divider()
          ],
        ),
      ),
    );
  }

  //
  Future popupEnviarIndiKaiMensagem(context, cidadeEstadoSelecionado) =>
      showDialog(
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
          content: SizedBox(
            height: MediaQuery.sizeOf(context).width * 0.8,
            width: MediaQuery.sizeOf(context).width * 0.9,
            child: Form(
              key: formKey,
              child: ListView(
                children: [
                  const Text(
                      "na mensagem escreva o numero de contato e o que o profissional realiza como atividade"),
                  const SizedBox(
                    height: 30,
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
                            icon: const Icon(
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
                      cidadeEstadoSelecionado = value.toString();
                    },
                    onSuggestionSelected: (suggestion) {
                      setState(() {
                        cidadeEstadoSelecionado = suggestion;
                        _cidadeEstadoTextEditingController.text = suggestion;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 25,
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
                  const SizedBox(
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

                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            ///Voltar
            ElevatedButton(
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
              child: Text(
                "Voltar",
                style: GoogleFonts.roboto(
                  color: azul,
                ),
              ),
            ),

            ///Confirmar
            FilledButton(
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
                    'Data': dataFormatada,
                    'CidadeEstado': cidadeEstadoSelecionado
                  }, SetOptions(merge: true));

                  //Passar a pagina
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: const Duration(seconds: 5),
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
              child: const Text(
                "Enviar",
              ),
            ),
          ],
        ),
      );
}
