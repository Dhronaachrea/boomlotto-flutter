import 'package:boom_lotto/src/common/theme.dart';
import 'package:boom_lotto/src/screens/inbox.screen.dart';
import 'package:flutter/material.dart';

class BellIcon extends StatelessWidget {
  const BellIcon({
    Key? key,
    required this.count,
  }) : super(key: key);

  final int count;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MaterialButton(
          minWidth: 30,
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const InboxScreen(),
              ),
            );
          },
          child: Image.asset('assets/icons/2.0x/bell.png'),
        ),
        count == 0
            ? Container()
            : Positioned(
                top: 7,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    color: ZeplinColors.pink_red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 15,
                    minHeight: 15,
                  ),
                  child: Text(
                    count.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
      ],
    );
  }
}
