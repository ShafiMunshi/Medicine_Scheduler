import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:medicine_app/data/database/app_database.dart';
import 'package:medicine_app/screens/add_medicine/view/add_new_medicine_view.dart';
import 'package:medicine_app/viewmodels/medicine_viewmodel.dart';

class AppSlidableWidget extends ConsumerWidget {
  const AppSlidableWidget({
    super.key,
    required this.child,
    required this.medicine,
  });

  final Widget child;
  final MedicineWithSchedules medicine;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Slidable(
        key: ValueKey(medicine.medicine.id),
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          extentRatio: .5,
          closeThreshold: .8,
          openThreshold: .2,
          children: [
            SlidableAction(
              onPressed: (context) {
                ref
                    .read(medicineControllerProvider.notifier)
                    .deleteMedicine(medicine.medicine.id);
              },
              backgroundColor: const Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
              borderRadius: BorderRadius.circular(20),
            ),
            SlidableAction(
              onPressed: (context) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddNewMedicineScreen(existingMedicine: medicine),
                  ),
                );
              },
              backgroundColor: const Color(0xFF21B7CA),
              foregroundColor: Colors.white,
              icon: Icons.edit,
              autoClose: true,
              flex: 1,
              label: 'Edit',
              borderRadius: BorderRadius.circular(20),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}
