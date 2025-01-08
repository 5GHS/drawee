import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drawee/presentation/viewmodels/user_viewmodel.dart';

class UserScreen extends ConsumerWidget {
  ProviderListenable? get userProvider => null;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider!);

    return Scaffold(
      appBar: AppBar(title: Text('User Profile')),
      body: user == null
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Text('Name: ${user.name}'),
                Image.network(user.imgUrl),
              ],
            ),
    );
  }
}