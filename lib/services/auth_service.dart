import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class AuthService {
  // ⚠️ 10.0.2.2 សម្រាប់ Android Emulator, localhost សម្រាប់ iOS/Web
  static const String baseUrl = 'http://localhost:5000/api';

  Future<AuthResult> register(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      // 🔍 Print មើលក្នុង Debug Console
      print('REGISTER STATUS CODE: ${response.statusCode}');
      print('REGISTER BODY: ${response.body}');

      if (response.body.isEmpty) {
        return AuthResult(
          success: false,
          message: 'Server មិនបានឆ្លើយតបទិន្នន័យមកវិញទេ! (Status: ${response.statusCode})',
        );
      }

      final data = jsonDecode(response.body);

      // ⚠️ ត្រូវប្រាកដថា status code ត្រូវនឹងអ្វីដែល backend ផ្ញើមក (201 ឬ 200)
      if ((response.statusCode == 201 || response.statusCode == 200) && data['success'] == true) {
        return AuthResult(
          success: true,
          message: data['message'] ?? 'Register successful',
          user: UserModel.fromJson(data['user']),
          token: data['token'],
        );
      } else {
        return AuthResult(
          success: false,
          message: data['message'] ?? 'Register failed',
        );
      }
    } catch (e) {
      print('REGISTER ERROR: $e');
      return AuthResult(
        success: false,
        message: 'មិនអាចភ្ជាប់ទៅកាន់ Server បានទេ: $e',
      );
    }
  }

  // 1. App/Method Login (ត្រូវប្រាកដថាឈ្មោះ login សរសេរជាអក្សរតូច)
  Future<AuthResult> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.body.isEmpty) {
        return AuthResult(
          success: false,
          message: 'Server មិនបានឆ្លើយតបទិន្នន័យមកវិញទេ!',
        );
      }

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        return AuthResult(
          success: true,
          message: data['message'] ?? 'Login successful',
          user: UserModel.fromJson(data['user']),
          token: data['token'],
        );
      } else {
        return AuthResult(
          success: false,
          message: data['message'] ?? 'Login failed',
        );
      }
    } catch (e) {
      return AuthResult(
        success: false,
        message: 'មិនអាចភ្ជាប់ទៅកាន់ Server បានទេ: $e',
      );
    }
  }
}