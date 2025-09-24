import 'dart:async';

import 'package:dompet/features/auth/data/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserProvider extends AsyncNotifier<User?> {
  @override
  FutureOr<User?> build() {
    final user = FirebaseAuth.instance.currentUser;
    return user;
  }

  Future<void> signIn() async {
    final repositoru = ref.read(authRepositoryProvider);
    state = const AsyncValue.loading();
    final user = await repositoru.signIn();
    state = AsyncValue.data(user);
  }

  Future<void> signOut() async {
    final repositoru = ref.read(authRepositoryProvider);
    try {
      await repositoru.signOut();
    } catch (e) {
      debugPrint('error $e');
    } finally {
      state = const AsyncValue.data(null);
    }
  }
}

final userProvider =
    AsyncNotifierProvider<UserProvider, User?>(UserProvider.new);
