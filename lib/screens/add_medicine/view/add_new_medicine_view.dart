import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:medicine_app/config/app_styles.dart';
import 'package:medicine_app/config/custom/custom_snackber.dart';
import 'package:medicine_app/constant/app_color.dart';
import 'package:medicine_app/data/database/app_database.dart';
import 'package:medicine_app/models/domain_models.dart';
import 'package:medicine_app/screens/add_medicine/components/date_picker.dart';
import 'package:medicine_app/screens/add_medicine/view/scanning_text_page.dart';
import 'package:medicine_app/screens/auth/component/common_fn.dart';
import 'package:medicine_app/viewmodels/medicine_viewmodel.dart';
import 'package:medicine_app/widgets/common/widget.dart';
import 'package:medicine_app/widgets/common_extension.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class AddNewMedicineScreen extends ConsumerStatefulWidget {
  static const String routeName = '/add_medicine_screen';
  const AddNewMedicineScreen({super.key, this.existingMedicine});

  final MedicineWithSchedules? existingMedicine;

  @override
  ConsumerState<AddNewMedicineScreen> createState() =>
      _AddNewMedicineScreenState();
}

class _AddNewMedicineScreenState extends ConsumerState<AddNewMedicineScreen> {
  final dosageController = TextEditingController();
  final medicineNameController = TextEditingController();
  final availMedicineController = TextEditingController();

  bool isBeforeMeal = true;
  bool isPcsSelected = true;

  // Repeat state variable
  Map<String, dynamic> repeat = {};
  List<DateTime> _selectedMonthlyDateInRepeat = [];
  List<String> _selectedWeekDaysRepeat = [];
  final repeatAfterDayController = TextEditingController(text: '1');
  RepeatVariation repeatVariation = RepeatVariation.day;

  // Schedule Time
  Map<String, TimeOfDay> scheduleTime = {};

  // Start-End date
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(const Duration(days: 60));

  XFile? _capturedImage;
  String? _existingImagePath;

  final _formKey = GlobalKey<FormState>();

