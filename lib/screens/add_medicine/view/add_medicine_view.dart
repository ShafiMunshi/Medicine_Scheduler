import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medicine_app/config/app_styles.dart';
import 'package:medicine_app/constant/app_color.dart';
import 'package:medicine_app/screens/auth/component/common_fn.dart';
import 'package:nb_utils/nb_utils.dart';

class AddMedicineScreen extends StatefulWidget {
  static const String routeName = '/add_medicine_screen';
  const AddMedicineScreen({super.key});

  @override
  _AddMedicineScreenState createState() => _AddMedicineScreenState();
}

class _AddMedicineScreenState extends State<AddMedicineScreen> {
  int dosage = 1;
  int availableMedicine = 30;
  int days = 10;
  bool isBeforeMeal = true;
  bool isMorningChecked = true;
  bool isNoonChecked = false;
  bool isNightChecked = false;
  String morningTime = '8:00 AM';
  bool isPcsSelected = true;

  Future<void> _selectTime(BuildContext context, String period) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (period == 'Morning') {
          morningTime =
              picked.format(context); // Formats the time as per device settings
        }
        // Add logic for Noon and Night if needed
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
            TextField(
              decoration: InputDecoration(
                hintText: 'eg. Napa',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade100),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16),

            // Upload Picture Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {},
                icon:
                    const Icon(Icons.file_upload_outlined, color: Colors.black),
                label: Text(
                  'Upload picture',
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
            ),
            const SizedBox(height: 16),

            // Medication Dosage
            Text(
              'Medication dosage',
              style: secondaryTextStyle(),
            ),
            const SizedBox(height: 8),
            medicationDosageSelector(),
            const SizedBox(height: 16),

            // Available Medicines
            Text(
              'Available medicines',
              style: secondaryTextStyle(),
            ),
            const SizedBox(height: 8),

            availableMedicineSelector(),
            const SizedBox(height: 16),

            // Meal Timing Buttons
            mealSelector(),
            const SizedBox(height: 16),

            // Schedule Checkboxes
            _buildScheduleRow(
              'Morning',
              morningTime,
              isMorningChecked,
            ),
            const SizedBox(height: 8),
            _buildScheduleRow(
              'Noon',
              'Set Alarm',
              isNoonChecked,
            ),
            const SizedBox(height: 8),
            _buildScheduleRow(
              'Night',
              'Set Alarm',
              isNightChecked,
            ),
            const SizedBox(height: 16),

            // Duration Selector
            Text(
              'How many days',
              style: secondaryTextStyle(),
            ),
            const SizedBox(height: 8),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.start,
            //   children: [
            //     IconButton(
            //       onPressed: () {
            //         setState(() {
            //           if (days > 1) days--;
            //         });
            //       },
            //       icon: const Icon(Icons.remove_circle_outline),
            //     ),
            //     Text(
            //       '$days Days',
            //       style: const TextStyle(fontSize: 16),
            //     ),
            //     IconButton(
            //       onPressed: () {
            //         setState(() {
            //           days++;
            //         });
            //       },
            //       icon: const Icon(Icons.add_circle_outline),
            //     ),
            //   ],
            // ),

            Container(
              decoration: boxDecoration(radius: 10, color: AppColors.greyColor),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        if (days > 1) days--;
                      });
                    },
                    icon: const Icon(Icons.remove),
                  ),
                  Text(
                    "$days Days",
                    style: const TextStyle(fontSize: 16),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        days++;
                      });
                    },
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Cancel and Add Medicine Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
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
              setState(() {
                if (availableMedicine > 1) availableMedicine--;
              });
            },
            icon: const Icon(Icons.remove),
          ),
          Text(
            "$availableMedicine Pcs",
            style: const TextStyle(fontSize: 16),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                availableMedicine++;
              });
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
                    setState(() {
                      if (dosage > 1) dosage--;
                    });
                  },
                  icon: const Icon(Icons.remove),
                ),
                Text(
                  dosage.toString(),
                  style: const TextStyle(fontSize: 16),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      dosage++;
                    });
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
  Widget _buildScheduleRow(String timeOfDay, String time, bool isChecked) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Transform.scale(
              scale: 1.4,
              child: Checkbox(
                value: isChecked,
                onChanged: (value) {},
                activeColor: AppColors.primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
            ),
            Text(
              timeOfDay,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
        Row(
          children: [
            const Icon(
              Icons.alarm,
              color: Colors.grey,
            ),
            const SizedBox(width: 8),
            Text(
              time,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ],
    );
  }
}
