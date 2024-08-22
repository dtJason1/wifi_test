import 'package:flutter/material.dart';

class FadeInDemo extends StatefulWidget {
  final Widget child;
  final AnimationController controller;
  FadeInDemo({required this.child, required this.controller});
  _FadeInDemoState createState() => _FadeInDemoState();
}

class _FadeInDemoState extends State<FadeInDemo> with TickerProviderStateMixin {
  late AnimationController _controller;
  late CurvedAnimation _curve;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 1));
    _curve = CurvedAnimation(parent: widget.controller, curve: Curves.easeIn);
    widget.controller.forward();
  }

  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: Offset(0.0, -1.5),
    end: Offset(0.0,0.0),
  ).animate(CurvedAnimation(
    parent: widget.controller,
    curve: Curves.easeInOut,
  ));

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: FadeTransition(
          opacity: _curve,
          child: widget.child
      ),
    );
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }
}
