import 'package:flutter/material.dart';
import 'package:medicine_app/data/repository/consume_repository.dart';
import 'package:medicine_app/data/source/my_shared_pref.dart';
import 'package:provider/provider.dart';

class SettingsView extends StatelessWidget {
  static String routeName = '/settings_view';
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              child: ListTile(
                title: Text('Clear Medicine Consume Log'),
                onTap: () async {
                  await context
                      .read<MedicineConsumeRepository>()
                      .clearAllMedicineConsumeLogs();
                },
              ),
            ),
            Card(
              child: ListTile(
                title: Text('Clear Shared Pref Log'),
                onTap: () async {
                  await MySharedPref.clear();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
