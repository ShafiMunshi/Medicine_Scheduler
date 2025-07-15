import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class CountdownWithValueNotifier extends StatefulWidget {
  final Duration initialDuration;

  const CountdownWithValueNotifier({super.key, required this.initialDuration});

  @override
  State<CountdownWithValueNotifier> createState() => _CountdownWithValueNotifierState();
}

class _CountdownWithValueNotifierState extends State<CountdownWithValueNotifier> {
  late final ValueNotifier<Duration> durationNotifier;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    durationNotifier = ValueNotifier(widget.initialDuration);

    timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (durationNotifier.value > Duration.zero) {
        durationNotifier.value -= Duration(seconds: 1);
      } else {
        timer?.cancel();
      }
    });
  }

  String format(Duration d) =>
      "Time left: ${d.inHours.toString().padLeft(2, '0')}:${(d.inMinutes % 60).toString().padLeft(2, '0')}";

  @override
  void dispose() {
    timer?.cancel();
    durationNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Duration>(
      valueListenable: durationNotifier,
      builder: (_, duration, __) {
        return Text(
          format(duration),
          style:primaryTextStyle(size: 10),
        );
      },
    );
  }
}