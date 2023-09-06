import 'package:flutter/material.dart';

class NListTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final Function()? onTap;

  const NListTile({super.key, required this.icon, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 10),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: Colors.white,),
        title: Text(text, style: TextStyle(color: Colors.white),),
        
      ),
    );
  }
}