import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medicine_app/config/app_styles.dart';
import 'package:medicine_app/constant/app_color.dart';
import 'package:medicine_app/models/medicine_model.dart';
import 'package:medicine_app/screens/auth/component/common_fn.dart';
import 'package:medicine_app/viewmodels/medicine_viewmodels.dart';
import 'package:medicine_app/widgets/common/common_fn.dart';
import 'package:medicine_app/widgets/common_extension.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class ScheduleView extends StatefulWidget {
  static const String routeName = '/schedule_screen';
  const ScheduleView({super.key});

  @override
  State<ScheduleView> createState() => _ScheduleViewState();
}

class _ScheduleViewState extends State<ScheduleView> {
  late PageController pageController;

  @override
  void initState() {
    pageController = PageController();
    getTodaysMedicine();
    super.initState();
  }

  void getTodaysMedicine() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MedicineViewmodels>().get_todays_medicine();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBarWidget(context,
          title: 'Medicine Schedule',
          changeIcon: true,
          iconWidget1: SvgPicture.asset('assets/icons/edit_square.svg')
              .paddingRight(20)),
      body: Consumer<MedicineViewmodels>(builder: (_, vm, __) {
        if (vm.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (vm.todaysMedicines.isEmpty) {
          return const Center(child: Text("No Medicine Found For Today"));
        }

        return PageView(
          controller: pageController,
          children: List.generate(
              vm.todaysMedicines.length,
              (index) => eachMedicine(
                  medicine: vm.todaysMedicines[index], index: index)),
        );
      }),
    );
  }

  Padding eachMedicine({required MedicineModel medicine, required int index}) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Medication Info
          Center(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {
                          pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.linear);
                        },
                        icon: Icon(Icons.arrow_back_ios_new_outlined)),
                    Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        CircleAvatar(
                          radius: 70.r,
                          backgroundColor: AppColors.secondaryColor,
                          child: CircleAvatar(
                            radius: 68.r,
                            backgroundImage: AssetImage(
                              getRandomMedicineImage(index),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 7.0),
                          decoration: BoxDecoration(
                            color: AppColors.secondaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            medicine.mealTiming == MealTiming.before
                                ? 'Before meal'
                                : 'After meal',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                        onPressed: () {
                          pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.linear);
                        },
                        icon: Icon(Icons.arrow_forward_ios_rounded)),
                  ],
                ),
                15.verticalSpace,
                Text(
                  medicine.medicineName,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // const Text(
                //   'Beximco Pharmaceuticals Ltd.',
                //   style: TextStyle(
                //     fontSize: 14,
                //     color: Colors.grey,
                //   ),
                // ),
                15.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Every day',
                      style: boldTextStyle(size: 18),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 4.0),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${medicine.scheduleTimes.length} times',
                        style: boldTextStyle(color: white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),

          Column(
            spacing: 8,
            children: List.generate(
                medicine.medicineScheduleList?.length ?? 0,
                (index) => _buildScheduleRow(
                    medicine.medicineScheduleList?[index].dayTimeName ?? '',
                    timeOfDayToString(
                        medicine.medicineScheduleList?[index].dayTime ??
                            TimeOfDay.now()),
                    index == 0)),
          ),

          const SizedBox(height: 16),

          // Add More Medicines Link
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Add more medicines',
                style: secondaryTextStyle(),
              ),
              Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    color: AppColors.primaryColor,
                    size: 15,
                  ),
                  8.horizontalSpace,
                  Text(
                    'Available',
                    style: secondaryTextStyle(size: 11),
                  ),
                  5.horizontalSpace,
                  Text(
                    '${medicine.availableQuantity} Pcs',
                    style: primaryTextStyle(
                        size: 11, color: AppColors.primaryColor),
                  )
                ],
              )
            ],
          ),
          10.verticalSpace,

          // Quantity Selector
          Row(
            children: [
              Flexible(
                flex: 2,
                child: Container(
                  decoration:
                      boxDecoration(radius: 10, color: AppColors.greyColor),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          // setState(() {
                          //   if (quantity > 0) quantity--;
                          // });
                        },
                        icon: const Icon(Icons.remove),
                      ),
                      Text(
                        '0 Pcs',
                        style: const TextStyle(fontSize: 16),
                      ),
                      IconButton(
                        onPressed: () {
                          // setState(() {
                          //   if (quantity < 50) quantity++;
                          // });
                        },
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                ),
              ),
              20.horizontalSpace,
              Flexible(
                flex: 1,
                child: Container(
                  alignment: Alignment.center,
                  width: double.maxFinite,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'Add',
                    style: boldTextStyle(color: white, size: 15),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // I Have Taken Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'I have taken medicine',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String getRandomMedicineImage(int index) {
    final rand = index % 3 + 1;
    return 'assets/images/medicine_$rand.png';
  }

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
