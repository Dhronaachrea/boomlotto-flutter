import 'dart:developer';
import 'package:boom_lotto/src/common/common.dart';
import 'package:boom_lotto/src/common/constants.dart';
import 'package:boom_lotto/src/services/win_service.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class WinnerListScreen extends StatefulWidget {
  const WinnerListScreen({Key? key}) : super(key: key);

  @override
  _WinnerListScreenState createState() => _WinnerListScreenState();
}

class _WinnerListScreenState extends State<WinnerListScreen>
    with TickerProviderStateMixin {
  TabController? tabController;
  List list = [];
  List responseList = [];
  int selectedIndex = 0;
  List<IconData> data = [
    Icons.home_outlined,
    Icons.search,
    Icons.add_box_outlined,
    Icons.favorite_outline_sharp,
    Icons.person_outline_sharp
  ];

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      initialIndex: 0,
      length: 5,
      vsync: this,
    );
    var request = {
      "deviceType": "Mobile",
      "serviceCode": ["DGE", "IGE"]
    };
    WinService.getWinnerList(request).then((response) {
      if (response == null) {
        showCupertinoDialog(
          context: context,
          builder: (ctx) {
            return CupertinoAlertDialog(
              title: const Text('Boom Lotto'),
              content: const Text("Internal Server Error"),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else {
        list = response['data']['DGE'];

        responseList = response['data'].entries.map((data) {
          return data.value;
        }).toList();

        log("responseList $responseList");
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: context.screenHeight * 0.15,
              child: RotationTransition(
                turns: const AlwaysStoppedAnimation(-7 / 360),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Center(
                      child: Text(
                        'WON',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        'AED100,000',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 30,
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        '14 Aug, 21',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              decoration: const BoxDecoration(
                color: Colors.lightBlueAccent,
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
            ).p8(),
            ListView.builder(
              shrinkWrap: true,
              itemCount: responseList.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Card(
                  elevation: 5,
                  shadowColor: Colors.black,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Text(
                          responseList[index][0]['serviceCode'].toString(),
                          style: const TextStyle(
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        AnimationLimiter(
                          child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: responseList[index].length,
                            itemBuilder: (context, j) {
                              return AnimationConfiguration.staggeredList(
                                position: j,
                                duration: const Duration(milliseconds: 375),
                                child: SlideAnimation(
                                  horizontalOffset: -50.0,
                                  child: FadeInAnimation(
                                    child: WinnerTile(
                                      data: responseList[index][j],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class WinnerTile extends StatelessWidget {
  const WinnerTile({
    Key? key,
    required this.data,
  }) : super(key: key);

  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const ColorBall(),
        WinnerText(data: data),
      ],
    );
  }
}

class WinnerText extends StatefulWidget {
  final Map<String, dynamic> data;
  const WinnerText({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  _WinnerTextState createState() => _WinnerTextState();
}

class _WinnerTextState extends State<WinnerText> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.screenWidth / 1.5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            children: [
              Text(
                'xxxx' +
                    widget.data['player'].toString().substring(
                          widget.data['player'].toString().length - 4,
                        ),
              ),
              const Text(' won '),
              Text(
                widget.data['amount'].toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(' on '),
              Text(
                widget.data['game_name'].toString(),
                style: const TextStyle(
                  color: Colors.green,
                ),
              ),
            ],
          ),
          Text(
            DateFormat(Common.dateTimeFormat).format(
              DateTime.parse(
                widget.data['datetime'],
              ),
            ),
            style: const TextStyle(color: Colors.blueGrey, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class ColorBall extends StatelessWidget {
  const ColorBall({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 60,
      alignment: Alignment.center,
      child: const Text(
        'Boom 5',
        style: TextStyle(color: Colors.black, fontSize: 10),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(40.0)),
        border: Border.all(
          color: Colors.orange[300]!,
          width: 7,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
    ).py8();
  }
}
