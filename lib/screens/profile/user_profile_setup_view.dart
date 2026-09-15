import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medicine_app/constant/app_color.dart';
import 'package:medicine_app/screens/top_screen_view.dart';
import 'package:medicine_app/viewmodels/auth_viewmodel.dart';
import 'package:medicine_app/viewmodels/profile_viewmodel.dart';
import 'package:nb_utils/nb_utils.dart';

class UserProfileSetupView extends ConsumerStatefulWidget {
  static const String routeName = '/user_profile_setup';

  final bool isInitialSetup;

  const UserProfileSetupView({
    super.key,
    this.isInitialSetup = true,
  });

  @override
  ConsumerState<UserProfileSetupView> createState() =>
      _UserProfileSetupViewState();
}

class _UserProfileSetupViewState extends ConsumerState<UserProfileSetupView> {
  final _formKey = GlobalKey<FormState>();

  final _nameCont = TextEditingController();
  final _ageCont = TextEditingController();
  final _weightCont = TextEditingController();
  final _heightCont = TextEditingController();
  final _allergiesCont = TextEditingController();
  final _chronicConditionsCont = TextEditingController();
  final _emergencyContactCont = TextEditingController();

  String _gender = 'Male';
  String? _bloodGroup = 'O+';
  String? _selectedAvatarKey = 'avatar_male_1';
  String? _customImagePath;

  final List<({String key, String emoji, String label})> _avatarPresets = [
    (key: 'avatar_male_1', emoji: '👨', label: 'Male'),
    (key: 'avatar_female_1', emoji: '👩', label: 'Female'),
    (key: 'avatar_doctor_m', emoji: '👨‍⚕️', label: 'Doctor M'),
    (key: 'avatar_doctor_f', emoji: '👩‍⚕️', label: 'Doctor F'),
    (key: 'avatar_senior_m', emoji: '👴', label: 'Senior M'),
    (key: 'avatar_senior_f', emoji: '👵', label: 'Senior F'),
  ];

