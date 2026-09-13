import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medicine_app/screens/auth/component/common_fn.dart';
import 'package:medicine_app/viewmodels/profile_viewmodel.dart';
import 'package:nb_utils/nb_utils.dart';

class MyProfileView extends ConsumerStatefulWidget {
  const MyProfileView({super.key});

  @override
  ConsumerState<MyProfileView> createState() => _MyProfileViewState();
}

class _MyProfileViewState extends ConsumerState<MyProfileView> {
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  bool _isEditing = false;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final user = await ref.read(userProfileProvider.future);
      if (user != null && mounted) {
        _nameController.text = user.name;
        _ageController.text = user.age.toString();
        _emailController.text = user.email ?? 'shafi@example.com';
        _phoneController.text = '+880 1700-000000';
        _addressController.text = 'Dhaka, Bangladesh';
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(userProfileProvider);

    return Scaffold(
      appBar: commonAppBarWidget(
        context,
        title: 'My Profile',
        changeIcon: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: profileAsync.when(
          data: (user) {
            final imagePath = user?.imagePath;
            final hasImage = imagePath != null && File(imagePath).existsSync();

            return Column(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: hasImage ? FileImage(File(imagePath)) : null,
                      child: !hasImage
                          ? const Icon(Icons.person, size: 50)
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildTextField(
                  controller: _nameController,
                  label: 'Name',
                  icon: Icons.person,
                  enabled: _isEditing,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _ageController,
                  label: 'Age',
                  icon: Icons.calendar_today,
                  enabled: _isEditing,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _emailController,
                  label: 'Email',
                  icon: Icons.email,
                  enabled: _isEditing,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _phoneController,
                  label: 'Phone',
                  icon: Icons.phone,
                  enabled: _isEditing,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _addressController,
                  label: 'Address',
                  icon: Icons.location_on,
                  enabled: _isEditing,
                  maxLines: 2,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_isEditing) {
                        final name = _nameController.text.trim();
                        final age = int.tryParse(_ageController.text.trim()) ?? 25;
                        final email = _emailController.text.trim();

                        await ref
                            .read(profileControllerProvider.notifier)
                            .updateProfileInfo(
                              name: name.isEmpty ? 'User' : name,
                              age: age,
                              email: email,
                            );

                        toast('Profile updated successfully!');
                      }
                      setState(() {
                        _isEditing = !_isEditing;
                      });
                    },
                    child: Text(
                      _isEditing ? 'Save' : 'Edit Profile',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () async {
                Navigator.pop(context);
                final XFile? image =
                    await _picker.pickImage(source: ImageSource.gallery);
                if (image != null) {
                  await ref
                      .read(profileControllerProvider.notifier)
                      .updateProfileImage(image);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Camera'),
              onTap: () async {
                Navigator.pop(context);
                final XFile? image =
                    await _picker.pickImage(source: ImageSource.camera);
                if (image != null) {
                  await ref
                      .read(profileControllerProvider.notifier)
                      .updateProfileImage(image);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool enabled,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return AppTextField(
      textFieldType: TextFieldType.NAME,
      controller: controller,
      enabled: enabled,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: inputDecoration(context, labelText: label, prefixIcon: Icon(icon)),
    );
  }
}
