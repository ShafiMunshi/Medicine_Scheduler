import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medicine_app/config/app_styles.dart';
import 'package:medicine_app/constant/app_color.dart';
import 'package:medicine_app/models/medicine_consumption_model.dart';
import 'package:medicine_app/models/medicine_model.dart';
import 'package:medicine_app/screens/auth/component/common_fn.dart';
import 'package:medicine_app/screens/schedule/schedule_time_widget.dart';
import 'package:medicine_app/viewmodels/medicine_viewmodels.dart';
import 'package:medicine_app/viewmodels/schedule_viewmodels.dart';
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
  int quantity = 0;
  int currentPage = 0;

  @override
  void initState() {
    pageController = PageController();
    getTodaysMedicineAndConsumeData();
    super.initState();
  }

  void getTodaysMedicineAndConsumeData() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MedicineViewmodels>().get_todays_medicine();
      context.read<ScheduleViewmodels>().get_all_medicine_consume_data();
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBarWidget(context,
          title: 'Medicine Schedule',
          changeIcon: true,
          iconWidget1: SvgPicture.asset('assets/icons/edit_square.svg')
              .paddingRight(20)),
      body: Consumer<MedicineViewmodels>(builder: (_, vmMedicine, __) {
        if (vmMedicine.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (vmMedicine.todaysMedicines.isEmpty) {
          return const Center(child: Text("No Medicine Found For Today"));
        }

        return Consumer<ScheduleViewmodels>(builder: (_, vmSchedule, __) {
          if (vmSchedule.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (pageController.hasClients &&
                pageController.page != currentPage) {
              pageController.jumpToPage(currentPage);
            }
          });

          return PageView.builder(
            controller: pageController,
            onPageChanged: (index) {
              currentPage = index;
            },
            itemCount: vmMedicine.todaysMedicines.length,
            itemBuilder: (context, index) {
              return eachMedicine(
                medicine: vmMedicine.todaysMedicines[index],
                index: index,
                vmSchedule: vmSchedule,
                vmMedicine: vmMedicine,
              );
            },
          );
        });
      }),
    );
  }

  SingleChildScrollView eachMedicine({
    required MedicineModel medicine,
    required int index,
    required ScheduleViewmodels vmSchedule,
    required MedicineViewmodels vmMedicine,
  }) {
    final mediConsume =
        vmSchedule.get_todays_medicine_consume_data_list(medicine.id!);

    return SingleChildScrollView(
      child: Padding(
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
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14),
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
                          '${medicine.medicineScheduleList?.length ?? 0} times',
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
                  medicine.medicineScheduleList?.length ?? 0, (index) {
                final mediScheduleTime =
                    medicine.medicineScheduleList?[index].dayTime;

                final isChecked = mediConsume?.any((consume) =>
                        consume.status == ConsumptionStatus.taken &&
                        consume.scheduledDateTime.hour ==
                            mediScheduleTime?.hour &&
                        consume.scheduledDateTime.minute ==
                            mediScheduleTime?.minute) ??
                    false;

                return ScheduleTimeWidget(
                  timeOfDay:
                      medicine.medicineScheduleList?[index].dayTimeName ?? '',
                  time: formatTimeOfDayTo12Hour(
                      medicine.medicineScheduleList?[index].dayTime ??
                          TimeOfDay.now(),
                      context),
                  isChecked: isChecked,
                  onChanged: (isTaken) async {
                    final now = DateTime.now();
                    final consumeModel = mediConsume?.firstWhere(
                        (consume) =>
                            consume.scheduledDateTime.hour ==
                                mediScheduleTime?.hour &&
                            consume.scheduledDateTime.minute ==
                                mediScheduleTime?.minute,
                        orElse: () => MedicineConsumeLogModel(
                              medicineId: medicine.id!,
                              dosageTaken: medicine.dosage,
                              status: isTaken
                                  ? ConsumptionStatus.taken
                                  : ConsumptionStatus.missed,
                              scheduledDateTime: DateTime(
                                  now.year,
                                  now.month,
                                  now.day,
                                  mediScheduleTime!.hour,
                                  mediScheduleTime.minute),
                              actualTakenTime: isTaken
                                  ? DateTime(now.year, now.month, now.day,
                                      now.hour, now.minute)
                                  : null,
                            ));

                    log("Is checked: $isChecked");
                    log("Is taken: $isTaken");

                    log("Consume Model: $consumeModel");
                    // Update the medicine consumption log

                    if (consumeModel != null) {
                      if (isTaken) {
                        await vmSchedule.update_medicine_consume_data(
                            medicine.id!, consumeModel, medicine);
                      } else {
                        // Revert the consume data if unchecked
                        final updatedConsumeModel = consumeModel.copyWith(
                          status: ConsumptionStatus.missed,
                          actualTakenTime: null,
                        );

                        await vmSchedule.revert_updated_medicine_consume_data(
                            medicine.id!, updatedConsumeModel, medicine);
                      }

                      await vmMedicine.get_all_medicine();
                    }
                  },
                );
              }),
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
                            setState(() {
                              if (quantity > 0) quantity--;
                            });
                          },
                          icon: const Icon(Icons.remove),
                        ),
                        Text(
                          '$quantity Pcs',
                          style: const TextStyle(fontSize: 16),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              quantity++;
                            });
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
                  child: InkWell(
                    onTap: () async {
                      final updatedMedicine = medicine.copyWith(
                        availableQuantity:
                            medicine.availableQuantity + quantity,
                      );
                      await context.read<MedicineViewmodels>().update_medicine(
                            updatedMedicine,
                          );

                      setState(() {
                        quantity = 0; // Reset quantity after adding
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: double.maxFinite,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 14),
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
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  color: AppColors.primaryColor,
                  size: 15,
                ),
                8.horizontalSpace,
                Text(
                  'Estimated Need',
                  style: secondaryTextStyle(size: 11),
                ),
                5.horizontalSpace,
                Text(
                  '${getTotalEstimatedMedicine(medicine)} Pcs',
                  style:
                      primaryTextStyle(size: 11, color: AppColors.primaryColor),
                )
              ],
            ),
            const SizedBox(height: 10),
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
      ),
    );
  }

  String getRandomMedicineImage(int index) {
    final rand = index % 3 + 1;
    return 'assets/images/medicine_$rand.png';
  }

  // get total estimated medicine will take by the user.
  int getTotalEstimatedMedicine(MedicineModel model) {
    return (model.medicineScheduleList?.length ?? 1) *
        model.dosage *
        (model.finalScheduleDates?.length ?? 1);
  }
}

// TODO: Mark medicine as taken to Medicine Consumption Model and track when when took medicine and when didn't
// TODO: Fix quantity issue, currently it is not updating the quantity in Medicine Model
