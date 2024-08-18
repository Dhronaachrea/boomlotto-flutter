import 'package:flutter/cupertino.dart';

class ShakeWidget extends StatelessWidget {
  final Duration duration;
  final double deltaX;
  final Widget child;
  final Curve curve;

  const ShakeWidget({
    Key? key,
    this.duration = const Duration(milliseconds: 500),
    this.deltaX = 20,
    this.curve = Curves.bounceOut,
    required this.child,
  }) : super(key: key);

  /// convert 0-1 to 0-1-0
  double shake(double animation) =>
      2 * (0.5 - (0.5 - curve.transform(animation)).abs());

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      key: key,
      tween: Tween(begin: 0.0, end: 1.0),
      duration: duration,
      builder: (context, animation, child) => Transform.translate(
        offset: Offset(deltaX * shake(animation), 0),
        child: child,
      ),
      child: child,
    );
  }
}

class ShakeX extends StatefulWidget {
  const ShakeX({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  _ShakeXState createState() => _ShakeXState();
}

class _ShakeXState extends State<ShakeX> with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Animation<double> offsetAnimation = Tween(begin: 0.0, end: 24.0)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(controller)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reverse();
        }
      });
    controller.forward(from: 0.0);
    return AnimatedBuilder(
      animation: offsetAnimation,
      builder: (context, child) {
        if (offsetAnimation.value < 0.0) {
          print('${offsetAnimation.value + 8.0}');
        }
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 24.0),
          padding: EdgeInsets.only(
              left: offsetAnimation.value + 30.0,
              right: 30.0 - offsetAnimation.value),
          child: child,
        );
      },
    );
  }
}
