import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:chat_app/models/user.dart';
import 'package:chat_app/global/environment.dart';
import 'package:chat_app/models/login_response.dart';

class AuthService with ChangeNotifier {
  late User user;
  bool _isAuthenticating = false;
  final _storage = const FlutterSecureStorage();

  bool get isAuthenticating => _isAuthenticating;
  set isAuthenticating(bool value) {
    _isAuthenticating = value;
    notifyListeners();
  }

  static Future<String?> getToken() async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');
    return token;
  }

  static Future<void> deleteToken() async {
    const storage = FlutterSecureStorage();
    await storage.delete(key: 'token');
  }

  Future<bool> login(String email, String password) async {
    isAuthenticating = true;
    final data = {'email': email, 'password': password};
    final url = Uri.parse('${Environment.apiUrl}/login');
    final response = await http.post(url,
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      final loginResponse = loginResponseFromJson(response.body);
      user = loginResponse.user;
      isAuthenticating = false;
      await _saveToken(loginResponse.token);

      return true;
    }

    isAuthenticating = false;
    return false;
  }

  Future register(String name, String email, String password) async {
    isAuthenticating = true;
    final data = {'name': name, 'email': email, 'password': password};
    final url = Uri.parse('${Environment.apiUrl}/login/new');
    final response = await http.post(url,
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      final jsonResponse = loginResponseFromJson(response.body);
      user = jsonResponse.user;
      isAuthenticating = false;
      await _saveToken(jsonResponse.token);

      return true;
    }

    isAuthenticating = false;
    final responseBody = jsonDecode(response.body);
    return responseBody['msg'];
  }

  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: 'token');
    if (token == null) return false;

    final url = Uri.parse('${Environment.apiUrl}/login/renew');

    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'x-token': token,
    });

    if (response.statusCode == 200) {
      final jsonResponse = loginResponseFromJson(response.body);
      user = jsonResponse.user;
      await _saveToken(jsonResponse.token);

      return true;
    }

    _deleteToken(token);
    return false;
  }

  Future _saveToken(String token) async {
    return await _storage.write(key: 'token', value: token);
  }

  Future _deleteToken(String token) async {
    return await _storage.delete(key: 'token');
  }
}
