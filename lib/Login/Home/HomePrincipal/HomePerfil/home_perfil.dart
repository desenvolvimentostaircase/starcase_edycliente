import 'dart:ffi';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edywasacliente/Cores/cores.dart';
import 'package:edywasacliente/checagem_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePerfil extends StatefulWidget {
  const HomePerfil({super.key});

  @override
  State<HomePerfil> createState() => _HomePerfilState();
}

class _HomePerfilState extends State<HomePerfil> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
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
              SizedBox(height: 20),
            _buildUploadStatus(),
            SizedBox(height: 20),
            FilledButton.icon(
              label: Text("Alterar Imagem"),
              onPressed: _pickImage,
              icon: Icon(Icons.add_photo_alternate),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 10, bottom: 10),
                backgroundColor: azul,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
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

  // Imagem
  File? _image;
  String? _downloadUrl;
  double _uploadProgress = 0;

  @override
  void initState() {
    super.initState();
    _loadImageUrl();
  }

  Future<void> _loadImageUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _downloadUrl = prefs.getString('image_url');
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File file = File(pickedFile.path);

       if (file.lengthSync() <= 500 * 1024) { // 500KB em bytes
        print("object : ${file.length()}");
        // 3MB em bytes
        setState(() {
          _image = file;
        });

        _uploadImage();
      } else {
        _showSizeError();
      }
    }
  }

  Future<void> _uploadImage() async {
    if (_image == null) return;

    FirebaseStorage storage = FirebaseStorage.instance;
    if (_downloadUrl != null) {
      // Deletar a imagem anterior
      try {
        await storage.refFromURL(_downloadUrl!).delete();
      } catch (e) {
        print("Erro ao deletar a imagem anterior: $e");
      }
    }

    String fileName = 'imagem_principal.png';
    Reference ref =
        storage.ref().child("cliente/$UID/perfil/dados/$fileName");
    UploadTask uploadTask = ref.putFile(_image!);

    // Monitorar o progresso do upload
    uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
      setState(() {
        _uploadProgress = snapshot.bytesTransferred.toDouble() /
            snapshot.totalBytes.toDouble();
      });
    });

    uploadTask.whenComplete(() async {
      String newDownloadUrl = await ref.getDownloadURL();
      print("Image URL: $newDownloadUrl");

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('image_url', newDownloadUrl);

      setState(() {
        _downloadUrl = newDownloadUrl;
        _image = null; // Clear the local file to use the URL instead
        _uploadProgress = 0; // Reset the progress bar
      });

      //armazenar url image no banco de dados
      await _firestore
          .collection('Cliente')
          .doc(UID)
          .collection('Perfil')
          .doc('Dados')
          .set({
        'ImagemPrincipalUrl': newDownloadUrl,
      }, SetOptions(merge: true));

      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('Cliente')
          .doc(UID)
          .collection('Perfil')
          .doc('Dados')
          .get();

      String email = doc['Email'];

      await _firestore
          .collection('Perfil Geral')
          .doc('Profissional')
          .collection(email)
          .doc('Perfil')
          .set({
        'ImagemPrincipalUrl': newDownloadUrl,
      }, SetOptions(merge: true));
      //
      
    });
  }

  void _showSizeError() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Erro"),
          content:
              Text("A imagem selecionada é muito grande. O limite é de 500 kB.\n\n Se o erro persistir entre em contato com o suporte"),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildUploadStatus() {
    return _image == null && _downloadUrl != null
        ? Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                _downloadUrl!,
                fit: BoxFit.cover,
              ),
            ),
            height: MediaQuery.sizeOf(context).width * 0.4,
            width: MediaQuery.sizeOf(context).width * 0.4,
          )
        : _image != null
            ? Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.file(
                        _image!,
                        fit: BoxFit.cover,
                      ),
                    ),
                    height: MediaQuery.sizeOf(context).width * 0.4,
                    width: MediaQuery.sizeOf(context).width * 0.4,
                  ),
                  SizedBox(height: 10),
                  _uploadProgress > 0
                      ? LinearProgressIndicator(value: _uploadProgress)
                      : Container(),
                ],
              )
            : Text(
                'Perfil sem imagem',
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
