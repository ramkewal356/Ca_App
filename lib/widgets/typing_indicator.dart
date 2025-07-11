import 'package:flutter/material.dart';

class TypingIndicator extends StatefulWidget {
  final String name;

  const TypingIndicator({required this.name, super.key});

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _dotOne, _dotTwo, _dotThree;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat();

    _dotOne = Tween<double>(begin: 0, end: 8).animate(
      CurvedAnimation(
          parent: _controller, curve: Interval(0.0, 0.3, curve: Curves.easeIn)),
    );

    _dotTwo = Tween<double>(begin: 0, end: 8).animate(
      CurvedAnimation(
          parent: _controller, curve: Interval(0.3, 0.6, curve: Curves.easeIn)),
    );

    _dotThree = Tween<double>(begin: 0, end: 8).animate(
      CurvedAnimation(
          parent: _controller, curve: Interval(0.6, 1.0, curve: Curves.easeIn)),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget dot(Animation<double> animation, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return Container(
            width: 8,
            height: animation.value,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text("${widget.name} is typing",
            style: TextStyle(fontStyle: FontStyle.italic)),
        dot(_dotOne, Colors.grey),
        dot(_dotTwo, Colors.grey.shade400),
        dot(_dotThree, Colors.blue),
      ],
    );
  }
}
