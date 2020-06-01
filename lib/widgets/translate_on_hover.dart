import 'package:flutter/material.dart';

class TranslateOnHover extends StatefulWidget {
  @override
  _TranslateOnHoverState createState() => _TranslateOnHoverState();

  final Widget child;

  TranslateOnHover({this.child});
}

class _TranslateOnHoverState extends State<TranslateOnHover> {
  final nonHoveringTraslation = Matrix4.identity();
  final hoveringTraslation = Matrix4.identity()..translate(0, -10, 0);

  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    void _mouseEnter(bool hovering) {
      setState(() {
        _hovering = hovering;
      });
    }

    return MouseRegion(
      onEnter: (_) => _mouseEnter(true),
      onExit: (_) => _mouseEnter(false),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 100),
        child: widget.child,
        transform: _hovering ? hoveringTraslation : nonHoveringTraslation,
      ),
    );
  }
}