  final List<String> _bloodGroups = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-',
  ];

  @override
  void initState() {
    super.initState();
    _loadExistingProfile();
  }

  Future<void> _loadExistingProfile() async {
    final user = await ref.read(userProfileProvider.future);
    if (user != null && mounted) {
      setState(() {
        if (user.name.isNotEmpty && user.name != 'Shafi Munshi' && user.name != 'User') {
          _nameCont.text = user.name;
        } else {
          final fbUser = ref.read(currentFirebaseUserProvider);
          _nameCont.text = fbUser?.displayName ?? user.name;
        }
        _ageCont.text = user.age.toString();
        if (user.gender != null && user.gender!.isNotEmpty) {
          _gender = user.gender!;
        }
        if (user.weight != null && user.weight! > 0) {
          _weightCont.text = user.weight.toString();
        }
        if (user.height != null && user.height! > 0) {
          _heightCont.text = user.height.toString();
        }
        if (user.bloodGroup != null && user.bloodGroup!.isNotEmpty) {
          _bloodGroup = user.bloodGroup;
        }
        if (user.allergies != null) {
          _allergiesCont.text = user.allergies!;
        }
        if (user.chronicConditions != null) {
          _chronicConditionsCont.text = user.chronicConditions!;
        }
        if (user.emergencyContact != null) {
          _emergencyContactCont.text = user.emergencyContact!;
        }
        if (user.imagePath != null && user.imagePath!.isNotEmpty) {
          if (user.imagePath!.startsWith('avatar_')) {
            _selectedAvatarKey = user.imagePath;
          } else {
            _customImagePath = user.imagePath;
          }
        }
      });
    }
  }

  @override
  void dispose() {
    _nameCont.dispose();
    _ageCont.dispose();
    _weightCont.dispose();
    _heightCont.dispose();
    _allergiesCont.dispose();
    _chronicConditionsCont.dispose();
    _emergencyContactCont.dispose();
    super.dispose();
  }

  Future<void> _pickCustomImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _customImagePath = picked.path;
        _selectedAvatarKey = null;
      });
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final name = _nameCont.text.trim();
    final age = int.tryParse(_ageCont.text.trim()) ?? 25;
    final weight = double.tryParse(_weightCont.text.trim());
    final height = double.tryParse(_heightCont.text.trim());
    final avatar = _customImagePath ?? _selectedAvatarKey;

    try {
      await ref.read(profileControllerProvider.notifier).saveFullProfile(
            name: name,
            gender: _gender,
            age: age,
            weight: weight,
            height: height,
            avatarUrl: avatar,
            bloodGroup: _bloodGroup,
            allergies: _allergiesCont.text.trim(),
            chronicConditions: _chronicConditionsCont.text.trim(),
            emergencyContact: _emergencyContactCont.text.trim(),
          );

      toast('Profile saved successfully!');

      if (mounted) {
        if (widget.isInitialSetup) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            TopScreenView.routeName,
            (route) => false,
          );
        } else {
          Navigator.pop(context);
        }
      }
    } catch (e) {
      toast('Error saving profile: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileControllerProvider);
    final isLoading = profileState.isLoading;

    return PopScope(
      canPop: !widget.isInitialSetup,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.isInitialSetup ? 'Complete Profile' : 'Edit Health Profile',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          automaticallyImplyLeading: !widget.isInitialSetup,
        ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: isLoading ? null : _saveProfile,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
            child: isLoading
                ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                : Text(
                    widget.isInitialSetup
                        ? 'Save & Continue'
                        : 'Update Profile',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.isInitialSetup) ...[
                const Text(
                  'Welcome to Medicine Scheduler! 👋',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                4.verticalSpace,
                const Text(
                  'Please fill in your details to ensure accurate dosing and keep your caregiver informed.',
                  style: TextStyle(fontSize: 13, color: Colors.black54),
                ),
                20.verticalSpace,
              ],

              // Avatar Selection Section
              Center(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 46,
                          backgroundColor: AppColors.primaryColor.withOpacity(0.15),
                          backgroundImage: _customImagePath != null &&
                                  File(_customImagePath!).existsSync()
                              ? FileImage(File(_customImagePath!))
                              : null,
                          child: _customImagePath == null
                              ? Text(
                                  _avatarPresets
                                      .firstWhere(
                                        (a) => a.key == _selectedAvatarKey,
                                        orElse: () => _avatarPresets.first,
                                      )
                                      .emoji,
                                  style: const TextStyle(fontSize: 44),
                                )
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: _pickCustomImage,
                            child: Container(
                              padding: const EdgeInsets.all(7),
                              decoration: const BoxDecoration(
                                color: AppColors.primaryColor,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                size: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    10.verticalSpace,
                    const Text(
                      'Choose an Avatar or Pick Photo',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    8.verticalSpace,
                    SizedBox(
                      height: 52,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: _avatarPresets.length,
                        separatorBuilder: (_, __) => 8.horizontalSpace,
                        itemBuilder: (context, index) {
                          final item = _avatarPresets[index];
                          final isSelected = _selectedAvatarKey == item.key &&
                              _customImagePath == null;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedAvatarKey = item.key;
                                _customImagePath = null;
                              });
                            },
                            child: Container(
                              width: 48,
                              height: 48,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primaryColor.withOpacity(0.18)
                                    : Colors.grey.shade100,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.primaryColor
                                      : Colors.grey.shade300,
                                  width: isSelected ? 2.5 : 1,
                                ),
                              ),
                              child: Text(
                                item.emoji,
                                style: const TextStyle(fontSize: 24),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              24.verticalSpace,
              _buildSectionHeader(
                icon: Icons.person_outline,
                title: 'Basic Information (Required)',
              ),
              14.verticalSpace,

              // Name
              TextFormField(
                controller: _nameCont,
                decoration: _inputDecoration(
                  label: 'Full Name *',
                  icon: Icons.person,
                  hint: 'e.g. John Doe',
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              14.verticalSpace,

              // Gender Selector
              const Text(
                'Gender *',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
              6.verticalSpace,
              Row(
                children: ['Male', 'Female', 'Other'].map((g) {
                  final isSelected = _gender == g;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: ChoiceChip(
                        label: Center(
                          child: Text(
                            g,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black87,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                        selected: isSelected,
                        selectedColor: AppColors.primaryColor,
                        backgroundColor: Colors.grey.shade100,
                        onSelected: (val) {
                          if (val) setState(() => _gender = g);
                        },
                      ),
                    ),
                  );
                }).toList(),
              ),
              14.verticalSpace,

              // Age & Weight & Height Row
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _ageCont,
                      keyboardType: TextInputType.number,
                      decoration: _inputDecoration(
                        label: 'Age *',
                        icon: Icons.calendar_today,
                        hint: '25',
                      ),
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'Age is required';
                        }
                        final parsed = int.tryParse(val.trim());
                        if (parsed == null || parsed <= 0 || parsed > 120) {
                          return 'Valid age';
                        }
                        return null;
                      },
                    ),
                  ),
                  10.horizontalSpace,
                  Expanded(
                    child: TextFormField(
                      controller: _weightCont,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: _inputDecoration(
                        label: 'Weight (kg)',
                        icon: Icons.monitor_weight_outlined,
                        hint: '65',
                      ),
                    ),
                  ),
                  10.horizontalSpace,
                  Expanded(
                    child: TextFormField(
                      controller: _heightCont,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: _inputDecoration(
                        label: 'Height (cm)',
                        icon: Icons.height,
                        hint: '172',
                      ),
                    ),
                  ),
                ],
              ),

              24.verticalSpace,
              _buildSectionHeader(
                icon: Icons.medical_services_outlined,
                title: 'Medical Details (Optional)',
              ),
              14.verticalSpace,

              // Blood Group
              DropdownButtonFormField<String>(
                value: _bloodGroup,
                decoration: _inputDecoration(
                  label: 'Blood Group',
                  icon: Icons.water_drop_outlined,
                ),
                items: _bloodGroups.map((bg) {
                  return DropdownMenuItem(value: bg, child: Text(bg));
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _bloodGroup = val);
                },
              ),
              14.verticalSpace,

              // Known Allergies
              TextFormField(
                controller: _allergiesCont,
                decoration: _inputDecoration(
                  label: 'Known Allergies',
                  icon: Icons.warning_amber_rounded,
                  hint: 'e.g. Penicillin, Aspirin, Peanuts',
                ),
              ),
              14.verticalSpace,

              // Chronic Conditions
              TextFormField(
                controller: _chronicConditionsCont,
                decoration: _inputDecoration(
                  label: 'Chronic Conditions',
                  icon: Icons.healing_outlined,
                  hint: 'e.g. Diabetes, Hypertension, Asthma',
                ),
              ),
              14.verticalSpace,

              // Emergency Contact
              TextFormField(
                controller: _emergencyContactCont,
                keyboardType: TextInputType.phone,
                decoration: _inputDecoration(
                  label: 'Emergency Contact (Phone / Name)',
                  icon: Icons.phone_in_talk_outlined,
                  hint: 'e.g. Mom: +1 555-0199',
                ),
              ),
              24.verticalSpace,
            ],
          ),
        ),
      ),
    ),
  );
  }

  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primaryColor),
        8.horizontalSpace,
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
    String? hint,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon, size: 20, color: Colors.grey.shade600),
      filled: true,
      fillColor: Colors.grey.shade50,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.primaryColor, width: 1.5),
      ),
    );
  }
}
