import 'package:flutter/material.dart';

class NTextBox extends StatelessWidget {
  final String text;
  final String sectionName;
  final void Function()? onPressed;

  const NTextBox({super.key, required this.text, required this.sectionName, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // color: Colors.grey[200],
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(8),
      ),
      margin: EdgeInsets.only(left: 20, right: 20, top: 20, ),
      padding: EdgeInsets.only(left: 15, bottom: 15, ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Section name
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(sectionName,
                style: TextStyle(color: Colors.grey[500]),
              ),

              //Edit button
              IconButton(onPressed: onPressed, icon: Icon(Icons.settings)),
            ],
          ),

          //Text
          Text(text,
            overflow: TextOverflow.ellipsis, 
          ),

        ],
      ),
    );
  }
}