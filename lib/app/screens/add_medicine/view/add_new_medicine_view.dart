import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:medicine_app/app/screens/add_medicine/components/date_picker.dart';
import 'package:medicine_app/app/screens/add_medicine/view/scanning_text_page.dart';
import 'package:medicine_app/app/screens/auth/component/common_fn.dart';
import 'package:medicine_app/app/viewmodels/medicine_viewmodels.dart';
import 'package:medicine_app/config/app_styles.dart';
import 'package:medicine_app/config/custom/custom_snackber.dart';
import 'package:medicine_app/constant/app_color.dart';
import 'package:medicine_app/models/medicine_model.dart';
import 'package:medicine_app/models/repeat_variation.dart';
import 'package:medicine_app/widgets/common/common_fn.dart';
import 'package:medicine_app/widgets/common/widget.dart';
import 'package:medicine_app/widgets/common_extension.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class AddNewMedicineScreen extends StatefulWidget {
  static const String routeName = '/add_medicine_screen';
  const AddNewMedicineScreen({super.key});

  @override
  _AddNewMedicineScreenState createState() => _AddNewMedicineScreenState();
}

class _AddNewMedicineScreenState extends State<AddNewMedicineScreen> {
  final dosageController = TextEditingController();
  final medicineNameController = TextEditingController();
  final availMedicineController = TextEditingController();

  bool isBeforeMeal = true;
  bool isPcsSelected = true;

  // Repeat state variable
  Map<String, dynamic> repeat = {};
  List<DateTime> _selectedMonthlyDateInRepeat = []; // Date in month
  List<String> _selectedWeekDaysRepeat = []; // for week days
  final repeatAfterDayController = TextEditingController(text: '1');
  RepeatVariation repeatVariation = RepeatVariation.day;

  // Schedule Time
  Map<String, TimeOfDay> scheduleTime = {};

  // Start-End date
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(Duration(days: 60));

  XFile? _capturedImage;

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
    dosageController.text = '1';
    repeat['day'] = '1';
    scheduleTime['Morning'] = TimeOfDay.now();
    availMedicineController.text = '30';
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
      initialTime: TimeOfDay.now(),
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
      appBar:
          commonAppBarWidget(context, title: 'Add Medicine', changeIcon: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Medicine Name Field
              Text(
                'Medicine Name *',
                style: secondaryTextStyle(),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Flexible(child: _nameField()),
                  12.horizontalSpace,
                  _scanPictureBtn()
                ],
              ),

              if (_capturedImage != null) // SizedBox(
                SizedBox(
                  height: 60,
                  width: 60,
                  child: Image.file(
                    File(_capturedImage!.path),
                    fit: BoxFit.cover,
                  ),
                ),
              const SizedBox(height: 16),

              if (_capturedImage == null)

                // Upload Picture Button
                _takePictureBtn(),
              const SizedBox(height: 16),
              // _scanPictureBtn(),

              // Medication Dosage
              Text('Medication dosage', style: secondaryTextStyle()),
              const SizedBox(height: 8),
              medicationDosageSelector(),
              const SizedBox(height: 16),

              // Repeat Section
              Text('Repeat', style: secondaryTextStyle()),
              const SizedBox(height: 8),
              repeatSection(),
              if (repeatVariation == RepeatVariation.weekly) 10.verticalSpace,
              if (repeatVariation == RepeatVariation.weekly)
                repeatWeeklySection(),
              if (repeatVariation == RepeatVariation.monthly)
                MultiDatePicker(
                  onDatesSelected: (dates) {
                    _selectedMonthlyDateInRepeat = dates;
                  },
                ),
              if (repeatVariation == RepeatVariation.weekly ||
                  repeatVariation == RepeatVariation.monthly)
                10.verticalSpace,
              // Available Medicines
              10.verticalSpace,
              Text('Available medicines', style: secondaryTextStyle()),
              const SizedBox(height: 8),

              availableMedicineSelector(),
              const SizedBox(height: 16),

              // Meal Timing Buttons
              mealSelector(),
              const SizedBox(height: 16),

              // Schedule Checkboxes
              scheduleTimeSelector(),
              addMoreScheduleBtn(),

              const SizedBox(height: 16),
              // Start-End Date Selector
              startEndDateSelector(context),

              const SizedBox(height: 24),

              // Cancel and Add Medicine Buttons
              Consumer<MedicineViewmodels>(builder: (context, vm, child) {
                if (vm.isLoading) return CircularProgressIndicator();
                return saveOrCancelBtn(context);
              }),
              //))
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
      final String fileName =
          p.basename(imageFile.path); // Get the original filename
      final String permanentPath = p.join(
          appDocDir.path, 'medicine_images', fileName); // Create a subfolder

      // Ensure the directory exists
      final Directory permanentDir = Directory(p.dirname(permanentPath));
      if (!await permanentDir.exists()) {
        await permanentDir.create(recursive: true);
      }

      // Copy the file
      final File sourceFile = File(imageFile.path);
      await sourceFile.copy(permanentPath);

