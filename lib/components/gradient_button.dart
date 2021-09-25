import 'dart:ffi';

import 'package:flutter/material.dart';

class GradientButton extends StatefulWidget {
  final Color color1;
  final Color color2;
  final String text;
  final Color textColor;
  final double width;
  final double height;
  final double borderRadius;
  final onpressed;

  const GradientButton({
     this.color1,
     this.color2,
     this.text,
     this.textColor,
    this.height = 50,
    this.width = 250,
    this.borderRadius = 30,
     this.onpressed,
  });

  @override
  _GradientButtonState createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton>
    with SingleTickerProviderStateMixin {
  double _scale=0;
   AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      duration: Duration(
        milliseconds: 200,
      ),
      lowerBound: 0.0,
      upperBound: 0.1,
      vsync: this,
    )..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _controller.value;
    return GestureDetector(
      onTapUp: _onTapUp,
      onTapDown: _onTapDown,
      onTap: widget.onpressed,
      child: Transform.scale(
        scale: _scale,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [widget.color1, widget.color2],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(widget.borderRadius),
            // boxShadow: [
            //   BoxShadow(
            //     color: Colors.black.withOpacity(0.5),
            //     spreadRadius: 1,
            //     blurRadius: 7,
            //     offset: Offset(1, 5),
            //   ),
            //],
          ),
          constraints: BoxConstraints(
            maxWidth: widget.width,
            minHeight: widget.height,
          ),
          alignment: Alignment.center,
          child: Text(
            widget.text,
            style: TextStyle(
              fontFamily: 'TCM',
              fontSize: 18,
              color: widget.textColor,
            ),
          ),
        ),
      ),
    );
  }
}
