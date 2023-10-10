import 'package:hchat/helper/colors.dart';
import 'package:flutter/material.dart';
// A custom button widget used for the "Read" function in the notification feature
///
/// This widget accepts the following parameters:
///
/// onTap : A required [Function()] that specifies the action to be performed when the button is tapped.
///
/// text : A required [String] that specifies the text to be displayed on the button.
///
/// color : An optional [Color] that sets the background color of the button. If not specified, it defaults to the primary color defined in the colors.dart file.
///
/// colorBorder : An optional [Color] that sets the border color of the button. If not specified, the button has no border.
///
/// textColor : An optional [Color] that sets the color of the button's text. If not specified, it defaults to white.
///
/// height : An optional [double] that specifies the height of the button. If not specified, it defaults to 56.
///
// the custom button for the notification "Read" function
class CustomButton extends StatelessWidget {
  CustomButton({
    required this.onTap,
    this.color = primary,
    required this.text,
    this.colorBorder,
    this.textColor,
    this.height = 56,
    Key? key,
  }) : super(key: key);
  String? text;
  Color? color;
  Function() onTap;
  Color? colorBorder;
  Color? textColor;
  double height;

// build up the read button
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: InkWell(
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          height: height,
          width: double.infinity,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(30),
            border: colorBorder == null
                ? null
                : Border.all(color: colorBorder!, width: 2),
          ),
          child: Text(
            text!,
            style: TextStyle(
              color: textColor ?? Colors.white,
              fontFamily: "Inter",
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
