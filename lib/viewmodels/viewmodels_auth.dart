import 'package:flutter/material.dart';
import 'package:medicine_app/config/custom/custom_logger.dart';
import 'package:medicine_app/data/repository/auth_repository.dart';
import 'package:medicine_app/data/repository/user_repository.dart';
import 'package:medicine_app/models/user_model.dart';

class AuthViewModels extends ChangeNotifier {
  final log = logger(AuthViewModels);
  late final AuthRepository repository;
  late final UserRepository userRepository;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  AuthViewModels(this.repository, this.userRepository);

  Future<void> signUp() async {
    _isLoading = true;
    notifyListeners();

    try {
      final userModel = UserModel.getSampleUser();
      await userRepository.insertUser(userModel);
    } catch (e) {
      log.e("Error during sign up: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void signIn() {}

  void signInWithGoogle() {}

  void signOut() {}
}
