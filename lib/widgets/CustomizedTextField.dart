import 'package:flutter/material.dart';
import 'package:gasna_user/brand_colors.dart';

class CustomizedTextField extends StatelessWidget {
  const CustomizedTextField({
    Key key,
    @required this.controller,
    @required this.hint,
  }) : super(key: key);

  final TextEditingController controller;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.name,
      textAlign: TextAlign.end,
      style: TextStyle(color: Colors.black, fontSize: 18),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(15.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide:
              BorderSide(color: BrandColors.colorTextSemiLight, width: 0.7),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: BrandColors.colorTextSemiLight, width: 0.7),
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: BrandColors.colorAccent, width: 1.2),
          borderRadius: BorderRadius.circular(10.0),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red, width: 0.7),
          borderRadius: BorderRadius.circular(10.0),
        ),
        filled: true,
        fillColor: Colors.white,
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 18),
      ),
      controller: controller,
    );
  }
}
