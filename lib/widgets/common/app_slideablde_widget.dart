import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:isar/isar.dart';
import 'package:medicine_app/app/screens/add_medicine/view/add_new_medicine_view.dart';
import 'package:medicine_app/app/viewmodels/medicine_viewmodels.dart';
import 'package:medicine_app/models/medicine_model.dart';
import 'package:provider/provider.dart';

class AppSlidableWidget extends StatelessWidget {
  const AppSlidableWidget(
      {super.key, required this.child, required this.medicine});

  final Widget child;
  final MedicineModel medicine;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Slidable(
        key: const ValueKey(0),

        // The end action pane is the one at the right or the bottom side.
        endActionPane: ActionPane(
          motion: DrawerMotion(),
          extentRatio: .5,
          closeThreshold: .8,
          openThreshold: .2,
          children: [
            SlidableAction(
              onPressed: (context) => deleteMedicine(medicine.id!, context),
              backgroundColor: Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
              borderRadius: BorderRadius.circular(20),
            ),
            SlidableAction(
              onPressed: (context) => updateMedicine(medicine, context),
              backgroundColor: Color(0xFF21B7CA),
              foregroundColor: Colors.white,
              icon: Icons.edit,
              autoClose: true,
              flex: 1,
              label: 'Edit',
              borderRadius: BorderRadius.circular(20),
            ),
          ],
        ),

        // The child of the Slidable is what the user sees when the
        // component is not dragged.
        child: child,
      ),
    );
  }

  void deleteMedicine(Id id, BuildContext context) async {
    final vm = context.read<MedicineViewmodels>();
    await vm.delete_medicine(id);
  }

  void updateMedicine(MedicineModel medicine, BuildContext context) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => AddNewMedicineScreen(existingMedicine: medicine)));
  }
}


// TODO: Next finish the medicine left count