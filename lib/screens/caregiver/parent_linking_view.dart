import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medicine_app/constant/app_color.dart';
import 'package:medicine_app/screens/auth/component/common_fn.dart';
import 'package:medicine_app/screens/caregiver/caregiver_dashboard_view.dart';
import 'package:medicine_app/viewmodels/auth_viewmodel.dart';
import 'package:medicine_app/viewmodels/caregiver_viewmodel.dart';
import 'package:medicine_app/viewmodels/profile_viewmodel.dart';
import 'package:nb_utils/nb_utils.dart';

class ParentLinkingView extends ConsumerStatefulWidget {
  static const String routeName = '/parent_linking_view';
  const ParentLinkingView({super.key});

  @override
  ConsumerState<ParentLinkingView> createState() => _ParentLinkingViewState();
}

class _ParentLinkingViewState extends ConsumerState<ParentLinkingView> {
  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(userProfileProvider);
    final currentFbUser = ref.watch(currentFirebaseUserProvider);

    return Scaffold(
      appBar: commonAppBarWidget(
        context,
        title: 'Caregiver & Family Supervision',
        changeIcon: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.primaryColor.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.family_restroom,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  16.horizontalSpace,
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Family Medicine Supervision',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Let a parent or family caregiver monitor whether you take all your medicine timely.',
                          style: TextStyle(fontSize: 12.5, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            24.verticalSpace,

            // If not logged in with Firebase, show helpful sign-in prompt
            if (currentFbUser == null) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amber.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.amber.shade900),
                        8.horizontalSpace,
                        Text(
                          'Sign In Required for Cloud Sync',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.amber.shade900,
                          ),
                        ),
                      ],
                    ),
                    8.verticalSpace,
                    const Text(
                      'To link with a parent or caregiver across devices, please sign in with Google, Apple, or Email.',
                      style: TextStyle(fontSize: 13, color: Colors.black87),
                    ),
                    12.verticalSpace,
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, '/sign_in_screen');
                      },
                      icon: const Icon(Icons.login, size: 18),
                      label: const Text('Sign In Now'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              24.verticalSpace,
            ],

            // Linking Code Section
            profileAsync.when(
              data: (user) {
                final code = user?.linkingCode ?? 'MED-LOCAL1';
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Your Personal Linking Code',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    6.verticalSpace,
                    const Text(
                      'Share this 6-character code with your parent or caregiver so they can monitor your schedule.',
                      style: TextStyle(fontSize: 13, color: Colors.black54),
                    ),
                    14.verticalSpace,
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.grey.shade300, width: 1.2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'LINKING CODE',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              4.verticalSpace,
                              Text(
                                code,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            ],
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              Clipboard.setData(ClipboardData(text: code));
                              toast('Code copied to clipboard: $code');
                            },
                            icon: const Icon(Icons.copy, size: 16),
                            label: const Text('Copy'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => const SizedBox(),
            ),

            28.verticalSpace,

            // How it works guide
            const Text(
              'How Caregiver Monitoring Works',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            12.verticalSpace,
            _buildInstructionStep(
              step: '1',
              title: 'Share your code',
              description: 'Send your linking code to your parent or guardian.',
            ),
            10.verticalSpace,
            _buildInstructionStep(
              step: '2',
              title: 'Parent enters the code',
              description:
                  'Your parent opens the Caregiver Dashboard and enters your linking code.',
            ),
            10.verticalSpace,
            _buildInstructionStep(
              step: '3',
              title: 'Live supervision & Missed Alerts',
              description:
                  'Your parent can see your medication checklist live, verify when doses are taken, and get alerted if any dose is missed.',
            ),

            32.verticalSpace,

            // Quick switch to Caregiver Dashboard (if user is also a parent/caregiver)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Are you also a Caregiver / Parent?',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  6.verticalSpace,
                  const Text(
                    'Switch to the Caregiver Dashboard to monitor your children or elderly family members.',
                    style: TextStyle(fontSize: 13, color: Colors.black54),
                  ),
                  14.verticalSpace,
                  OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CaregiverDashboardView(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.remove_red_eye_outlined, size: 18),
                    label: const Text('Open Caregiver Dashboard'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primaryColor,
                      side: const BorderSide(color: AppColors.primaryColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionStep({
    required String step,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 13,
          backgroundColor: AppColors.primaryColor.withOpacity(0.15),
          child: Text(
            step,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
            ),
          ),
        ),
        12.horizontalSpace,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              2.verticalSpace,
              Text(
                description,
                style: const TextStyle(fontSize: 12.5, color: Colors.black54),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
