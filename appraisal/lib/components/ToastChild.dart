import 'package:flutter/material.dart';

Widget ToastChild(
    {String text,
    Icon icon,
    Color backgroundColor = Colors.greenAccent,
    Color textColor = Colors.black}) {
  return Card(
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        //borderRadius: BorderRadius.circular(25.0),
        color: backgroundColor,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          SizedBox(
            width: 12.0,
          ),
          Text(
            text,
            style: TextStyle(color: textColor),
          ),
        ],
      ),
    ),
  );
}
