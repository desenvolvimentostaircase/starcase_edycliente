import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../Cores/cores.dart';

class HomeTutoriais extends StatefulWidget {
  const HomeTutoriais({super.key});

  @override
  State<HomeTutoriais> createState() => _HomeTutoriaisState();
}

class _HomeTutoriaisState extends State<HomeTutoriais> {
  abrirURL(url) async {
    Uri whatsappUrl = Uri.parse("$url");

    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl);
    } else {
      throw 'Could not launch $whatsappUrl';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(25),
        child: ListView(
          children: [
            Row(
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
                  "Tutoriais",
                  style: GoogleFonts.roboto(
                    color: azul,
                    fontWeight: FontWeight.bold,
                    fontSize: 45,
                  ),
                ),
              ],
            ),
            Text(
              "Aqui ficam os tutoriais",
              style: GoogleFonts.roboto(
                color: cinzaEscuro,
                fontSize: 15,
              ),
            ),
            //
            SizedBox(
              height: 10,
            ),
            //
            Container(
              decoration: BoxDecoration(
                color: cinza,
                borderRadius: BorderRadius.circular(15),
              ),
              height: 100,
              width: 100,
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Text("Enviar solicitação para os profissionais"),
                  SizedBox(
                    height: 10,
                  ),
                  FilledButton.icon(
                    label: Text(
                      "Assista",
                      style: GoogleFonts.roboto(
                        color: cinzaClaro,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    icon: Icon(FontAwesomeIcons.youtube),
                    onPressed: () {
                      String url =
                          "https://www.youtube.com/watch?v=5xXqmvAKWdo&list=PLiHBXwlsXOYy1rSkdrsf49NjAHcyU9699";
                      abrirURL(url);
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
                ],
              ),
            ),
            //
            SizedBox(
              height: 10,
            ),
            //
            Container(
              decoration: BoxDecoration(
                color: cinza,
                borderRadius: BorderRadius.circular(15),
              ),
              height: 100,
              width: 100,
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Text("Como salvar contato de profissional"),
                  SizedBox(
                    height: 10,
                  ),
                  FilledButton.icon(
                    label: Text(
                      "Assista",
                      style: GoogleFonts.roboto(
                        color: cinzaClaro,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    icon: Icon(FontAwesomeIcons.youtube),
                    onPressed: () {
                      String url =
                          "https://www.youtube.com/watch?v=IuE-YDdyLi4&list=PLiHBXwlsXOYy1rSkdrsf49NjAHcyU9699&index=2";
                      abrirURL(url);
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
                ],
              ),
            ),
            //
            SizedBox(
              height: 10,
            ),
            //
            Container(
              decoration: BoxDecoration(
                color: cinza,
                borderRadius: BorderRadius.circular(15),
              ),
              height: 130,
              width: 100,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Buscar pelo profissional e ver o perfil dele no app",
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    FilledButton.icon(
                      label: Text(
                        "Assista",
                        style: GoogleFonts.roboto(
                          color: cinzaClaro,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      icon: Icon(FontAwesomeIcons.youtube),
                      onPressed: () {
                        String url =
                            "https://www.youtube.com/watch?v=AmAG9jqFXXY&list=PLiHBXwlsXOYy1rSkdrsf49NjAHcyU9699&index=4";
                        abrirURL(url);
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
                  ],
                ),
              ),
            ),
            //
          ],
        ),
      ),
    );
  }
}
