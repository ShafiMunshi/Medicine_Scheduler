import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medicine_app/data/repository/user_repository.dart';
import 'package:medicine_app/models/user_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class ProfileViewmodels extends ChangeNotifier {
  final UserRepository userRepository;
  ProfileViewmodels(this.userRepository);

  UserModel? _userModel;
  UserModel? get userModel => _userModel;

  bool isLoading = false;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  fetchUserData() async {
    isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _userModel = await userRepository.getUserData();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  updateProfileImg(XFile xFile) async {
    isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final appDir = await getApplicationDocumentsDirectory();
      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}${p.extension(xFile.path)}';
      final File newImage = await File(xFile.path).copy(
        p.join(appDir.path, fileName),
      );

      final newModel = _userModel!.copyWith(imagePath: newImage.path);
      await userRepository.updateUserData(newModel);
      await fetchUserData(); // Refresh user data after updating the image
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
