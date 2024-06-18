import 'package:flutter/material.dart';
import 'dart:math' as math;

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.child,
    required this.onTap,
  });

  final Widget child;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Transform.rotate(
        angle: math.pi / 4,
        child: Container(
          width: 60.0,
          height: 60.0,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(23.0),
          ),
          child: Transform.rotate(
            angle: -math.pi / 4,
            child: child,
          ),
        ),
      ),
    );
  }
}