  final weekDays = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];

  @override
  void initState() {
    super.initState();

    if (widget.existingMedicine != null) {
      _populateStateVariables(widget.existingMedicine!);
    } else {
      dosageController.text = '1';
      repeat['day'] = '1';
      scheduleTime['Morning'] = const TimeOfDay(hour: 8, minute: 0);
      availMedicineController.text = '30';
    }
  }

  void _populateStateVariables(MedicineWithSchedules med) {
    startDate = med.medicine.startDate;
    endDate = med.medicine.endDate;

    medicineNameController.text = med.medicine.medicineName;
    dosageController.text = med.medicine.dosage.toString();
    availMedicineController.text = med.medicine.availableQuantity.toString();

    isBeforeMeal = med.mealTimingEnum == MealTiming.before;
    isPcsSelected = med.dosageUnitEnum == DosageUnit.pcs;

    _existingImagePath = med.medicine.imagePath;
    if (_existingImagePath != null && File(_existingImagePath!).existsSync()) {
      _capturedImage = XFile(_existingImagePath!);
    }

    repeatVariation = med.repeatVariationEnum;

    switch (repeatVariation) {
      case RepeatVariation.day:
      case RepeatVariation.timely:
        repeatAfterDayController.text = (med.medicine.repeatDays ?? 1).toString();
        repeat['type'] = 'days';
        repeat['day'] = med.medicine.repeatDays ?? 1;
        break;
      case RepeatVariation.weekly:
        _selectedWeekDaysRepeat = [...med.weekDaysList];
        for (var i in _selectedWeekDaysRepeat) {
          repeat[i] = '1';
        }
        repeat['type'] = 'weekly';
        break;
      case RepeatVariation.monthly:
        final allDays = med.monthDaysList
            .map((e) => DateTime(startDate.year, startDate.month, e))
            .toList();
        _selectedMonthlyDateInRepeat = allDays;
        repeat['type'] = 'monthly';
        break;
    }

    scheduleTime.clear();
    for (final s in med.schedules) {
      scheduleTime[s.dayTimeName] = TimeOfDay(hour: s.hour, minute: s.minute);
    }
  }

  @override
  void dispose() {
    dosageController.dispose();
    medicineNameController.dispose();
    availMedicineController.dispose();
    repeatAfterDayController.dispose();
    super.dispose();
  }

  Future<void> _selectTime(BuildContext context, String timesOfDay) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: scheduleTime[timesOfDay] ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        scheduleTime[timesOfDay] = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBarWidget(
        context,
        title: widget.existingMedicine == null ? 'Add Medicine' : 'Update Medicine',
        changeIcon: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Medicine Name *',
                style: secondaryTextStyle(),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Flexible(child: _nameField()),
                  12.horizontalSpace,
                  _scanPictureBtn(),
                ],
              ),
              if (_capturedImage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    children: [
                      SizedBox(
                        height: 60,
                        width: 60,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            File(_capturedImage!.path),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      10.horizontalSpace,
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _capturedImage = null;
                            _existingImagePath = null;
                          });
                        },
                        icon: const Icon(Icons.delete, color: Colors.red),
                      )
                    ],
                  ),
                ),
              const SizedBox(height: 16),
              if (_capturedImage == null) _takePictureBtn(),
              const SizedBox(height: 16),
              Text('Medication dosage', style: secondaryTextStyle()),
              const SizedBox(height: 8),
              medicationDosageSelector(),
              const SizedBox(height: 16),
              Text('Repeat', style: secondaryTextStyle()),
              const SizedBox(height: 8),
              repeatHeadingSection(),
              if (repeatVariation == RepeatVariation.weekly) 10.verticalSpace,
              if (repeatVariation == RepeatVariation.weekly) repeatWeeklySection(),
              if (repeatVariation == RepeatVariation.monthly) repeatMonthlySection(),
              if (repeatVariation == RepeatVariation.weekly ||
                  repeatVariation == RepeatVariation.monthly)
                10.verticalSpace,
              10.verticalSpace,
              Text('Available medicines', style: secondaryTextStyle()),
              const SizedBox(height: 8),
              availableMedicineSelector(),
              const SizedBox(height: 16),
              mealAfterBeforeSelector(),
              const SizedBox(height: 16),
              alarmTimeSelector(),
              addMoreScheduleBtn(),
              const SizedBox(height: 16),
              startEndDateSelector(context),
              const SizedBox(height: 24),
              saveOrCancelBtn(context),
            ],
          ),
        ),
      ),
    );
  }

  Future<String?> _copyImageToPermanentStorage(XFile? imageFile) async {
    if (imageFile == null) return null;
    try {
      final Directory appDocDir = await getApplicationDocumentsDirectory();
      final String fileName = '${DateTime.now().millisecondsSinceEpoch}_${p.basename(imageFile.path)}';
      final String permanentPath = p.join(appDocDir.path, 'medicine_images', fileName);

      final Directory permanentDir = Directory(p.dirname(permanentPath));
      if (!await permanentDir.exists()) {
        await permanentDir.create(recursive: true);
      }

      await File(imageFile.path).copy(permanentPath);
      return permanentPath;
    } catch (e) {
      log('Error copying image: $e');
      return null;
    }
  }

  Expanded _bottomBtn(
    BuildContext context, {
    required VoidCallback ontap,
    required String title,
    required Color color,
  }) {
    return Expanded(
      child: OutlinedButton(
        onPressed: ontap,
        style: OutlinedButton.styleFrom(
          backgroundColor: color.withOpacity(.08),
          padding: const EdgeInsets.symmetric(vertical: 16),
          side: BorderSide(color: color.withOpacity(.2)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.r),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Row startEndDateSelector(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Start date', style: secondaryTextStyle()),
              8.verticalSpace,
              InkWell(
                onTap: () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: startDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2050),
                  );

                  if (selectedDate != null) {
                    setState(() {
                      startDate = selectedDate;
                    });
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 50,
                  decoration: boxDecoration(radius: 12, showShadow: true),
                  child: Text(
                    DateFormat('d MMM, yy').format(startDate),
                    style: boldTextStyle(size: 16),
                  ),
                ),
              )
            ],
          ),
        ),
        20.horizontalSpace,
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('End date', style: secondaryTextStyle()),
              8.verticalSpace,
              InkWell(
                onTap: () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: endDate.isAfter(startDate) ? endDate : startDate,
                    firstDate: startDate,
                    lastDate: DateTime(2050),
                  );

                  if (selectedDate != null) {
                    setState(() {
                      endDate = selectedDate;
                    });
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 50,
                  decoration: boxDecoration(radius: 12, showShadow: true),
                  child: Text(
                    DateFormat('d MMM, yy').format(endDate),
                    style: boldTextStyle(size: 16),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Center addMoreScheduleBtn() {
    return Center(
      child: ElevatedButton.icon(
        icon: const Icon(Icons.add_alarm),
        onPressed: () {
          final newTimesString = switch (scheduleTime.length) {
            0 => 'Morning',
            1 => 'Noon',
            2 => 'Evening',
            3 => 'Night',
            _ => 'Time ${scheduleTime.length + 1}',
          };
          setState(() {
            final now = TimeOfDay.now();
            scheduleTime[newTimesString] = TimeOfDay(
              hour: (now.hour + 2) % 24,
              minute: 0,
            );
          });
        },
        label: const Text('Add More Schedule Time'),
      ),
    );
  }

  ListView alarmTimeSelector() {
    return ListView.builder(
      itemCount: scheduleTime.length,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        final timeDay = scheduleTime.entries.elementAt(index).key;
        return _buildScheduleRow(
          timeDay,
          'Set Alarm',
          true,
        );
      },
    );
  }

  Row repeatHeadingSection() {
    return Row(
      children: [
        if (repeatVariation != RepeatVariation.weekly)
          Text('Every After', style: boldTextStyle(size: 16)),
        10.horizontalSpace,
        switch (repeatVariation) {
          RepeatVariation.day || RepeatVariation.timely => SizedBox(
              width: 50,
              child: TextFormField(
                controller: repeatAfterDayController,
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Required';
                  }
                  final parsed = int.tryParse(val);
                  if (parsed == null || parsed < 1) {
                    return '> 0';
                  }
                  return null;
                },
                decoration: fieldDecor('1'),
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(3),
                ],
              ),
            ),
          RepeatVariation.weekly => const SizedBox(),
          RepeatVariation.monthly => const SizedBox(),
        },
        15.horizontalSpace,
        Container(
          height: 50,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: boxDecoration(radius: 8, color: AppColors.greyColor),
          child: DropdownButton2<RepeatVariation>(
            value: repeatVariation,
            isDense: true,
            underline: const SizedBox(),
            onChanged: (val) {
              if (val != null) {
                setState(() {
                  repeatVariation = val;
                });
              }
            },
            items: const [
              DropdownMenuItem(
                value: RepeatVariation.day,
                child: Text('Day'),
              ),
              DropdownMenuItem(
                value: RepeatVariation.weekly,
                child: Text('Weekly'),
              ),
              DropdownMenuItem(
                value: RepeatVariation.monthly,
                child: Text('At Month'),
              ),
            ],
          ),
        )
      ],
    );
  }

  SizedBox repeatWeeklySection() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        itemCount: 7,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          final day = weekDays[index];
          final isSelected = _selectedWeekDaysRepeat.contains(day);

          return InkWell(
            onTap: () {
              setState(() {
                if (isSelected) {
                  _selectedWeekDaysRepeat.remove(day);
                } else {
                  _selectedWeekDaysRepeat.add(day);
                }
              });
            },
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(right: 10.w),
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: boxDecoration(
                bgColor: isSelected ? AppColors.primaryColor : Colors.white,
                color: AppColors.primaryColor,
                radius: 8.r,
              ),
              child: Text(
                day,
                style: TextStyle(
                  color: isSelected ? AppColors.white : Colors.black87,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  MultiDatePicker repeatMonthlySection() {
    return MultiDatePicker(
      initialDates: widget.existingMedicine == null
          ? null
          : [..._selectedMonthlyDateInRepeat],
      onDatesSelected: (dates) {
        _selectedMonthlyDateInRepeat = dates;
      },
    );
  }

  SizedBox _takePictureBtn() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () {
          _openCameraToTakePicture();
        },
        icon: const Icon(Icons.camera_alt, color: Colors.black),
        label: Text(
          'Take picture',
          style: secondaryTextStyle(size: 15),
        ),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          side: BorderSide(color: Colors.grey[300]!),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  SizedBox _scanPictureBtn() {
    return SizedBox(
      width: 60,
      height: 60,
      child: OutlinedButton(
        onPressed: () async {
          final res = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const ScanningPage(title: 'Scan'),
            ),
          );

          if (res != null && res['data'] is String) {
            medicineNameController.text = res['data'] as String;
          }
        },
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: AppColors.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Text(
          'Scan',
          style: TextStyle(fontSize: 14, color: white),
        ),
      ),
    );
  }

  TextFormField _nameField() {
    return TextFormField(
      controller: medicineNameController,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter medicine name';
        }
        return null;
      },
      decoration: fieldDecor('eg. Napa Extra'),
    );
  }

  Future<void> _openCameraToTakePicture() async {
    final result = await ImagePicker().pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.rear,
    );
    if (result != null) {
      setState(() {
        _capturedImage = result;
      });
    }
  }

  Container mealAfterBeforeSelector() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: boxDecoration(
        bgColor: Colors.transparent,
        radius: 10,
        color: AppColors.greyColor.withOpacity(.3),
      ),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  isBeforeMeal = true;
                });
              },
              style: ElevatedButton.styleFrom(
                elevation: .2,
                backgroundColor: isBeforeMeal ? AppColors.primaryColor : white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Before meal',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: isBeforeMeal ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  isBeforeMeal = false;
                });
              },
              style: ElevatedButton.styleFrom(
                elevation: .2,
                backgroundColor: !isBeforeMeal ? AppColors.primaryColor : Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'After meal',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: !isBeforeMeal ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container availableMedicineSelector() {
    return Container(
      decoration: boxDecoration(radius: 10, color: AppColors.greyColor),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              int res = availMedicineController.toInt();
              if (res > 1) res--;
              availMedicineController.text = res.toString();
            },
            icon: const Icon(Icons.remove),
          ),
          SizedBox(
            width: 70,
            child: TextFormField(
              controller: availMedicineController,
              validator: (val) {
                if (val == null || val.isEmpty) {
                  return 'Required';
                }
                final num = int.tryParse(val);
                if (num == null || num < 0) {
                  return 'Invalid';
                }
                return null;
              },
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(4),
              ],
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: '0',
                suffixText: 'Pcs',
                hintStyle: TextStyle(fontSize: 16),
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              int res = availMedicineController.toInt();
              res++;
              availMedicineController.text = res.toString();
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  Row medicationDosageSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            decoration: boxDecoration(radius: 10, color: AppColors.greyColor),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    int res = dosageController.toInt();
                    if (res > 1) res--;
                    dosageController.text = res.toString();
                  },
                  icon: const Icon(Icons.remove),
                ),
                SizedBox(
                  width: 70,
                  child: TextFormField(
                    controller: dosageController,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Required';
                      }
                      final num = int.tryParse(val);
                      if (num == null || num < 1) {
                        return '> 0';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(3),
                    ],
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: '1',
                      hintStyle: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    int res = dosageController.toInt();
                    res++;
                    dosageController.text = res.toString();
                  },
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          ),
        ),
        10.horizontalSpace,
        Row(
          children: [
            ChoiceChip(
              label: const Text('Pcs'),
              selected: isPcsSelected,
              checkmarkColor: Colors.white,
              onSelected: (selected) {
                setState(() {
                  isPcsSelected = true;
                });
              },
              selectedColor: AppColors.primaryColor,
              labelStyle: TextStyle(
                color: isPcsSelected ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(width: 8),
            ChoiceChip(
              label: const Text('Cup'),
              selected: !isPcsSelected,
              onSelected: (selected) {
                setState(() {
                  isPcsSelected = false;
                });
              },
              checkmarkColor: Colors.white,
              selectedColor: AppColors.primaryColor,
              labelStyle: TextStyle(
                color: !isPcsSelected ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildScheduleRow(
    String timeOfDay,
    String time,
    bool isChecked,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Transform.scale(
              scale: 1.2,
              child: IconButton(
                onPressed: () {
                  if (scheduleTime.length > 1) {
                    setState(() {
                      scheduleTime.remove(timeOfDay);
                    });
                  } else {
                    CustomSnackBar.showCustomErrorToast(
                      message: 'At least one schedule is required',
                    );
                  }
                },
                icon: const Icon(
                  Icons.cancel_outlined,
                  color: Colors.red,
                  size: 20,
                ),
              ),
            ),
            Text(
              timeOfDay,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
        InkWell(
          onTap: () {
            _selectTime(context, timeOfDay);
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.alarm,
                color: Colors.blue,
              ),
              const SizedBox(width: 8),
              Text(
                scheduleTime[timeOfDay]!.format(context),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Row saveOrCancelBtn(BuildContext context) {
    final state = ref.watch(medicineControllerProvider);

    return Row(
      children: [
        _bottomBtn(
          context,
          ontap: () => Navigator.pop(context),
          title: 'Cancel',
          color: Colors.red,
        ),
        const SizedBox(width: 16),
        _bottomBtn(
          context,
          ontap: state.isLoading ? () {} : () => _onSaveMedicine(),
          title: state.isLoading
              ? 'Saving...'
              : (widget.existingMedicine != null ? 'Update' : 'Add Medicine'),
          color: widget.existingMedicine != null ? Colors.green : AppColors.primaryColor,
        ),
      ],
    );
  }

  Future<void> _onSaveMedicine() async {
    if (!_formKey.currentState!.validate()) return;

    if (endDate.isBefore(startDate)) {
      CustomSnackBar.showCustomErrorToast(message: "End date must be after start date");
      return;
    }

    if (scheduleTime.isEmpty) {
      CustomSnackBar.showCustomErrorToast(message: "At least one schedule time is required");
      return;
    }

    if (repeatVariation == RepeatVariation.weekly && _selectedWeekDaysRepeat.isEmpty) {
      CustomSnackBar.showCustomErrorToast(message: "Please select weekdays to repeat");
      return;
    }

    if (repeatVariation == RepeatVariation.monthly && _selectedMonthlyDateInRepeat.isEmpty) {
      CustomSnackBar.showCustomErrorToast(message: "Please select month dates to repeat");
      return;
    }

    String? permanentImagePath = _existingImagePath;
    if (_capturedImage != null && _capturedImage!.path != _existingImagePath) {
      permanentImagePath = await _copyImageToPermanentStorage(_capturedImage);
    }

    final dosage = int.parse(dosageController.text.trim());
    final availableQuantity = int.parse(availMedicineController.text.trim());
    final medicineName = medicineNameController.text.trim();
    final mealTiming = isBeforeMeal ? MealTiming.before : MealTiming.after;
    final dosageUnit = isPcsSelected ? DosageUnit.pcs : DosageUnit.cup;

    final repeatDays = (repeatVariation == RepeatVariation.day || repeatVariation == RepeatVariation.timely)
        ? int.tryParse(repeatAfterDayController.text.trim()) ?? 1
        : null;

    final weekDays = repeatVariation == RepeatVariation.weekly ? _selectedWeekDaysRepeat : null;
    final monthDays = repeatVariation == RepeatVariation.monthly
        ? _selectedMonthlyDateInRepeat.map((e) => e.day).toList()
        : null;

    final controller = ref.read(medicineControllerProvider.notifier);

    if (widget.existingMedicine != null) {
      final success = await controller.updateMedicine(
        id: widget.existingMedicine!.medicine.id,
        medicineName: medicineName,
        dosage: dosage,
        dosageUnit: dosageUnit,
        availableQuantity: availableQuantity,
        mealTiming: mealTiming,
        repeatVariation: repeatVariation,
        repeatDays: repeatDays,
        weekDays: weekDays,
        monthDays: monthDays,
        startDate: startDate,
        endDate: endDate,
        scheduleTimes: scheduleTime,
        imagePath: permanentImagePath,
        existingTakenCount: widget.existingMedicine!.medicine.medicineTakenCount,
        existingCreatedAt: widget.existingMedicine!.medicine.createdAt,
      );

      if (mounted && success) {
        CustomSnackBar.showCustomSnackBar(
          title: "Medicine Updated",
          message: "$medicineName updated successfully",
          context: context,
        );
        Navigator.pop(context);
      }
    } else {
      final id = await controller.addMedicine(
        medicineName: medicineName,
        dosage: dosage,
        dosageUnit: dosageUnit,
        availableQuantity: availableQuantity,
        mealTiming: mealTiming,
        repeatVariation: repeatVariation,
        repeatDays: repeatDays,
        weekDays: weekDays,
        monthDays: monthDays,
        startDate: startDate,
        endDate: endDate,
        scheduleTimes: scheduleTime,
        imagePath: permanentImagePath,
      );

      if (mounted && id != null) {
        CustomSnackBar.showCustomSnackBar(
          title: "Medicine Added",
          message: "$medicineName added and scheduled successfully",
          context: context,
        );
        Navigator.pop(context);
      }
    }
  }
}
