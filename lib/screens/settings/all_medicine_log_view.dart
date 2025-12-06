import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:medicine_app/models/medicine_consumption_model.dart';
import 'package:medicine_app/models/medicine_model.dart';
import 'package:medicine_app/viewmodels/medicine_viewmodels.dart';
import 'package:medicine_app/viewmodels/schedule_viewmodels.dart';
import 'package:provider/provider.dart';

class AllMedicineLogView extends StatefulWidget {
  const AllMedicineLogView({super.key});

  @override
  State<AllMedicineLogView> createState() => _AllMedicineLogViewState();
}

class _AllMedicineLogViewState extends State<AllMedicineLogView> {
  List<MedicineModel> allMedicines = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = context.read<MedicineViewmodels>();

      vm.get_all_medicine();
      allMedicines = vm.medicines;
      setState(() {});
    });
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final vmS = context.read<ScheduleViewmodels>();
    return Scaffold(
      appBar: AppBar(
        title: Text('All Medicine Log View'),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: allMedicines.length,
          itemBuilder: (context, index) {
            final medicine = allMedicines[index];
            return ListTile(
                title: Text(medicine.medicineName),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Dosage: ${medicine.dosage} ${medicine.dosageUnit}'),
                    Text(
                        'Available Qty: ${medicine.availableQuantity} ${medicine.dosageUnit}'),
                    FutureBuilder(
                      future:
                          vmS.get_specific_medicine_consume_data(medicine.id!),
                      // initialData: InitialData,
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        }

                        if (snapshot.hasData) {
                          final List<MedicineConsumeLogModel> logs =
                              snapshot.data;

                          log("Logs Length for ${medicine.medicineName}: ${logs.length}");
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Consumption Logs:'),
                              ...logs.map<Widget>((log) {
                                return Text(
                                    '- Taken at: ${log.actualTakenTime} Schedule : ${log.scheduledDateTime}');
                              }).toList(),
                            ],
                          );
                        }
                        return SizedBox();
                      },
                    ),
                  ],
                ));
          },
        ),
      ),
    );
  }
}
