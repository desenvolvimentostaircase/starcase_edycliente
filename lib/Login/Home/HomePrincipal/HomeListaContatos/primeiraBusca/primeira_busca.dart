import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edywasacliente/Cores/cores.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../ads/ads.dart';
import '../Buscar/buscar.dart' as soli;
import 'perfil_profissional_sub.dart';
import 'salvarContato/salvar_contato.dart';

class PrimeiraBusca extends StatefulWidget {
  final String cidadeEstadoAux;
  final String profissionalAux;

  const PrimeiraBusca(this.cidadeEstadoAux, this.profissionalAux, {Key? key})
      : super(key: key);

  @override
  State<PrimeiraBusca> createState() => _PrimeiraBuscaState();
}

abrirWhatsApp(whatsAppContato, nomeContato) async {
  Uri whatsappUrl = Uri.parse(
      "whatsapp://send?phone=+55$whatsAppContato&text=Olá $nomeContato, venho da Staircase gostaria de saber se você está disponível para serviço?");

  if (await canLaunchUrl(whatsappUrl)) {
    await launchUrl(whatsappUrl);
  } else {
    throw 'Could not launch $whatsappUrl';
  }
}

Stream<List<soli.BuscarDadosGeral>> leiaBuscasProfissionais(
  profissional,
  cidadeEstado,
) =>
    FirebaseFirestore.instance
        .collection("Busca Geral")
        .doc(profissional)
        .collection(cidadeEstado)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => soli.BuscarDadosGeral.fromJson(doc.data()))
            .toList());

class _PrimeiraBuscaState extends State<PrimeiraBusca> {
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: cinzaClaro,
        body: ListView(
          children: [
            //
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
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
                    "Buscas",
                    style: GoogleFonts.roboto(
                      color: azul,
                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Text(
                "Encontre os profissionais para o seu serviço",
                style: GoogleFonts.roboto(
                  color: cinzaEscuro,
                  fontSize: 15,
                ),
              ),
            ),
            getAd(),

            //CidadeEstado e Profissional
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    30,
                  ),
                  color: cinza,
                ),
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8, bottom: 8, top: 8),
                  child: ListTile(
                    subtitle: Text(
                      widget.cidadeEstadoAux,
                      style: GoogleFonts.roboto(
                        color: cinzaEscuro,
                        fontSize: 16,
                      ),
                    ),
                    title: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        widget.profissionalAux,
                        style: GoogleFonts.roboto(
                          color: cinzaEscuro,
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            //

            SizedBox(
              height: 15,
            ),
            //
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.38,
                width: MediaQuery.of(context).size.width,
                child: StreamBuilder<List<soli.BuscarDadosGeral>>(
                  stream: leiaBuscasProfissionais(
                    widget.profissionalAux,
                    widget.cidadeEstadoAux,
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text("Something went wong! ${snapshot.error}");
                    } else if (snapshot.hasData) {
                      final leiaBuscar = snapshot.data!;
                      return ListView.builder(
                          itemCount: leiaBuscar.length,
                          itemBuilder: (context, index) {
                            final buscar = leiaBuscar[index];
                            return columnSolicitacao(buscar,
                                widget.profissionalAux, widget.cidadeEstadoAux);
                          });
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
            ),
            getAd(),
            //
          ],
        ),
      );

  Widget columnSolicitacao(buscar, profissional, cidadeEstado) => ListTile(
      trailing: IconButton(
        icon: Icon(Icons.bookmark_add_outlined),
        color: azul,
        onPressed: () {
          popupSalvarContato(
              buscar.whatsAppContato, buscar.nome, profissional, cidadeEstado);
        },
      ),
      leading: buscar.imagemPrincipalUrl.isNotEmpty
          ? Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  buscar.imagemPrincipalUrl,
                  fit: BoxFit.cover,
                ),
              ),
              height: 60,
              width: 60,
            )
          : SizedBox(),
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
      subtitle: buscar.imagemPrincipalUrl.isNotEmpty
          ? Row(
              children: [

buscar.cnpj != "" ?

                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10), color: cinza),
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Text(
                      
                      "CNPJ",
                    ),
                  ),
                ):

                SizedBox(),
                SizedBox(
                  width: 10,
                ),

                buscar.emiteNotaFiscal == "Sim" ?
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10), color: cinza),
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Text(
                      "Emite nota fiscal",
                    ),
                  ),
                ):SizedBox(),
              ],
            )
          : Text(
              "${buscar.whatsAppContato}",
              style: GoogleFonts.roboto(
                color: cinzaEscuro,
                fontSize: 14,
              ),
            ),
      onTap: buscar.email.isNotEmpty
          ? () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => PerfilProfissional(buscar.email,
                      ),
                ),
              );
            }
          : () {
              abrirWhatsApp(
                buscar.whatsAppContato,
                buscar.nome,
              );
            });

  Future popupSalvarContato(
          whatsAppContato, nome, profissional, cidadeEstado) =>
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: cinzaClaro,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text(
            "Salvar contato?",
            textAlign: TextAlign.center,
            style: GoogleFonts.roboto(
              fontSize: 25,
              color: azul,
              fontWeight: FontWeight.bold,
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton(
              onPressed: () {
                final salvarContato = SalvarContato(
                  nome: nome,
                  whatsAppContato: whatsAppContato,
                  cidadeEstadoSelecionada: cidadeEstado,
                  profissionalSelecionada: profissional,
                );
                createSalvarContato(salvarContato);
                Navigator.pop(context);
                final snackBar = SnackBar(
                  backgroundColor: azul,
                  content: Text('Contato salvo com sucesso'),
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
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 10, bottom: 10),
                backgroundColor: azul,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
            //
            ElevatedButton(
              onPressed: () {},
              child: Text(
                "Não",
                style: GoogleFonts.roboto(
                  color: cinzaClaro,
                  fontSize: 20,
                ),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 10, bottom: 10),
                backgroundColor: azul,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
          ],
        ),
      );
}
