
   import 'package:cloud_firestore/cloud_firestore.dart';
   import 'package:firebase_auth/firebase_auth.dart';
   

//Função para buscar primeiro nome do usuário no banco e apresentar na tela principal
Future<String> carregarNomeUsuario() async {
  try {
    final String uid = FirebaseAuth.instance.currentUser!.uid;
    final DocumentSnapshot<Map<String, dynamic>> docSnapshot = await FirebaseFirestore.instance
        .collection('Cliente') // Nome da coleção
        .doc(uid)
        .collection('Perfil') // Subcoleção correta
        .doc('Dados') // ID do documento correto
        .get();

    if (docSnapshot.exists) {
      final String nomeCompleto = docSnapshot.data()?['Nome'] ?? 'Usuário';
      final String primeiroNome = nomeCompleto.split(' ')[0]; // Pega apenas o primeiro nome
      return primeiroNome;
    } else {
      return 'Usuário não encontrado';
    }
  } catch (e) {
    print('Erro ao buscar o nome: $e');
    return 'Erro ao buscar o nome';
  }
}
