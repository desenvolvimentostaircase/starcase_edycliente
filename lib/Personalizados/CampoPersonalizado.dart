import 'package:edywasacliente/Cores/cores.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CampoPersonalizado extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final Function()? onSuffixIconTap;
  final IconData? suffixIcon;
  final Color fillColor;
  final Color borderColor;
  final Color focusedBorderColor;
  final TextStyle? hintStyle;
  final TextStyle? textStyle;
  final double width;
  final double height;

  const CampoPersonalizado({
    Key? key,
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.onSuffixIconTap,
    this.suffixIcon,
    required this.fillColor,
    required this.borderColor,
    required this.focusedBorderColor,
    this.hintStyle,
    this.textStyle,
    this.width = 342,
    this.height = 38, required String? Function(dynamic value) validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        style: textStyle ?? GoogleFonts.roboto(fontSize: 17),
        cursorColor: borderColor,
        decoration: InputDecoration(
          filled: true,
          fillColor: fillColor,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              color: borderColor,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              color: focusedBorderColor,
              width: 3,
            ),
          ),
          hintText: hintText,
          hintStyle: hintStyle ??
              GoogleFonts.roboto(
                fontSize: 15,
                color: borderColor.withOpacity(0.5),
              ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 20,
          ),
          suffixIcon: suffixIcon != null
              ? GestureDetector(
                  onTap: onSuffixIconTap,
                  child: Icon(
                    suffixIcon,
                    size: 28,
                    color: azul,
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
