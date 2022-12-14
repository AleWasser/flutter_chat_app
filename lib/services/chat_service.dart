import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:chat_app/global/environment.dart';
import 'package:chat_app/models/messages_response.dart';
import 'package:chat_app/models/user.dart';
import 'package:chat_app/services/auth_service.dart';

class ChatService with ChangeNotifier {
  late User targetUser;

  Future<List<Message>> loadMessages(String userId) async {
    final token = await AuthService.getToken();

    final url = Uri.parse('${Environment.apiUrl}/messages/$userId');
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'x-token': token!,
    });
    final messages = messagesResponseFromJson(response.body);

    return messages.messages;
  }
}
