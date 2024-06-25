import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:pento_flutter/auth.provider.dart';

Future<void> submitForm(WidgetRef ref, Map<String, dynamic> formData) async {
  final token = ref.read(authTokenProvider);

  if (token == null) {
    throw Exception('No auth token found');
  }

  final formDataWithProductKey = {'product': formData};
  final response = await http.put(
    Uri.parse('http://localhost:4000/api/products/1'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode(formDataWithProductKey),
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to submit form');
  }
}
