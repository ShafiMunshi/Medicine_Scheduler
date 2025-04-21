import 'package:flutter/material.dart';
import 'package:medicine_app/config/custom/custom_logger.dart';
import 'package:medicine_app/repository/auth/auth_repository.dart';

class AuthViewModels extends ChangeNotifier {
  final log = logger(AuthViewModels);
  late final AuthRepository repository;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  AuthViewModels(this.repository);

  void signUp() {
    _isLoading = true;
    notifyListeners();

    try {} catch (e) {}
  }

  void signIn() {}

  void signInWithGoogle() {}

  void signOut() {}
}
