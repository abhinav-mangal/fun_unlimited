import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const defaultImage =
    "https://firebasestorage.googleapis.com/v0/b/instagram-clone-2f0f9.appspot.com/o/default%2Fdefault.png?alt=media&token=3b0b0b0e-3b1f-4b1f-8b1f-3b1f3b1f3b1f";

Widget tapper({required Function() onTap, required Widget child}) {
  return CupertinoButton(
    padding: EdgeInsets.zero,
    onPressed: onTap,
    child: child,
  );
}

class AnimatedButton extends StatefulWidget {
  final GestureTapCallback onPressed;
  final Widget child;
  final bool enabled;
  final Color color;
  final double height;
  final double width;
  final Color color1;
  final Color color2;
  final ShadowDegree shadowDegree;
  final int duration;
  final BoxShape shape;
  final double radius;

  const AnimatedButton({
    Key? key,
    required this.onPressed,
    required this.child,
    this.enabled = true,
    this.color = Colors.blue,
    this.height = 64,
    this.shadowDegree = ShadowDegree.light,
    this.width = 200,
    this.color1 = Colors.red,
    this.color2 = Colors.purple,
    this.duration = 70,
    this.radius = 30,
    this.shape = BoxShape.rectangle,
  }) : super(key: key);

  @override
  _AnimatedButtonState createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> {
  static const Curve _curve = Curves.easeIn;
  static const double _shadowHeight = 4;
  double _position = 4;

  @override
  Widget build(BuildContext context) {
    final double height = widget.height - _shadowHeight;

    return GestureDetector(
      // width here is required for centering the button in parent
      onTapDown: widget.enabled ? _pressed : null,
      onTapUp: widget.enabled ? _unPressedOnTapUp : null,
      onTapCancel: widget.enabled ? _unPressed : null,
      // width here is required for centering the button in parent
      child: SizedBox(
        width: widget.width,
        height: height + _shadowHeight,
        child: Stack(
          children: <Widget>[
            // background shadow serves as drop shadow
            // width is necessary for bottom shadow
            Positioned(
              bottom: 0,
              child: Container(
                height: height,
                width: widget.width,
                decoration: BoxDecoration(
                  color: widget.enabled
                      ? darken(widget.color, widget.shadowDegree)
                      : darken(Colors.grey, widget.shadowDegree),
                  borderRadius: widget.shape != BoxShape.circle
                      ? BorderRadius.all(
                          Radius.circular(widget.radius),
                        )
                      : null,
                  shape: widget.shape,
                ),
              ),
            ),
            AnimatedPositioned(
              curve: _curve,
              duration: Duration(milliseconds: widget.duration),
              bottom: _position,
              child: Container(
                height: height,
                width: widget.width,
                decoration: BoxDecoration(
                  color: widget.enabled ? widget.color : Colors.grey,
                  borderRadius: widget.shape != BoxShape.circle
                      ? BorderRadius.all(
                          Radius.circular(widget.radius),
                        )
                      : null,
                  gradient: LinearGradient(
                    colors: [
                      widget.color1,
                      widget.color2,
                    ],
                  ),
                  shape: widget.shape,
                ),
                child: Center(
                  child: widget.child,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _pressed(_) {
    setState(() {
      _position = 0;
    });
  }

  void _unPressedOnTapUp(_) => _unPressed();

  void _unPressed() {
    setState(() {
      _position = 4;
    });
    widget.onPressed();
  }
}

// Get a darker color from any entered color.
// Thanks to @NearHuscarl on StackOverflow
Color darken(Color color, ShadowDegree degree) {
  double amount = degree == ShadowDegree.dark ? 0.3 : 0.12;
  final hsl = HSLColor.fromColor(color);
  final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

  return hslDark.toColor();
}

enum ShadowDegree { light, dark }

class Debouncer {
  Timer? _timer;
  void run(VoidCallback action) {
    if (_timer?.isActive ?? false) {
      _timer?.cancel();
      log("Cancelled");
    }
    _timer = Timer(const Duration(milliseconds: 500), action);
  }
}
