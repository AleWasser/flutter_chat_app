import 'package:http/http.dart' as http;

import 'package:chat_app/global/environment.dart';
import 'package:chat_app/models/user.dart';
import 'package:chat_app/models/user_response.dart';
import 'package:chat_app/services/auth_service.dart';

class UsersService {
  Future<List<User>> getUsers() async {
    try {
      final url = Uri.parse('${Environment.apiUrl}/users');
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'x-token': await AuthService.getToken() ?? ''
      });

      final usersResponse = usersResponseFromJson(response.body);

      return usersResponse.users;
    } catch (e) {
      return [];
    }
  }
}
