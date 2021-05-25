import 'package:appraisal/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class MyTextField extends StatelessWidget {
  final String label;
  final String hint;
  final bool showLabel;
  final Icon icon;
  final TextEditingController controller;
  bool obscure;
  bool readOnly;
  MyTextField(
      {Key key,
      this.label,
      this.hint,
      this.showLabel,
      this.icon,
      this.controller,
      this.obscure = false,
      this.readOnly = false})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        showLabel
            ? Align(
                alignment: Alignment.topLeft,
                child: Text(
                  label,
                  style: TextStyle(
                      color: Color(k_orange_color),
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0),
                ),
              )
            : SizedBox(),
        SizedBox(
          height: showLabel ? 5.0 : 0,
        ),
        Container(
          height: 50.0,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                readOnly: readOnly,
                obscureText: obscure,
                controller: controller,
                decoration: InputDecoration(
                  icon: icon,
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  contentPadding:
                      EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                  hintText: hint,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
