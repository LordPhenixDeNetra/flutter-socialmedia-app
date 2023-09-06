import 'package:flutter/material.dart';

class NCommentButton extends StatelessWidget {

  final void Function()? onTap;

  const NCommentButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        Icons.comment,
        color: Colors.grey,
      ),
    );
  }
}