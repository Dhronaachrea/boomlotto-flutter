import 'package:boom_lotto/src/common/theme.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class ThemeButton extends StatelessWidget {
  final String? text;
  final VoidCallback onPressed;
  final bool? enabled;
  final Widget? child;
  final borderRadius;

  const ThemeButton({
    Key? key,
    this.text,
    required this.onPressed,
    this.enabled,
    this.child,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 51,
      width: context.screenWidth - 40,
      margin: const EdgeInsets.symmetric(vertical: 18),
      child: ElevatedButton(
        onPressed: onPressed,
        style: enabled == true
            ? ElevatedButton.styleFrom(
                primary: ZeplinColors.pink_red,
                onPrimary: Colors.white,
                shadowColor: ZeplinColors.pink_red_opaque,
                elevation: 10.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius ?? 35),
                ),
              )
            : ElevatedButton.styleFrom(
                primary: ZeplinColors.pink_red_33,
                onPrimary: Colors.white,
                shadowColor: Colors.transparent,
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(35.0),
                ),
              ),
        child: text != null
            ? Center(
                child: Text(
                  text!,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              )
            : child,
      ),
    );
  }
}
