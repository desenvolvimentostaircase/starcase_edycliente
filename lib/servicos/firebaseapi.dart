import 'package:http/http.dart' as http;
import 'dart:convert';

class NotificationService {
  // Substitua pela chave do servidor correta
  final String serverToken = 'BNq_Xpi5wXzR54BY1k4sED3W_lzX7CBLUYJZOk3Sh0lVSYjmrIUp4QwOc9DMtXbJDBHtQy3auG5mXzcUpNSpZ9k'; // Chave do servidor

  Future<void> sendNotification(String token, String title, String body) async {
    try {
      final response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverToken', // Certifique-se de que está usando a chave do servidor
        },
        body: jsonEncode(<String, dynamic>{
          'to': token,
          'notification': <String, dynamic>{
            'title': title,
            'body': body,
          },
        }),
      );

      if (response.statusCode == 200) {
        print('Notificação enviada com sucesso!');
      } else {
        print('Erro ao enviar notificação: ${response.statusCode}');
        print('Resposta do servidor: ${response.body}');
      }
    } catch (e) {
      print('Exceção ao enviar notificação: $e');
    }
  }
}
