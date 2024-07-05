import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:pento_flutter/providers/auth.provider.dart';

class Product {
  final String name;
  final String description;

  Product({required this.name, required this.description});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'],
      description: json['description'],
    );
  }
}

final productFormProvider =
    ChangeNotifierProvider((ref) => ProductFormNotifier());

class ProductFormNotifier extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  Product? _product;
  Product? get product => _product;

  Future<void> submitForm(WidgetRef ref, Map<String, dynamic> formData) async {
    final token = ref.read(authTokenProvider);

    if (token == null) {
      throw Exception('No auth token found');
    }

    _isLoading = true;
    notifyListeners();

    final response = await http.put(
      Uri.parse('http://localhost:4000/api/products/1'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(formData),
    );

    _isLoading = false;
    notifyListeners();

    if (response.statusCode != 200) {
      throw Exception('Failed to submit form');
    }
  }

  Future<void> fetchProduct(WidgetRef ref) async {
    final token = ref.read(authTokenProvider);

    if (token == null) {
      throw Exception('No auth token found');
    }

    _isLoading = true;
    notifyListeners();

    final response = await http.get(
      Uri.parse('http://localhost:4000/api/products/1'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      _isLoading = false;
      notifyListeners();
      throw Exception('Failed to fetch product');
    }

    final productJson = jsonDecode(response.body);
    _product = Product.fromJson(productJson["data"]);

    _isLoading = false;
    notifyListeners();
  }
}
