import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AnimatedAutoAwesomeIcon extends StatefulWidget {
  const AnimatedAutoAwesomeIcon({Key? key}) : super(key: key);

  @override
  _AnimatedAutoAwesomeIconState createState() => _AnimatedAutoAwesomeIconState();
}

class _AnimatedAutoAwesomeIconState extends State<AnimatedAutoAwesomeIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(); // continuously loops
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(

      turns: _controller,
      child: Icon(
        Icons.auto_awesome,
        color: Colors.green.shade700,
        size: 36.r,
      ),
    );
  }
}
