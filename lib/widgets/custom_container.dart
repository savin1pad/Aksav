// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:journey/global/constants.dart';

class CustomContainer extends StatefulWidget {
  final String title;
  final IconData icon;
  final double height;
  final double width;
  final bool showShadow;
  final double textSize;
  final Color color;
  final Color textColor;
  const CustomContainer({
    Key? key,
    required this.title,
    required this.icon,
    required this.height,
    required this.width,
    required this.showShadow,
    required this.textSize,
    required this.color,
    required this.textColor,
  }) : super(key: key);

  @override
  State<CustomContainer> createState() => _CustomContainerState();
}

class _CustomContainerState extends State<CustomContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: Colors.grey),
        gradient: LinearGradient(
          colors: [
            const Color(0xffF6F0C4),
            ConstantVars.maintheme,
          ],
          stops: const [0, 0],
          begin: FractionalOffset.bottomRight,
          end: FractionalOffset.topLeft,
        ),
        boxShadow: [
          widget.showShadow
              ? const BoxShadow(
                  color: Colors.grey,
                  blurRadius: 4.0,
                  spreadRadius: 1,
                  offset: Offset(0, 1),
                )
              : const BoxShadow(),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            widget.icon,
            color: Colors.white,
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: Text(
              widget.title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                // height: widget.textSize,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomContainer2 extends StatefulWidget {
  final String title;
  final IconData icon;
  final double height;
  final double width;
  final bool showShadow;
  final double textSize;
  final Color color;
  final Color textColor;
  const CustomContainer2({
    Key? key,
    required this.title,
    required this.icon,
    required this.height,
    required this.width,
    required this.showShadow,
    required this.textSize,
    required this.color,
    required this.textColor,
  }) : super(key: key);

  @override
  State<CustomContainer2> createState() => _CustomContainer2State();
}

class _CustomContainer2State extends State<CustomContainer2> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: Colors.grey),
        gradient: const LinearGradient(
          colors: [
            Colors.white,
            Colors.white,
          ],
          stops: [0, 0],
          begin: FractionalOffset.bottomRight,
          end: FractionalOffset.topLeft,
        ),
        boxShadow: [
          widget.showShadow
              ? const BoxShadow(
                  color: Colors.grey,
                  blurRadius: 4.0,
                  spreadRadius: 1,
                  offset: Offset(0, 1),
                )
              : const BoxShadow(),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            widget.icon,
            color: const Color(0xff356cf6),
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: Text(
              widget.title,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Color(0xff356cf6),
                // foreground: Paint()..shader = linearGradient2,
                // height: widget.textSize,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomContainerIcon extends StatefulWidget {
  final String title;
  final IconData icon;
  final double height;
  final double width;
  final bool showShadow;
  final double textSize;
  final Color color;
  final Color textColor;
  const CustomContainerIcon({
    Key? key,
    required this.title,
    required this.icon,
    required this.height,
    required this.width,
    required this.showShadow,
    required this.textSize,
    required this.color,
    required this.textColor,
  }) : super(key: key);

  @override
  State<CustomContainerIcon> createState() => _CustomContainerIconState();
}

class _CustomContainerIconState extends State<CustomContainerIcon> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: Colors.grey),
        gradient: const LinearGradient(
          colors: [
            Colors.white,
            Colors.white,
          ],
          stops: [0, 0],
          begin: FractionalOffset.bottomRight,
          end: FractionalOffset.topLeft,
        ),
        boxShadow: [
          widget.showShadow
              ? const BoxShadow(
                  color: Colors.grey,
                  blurRadius: 4.0,
                  spreadRadius: 1,
                  offset: Offset(0, 1),
                )
              : const BoxShadow(),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            widget.icon,
            color: const Color(0xff356cf6),
          ),
        ],
      ),
    );
  }
}
