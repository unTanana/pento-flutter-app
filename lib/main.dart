import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pento_flutter/providers/auth.provider.dart';
import 'package:pento_flutter/utils/guarded.dart';
import 'package:pento_flutter/screens/login.dart';
import 'package:pento_flutter/screens/product.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      home: isAuthenticated(ref) ? const ProductFormPage() : LoginPage(),
      routes: {
        '/login': (context) => LoginPage(),
        '/form': (context) => const GuardedPage(child: ProductFormPage()),
      },
    );
  }
}
