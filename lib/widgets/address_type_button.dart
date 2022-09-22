import 'package:flutter/material.dart';

class AddressTypeButton extends StatefulWidget {
  const AddressTypeButton(
      {required this.title,
      required this.selected,
      required this.onTap,
      Key? key})
      : super(key: key);

  final String title;
  final bool selected;
  final VoidCallback onTap;
  @override
  State<AddressTypeButton> createState() => _AddressTypeButtonState();
}

class _AddressTypeButtonState extends State<AddressTypeButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              height: 28,
              width: 28,
              child: Image.asset(
                widget.title == "Home"
                    ? "assets/icons/icons_png/061-home.png"
                    : widget.title == "Office"
                        ? "assets/icons/icons_png/062-office.png"
                        : "assets/icons/icons_png/063-building.png",
                color: const Color(0xff38456C),
              ),
            ),
            Text(
              widget.title,
              style: const TextStyle(fontSize: 14),
            ),
            Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xff38456C), width: 2),
                shape: BoxShape.circle,
              ),
              child: widget.selected
                  ? Container(
                      height: 12,
                      width: 12,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 1),
                          shape: BoxShape.circle,
                          color: const Color(0xff38456C)),
                    )
                  : Container(),
            ),
          ],
        ),
      ),
    );
  }
}
