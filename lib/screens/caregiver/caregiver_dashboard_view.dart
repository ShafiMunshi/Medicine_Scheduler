import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:medicine_app/constant/app_color.dart';
import 'package:medicine_app/models/user_profile_model.dart';
import 'package:medicine_app/screens/auth/component/common_fn.dart';
import 'package:medicine_app/viewmodels/auth_viewmodel.dart';
import 'package:medicine_app/viewmodels/caregiver_viewmodel.dart';
import 'package:nb_utils/nb_utils.dart';

class CaregiverDashboardView extends ConsumerStatefulWidget {
  static const String routeName = '/caregiver_dashboard';
  const CaregiverDashboardView({super.key});

  @override
  ConsumerState<CaregiverDashboardView> createState() =>
      _CaregiverDashboardViewState();
}

class _CaregiverDashboardViewState
    extends ConsumerState<CaregiverDashboardView> {
  int _selectedPatientIndex = 0;
  DateTime _selectedDate = DateTime.now();

  String get _formattedDate => DateFormat('yyyy-MM-dd').format(_selectedDate);

  void _showLinkPatientDialog() {
    final codeCont = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.person_add_alt_1, color: AppColors.primaryColor),
            SizedBox(width: 8),
            Text('Link Family Member'),
          ],
        ),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Enter the 6-character linking code shown on your child or family member\'s screen:',
                style: TextStyle(fontSize: 13, color: Colors.black87),
              ),
              14.verticalSpace,
              TextFormField(
                controller: codeCont,
                textCapitalization: TextCapitalization.characters,
                decoration: InputDecoration(
                  hintText: 'e.g. MED-A8B9C2 or A8B9C2',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.qr_code),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Please enter a linking code';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;
              final code = codeCont.text.trim();
              Navigator.pop(dialogCtx);

              try {
                final patient = await ref
                    .read(caregiverControllerProvider.notifier)
                    .linkPatient(code);
                toast('Successfully linked ${patient.name}!');
              } catch (e) {
                toast('Failed to link: $e');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Link'),
          ),
        ],
      ),
    );
  }

  void _showUnlinkDialog(UserProfileModel patient) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Text('Unlink Patient?'),
        content: Text(
          'Are you sure you want to stop monitoring ${patient.name}? You can re-link anytime using their linking code.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogCtx);
              try {
                await ref
                    .read(caregiverControllerProvider.notifier)
                    .unlinkPatient(patient.uid);
                toast('Unlinked ${patient.name}');
              } catch (e) {
                toast('Unlink error: $e');
              }
            },
            child: const Text('Unlink', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentFbUser = ref.watch(currentFirebaseUserProvider);
    final monitoredPatientsAsync = ref.watch(monitoredPatientsProvider);

    return Scaffold(
      appBar: commonAppBarWidget(
        context,
        title: 'Caregiver Dashboard',
        changeIcon: true,
        iconWidget1: IconButton(
          icon: const Icon(Icons.person_add_alt_1, color: AppColors.primaryColor),
          tooltip: 'Link Family Member',
          onPressed: _showLinkPatientDialog,
        ),
      ),
      body: currentFbUser == null
          ? _buildSignInPrompt()
          : monitoredPatientsAsync.when(
              data: (patients) {
                if (patients.isEmpty) {
                  return _buildEmptyState();
                }

                if (_selectedPatientIndex >= patients.length) {
                  _selectedPatientIndex = 0;
                }
                final selectedPatient = patients[_selectedPatientIndex];

                return Column(
                  children: [
                    // Patient Selector Bar
                    if (patients.length > 1) _buildPatientSelector(patients),

                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Patient Info Card
                            _buildPatientHeaderCard(selectedPatient),
                            16.verticalSpace,

                            // Date Navigator
                            _buildDateNavigator(),
                            16.verticalSpace,

                            // Live Adherence & Doses
                            _buildDailyStatusSection(selectedPatient),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
    );
  }

  Widget _buildSignInPrompt() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.family_restroom,
              size: 64,
              color: AppColors.primaryColor,
            ),
            16.verticalSpace,
            const Text(
              'Sign In to Monitor Family',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            8.verticalSpace,
            const Text(
              'To view your children or family members\' medication adherence live, please sign in with Google, Apple, or Email.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            20.verticalSpace,
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/sign_in_screen');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text('Sign In Now'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.people_outline,
                size: 64,
                color: AppColors.primaryColor,
              ),
            ),
            20.verticalSpace,
            const Text(
              'No Monitored Family Members',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            10.verticalSpace,
            const Text(
              'You haven\'t linked any patients or family members yet. Ask them for their 6-character linking code to get started!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13.5, color: Colors.black54),
            ),
            24.verticalSpace,
            ElevatedButton.icon(
              onPressed: _showLinkPatientDialog,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Link Child / Patient'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientSelector(List<UserProfileModel> patients) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      color: Colors.grey.shade100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: patients.length,
        separatorBuilder: (_, __) => 8.horizontalSpace,
        itemBuilder: (context, index) {
          final patient = patients[index];
          final isSelected = _selectedPatientIndex == index;
          return ChoiceChip(
            label: Text(patient.name),
            selected: isSelected,
            selectedColor: AppColors.primaryColor,
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : Colors.black87,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
            onSelected: (val) {
              if (val) setState(() => _selectedPatientIndex = index);
            },
          );
        },
      ),
    );
  }

  Widget _buildPatientHeaderCard(UserProfileModel patient) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: AppColors.primaryColor.withOpacity(0.15),
                child: Text(
                  patient.name.isNotEmpty ? patient.name[0].toUpperCase() : 'P',
                  style: const TextStyle(
                    fontSize: 22,
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
                    Row(
                      children: [
                        Text(
                          patient.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        6.horizontalSpace,
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '${patient.age} yrs • ${patient.gender ?? "N/A"}',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.blue.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    4.verticalSpace,
                    Text(
                      patient.bloodGroup != null
                          ? 'Blood Group: ${patient.bloodGroup}'
                          : 'Caregiver Monitored',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () => _showUnlinkDialog(patient),
                tooltip: 'Options',
              ),
            ],
          ),

          // Vitals & Medical chips
          if (patient.emergencyContact != null ||
              patient.allergies != null ||
              patient.chronicConditions != null) ...[
            12.verticalSpace,
            Divider(color: Colors.grey.shade200, height: 1),
            10.verticalSpace,
            Row(
              children: [
                if (patient.emergencyContact != null &&
                    patient.emergencyContact!.isNotEmpty)
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Clipboard.setData(
                          ClipboardData(text: patient.emergencyContact!),
                        );
                        toast('Contact copied: ${patient.emergencyContact}');
                      },
                      icon: const Icon(Icons.phone, size: 14, color: Colors.green),
                      label: Text(
                        patient.emergencyContact!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 11, color: Colors.green),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.green, width: 0.8),
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                      ),
                    ),
                  ),
                if (patient.allergies != null &&
                    patient.allergies!.isNotEmpty) ...[
                  8.horizontalSpace,
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Text(
                      'Allergy: ${patient.allergies}',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.red.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDateNavigator() {
    final isToday = DateUtils.isSameDay(_selectedDate, DateTime.now());
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () {
            setState(() {
              _selectedDate = _selectedDate.subtract(const Duration(days: 1));
            });
          },
        ),
        Row(
          children: [
            const Icon(Icons.calendar_today, size: 16, color: AppColors.primaryColor),
            8.horizontalSpace,
            Text(
              isToday
                  ? 'Today (${DateFormat('MMM d').format(_selectedDate)})'
                  : DateFormat('EEE, MMM d, yyyy').format(_selectedDate),
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: () {
            setState(() {
              _selectedDate = _selectedDate.add(const Duration(days: 1));
            });
          },
        ),
      ],
    );
  }

  Widget _buildDailyStatusSection(UserProfileModel patient) {
    final statusAsync = ref.watch(
      patientDailyStatusFamily((
        patientUid: patient.uid,
        dateString: _formattedDate,
      )),
    );

    return statusAsync.when(
      data: (status) {
        if (status == null || status.doses.isEmpty) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              children: [
                const Icon(Icons.medication_outlined, size: 40, color: Colors.grey),
                10.verticalSpace,
                Text(
                  'No medicine schedule synced for $_formattedDate',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                ),
                4.verticalSpace,
                const Text(
                  'Status updates automatically when patient takes or updates medication.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        final hasMissed = status.totalMissed > 0;
        final allTaken = status.totalScheduled > 0 &&
            status.totalTaken == status.totalScheduled;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Alert Banner
            if (hasMissed)
              Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.red.shade300),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning_amber_rounded,
                        color: Colors.red, size: 24),
                    10.horizontalSpace,
                    Expanded(
                      child: Text(
                        'Attention: ${patient.name} has missed ${status.totalMissed} dose(s) today!',
                        style: TextStyle(
                          color: Colors.red.shade900,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else if (allTaken)
              Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.green.shade300),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_outline,
                        color: Colors.green, size: 24),
                    10.horizontalSpace,
                    Expanded(
                      child: Text(
                        'Great news! ${patient.name} has taken all medicines timely today! 🎉',
                        style: TextStyle(
                          color: Colors.green.shade900,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // KPI Summary Chips
            Row(
              children: [
                _buildKpiCard(
                  label: 'Scheduled',
                  value: status.totalScheduled.toString(),
                  color: Colors.blue,
                ),
                8.horizontalSpace,
                _buildKpiCard(
                  label: 'Taken',
                  value: status.totalTaken.toString(),
                  color: Colors.green,
                ),
                8.horizontalSpace,
                _buildKpiCard(
                  label: 'Missed',
                  value: status.totalMissed.toString(),
                  color: Colors.red,
                ),
                8.horizontalSpace,
                _buildKpiCard(
                  label: 'Upcoming',
                  value: status.totalPending.toString(),
                  color: Colors.orange,
                ),
              ],
            ),
            18.verticalSpace,

            const Text(
              'Medication Checklist',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            10.verticalSpace,

            // Doses List
            ...status.doses.map((dose) => _buildDoseItem(dose)),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error loading status: $e')),
    );
  }

  Widget _buildKpiCard({
    required String label,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            2.verticalSpace,
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: color.withOpacity(0.8),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDoseItem(PatientMedicineDoseStatus dose) {
    Color statusColor;
    IconData statusIcon;
    String statusText;

    if (dose.status == 'taken') {
      statusColor = Colors.green;
      statusIcon = Icons.check_circle;
      statusText = dose.actualTakenTime != null
          ? 'Taken at ${dose.actualTakenTime}'
          : 'Taken';
    } else if (dose.status == 'missed') {
      statusColor = Colors.red;
      statusIcon = Icons.cancel;
      statusText = 'Missed';
    } else {
      statusColor = Colors.orange;
      statusIcon = Icons.hourglass_top;
      statusText = 'Upcoming';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: dose.status == 'missed'
              ? Colors.red.shade300
              : Colors.grey.shade200,
          width: dose.status == 'missed' ? 1.2 : 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(statusIcon, color: statusColor, size: 20),
          ),
          12.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dose.medicineName,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                2.verticalSpace,
                Text(
                  '${dose.dosage} • ${dose.dayTimeName} (${dose.timeString})',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              statusText,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.bold,
                color: statusColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
