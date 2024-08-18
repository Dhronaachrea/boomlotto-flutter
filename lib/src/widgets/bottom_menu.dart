import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class BottomNavigationView extends StatelessWidget {
  const BottomNavigationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: const BoxDecoration(
        color: Colors.deepOrangeAccent,
        borderRadius: BorderRadius.all(Radius.circular(40.0)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const <Widget>[
          TabItem(
            icon: Icons.home,
            text: 'Home',
          ),
          TabItem(
            icon: Icons.emoji_emotions,
            text: 'Boom5',
          ),
          TabItem(
            icon: Icons.add_circle,
          ),
          TabItem(
            icon: CupertinoIcons.bolt_fill,
            text: 'Instant Win',
          ),
          TabItem(
            icon: Icons.person,
            text: 'Our Winners',
          ),
        ],
      ),
    ).p20();
  }
}

class TabItem extends StatelessWidget {
  final IconData icon;
  final String? text;
  const TabItem({
    Key? key,
    required this.icon,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Icon(
          icon,
          size: 30,
          color: Colors.white,
        ),
        text != null
            ? Text(
                text!,
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                ),
              )
            : Container(),
      ],
    );
  }
}
