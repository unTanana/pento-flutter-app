import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// A provider that holds the auth token
final authTokenProvider = StateProvider<String?>((ref) => null);

// A function to perform the login
Future<void> login(WidgetRef ref, String email, String password) async {
  final response = await http.post(
    Uri.parse('http://localhost:4000/api/login'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'email': email,
      'password': password,
    }),
  );

  if (response.statusCode == 200) {
    final responseData = jsonDecode(response.body);
    final token = responseData['token'];

    // Update the auth token
    ref.read(authTokenProvider.notifier).state = token;
  } else {
    throw Exception('Failed to login');
  }
}

// A function to check if the user is authenticated
bool isAuthenticated(WidgetRef ref) {
  final token = ref.read(authTokenProvider);
  return token != null;
}
