import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../Cores/cores.dart';

class DoacaoNosAjude extends StatefulWidget {
  const DoacaoNosAjude({super.key});

  @override
  State<DoacaoNosAjude> createState() => _DoacaoNosAjudeState();
}

class _DoacaoNosAjudeState extends State<DoacaoNosAjude> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  "Doação",
                  style: GoogleFonts.roboto(
                    color: azul,
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                  ),
                ),
              ],
            ),

            SizedBox(
              height: 10,
            ),
            //Nos ajude
            Container(
              decoration: BoxDecoration(
                color: cinza,
                borderRadius: BorderRadius.circular(15),
              ),
              height: 150,
              width: 100,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Para nos ajudar nesse projeto, doe qualquer valor\n Pix: 12122-12121212-211",
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    FilledButton.icon(
                      label: Text(
                        "Copiar chave",
                        style: GoogleFonts.roboto(
                          color: cinzaClaro,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      icon: Icon(Icons.copy),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => const DoacaoNosAjude()),
                        );
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
          ],
        ),
      ),
    );
  }
}
