import 'package:flutter/material.dart';

class AltButton extends StatelessWidget {
  final String title;
  final Color bgColor;
  final Color borderColor;
  final Color textColor;
  final Function onPressed;
  final double height;
  final double width;
  final double borderRadius;
  final double fontSize;
  final String fontFamily;
  final double elevation;
  // final Gradient gradient;

  AltButton({
    @required this.title,
    @required this.onPressed,
    @required this.bgColor,
    @required this.borderColor,
    this.textColor = Colors.white,
    this.height = 50,
    this.width = 250,
    this.borderRadius = 0,
    this.fontSize = 26,
    this.fontFamily,
    this.elevation = 0,
    // this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: elevation,
      borderRadius: BorderRadius.circular(borderRadius),
      child: GestureDetector(
        // borderRadius: BorderRadius.circular(borderRadius),
        onTap: onPressed,
        child: Container(
          alignment: Alignment.center,
          height: height,
          width: width,
          decoration: BoxDecoration(
            // gradient: gradient,
            color: bgColor,
            border: Border.all(
              color: borderColor,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: Text(
            title,
            style: TextStyle(
              color: textColor,
              fontSize: fontSize,
              fontFamily: fontFamily,
            ),
          ),
        ),
      ),
    );
  }
}
