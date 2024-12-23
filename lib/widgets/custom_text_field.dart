import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.textEditingController,
    required this.onPlaceSelect,
  });

  final TextEditingController textEditingController;
  final void Function() onPlaceSelect;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textEditingController,
      decoration: InputDecoration(
        hintText: 'Search here',
        filled: true,
        fillColor: Colors.white,
        border: buildBorder(),
        enabledBorder: buildBorder(),
        focusedBorder: buildBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 16),
        suffixIcon: textEditingController.text.isEmpty
            ? null
            : IconButton(
                onPressed: onPlaceSelect,
                icon: const Icon(Icons.clear),
              ),
      ),
    );
  }

  OutlineInputBorder buildBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(24),
      borderSide: const BorderSide(color: Colors.transparent),
    );
  }
}
