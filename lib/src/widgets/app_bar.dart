import 'dart:convert';
import 'package:boom_lotto/src/common/shared.dart';
import 'package:boom_lotto/src/common/theme.dart';
import 'package:boom_lotto/src/constants/strings.dart';
import 'package:boom_lotto/src/widgets/bell_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyAppBar extends StatefulWidget {
  const MyAppBar({
    this.myKey,
    Key? key,
    this.title,
    this.showBalance = true,
    this.showBell = true,
    this.showDrawer = true,
    this.textDirection,
  }) : super(key: key);

  final GlobalKey<ScaffoldState>? myKey;
  final String? title;
  final bool? showDrawer;
  final bool? showBalance;
  final bool? showBell;
  final TextDirection? textDirection;

  @override
  _MyAppBarState createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {
  String totalBalance = '0.0';
  String? unreadMsgCount;
  @override
  void initState() {
    super.initState();

    MySharedPreferences.instance.getAllPrefs().then((prefs) {
      if (prefs["walletBean"] != null) {
        setState(() {
          totalBalance =
              jsonDecode(prefs["walletBean"])["totalBalance"].toString();
          unreadMsgCount = prefs["unreadMsgCount"];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: widget.textDirection ?? TextDirection.ltr,
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleSpacing: 0,
        title: widget.title != null
            ? FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  widget.title!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontFamily: "OpenSans",
                    fontSize: 18,
                  ),
                ),
              )
            : Container(),
        leading: widget.showDrawer == true
            ? MaterialButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                  // textDirection == TextDirection.ltr
                  //     ? Scaffold.of(context).openDrawer()
                  //     : Scaffold.of(context).openEndDrawer();
                },
                child: Image.asset('assets/icons/2.0x/drawer.png'),
              )
            : MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Image.asset('assets/icons/2.0x/back.png'),
              ),
        actions: [
          widget.showBell == true
              ? const Center(
                  child: BellIcon(
                    count: 3,
                  ),
                )
              : Container(),
          // //withdrawal
          // widget.showBalance == true
          //     ? GestureDetector(
          //   onTap: () {
          //     Navigator.pushNamed(context, WITHDRAWAL_SCREEN);
          //   },
          //   child: Align(
          //     alignment: Alignment.center,
          //     child: Wrap(
          //       children: [
          //         Container(
          //           decoration: const BoxDecoration(
          //             borderRadius: BorderRadius.all(
          //               Radius.circular(25),
          //             ),
          //             color: ZeplinColors.pink_red_opaque,
          //           ),
          //           child: Row(
          //             children: [
          //               Container(
          //                 decoration: const BoxDecoration(
          //                   borderRadius: BorderRadius.all(
          //                     Radius.circular(25),
          //                   ),
          //                   color: ZeplinColors.pink_red,
          //                 ),
          //                 child: const Icon(
          //                   CupertinoIcons.minus_circle,
          //                   color: ZeplinColors.white,
          //                   size: 30,
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // )
          //     : Container(),
          //deposit
          widget.showBalance == true
              ? GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, DEPOSIT_SCREEN);
                  },
                  child: Align(
                    alignment: Alignment.center,
                    child: Wrap(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(25),
                            ),
                            color: ZeplinColors.pink_red_opaque,
                          ),
                          child: Row(
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(25),
                                  ),
                                  color: ZeplinColors.pink_red,
                                ),
                                child: const Icon(
                                  CupertinoIcons.plus_circle,
                                  color: ZeplinColors.white,
                                  size: 30,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(8),
                                child: Row(
                                  children: [
                                    const Text(
                                      'AED ',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      totalBalance,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
