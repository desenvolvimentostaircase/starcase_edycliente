import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edywasacliente/Cores/cores.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePerfil extends StatefulWidget {
  const HomePerfil({super.key});

  @override
  State<HomePerfil> createState() => _HomePerfilState();
}

class _HomePerfilState extends State<HomePerfil> {

  Widget ListTileBuscar(BuscarDadosGeral buscar) => 
      
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
                  "${buscar.nome}",
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
                    "${buscar.whatsAppContato}",
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
  Stream<List<BuscarDadosGeral>> leiaBuscar() => FirebaseFirestore.instance
      .collection('Cliente')
      .doc(UID)
      .collection("Perfil")
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => BuscarDadosGeral.fromJson(doc.data()))
          .toList());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cinzaClaro,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(35),
          child: ListView(
            children: [
              Text(
                "Perfil",
                style: GoogleFonts.roboto(
                  color: azul,
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                ),
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
                child: StreamBuilder<List<BuscarDadosGeral>>(
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

//Informações do cliente
class BuscarDadosGeral {
  String id;
  String idGeral;
  final String nome;
  final String whatsAppContato;

  BuscarDadosGeral({
    this.id = '',
    this.idGeral = '',
    required this.nome,
    required this.whatsAppContato,
  });

  Map<String, dynamic> toJson() => {
        'Id': id,
        'IdGeral': idGeral,
        'Nome': nome,
        'WhatsAppContato': whatsAppContato,
      };

  static BuscarDadosGeral fromJson(Map<String, dynamic> json) =>
      BuscarDadosGeral(
        id: json["Id"] ?? '',
        idGeral: json["IdGeral"] ?? '',
        nome: json['Nome'] ?? '',
        whatsAppContato: json['WhatsAppContato'] ?? '',
      );
}
