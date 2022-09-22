import 'package:flutter/material.dart';

class SignUpFlowButton extends StatefulWidget {
  SignUpFlowButton(
      {required this.buttonText, required this.onPressed,this.textColor, Key? key})
      : super(key: key);

  @override
  State<SignUpFlowButton> createState() => _SignUpFlowButtonState();

  final String buttonText;
  Color? textColor;
  var onPressed;
}

class _SignUpFlowButtonState extends State<SignUpFlowButton> {
  @override
  Widget build(BuildContext context) {
    var ht = MediaQuery.of(context).size.height;
    var wd = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 18, horizontal: 38.0),
      child: Container(
        width: wd / 2,
        decoration: BoxDecoration(
            border: Border.all(color: Color(0xff1FD0C2), width: 3),
            borderRadius: BorderRadius.circular(30)),
        child: TextButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.transparent)),
            child: Text(
              widget.buttonText,
              style: TextStyle(color: widget.textColor?? Colors.white),
            ),
            onPressed: widget.onPressed),
      ),
    );
  }
}
