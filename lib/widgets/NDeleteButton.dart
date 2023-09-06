import 'package:flutter/material.dart';

class NDeleteButton extends StatelessWidget {
  final void Function()? onTap;
  const NDeleteButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        Icons.cancel,
        color: Colors.grey,
      ),
    );
  }
}