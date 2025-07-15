import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_scalable_ocr/flutter_scalable_ocr.dart';

class ScanningPage extends StatefulWidget {
  const ScanningPage({
    super.key,
    required this.title,
  });

  final String title;

  @override
  State<ScanningPage> createState() => _ScanningPageState();
}

class _ScanningPageState extends State<ScanningPage> {
  String text = "";
  final StreamController<String> controller = StreamController<String>();
  bool torchOn = false;
  int cameraSelection = 0;
  bool lockCamera = true;
  bool loading = false;
  final GlobalKey<ScalableOCRState> cameraKey = GlobalKey<ScalableOCRState>();

  void setText(value) {
    controller.add(value);
  }

  @override
  void dispose() {
    controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              !loading
                  ? ScalableOCR(
                      key: cameraKey,
                      torchOn: torchOn,
                      cameraSelection: cameraSelection,
                      lockCamera: lockCamera,
                      paintboxCustom: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 4.0
                        ..color = const Color.fromARGB(153, 102, 160, 241),
                      boxLeftOff: 5,
                      boxBottomOff: 2.5,
                      boxRightOff: 5,
                      boxTopOff: 2.5,
                      boxHeight: MediaQuery.of(context).size.height / 3,
                      getRawData: (value) {
                        //inspect(value);
                      },
                      getScannedText: (value) {
                        setText(value);
                        text = value;
                      })
                  : Padding(
                      padding: const EdgeInsets.all(17.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        height: MediaQuery.of(context).size.height / 3,
                        width: MediaQuery.of(context).size.width,
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ),
              StreamBuilder<String>(
                stream: controller.stream,
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  return Result(
                      text: snapshot.data != null ? snapshot.data! : "");
                },
              ),
              ElevatedButton(
                  onPressed: () async {
                    // 1. Capture the final text value
                    final scannedText = text; // Use the state variable 'text'

                    setState(() {
                      loading = true;
                    });

                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      // Ensure the widget is still mounted before popping
                      if (mounted) {
                        Navigator.pop(context, {'data': scannedText});
                      }
                    });
                  },
                  child: Text('Selection Done'))
            ],
          ),
        ));
  }
}

class Result extends StatelessWidget {
  const Result({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text("Readed text: $text");
  }
}