      log('Image copied to: $permanentPath'); // For debugging
      return permanentPath; // Return the new, permanent path
    } catch (e) {
      log('Error copying image: $e');
      // Handle error appropriately (e.g., show a message to the user)
      return null; // Indicate failure
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
          backgroundColor: color.withValues(alpha: .05),
          padding: const EdgeInsets.symmetric(vertical: 16),
          side: BorderSide(color: color.withValues(alpha: .05)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.r),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(color: color, fontSize: 16),
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
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2050));

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
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2050));

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
        child: ElevatedButton(
            onPressed: () {
              final newTimesString = switch (scheduleTime.length) {
                0 => 'Morning',
                1 => 'Noon',
                2 => 'Evening',
                3 => 'Night',
                _ => 'New Time ${scheduleTime.length + 1}',
              };
              setState(() {
                scheduleTime[newTimesString] = TimeOfDay.now().replacing(
                    minute: (TimeOfDay.now().minute + 10) % 60,
                    hour: (TimeOfDay.now().hour +
                            (TimeOfDay.now().minute + 10) ~/ 60) %
                        24);
              });
            },
            child: Text('Add More Schedule Time')));
  }

  ListView scheduleTimeSelector() {
    return ListView.builder(
      itemCount: scheduleTime.length,
      physics: NeverScrollableScrollPhysics(),
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

  SizedBox repeatWeeklySection() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        itemCount: 7,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              setState(() {
                if (repeat.containsKey(weekDays[index])) {
                  repeat.remove(weekDays[index]);
                  _selectedWeekDaysRepeat.remove(weekDays[index]);
                } else {
                  repeat[weekDays[index]] = '1';
                  _selectedWeekDaysRepeat.add(weekDays[index]);
                }
              });
            },
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(right: 10.w),
              padding: EdgeInsets.all(8.w),
              decoration: boxDecoration(
                  bgColor: repeat.containsKey(weekDays[index])
                      ? AppColors.primaryColor
                      : Colors.white,
                  color: AppColors.primaryColor,
                  radius: 8.r),
              child: Text(
                weekDays[index],
                style: TextStyle(
                  color: repeat.containsKey(weekDays[index])
                      ? AppColors.white
                      : Colors.black87,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Row repeatSection() {
    return Row(
      children: [
        if (repeatVariation != RepeatVariation.weekly)
          Text('Every After', style: boldTextStyle(size: 16)),
        10.horizontalSpace,
        switch (repeatVariation) {
          RepeatVariation.day => SizedBox(
              width: 50,
              child: TextFormField(
                controller: repeatAfterDayController,
                validator: (val) {
                  if (val!.isEmpty) {
                    return 'Add Repeat After Day';
                  }
                  return null;
                },
                decoration: fieldDecor('0'),
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(3),
                ],
              ),
            ),
          RepeatVariation.weekly => SizedBox(),
          RepeatVariation.timely => SizedBox(),
          RepeatVariation.monthly => SizedBox(),
        },
        15.horizontalSpace,
        Container(
          height: 60,
          alignment: Alignment.center,
          // width: 80,
          decoration: boxDecoration(radius: 8, color: AppColors.greyColor),
          child: DropdownButton2(
              value: repeatVariation,
              isDense: true,
              // isExpanded: true,
              underline: SizedBox(),
              dropdownStyleData: DropdownStyleData(
                elevation: 2,
              ),
              onChanged: (val) {
                setState(() {
                  if (val != null) {
                    repeatVariation = val;
                    repeat = {};

                    switch (repeatVariation) {
                      case RepeatVariation.day:
                        repeat['type'] = 'days';
                        repeat['day'] =
                            int.parse(repeatAfterDayController.text);
                        break;
                      case RepeatVariation.weekly:
                        repeat['type'] = 'weekly';
                        break;
                      case RepeatVariation.timely:
                        repeat['type'] = 'timely';
                        break;
                      case RepeatVariation.monthly:
                        repeat['type'] = 'monthly';
                        break;
                    }
                  }
                });
              },
              items: [
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
                )
              ]),
        )
      ],
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
      child: OutlinedButton.icon(
        onPressed: () async {
          final res = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => ScanningPage(
                        title: 'Scan',
                      )));

          final result = res['data'] as String;

          medicineNameController.text = result;
        },
        // icon: const Icon(Icons.camera_alt, color: Colors.black),
        label: Text(
          'Scan',
          style: secondaryTextStyle(size: 15, color: white),
        ),

        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          side: BorderSide(color: Colors.grey[300]!),
          backgroundColor: AppColors.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  TextFormField _nameField() {
    return TextFormField(
        controller: medicineNameController,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter medicine name';
          }
          return null;
        },
        decoration: fieldDecor('eg. Napa'));
  }

  _openCameraToTakePicture() async {
    final result = await ImagePicker().pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.rear,
    );
    if (result != null) {
      _capturedImage = result;
      setState(() {});
    }
  }

  Container mealSelector() {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: boxDecoration(
        bgColor: Colors.transparent,
        radius: 10,
        color: AppColors.greyColor.withValues(alpha: .3),
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
                backgroundColor:
                    !isBeforeMeal ? AppColors.primaryColor : Colors.white,
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
                    if (val!.isEmpty) {
                      return 'Add How much medicine you have';
                    } else if (val.toInt() < 1) {
                      return "Add positive number";
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
                    hintText: '0',
                    suffixText: 'Pcs',
                    hintStyle: TextStyle(fontSize: 16),
                  ))),
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
                          if (val!.isEmpty) {
                            return 'Add How much medicine you have to take per day';
                          } else if (val.toInt() < 1) {
                            return "Add positive number";
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
                          hintText: '0',
                          hintStyle: TextStyle(fontSize: 16),
                        ))),
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

  // Helper method to build schedule rows
  // Helper method to build schedule rows
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
              scale: 1.4,
              child: IconButton(
                  onPressed: () {
                    if (scheduleTime.length > 1) {
                      setState(() {
                        if (scheduleTime.containsKey(timeOfDay)) {
                          scheduleTime.remove(timeOfDay);
                        }
                      });
                    } else {
                      CustomSnackBar.showCustomErrorToast(
                          message: 'At least one schedule is required');
                    }
                  },
                  icon: Icon(
                    Icons.cancel_outlined,
                    color: Colors.red,
                    size: 20,
                  )),
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
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Row saveOrCancelBtn(BuildContext context) {
    return Row(
      children: [
        _bottomBtn(context, ontap: () {
          Navigator.pop(context);
        }, title: 'Cancel', color: Colors.red),
        const SizedBox(width: 16),
        _bottomBtn(
          context,
          ontap: () async {
            if (_formKey.currentState!.validate()) {
              String? permanentImagePath;
              if (_capturedImage != null) {
                // Show loading indicator while copying?
                permanentImagePath =
                    await _copyImageToPermanentStorage(_capturedImage);
                if (permanentImagePath == null) {
                  // Handle the error - maybe show a snackbar and don't proceed?
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content:
                          Text('Failed to save image. Please try again.')));
                  return; // Stop the save process
                }
              }

              final dosage = int.parse(dosageController.text);
              final dosageUnit =
                  isPcsSelected ? DosageUnit.pcs : DosageUnit.cup;
              final availableQuantity = int.parse(availMedicineController.text);
              final medicineName = medicineNameController.text;
              final mealTiming =
                  isBeforeMeal ? MealTiming.before : MealTiming.after;

              log(" Screen : week days : $_selectedWeekDaysRepeat");
              log(" Screen : Monthly days : $_selectedMonthlyDateInRepeat");

              if (repeatVariation == RepeatVariation.weekly &&
                  _selectedWeekDaysRepeat.isEmpty) {
                CustomSnackBar.showCustomErrorToast(
                    message: "Select Some week days to repeat");
                return;
              }

              if (repeatVariation == RepeatVariation.monthly &&
                  _selectedMonthlyDateInRepeat.isEmpty) {
                CustomSnackBar.showCustomErrorToast(
                    message: "Select Some days to repeat");
                return;
              }

              final repeatMap = switch (repeatVariation) {
                RepeatVariation.day => {
                    'type': 'days',
                    'day': int.parse(repeatAfterDayController.text),
                  },
                RepeatVariation.weekly => {
                    'type': 'weekly',
                    'days': _selectedWeekDaysRepeat
                  },
                RepeatVariation.timely => {
                    'type': 'timely',
                    'dayTime': '',
                  },
                RepeatVariation.monthly => {
                    'type': 'monthly',
                    'days':
                        _selectedMonthlyDateInRepeat.map((e) => e.day).toList()
                  }
              };

              final newScheduleTimes = <String, String>{};
              scheduleTime.forEach((key, value) {
                newScheduleTimes[key] = timeOfDayToString(value);
              });

              if (newScheduleTimes.isEmpty) {
                CustomSnackBar.showCustomErrorToast(
                    message:
                        "Select Some schedule times when to take the medicine");
                return;
              }

              print('added');

              final newMedicine = MedicineModel(
                medicineName: medicineName,
                dosage: dosage,
                dosageUnit: dosageUnit,
                availableQuantity: availableQuantity,
                mealTiming: mealTiming,
                repeatMap: repeatMap,
                repeatVariation: repeatVariation,
                imagePath: permanentImagePath,
                createdAt: DateTime.now(),
                modifiedAt: DateTime.now(),
                startDate: startDate,
                endDate: endDate,
                scheduleTimes: newScheduleTimes,
              );

              log('model created');

              final viewModel = context.read<MedicineViewmodels>();

              await viewModel.add_medicine(newMedicine).whenComplete(() {
                if (mounted) {
                  if (viewModel.errorMessage == null) {
                    Navigator.pop(context);
                    CustomSnackBar.showCustomSnackBar(
                        title: "Medicine added",
                        message: "$medicineName has been added successfully",
                        context: context);
                  } else {
                    CustomSnackBar.showCustomErrorToast(
                        message: "Error: ${viewModel.errorMessage}");
                  }
                }
              });
            }
          },
          title: 'Add Medicine',
          color: AppColors.primaryColor,
        ),
      ],
    );
  }
}

// TODO: Validate each field accurate so that no null issue should occur in future..
