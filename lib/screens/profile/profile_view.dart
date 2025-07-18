import 'package:flutter/material.dart';
import 'package:medicine_app/data/repository/consume_repository.dart';
import 'package:provider/provider.dart';

class ProfileView extends StatelessWidget {
  static String routeName = '/profile';
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
            ElevatedButton(
                onPressed: () async {
                  await context.read<MedicineConsumeRepository>().clearAllMedicineConsumeLogs();
                },
                child: Text('Clear Medicine Consume Log')),
          ],
        ),
      ),
    );
  }
}
