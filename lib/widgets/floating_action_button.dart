import 'package:flutter/material.dart';


class FloatingActionButtonWidget extends StatelessWidget {
  const FloatingActionButtonWidget({super.key, required this.getCurrentLocationFun});

  final void Function() getCurrentLocationFun;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
          backgroundColor: Colors.green,
          onPressed: getCurrentLocationFun,
          child: const Icon(Icons.gps_fixed),
        ),
      ],
    );
  }
}