import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final GestureTapCallback onPressed;
  final String textLabel;
  final Color color;
  final Color? outline;
  final double? radius;
  final Color textColor;
  final double btnHeight;
  final TextStyle style;

  Button({
    required this.onPressed,
    required this.textLabel,
    required this.color,
    required this.textColor,
    required this.btnHeight,
    required this.style,
    this.outline,
    this.radius,
  });

  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          EdgeInsets.symmetric(vertical: btnHeight),
        ),
        backgroundColor: MaterialStateProperty.all<Color>(color),
        foregroundColor: MaterialStateProperty.all<Color>(textColor),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: (radius != null)
                ? BorderRadius.circular(radius!)
                : BorderRadius.circular(10.0),
            side: BorderSide(
              color: (outline != null) ? outline! : color,
            ),
          ),
        ),
      ),
      child: FittedBox(
        fit: BoxFit.contain,
        child: Text(
          textLabel,
          style: style,
        ),
      ),
    );
  }
}
