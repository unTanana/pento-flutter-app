import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pento_flutter/auth.provider.dart';
import 'package:pento_flutter/guarded.dart';
import 'package:pento_flutter/product_form.provider.dart';

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

class LoginPage extends ConsumerWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await login(
                      ref, emailController.text, passwordController.text);
                  Navigator.pushReplacementNamed(context, '/form');
                } catch (e) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(e.toString())));
                }
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductFormPage extends ConsumerStatefulWidget {
  const ProductFormPage({super.key});

  @override
  _ProductFormPageState createState() => _ProductFormPageState();
}

class _ProductFormPageState extends ConsumerState<ProductFormPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _fetchProduct());
  }

  Future<void> _fetchProduct() async {
    try {
      await ref.read(productFormProvider).fetchProduct(ref);
      final product = ref.read(productFormProvider).product;
      if (product != null) {
        _nameController.text = product.name;
        _descriptionController.text = product.description;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load product')));
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final productFormNotifier = ref.watch(productFormProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Submit Form')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (productFormNotifier.isLoading) {
                  return;
                }
                try {
                  final formData = {
                    'product': {
                      'name': _nameController.text,
                      'description': _descriptionController.text,
                    }
                  };
                  await productFormNotifier.submitForm(ref, formData);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Form submitted successfully')));
                } catch (e) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(e.toString())));
                }
              },
              child: productFormNotifier.isLoading
                  ? const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    )
                  : const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
