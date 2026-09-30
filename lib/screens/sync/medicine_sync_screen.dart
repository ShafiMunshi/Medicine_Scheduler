import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medicine_app/constant/app_color.dart';
import 'package:medicine_app/models/domain_models.dart';
import 'package:medicine_app/screens/profile/user_profile_setup_view.dart';
import 'package:medicine_app/screens/top_screen_view.dart';
import 'package:medicine_app/viewmodels/auth_viewmodel.dart';
import 'package:medicine_app/viewmodels/database_providers.dart';
import 'package:medicine_app/viewmodels/medicine_viewmodel.dart';
import 'package:nb_utils/nb_utils.dart';

class MedicineSyncScreen extends ConsumerStatefulWidget {
  static const String routeName = '/medicine_sync_screen';

  final String? targetRoute;
  final bool isFromSettings;

  const MedicineSyncScreen({
    super.key,
    this.targetRoute,
    this.isFromSettings = false,
  });

  @override
  ConsumerState<MedicineSyncScreen> createState() => _MedicineSyncScreenState();
}

class _MedicineSyncScreenState extends ConsumerState<MedicineSyncScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;

  bool _isLoading = true;
  bool _isSuccess = false;
  String? _errorMessage;
  String _currentStepMessage = 'Initializing cloud sync...';
  double _progress = 0.05;
  MedicineSyncSummary? _syncSummary;

  Timer? _redirectTimer;
  int _redirectCountdown = 3;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.92, end: 1.08).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );

    // Kick off fetching and upserting process
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startSyncProcess();
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    _redirectTimer?.cancel();
    super.dispose();
  }

  Future<void> _startSyncProcess() async {
    setState(() {
      _isLoading = true;
      _isSuccess = false;
      _errorMessage = null;
      _progress = 0.1;
      _currentStepMessage = 'Verifying authentication...';
    });

    final currentFbUser = ref.read(currentFirebaseUserProvider) ??
        fb.FirebaseAuth.instance.currentUser;

    if (currentFbUser == null) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'No authenticated user found. Please log in again.';
      });
      return;
    }

    try {
      final controller = ref.read(medicineControllerProvider.notifier);

      final summary = await controller.syncMedicinesFromFirestore(
        currentFbUser.uid,
        onProgress: (stepMessage, progressValue) {
          if (mounted) {
            setState(() {
              _currentStepMessage = stepMessage;
              _progress = progressValue;
            });
          }
        },
      );

      if (!mounted) return;

      if (summary.isSuccess) {
        setState(() {
          _isLoading = false;
          _isSuccess = true;
          _progress = 1.0;
          _currentStepMessage = summary.totalFound > 0
              ? 'Successfully synced ${summary.totalUpserted} medicines!'
              : 'Sync complete. No remote medicines found.';
          _syncSummary = summary;
        });

        // Determine destination route
        final args = ModalRoute.of(context)?.settings.arguments
            as Map<String, dynamic>?;
        final isFromSettings =
            widget.isFromSettings || (args?['isFromSettings'] as bool? ?? false);

        if (!isFromSettings) {
          _startAutoRedirectTimer();
        }
      } else {
        setState(() {
          _isLoading = false;
          _isSuccess = false;
          _errorMessage = summary.errorMessage ??
              'Unable to sync medicines from cloud. You can still continue offline.';
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _isSuccess = false;
        _errorMessage =
            'Sync error: $e\nYour local medicines remain safe and accessible.';
      });
    }
  }

  void _startAutoRedirectTimer() {
    _redirectTimer?.cancel();
    _redirectCountdown = 3;
    _redirectTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_redirectCountdown <= 1) {
        timer.cancel();
        _proceedToNextScreen();
      } else {
        setState(() {
          _redirectCountdown--;
        });
      }
    });
  }

  Future<void> _proceedToNextScreen() async {
    _redirectTimer?.cancel();

    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final isFromSettings =
        widget.isFromSettings || (args?['isFromSettings'] as bool? ?? false);

    if (isFromSettings) {
      Navigator.pop(context);
      return;
    }

    String? target = widget.targetRoute ?? args?['targetRoute'] as String?;

    if (target == null) {
      // Check local user profile completion
      final userRepo = ref.read(userRepositoryProvider);
      final localUser = await userRepo.getUser();
      final isCompleted = localUser?.isProfileCompleted ?? false;
      target = isCompleted
          ? TopScreenView.routeName
          : UserProfileSetupView.routeName;
    }

    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(
      context,
      target,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final isFromSettings =
        widget.isFromSettings || (args?['isFromSettings'] as bool? ?? false);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: isFromSettings
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: Colors.black87, size: 20),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        automaticallyImplyLeading: isFromSettings,
        title: const Text(
          'Cloud Medicine Sync',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            children: [
              const Spacer(),

              // Animated Sync Icon / Illustration
              _buildCenterVisual(),
              24.verticalSpace,

              // Status Heading
              Text(
                _isLoading
                    ? 'Restoring Your Medicines'
                    : _isSuccess
                        ? 'Sync Completed!'
                        : 'Sync Encountered an Issue',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              8.verticalSpace,

              // Status Subtitle
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  _isLoading
                      ? 'Fetching your saved medications from Cloud Firestore and setting up reminders on this device...'
                      : _isSuccess
                          ? (_syncSummary?.totalFound ?? 0) > 0
                              ? 'Successfully downloaded and updated ${_syncSummary?.totalUpserted} medicines into your local database.'
                              : 'Your cloud account is synced. No previous medicines were found.'
                          : (_errorMessage ??
                              'Could not reach cloud backup. You can continue offline.'),
                  style: TextStyle(
                    fontSize: 14,
                    color: _errorMessage != null
                        ? Colors.red.shade700
                        : Colors.grey.shade600,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              24.verticalSpace,

              // Progress Bar & Step info
              if (_isLoading) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: _progress.clamp(0.0, 1.0),
                    minHeight: 8,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.primaryColor,
                    ),
                  ),
                ),
                12.verticalSpace,
                Text(
                  _currentStepMessage,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.blueGrey.shade700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],

              // Medicines preview list if synced successfully
              if (_isSuccess &&
                  _syncSummary != null &&
                  _syncSummary!.medicineNames.isNotEmpty) ...[
                12.verticalSpace,
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.check_circle_rounded,
                              color: Colors.green, size: 20),
                          8.horizontalSpace,
                          Text(
                            'Restored Medicines (${_syncSummary!.medicineNames.length})',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      12.verticalSpace,
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _syncSummary!.medicineNames.take(6).map((name) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.medication_rounded,
                                  size: 16,
                                  color: AppColors.primaryColor,
                                ),
                                6.horizontalSpace,
                                Text(
                                  name,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                      if (_syncSummary!.medicineNames.length > 6) ...[
                        8.verticalSpace,
                        Text(
                          '+ ${_syncSummary!.medicineNames.length - 6} more medicines',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],

              const Spacer(),

              // Action buttons
              _buildBottomActions(isFromSettings),
              12.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCenterVisual() {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        width: 120.w,
        height: 120.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: _isLoading
                ? [
                    AppColors.primaryColor.withOpacity(0.15),
                    AppColors.primaryColor.withOpacity(0.05),
                  ]
                : _isSuccess
                    ? [
                        Colors.green.withOpacity(0.18),
                        Colors.green.withOpacity(0.05),
                      ]
                    : [
                        Colors.red.withOpacity(0.18),
                        Colors.red.withOpacity(0.05),
                      ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(
            color: _isLoading
                ? AppColors.primaryColor.withOpacity(0.3)
                : _isSuccess
                    ? Colors.green.withOpacity(0.3)
                    : Colors.red.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Center(
          child: _isLoading
              ? const Icon(
                  Icons.cloud_sync_rounded,
                  size: 56,
                  color: AppColors.primaryColor,
                )
              : _isSuccess
                  ? const Icon(
                      Icons.cloud_done_rounded,
                      size: 56,
                      color: Colors.green,
                    )
                  : const Icon(
                      Icons.cloud_off_rounded,
                      size: 56,
                      color: Colors.redAccent,
                    ),
        ),
      ),
    );
  }

  Widget _buildBottomActions(bool isFromSettings) {
    if (_isLoading) {
      return SizedBox(
        width: double.infinity,
        height: 50,
        child: OutlinedButton(
          onPressed: _proceedToNextScreen,
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            side: BorderSide(color: Colors.grey.shade300),
          ),
          child: const Text(
            'Skip & Continue to App',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
        ),
      );
    }

    if (_isSuccess) {
      return SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: _proceedToNextScreen,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            foregroundColor: Colors.white,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            isFromSettings
                ? 'Done'
                : 'Continue to App (${_redirectCountdown}s)',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }

    // Error State Actions
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton.icon(
            onPressed: _startSyncProcess,
            icon: const Icon(Icons.refresh_rounded, color: Colors.white),
            label: const Text(
              'Retry Cloud Sync',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        10.verticalSpace,
        SizedBox(
          width: double.infinity,
          height: 48,
          child: TextButton(
            onPressed: _proceedToNextScreen,
            child: const Text(
              'Continue with Local Storage',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
