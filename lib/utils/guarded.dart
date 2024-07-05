import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pento_flutter/providers/auth.provider.dart';

class GuardedPage extends ConsumerWidget {
  final Widget child;

  const GuardedPage({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAuth = isAuthenticated(ref);

    if (!isAuth) {
      Future.microtask(() => Navigator.pushReplacementNamed(context, '/login'));
      return const SizedBox.shrink();
    }

    return child;
  }
}
