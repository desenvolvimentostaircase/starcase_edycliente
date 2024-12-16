import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../../../Cores/cores.dart';

class NosIndiqueProfissionais extends StatefulWidget {
  const NosIndiqueProfissionais({super.key});

  @override
  State<NosIndiqueProfissionais> createState() =>
      _NosIndiqueProfissionaisState();
}

class _NosIndiqueProfissionaisState extends State<NosIndiqueProfissionais> {
  final formKey = GlobalKey<FormState>();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _cidadeEstadoTextEditingController =
      TextEditingController();
  final TextEditingController _whatsAppContatoTextEditingController =
      TextEditingController();
  final TextEditingController _oQueFazTextEditingController =
      TextEditingController();

  List<String> listCidadeEstado = <String>[
    "Três Lagoas - MS",
    "Andradina - SP",
    "Ilha Solteira - SP",
    "Castilho - SP",
    "Tupã - SP",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formKey,
        child: ListView(
          children: [
            SizedBox(
              height: 25,
            ),
            Row(
              children: [
                SizedBox(
                  width: 25,
                ),
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
                  "Nos indique profissionais",
                  style: GoogleFonts.roboto(
                    color: cinzaEscuro,
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
              ],
            ),
            //
            SizedBox(
              height: 15,
            ),
            //
            Padding(
              padding: const EdgeInsets.only(left: 25, right: 25),
              child: TypeAheadFormField<String>(
                textFieldConfiguration: TextFieldConfiguration(
                  controller: _cidadeEstadoTextEditingController,
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
                      hintText: "Cidade"),
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      !listCidadeEstado.contains(value)) {
                    return 'Selecione uma cidade';
                  }
                  return null;
                },
                suggestionsCallback: (pattern) {
                  return listCidadeEstado.where((option) =>
                      option.toLowerCase().contains(pattern.toLowerCase()));
                },
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    title: Text(suggestion),
                  );
                },
                onSuggestionSelected: (suggestion) {
                  setState(() {
                    _cidadeEstadoTextEditingController.text = suggestion;
                  });
                },
              ),
            ),
            SizedBox(
              height: 15,
            ),
            //Telefone

            Padding(
              padding: const EdgeInsets.only(left: 25, right: 25),
              child: TextFormField(
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
                  hintText: "Telefone",
                  hintStyle: GoogleFonts.roboto(
                    color: cinzaEscuro.withOpacity(0.6),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Preencha o campo';
                  } else if (value.length != 11) {
                    return 'Telefone contém 11 digitos';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(
              height: 15,
            ),
            //o que faz?
            Padding(
              padding: const EdgeInsets.only(left: 25, right: 25),
              child: TextFormField(
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
            ),
            SizedBox(
              height: 10,
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
          "Enviar",
          style: GoogleFonts.roboto(
            fontSize: 20,
            color: cinzaClaro,
          ),
        ),
        icon: Icon(
          Icons.send,
          color: cinzaClaro,
        ),
        onPressed: () async {
          final isValidForm = formKey.currentState!.validate();
          if (isValidForm) {
            //Adicionar no app Administrador
            final docRef = _firestore
                .collection('Administrador')
                .doc('Indikai')
                .collection('Contatos')
                .doc();

            final id = docRef.id;

            //data atual
            final DateTime now = DateTime.now();
            final DateFormat formatter = DateFormat('dd/MM/yyyy');
            final String dataFormatada = formatter.format(now);

            await docRef.set({
              'OQueFaz': _oQueFazTextEditingController.text,
              'WhatsAppContato': _whatsAppContatoTextEditingController.text,
              'Id': id,
              'Data': dataFormatada,
            }, SetOptions(merge: true));
          }
        },
      ),
    );
  }
}
