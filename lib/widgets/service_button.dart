import 'package:flutter/material.dart';

class ServiceButton extends StatefulWidget {
  const ServiceButton(
      {required this.buttonText,
      this.width,
      this.height,
      this.fontSize,
      this.onTap,
      this.color,
      Key? key})
      : super(key: key);

  @override
  State<ServiceButton> createState() => _ServiceButtonState();
  final String buttonText;
  final double? width;
  final double? height;
  final VoidCallback? onTap;
  final double? fontSize;
  final Color? color;
}

class _ServiceButtonState extends State<ServiceButton> {
  @override
  Widget build(BuildContext context) {
    var wd = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: SizedBox(
        width: widget.width ?? wd / 1.25,
        height: widget.height ?? 50,
        child: ElevatedButton(
          onPressed: widget.onTap ?? () {

          },
          child: Text(
            widget.buttonText,
            style: TextStyle(
                color: Colors.black87, fontSize: widget.fontSize ?? 18),
          ),
          style: ButtonStyle(
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40))),
              side: MaterialStateProperty.all(
                  const BorderSide(color: Color(0xff1FD0C2), width: 2)),
              backgroundColor: MaterialStateProperty.all(Colors.white)
          ),
        ),
      ),
    );
  }
}
