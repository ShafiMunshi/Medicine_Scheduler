import 'package:flutter/material.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key, required this.incoming});

  final List<String> incoming;

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  List<String> _list = [];

  @override
  void initState() {
    addList();
    super.initState();
  }

  addList() {
    _list = widget.incoming;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              _list.add("New data");
            },
            child: Text("Adding")),
      ),
    );
  }
}
