import 'package:flutter/material.dart';
import 'package:medicine_app/constant/app_color.dart';

class ScheduleTimeWidget extends StatefulWidget {
  ScheduleTimeWidget(
      {super.key,
      required this.timeOfDay,
      required this.time,
      this.isChecked = false,
      required this.onChanged});

  final String timeOfDay, time;
  bool isChecked;

  final Function(bool) onChanged;

  @override
  State<ScheduleTimeWidget> createState() => _ScheduleTimeWidgetState();
}

class _ScheduleTimeWidgetState extends State<ScheduleTimeWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Transform.scale(
              scale: 1.4,
              child: Checkbox(
                value: widget.isChecked,
                onChanged: (value) {
                  print("Checkbox changed: $value");
                  // Update the state of the checkbox
                  setState(() {
                    widget.isChecked = value!;
                  });

                  if(value!=null) {
                    widget.onChanged(value);// Notify parent{
                  }
                },
                activeColor: AppColors.primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
            ),
            Text(
              widget.timeOfDay,
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
              widget.time,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ],
    );
  }
}
