import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:verdant_solar/utils/constants.dart';

// ignore: must_be_immutable
class InputField extends StatelessWidget {
  final controller;
  final String textLabel;
  final TextStyle style;
  final bool hide;
  IconData? icon;
  int? maxLines = 1;
  bool? enabled = true;
  List<TextInputFormatter>? inputFormatters = [];
  TextInputType? keyboardType = TextInputType.name;
  Widget? suffix = Container();

  InputField({
    this.controller,
    required this.textLabel,
    required this.style,
    required this.hide,
    this.icon,
    this.maxLines,
    this.enabled,
    this.inputFormatters,
    this.keyboardType,
    this.suffix,
  });

  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(bottom: 6),
              width: context.width,
              child: Text(
                textLabel.toUpperCase(),
                textAlign: TextAlign.start,
                style: style,
              ),
            ),
            TextField(
              keyboardType: keyboardType,
              inputFormatters: inputFormatters,
              enabled: enabled,
              maxLines: maxLines,
              cursorColor: Colors.grey,
              controller: controller,
              obscureText: hide,
              decoration: InputDecoration(
                fillColor: (enabled!) ? Colors.white : Colors.grey[400],
                filled: true,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                suffix: suffix,
                prefixIcon: (icon != null)
                    ? Icon(
                        icon,
                        color: Color(kSecondaryColor),
                      )
                    : null,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(
                      color: Color(kSecondaryColor).withOpacity(0.8),
                      width: 1.5),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(
                      color: Color(kSecondaryColor).withOpacity(0.8),
                      width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide:
                      BorderSide(color: Color(kSecondaryColor), width: 2),
                ),
              ),
            ),
          ],
        ));
  }
}

// ignore: must_be_immutable
class FormTextField extends StatelessWidget {
  final controller;
  final String textLabel;
  final TextStyle style;
  final bool hide;
  final bool isRequired;
  IconData? icon;
  int? maxLines = 1;
  bool? enabled = true;
  List<TextInputFormatter>? inputFormatters = [];
  TextInputType? keyboardType = TextInputType.name;
  Widget? suffix = Container();
  Function(String)? onChange;

  FormTextField({
    this.controller,
    required this.textLabel,
    required this.style,
    required this.hide,
    required this.isRequired,
    this.icon,
    this.maxLines,
    this.enabled,
    this.inputFormatters,
    this.keyboardType,
    this.suffix,
    this.onChange,
  });

  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 6),
            width: context.width,
            child: Row(
              children: [
                Text(
                  textLabel,
                  textAlign: TextAlign.start,
                  style: style,
                ),
                (isRequired)
                    ? Text(
                        "*",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
          TextField(
            onChanged: onChange,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            enabled: enabled,
            maxLines: maxLines,
            cursorColor: Colors.grey,
            controller: controller,
            obscureText: hide,
            style: TextStyle(fontSize: 14),
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              suffix: suffix,
              prefixIcon: (icon != null)
                  ? Icon(
                      icon,
                      color: Color(kPrimaryColor),
                    )
                  : null,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                borderSide:
                    BorderSide(color: Colors.grey.withOpacity(0.8), width: 1.5),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                borderSide:
                    BorderSide(color: Colors.grey.withOpacity(0.8), width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                borderSide: BorderSide(color: Colors.grey, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
