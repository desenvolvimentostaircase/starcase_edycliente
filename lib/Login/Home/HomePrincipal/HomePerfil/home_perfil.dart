import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edywasacliente/Cores/cores.dart';
import 'package:edywasacliente/checagem_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePerfil extends StatefulWidget {
  const HomePerfil({super.key});

  @override
  State<HomePerfil> createState() => _HomePerfilState();
}

class _HomePerfilState extends State<HomePerfil> {
  final _firebaseAuth = FirebaseAuth.instance;

  Widget ListTileBuscar(PerfilDados perfilDados) => 
      
      Column(
        children: [
          Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: cinza,
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 5, top: 5, bottom: 5),
                child: ListTile(
                  title: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  "${perfilDados.nome}",
                  style: GoogleFonts.roboto(
                    color: cinzaEscuro,
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
                  trailing: Icon(Icons.edit,color: azul,),
                )
              ),
            
          ),
          SizedBox(height: 10,),
          Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: cinza,
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 5, top: 5, bottom: 5),
                child: ListTile(
                  title: Text(
                    "${perfilDados.whatsAppContato}",
                    style: GoogleFonts.roboto(
                      color: cinzaEscuro,
                      fontSize: 21,
                     
                    ),
                  ),
                  trailing: Icon(Icons.edit,color: azul,),
                )
              ),
            
          ),
        ],
      );

      

 String UID = FirebaseAuth.instance.currentUser!.uid.toString();
  /// Le o conteudo local
  Stream<List<PerfilDados>> leiaBuscar() => FirebaseFirestore.instance
      .collection('Cliente')
      .doc(UID)
      .collection("Perfil")
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => PerfilDados.fromJson(doc.data()))
          .toList());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cinzaClaro,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: ListView(
            children: [
              Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
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
                  SizedBox(width: 10,),
                    Text(
                      "Perfil",
                      style: GoogleFonts.roboto(
                        color: azul,
                        fontWeight: FontWeight.bold,
                        fontSize: 45,
                      ),
                    ),
                  ],
                ),

                ///

                FilledButton.icon(
                  label: Text(
                    "Sair",
                    style: GoogleFonts.roboto(
                      color: cinzaClaro,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  icon: Icon(Icons.logout),
                  onPressed: () async {
                    await _firebaseAuth.signOut().then(
                          (solicitacao) => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ChecagemPage(),
                            ),
                          ),
                        );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.only(
                        left: 20, top: 10, right: 20, bottom: 10),
                    backgroundColor: vermelho,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                )
              ],
            ),
              Text(
                "Aqui é onde ficam os seus dados de perfil no app",
                style: GoogleFonts.roboto(
                  color: cinzaEscuro,
                  fontSize: 15,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              CircleAvatar(
                child: Icon(
                  Icons.add_a_photo,
                  size: 32,
                ),
                radius: MediaQuery.of(context).size.width * 0.20,
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                color: cinzaClaro,
                height: MediaQuery.of(context).size.height * 0.3,
                child: StreamBuilder<List<PerfilDados>>(
                  stream: leiaBuscar(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text("Something went wong! ${snapshot.error}");
                    } else if (snapshot.hasData) {
                      final leiaBuscar = snapshot.data!;
                      return ListView.builder(
                        itemCount: leiaBuscar.length,
                        itemBuilder: (context, index) {
                          final buscar = leiaBuscar[index];

                          return ListTileBuscar(buscar);
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
      ),
    );
  }
}

//dados internos
class PerfilDados {
  String id;
  String idGeral;
  final String nome;
  final String whatsAppContato;
  final String email;
  final String imagemPrincipalUrl;
  final String instagram;

  PerfilDados({
    this.id = '',
    this.idGeral = '',
    required this.nome,
    required this.whatsAppContato,
    required this.email,
    this.imagemPrincipalUrl = '',
    this.instagram = '',
   
  });

  Map<String, dynamic> toJson() => {
        'Id': id,
        'IdGeral': idGeral,
        'Nome': nome,
        'WhatsAppContato': whatsAppContato,
        'Email': email,
        'ImagemPrincipalUrl': imagemPrincipalUrl,
        'Instagram': instagram,
      };

  static PerfilDados fromJson(Map<String, dynamic> json) =>
      PerfilDados(
        id: json["Id"] ?? '',
        idGeral: json["IdGeral"] ?? '',
        nome: json['Nome'] ?? '',
        whatsAppContato: json['WhatsAppContato'] ?? '',
        email: json['Email'] ?? '',
        imagemPrincipalUrl: json['ImagemPrincipalUrl'] ?? '',
        instagram: json['Instagram'] ?? '',
      );
}
