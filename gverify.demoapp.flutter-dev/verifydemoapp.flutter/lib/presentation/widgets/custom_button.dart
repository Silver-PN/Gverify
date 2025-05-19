import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xverifydemoapp/core/constants/text_style.dart';

class CustomButton extends StatelessWidget{
  const CustomButton({Key? key, required this.onPressed,required this.content}) : super(key: key);
  final VoidCallback onPressed;
  final String content;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: SizedBox(
        width: double.infinity,
        height: 46.0,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            textStyle: const TextStyle(fontSize: 15.0),
          ),
          child: Text(content, style: mediumTextStyle(15, Colors.white)),
        ),
      ),
    );
  }

}