import 'package:boom_lotto/src/common/constants.dart';
import 'package:boom_lotto/src/common/theme.dart';
import 'package:boom_lotto/src/screens/transaction_screen.dart';
import 'package:boom_lotto/src/widgets/app_bar.dart';
import 'package:boom_lotto/src/widgets/bottom_navigation_item.dart';
import 'package:boom_lotto/src/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:velocity_x/velocity_x.dart';

class CommonContainer {
  final Widget child;
  const CommonContainer(this.child, this.height);
  final height;

  getContainer(String msg) {
    return Stack(
      children: [
        SvgPicture.asset(
          "assets/background.svg",
          fit: BoxFit.cover,
          height: double.infinity,
          width: double.infinity,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            shadowColor: Colors.transparent,
            bottom: PreferredSize(
              child: Row(
                children: [
                  Text(
                    msg,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ).p20(),
                ],
              ),
              preferredSize: const Size.fromHeight(70.0),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
          ),
          body: Container(
            // height: context.screenHeight * 0.9,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
              color: Colors.white,
            ),
            height: height,
            child: child,
          ),
        ),
      ],
    );
  }
}

class MyScaffold extends StatefulWidget {
  final Widget child;
  final double? height;
  final bool? showDrawer;
  final bool? showBalance;
  final bool? showBell;
  final String? title;
  final bool? showBottomNavigationBar;

  const MyScaffold({
    Key? key,
    required this.child,
    this.height,
    this.showDrawer = true,
    this.showBalance = true,
    this.showBell = true,
    this.title,
    this.showBottomNavigationBar = false
  })  : super(key: key);

  @override
  MyScaffoldState createState() => MyScaffoldState();
}

class MyScaffoldState extends State<MyScaffold> {
  int index = 0;


  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      SvgPicture.asset(
        "assets/background.svg",
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
      ),
      Scaffold(
        backgroundColor: Colors.transparent,
        appBar: PreferredSize(
          preferredSize: const Size(double.infinity, kToolbarHeight + 10),
          child: MyAppBar(
            showBalance: widget.showBalance,
            showBell: widget.showBell,
            showDrawer: widget.showDrawer,
            title: widget.title,
            textDirection: textDirection,
          ),
        ),
        drawer: const MyDrawer(),
        // bottomNavigationBar: BottomNavigationItem(),
        bottomNavigationBar:  BottomNavigationBar(
            backgroundColor: ZeplinColors.white,
            currentIndex: index,
            onTap: (int index) {
              setState(() {
                this.index = index;
              }
              );
              // _navigateToScreens(index);
            },
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                // backgroundColor: Colors.white,
                  icon: index == 0 ? Image.asset('assets/icons/bottom_home_icon.png',scale: 1.5,color: ZeplinColors.dark_blue) : Image.asset('assets/icons/bottom_home_icon.png',scale: 1.5,color: ZeplinColors.dark_grey),
                  title:  Text('WINNERS',style: TextStyle(color: index == 0 ? ZeplinColors.blue_violet_dark : ZeplinColors.blue_violet_dark))),
              BottomNavigationBarItem(
                  icon: index==1 ? Image.asset('assets/icons/bottom_home_icon.png',scale: 1.5,color: ZeplinColors.dark_blue) : Image.asset('assets/icons/bottom_home_icon.png',scale: 1.5,color: ZeplinColors.dark_grey),
                  title:  Text('DEPOSIT',style: TextStyle(color: index == 1 ? ZeplinColors.blue_violet_dark : ZeplinColors.blue_violet_dark))),
              BottomNavigationBarItem(
                  icon: index==2 ? Image.asset('assets/icons/bottom_home_icon.png',scale: 1.5,color: ZeplinColors.dark_blue) : Image.asset('assets/icons/bottom_home_icon.png',scale: 1.5,color: ZeplinColors.dark_grey),
                  title:  Text('BOOM 5',style: TextStyle(color: index == 2 ? ZeplinColors.blue_violet_dark : ZeplinColors.blue_violet_dark))),
              BottomNavigationBarItem(
                  icon: index==3 ? Image.asset('assets/icons/bottom_home_icon.png',scale: 1.5,color: ZeplinColors.dark_blue) : Image.asset('assets/icons/bottom_home_icon.png',scale: 1.5,color: ZeplinColors.dark_grey),
                  title:  Text('INSTANT WIN',style: TextStyle(color: index == 3 ? ZeplinColors.blue_violet_dark : ZeplinColors.blue_violet_dark))),
            ]),
        body: Directionality(
          textDirection: textDirection,
          child: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
                color: ZeplinColors.pale_grey,
              ),
              child: widget.child,
            ),
          ),
        ),
      ),
    ]);
  }
}