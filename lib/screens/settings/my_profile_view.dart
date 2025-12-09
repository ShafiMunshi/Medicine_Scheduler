import 'package:flutter/material.dart';
import 'package:medicine_app/screens/auth/component/common_fn.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:medicine_app/viewmodels/profile_viewmodels.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class MyProfileView extends StatefulWidget {
  const MyProfileView({super.key});

  @override
  State<MyProfileView> createState() => _MyProfileViewState();
}

class _MyProfileViewState extends State<MyProfileView> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  bool _isEditing = false;
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  getUserData() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final vm = context.read<ProfileViewmodels>();

      await vm.fetchUserData();

      _profileImage = vm.userModel?.imagePath != null
          ? File(vm.userModel!.imagePath!)
          : null;
      _nameController.text = vm.userModel?.name ?? '';
      _emailController.text = vm.userModel?.email ?? '';
      _phoneController.text = '01XXXXXXXXX';
      _addressController.text = 'Temporary Address';
    });
  }

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBarWidget(
        context,
        title: 'My Profile',
        changeIcon: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<ProfileViewmodels>(builder: (_, vm, __) {
          if (vm.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Column(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: _profileImage != null
                          ? FileImage(_profileImage!)
                          : null,
                      child: _profileImage == null
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
                  maxLines: 3,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isEditing = !_isEditing;
                      });
                      if (!_isEditing) {
                        // Save data logic here
                      }
                    },
                    child: Text(_isEditing ? 'Save' : 'Edit Profile'),
                  ),
                ),
              ],
            );
          }
        }),
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
                  await context
                      .read<ProfileViewmodels>()
                      .updateProfileImg(image);
                  setState(() {
                    _profileImage = File(image.path);
                  });
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
                  setState(() {
                    _profileImage = File(image.path);
                  });
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
  }) {
    return AppTextField(
      textFieldType: TextFieldType.NAME,
      controller: controller,
      enabled: enabled,
      maxLines: maxLines,
      decoration:
          inputDecoration(context, labelText: label, prefixIcon: Icon(icon)),
    );
  }
}
