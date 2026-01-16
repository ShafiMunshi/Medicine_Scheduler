import 'package:flutter/material.dart';
import 'package:medicine_app/constant/app_color.dart';

class ScheduleTimeWidget extends StatefulWidget {
  ScheduleTimeWidget(
      {super.key,
      required this.timeOfDay,
      required this.time,
      this.isChecked = false,
      required this.showWaterWave,
      required this.onChanged});

  final String timeOfDay, time;
  bool isChecked;

  double defaultScale = 1.4;

  final Function(bool) onChanged;
  final bool showWaterWave;

  @override
  State<ScheduleTimeWidget> createState() => _ScheduleTimeWidgetState();
}

class _ScheduleTimeWidgetState extends State<ScheduleTimeWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 2000));

  @override
  void initState() {
    super.initState();
    _startWaveAnimation();
  }

  void _startWaveAnimation() {
    if (!widget.isChecked) {
      animationController.forward().then((_) {
        if (!widget.isChecked && mounted) {
          animationController.reset();
          _startWaveAnimation();
        }
      });
    }
  }

  @override
  void didUpdateWidget(ScheduleTimeWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isChecked != widget.isChecked) {
      if (!widget.isChecked) {
        _startWaveAnimation();
      } else {
        animationController.stop();
        animationController.reset();
      }
    }
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                // Water wave animation
                if (!widget.isChecked)
                  AnimatedBuilder(
                    animation: animationController,
                    builder: (context, child) {
                      return Container(
                        width: 20 + (animationController.value * 20),
                        height: 20 + (animationController.value * 20),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primaryColor.withValues(
                              alpha: 0.3 - (animationController.value * 0.3)),
                          border: Border.all(
                            color: AppColors.primaryColor.withValues(
                                alpha: 0.5 - (animationController.value * 0.5)),
                            width: 2,
                          ),
                        ),
                      );
                    },
                  ),
                // Checkbox with scale animation
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  transform: Matrix4.identity()
                    ..scale(widget.isChecked ? 1.2 : 1.0),
                  child: Checkbox(
                    value: widget.isChecked,
                    onChanged: (value) {
                      setState(() {
                        widget.isChecked = value!;
                      });

                      if (value != null) {
                        widget.onChanged(value);
                      }
                    },
                    activeColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                ),
              ],
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
