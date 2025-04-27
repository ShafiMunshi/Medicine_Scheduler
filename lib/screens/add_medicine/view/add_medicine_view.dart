import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:medicine_app/config/app_styles.dart';
import 'package:medicine_app/constant/app_color.dart';
import 'package:medicine_app/screens/add_medicine/components/date_picker.dart';
import 'package:medicine_app/screens/add_medicine/view/scanning_text_page.dart';
import 'package:medicine_app/screens/auth/component/common_fn.dart';
import 'package:medicine_app/widgets/common/widget.dart';
import 'package:medicine_app/widgets/common_extension.dart';
import 'package:nb_utils/nb_utils.dart';

class AddMedicineScreen extends StatefulWidget {
  static const String routeName = '/add_medicine_screen';
  const AddMedicineScreen({super.key});

  @override
  _AddMedicineScreenState createState() => _AddMedicineScreenState();
}

enum RepeatVariation { timely, days, weekly, monthly }

class _AddMedicineScreenState extends State<AddMedicineScreen> {
  final dosageController = TextEditingController();
  final medicineNameController = TextEditingController();
  final availMedicineController = TextEditingController();
  int availableMedicine = 30;
  int days = 10;
  bool isBeforeMeal = true;
  bool isMorningChecked = true;
  bool isNoonChecked = false;
  bool isNightChecked = false;
  String morningTime = '8:00 AM';
  bool isPcsSelected = true;

  // Repeat state variable
  Map<String, dynamic> repeat = {};
  List<DateTime> _selectedDateInRepeat = [];
  List<String> _selectedWeekDaysRepeat = [];
  int _repeatAfterDay = 1;
  RepeatVariation repeatVariation = RepeatVariation.days;

  // Schedule Time
  Map<String, TimeOfDay> scheduleTime = {};

  // Start-End date
  DateTime startDate = DateTime.now();
  DateTime? endDate = DateTime.now().add(Duration(days: 100));

  XFile? _capturedImage;

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
  }

  @override
  void dispose() {
    dosageController.dispose();
    medicineNameController.dispose();
    availMedicineController.dispose();
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

            // Repeat
            Text('Repeat', style: secondaryTextStyle()),
            const SizedBox(height: 8),
            repeatSection(),
            if (repeatVariation == RepeatVariation.weekly) 10.verticalSpace,
            if (repeatVariation == RepeatVariation.weekly)
              repeatWeeklySection(),
            if (repeatVariation == RepeatVariation.monthly)
              MultiDatePicker(
                onDatesSelected: (dates) {},
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
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.red.withValues(alpha: .05),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side:
                          BorderSide(color: Colors.red.withValues(alpha: .05)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.red, fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                    ),
                    child: const Text(
                      'Add Medicine',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ],
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
                    DateFormat('d MMM, yy').format(startDate),
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
                2 => 'Night',
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
            child: Text('Add More Time')));
  }

  ListView scheduleTimeSelector() {
    return ListView.builder(
      itemCount: scheduleTime.length,
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
                } else {
                  repeat[weekDays[index]] = '1';
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
          RepeatVariation.days => SizedBox(
              width: 50,
              child: TextField(
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
          RepeatVariation.monthly => SizedBox(
              // width: 50,
              // child: TextField(
              //   decoration: fieldDecor('0'),
              //   textAlign: TextAlign.center,
              //   keyboardType: TextInputType.number,
              //   inputFormatters: [
              //     FilteringTextInputFormatter.digitsOnly,
              //     LengthLimitingTextInputFormatter(3),
              //   ],
              // ),
              ),
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
                      case RepeatVariation.days:
                        repeat['type'] = 'days';
                        repeat['day'] = '1';
                        break;
                      case RepeatVariation.weekly:
                        repeat['type'] = 'weekly';
                        break;
                      case RepeatVariation.timely:
                        repeat['type'] = 'timely';
                        break;
                      case RepeatVariation.monthly:
                        repeat['type'] = 'monthly';
                        repeat['day'] = '1';
                        break;
                    }
                  }
                });
              },
              items: [
                DropdownMenuItem(
                  value: RepeatVariation.days,
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

  TextField _nameField() {
    return TextField(
        controller: medicineNameController, decoration: fieldDecor('eg. Napa'));
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
              child: TextField(
                  controller: availMedicineController,
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
                    child: TextField(
                        controller: dosageController,
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
              // child: Checkbox(
              //   value: isChecked,
              //   onChanged: (value) {},
              //   activeColor: AppColors.primaryColor,
              //   shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(20)),
              // ),

              child: IconButton(
                  onPressed: () {
                    setState(() {
                      if (scheduleTime.containsKey(timeOfDay)) {
                        scheduleTime.remove(timeOfDay);
                      }
                    });
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
}
