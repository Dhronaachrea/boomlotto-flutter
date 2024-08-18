import 'dart:async';
import 'dart:developer';
import 'package:audioplayers/audioplayers.dart';
import 'package:boom_lotto/src/common/theme.dart';
import 'package:boom_lotto/src/services/dge_service.dart';
import 'package:boom_lotto/src/widgets/app_bar.dart';
import 'package:boom_lotto/src/widgets/shake_widget.dart';
import 'package:boom_lotto/src/widgets/theme_button.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:velocity_x/velocity_x.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class Ball {
  int number;
  bool isSelected;
  bool isEnabled;

  Ball({
    required this.number,
    required this.isSelected,
    required this.isEnabled,
  });
}

class PanelData {
  List<int> pickedValues;
  bool quickPick;
  bool isExpanded;

  PanelData({
    required this.pickedValues,
    required this.quickPick,
    required this.isExpanded,
  });

  @override
  String toString() {
    return "pickedValues: " +
        pickedValues.toString() +
        ",\n quickPick: " +
        quickPick.toString() +
        ",\n isExpanded: " +
        isExpanded.toString() +
        '\n\n';
  }
}

class _GameScreenState extends State<GameScreen> {
  final sound = AudioCache();

  DateTime drawDate = DateTime(0);
  static const duration = Duration(seconds: 1);
  int timeDiff = 0;
  bool isActive = false;
  Timer timer = Timer(duration, () {});

  List<PanelData> panelData = [
    PanelData(
      pickedValues: [],
      quickPick: false,
      isExpanded: true,
    )
  ];

  List<int> totalNumbers = List<int>.generate(30, (i) {
    return i + 1;
  });

  Color borderColor = ZeplinColors.cloudy_blue;
  Color fillColor = Colors.white;

  Color selectedBorderColor = ZeplinColors.pink_red;
  Color selectedFillColor = ZeplinColors.faded_pink;

  Color textColor = Colors.black;
  Color selectedTextColor = ZeplinColors.pink_red;

  List<List<int>> lineArray = [[]];
  int maxBalls = 5;
  int maxPanelAllowed = 10;

  int selectedDraws = 1;
  int selectedLine = 1;

  bool showError = false;
  Map<String, dynamic>? response;

  @override
  void initState() {
    super.initState();

    // WidgetsBinding.instance!.addPostFrameCallback((_) {
    //   _callDge();
    // });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  _callDge() async {
    var request = {
      "field": [
        "DRAW_INFO",
        "CURRENCY",
        "BET_INFO",
        "DRAW_PRIZE_MULTIPLIER",
        "WINNING_RESULT",
        "NUMBER_CONFIG",
        "GAMES_SCHEMA"
      ],
      "gameCodes": ["DailyLotto"],
      "domainCode": "www.winboom.ae"
    };
    await DGEService.fetchGameData(request).then((resp) {
      if (resp == null) {
        response = null;
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
        response = resp['responseData'];

        maxBalls = int.parse(response!['gameRespVOs'][0]["betRespVOs"][0]
                ["pickTypeData"]["pickType"][0]["range"][0]["pickCount"]
            .substring(2));

        maxPanelAllowed = response!['gameRespVOs'][0]["maxPanelAllowed"];

        try {
          drawDate = DateTime.parse(
              response!['gameRespVOs'][0]['drawRespVOs'][0]['drawDateTime']);
          timeDiff = drawDate
              .difference(DateTime.parse(response!['currentDate']))
              .inSeconds;
        } catch (e) {
          log("Exception Draw Date time @ initState : $e");
        }

        timer = Timer.periodic(duration, (Timer t) {
          _handleTick();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/background.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: const PreferredSize(
          preferredSize: Size(double.infinity, kToolbarHeight + 10),
          child: MyAppBar(
            showBalance: true,
            showBell: true,
            showDrawer: false,
            title: "Boom 5",
          ),
        ),
        body: Column(
          children: [
            Expanded(
              flex: 8,
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20.0)),
                    color: ZeplinColors.pale_grey,
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: Column(
                          children: [
                            _buildJackpotView(context),
                            _buildTimerView(context),
                          ],
                        ),
                      ),
                      _buildDivider(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: Column(
                          children: [
                            _buildGamePlay(context),
                          ],
                        ),
                      ),
                      _buildAddLine(context),
                      _buildDivider(),
                      _buildDonationView(context),
                    ],
                  ),
                ),
              ),
            ),
            _buildBottomView(),
          ],
        ),
      ),
    );
  }

  _buildJackpotView(BuildContext context) {
    return SizedBox(
      height: context.screenHeight / 14,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FittedBox(
            fit: BoxFit.fitHeight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Jackpot',
                  style: TextStyle(
                    color: ZeplinColors.dark_blue.withOpacity(0.6),
                    fontFamily: 'OpenSans',
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'AED ',
                      style: TextStyle(
                        color: ZeplinColors.dark_blue,
                        fontSize: 22,
                        fontFamily: 'OpenSans',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      response?['gameRespVOs'][0]['jackpotAmount'].toString() ??
                          '500,000',
                      style: const TextStyle(
                        color: ZeplinColors.dark_blue,
                        fontSize: 22,
                        fontFamily: 'OpenSans',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          const Spacer(),
          Image.asset('assets/paa_boom.png'),
        ],
      ),
    ).py12();
  }

  _buildTimerView(BuildContext context) {
    int days = timeDiff ~/ (24 * 60 * 60) % 24;
    int hours = timeDiff ~/ (60 * 60) % 24;
    int minutes = (timeDiff ~/ 60) % 60;
    int seconds = timeDiff % 60;

    return SizedBox(
      height: context.screenHeight / 14,
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'Starts In',
                  style: TextStyle(
                    color: ZeplinColors.dark_blue_two,
                    fontFamily: 'OpenSans',
                  ),
                ),
              ),
              Text(
                '${(days == 0) ? '' : '${days.toString().padLeft(2, '0')} D : '} ${(hours == 0) ? '' : '${hours.toString().padLeft(2, '0')} H : '}${minutes.toString().padLeft(2, '0')} M : ${seconds.toString().padLeft(2, '0')} S',
                style: const TextStyle(
                  color: ZeplinColors.dark_blue_two,
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'Next Draw',
                  style: TextStyle(
                    color: ZeplinColors.dark_blue_two.withOpacity(0.6),
                    fontFamily: 'OpenSans',
                  ),
                ),
              ),
              const Text(
                '15th Jul, Thursday',
                style: TextStyle(
                  color: ZeplinColors.dark_blue_two,
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _buildDivider() {
    return Container(
      height: 0,
      decoration: BoxDecoration(
        border: Border.all(
          color: ZeplinColors.light_blue_grey,
          width: 1,
        ),
      ),
    );
  }

  _buildGamePlay(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: panelData.length,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        return ExpandableNotifier(
          initialExpanded: true,
          child: ScrollOnExpand(
            child: Builder(
              builder: (context) {
                var controller =
                    ExpandableController.of(context, required: true)!;
                WidgetsBinding.instance!.addPostFrameCallback((_) {
                  panelData[index].isExpanded == true
                      ? controller.expanded = true
                      : controller.expanded = false;
                });

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (panelData[index].pickedValues.length == maxBalls) {
                        textColor = Colors.blueGrey;
                      } else {
                        textColor = Colors.black;
                      }
                      for (var i in panelData) {
                        i.isExpanded = false;
                      }
                      panelData[index].isExpanded = true;
                    });
                  },
                  child: Expandable(
                    collapsed: buildCollapsed(index),
                    expanded: buildExpanded(index),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  buildCollapsed(index) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: ZeplinColors.light_blue_grey,
          width: 1,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Line ${index + 1}',
            style: const TextStyle(
              color: ZeplinColors.dark_blue_two,
              fontFamily: 'OpenSans',
              fontWeight: FontWeight.w700,
            ),
          ).pOnly(bottom: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (var i = 0; i < maxBalls; i++)
                _buildBall(panelData[index].pickedValues.length > i
                    ? panelData[index].pickedValues[i]
                    : -1),
              GestureDetector(
                onTap: () {
                  setState(() {
                    panelData.remove(panelData[index]);
                  });
                },
                child: Container(
                  height: 45,
                  width: 45,
                  decoration: const BoxDecoration(
                    color: ZeplinColors.pink_red_6,
                    borderRadius: BorderRadius.all(Radius.circular(40.0)),
                  ),
                  child: const Icon(
                    Icons.delete_outlined,
                    color: ZeplinColors.pink_red,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  buildExpanded(index) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: ZeplinColors.light_blue_grey,
          width: 1,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      child: Column(
        children: [
          _buildHeader(index),
          _buildGameGrid(context, index),
          _buildBottom(index),
        ],
      ),
    );
  }

  _buildBall(int number) {
    return Container(
      height: 45,
      width: 45,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: ZeplinColors.pale_grey,
        border: Border.all(
          color: ZeplinColors.light_blue_grey,
          width: 1,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(40)),
      ),
      child: Text(
        number == -1 ? '?' : number.toString(),
        style: const TextStyle(
          color: ZeplinColors.dark_blue,
          fontFamily: 'OpenSans',
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  _buildHeader(index) {
    return Row(
      children: [
        Text(
          'Line ${index + 1}',
          style: const TextStyle(
            color: ZeplinColors.dark_blue_two,
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.w700,
          ),
        ),
        const Spacer(),
        Text(
          'Pick 5 Numbers',
          style: TextStyle(
            color: ZeplinColors.dark_blue_two.withOpacity(0.6),
            fontFamily: 'OpenSans',
          ),
        ),
      ],
    );
  }

  _buildGameGrid(BuildContext context, int i) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: AnimationLimiter(
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          itemCount: totalNumbers.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 6,
            childAspectRatio: 1,
            crossAxisSpacing: 6,
            mainAxisSpacing: 6,
          ),
          itemBuilder: (BuildContext context, int j) {
            return AnimationConfiguration.staggeredGrid(
              position: j,
              duration: const Duration(milliseconds: 375),
              columnCount: 6,
              child: SlideAnimation(
                child: FadeInAnimation(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _didTapBall(i, j);
                      });
                    },
                    child: AnimatedContainer(
                      curve: Curves.easeOut,
                      duration: const Duration(milliseconds: 500),
                      alignment: Alignment.center,
                      child: Text(
                        '${totalNumbers[j]}',
                        style: TextStyle(
                          backgroundColor: Colors.transparent,
                          color: panelData[i].pickedValues.contains(j + 1)
                              ? selectedTextColor
                              : textColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: panelData[i].pickedValues.contains(j + 1)
                            ? selectedFillColor
                            : fillColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(40.0)),
                        border: Border.all(
                          color: panelData[i].pickedValues.contains(j + 1)
                              ? selectedBorderColor
                              : borderColor,
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  _didTapBall(i, j) {
    if (panelData[i].pickedValues.contains(totalNumbers[j])) {
      panelData[i].pickedValues.remove(totalNumbers[j]);
      panelData[i].quickPick = false;
      textColor = Colors.black;
    } else {
      if (panelData[i].pickedValues.length < maxBalls) {
        panelData[i].pickedValues.add(totalNumbers[j]);
      }
    }

    if (panelData[i].pickedValues.length == maxBalls) {
      if (!(panelData[i].pickedValues.length < maxBalls)) {
        textColor = Colors.blueGrey;
        sound.play('sounds/addLine.mp3');
      } else {
        textColor = Colors.black;
      }
    }
  }

  _buildBottom(index) {
    List<int> random = List.generate(29, (i) => i + 1);
    random.shuffle();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Line Price',
              style: TextStyle(
                color: ZeplinColors.dark_blue_two.withOpacity(0.6),
                fontFamily: 'OpenSans',
              ),
            ),
            const Text(
              'AED 10',
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const Spacer(),
        GestureDetector(
          onTap: () {
            setState(() {
              panelData[index].pickedValues = random.take(maxBalls).toList();
              panelData[index].quickPick = true;

              textColor = Colors.blueGrey;
            });
            sound.play('sounds/addLine.mp3');
          },
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            height: 28,
            decoration: BoxDecoration(
              border: Border.all(
                color: ZeplinColors.pink_red,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(30),
              color: panelData[index].quickPick
                  ? ZeplinColors.pink_red
                  : Colors.white,
            ),
            child: Text(
              'Quick Pick',
              style: TextStyle(
                color: panelData[index].quickPick
                    ? Colors.white
                    : ZeplinColors.pink_red,
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              panelData[index].pickedValues = [];
              panelData[index].quickPick = false;

              textColor = Colors.black;
            });
          },
          child: Container(
            height: 40,
            width: 40,
            decoration: const BoxDecoration(
              color: ZeplinColors.pink_red_6,
              borderRadius: BorderRadius.all(Radius.circular(40.0)),
            ),
            child: const Icon(
              Icons.delete_outlined,
              color: ZeplinColors.pink_red,
            ),
          ).pOnly(left: 10),
        ),
      ],
    );
  }

  _buildAddLine(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          ShakeWidget(
            key: panelData[panelData.length - 1].pickedValues.isEmpty
                ? UniqueKey()
                : null,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  if (panelData[panelData.length - 1].pickedValues.length ==
                      maxBalls) {
                    for (var i in panelData) {
                      i.isExpanded = false;
                    }
                    panelData.add(
                      PanelData(
                        pickedValues: [],
                        quickPick: false,
                        isExpanded: true,
                      ),
                    );
                    textColor = Colors.black;
                  }
                });
              },
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                height: 28,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: ZeplinColors.pink_red,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Text(
                  '+ ADD LINE',
                  style: TextStyle(
                    color: ZeplinColors.pink_red,
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ).px12(),
            ),
          ),
          const Spacer(),
          Text(
            '${panelData.length} Lines x $selectedDraws Draws',
            style: const TextStyle(
              color: ZeplinColors.dark_blue_two,
              fontFamily: 'OpenSans',
            ),
          ),
        ],
      ),
    );
  }

  _buildDonationView(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'You are going to donate.',
                style: TextStyle(
                  color: ZeplinColors.dark_blue,
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.w600,
                ),
              ).pOnly(bottom: 4),
              const Text(
                'Helping others and giving hopeis great humanity.',
                style: TextStyle(
                  color: Color(0xff686694),
                  fontSize: 12,
                  fontFamily: 'OpenSans',
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  const Positioned(
                    left: 0,
                    bottom: 0,
                    child: CircleAvatar(
                      minRadius: 20,
                      backgroundColor: ZeplinColors.light_blue_grey,
                    ),
                  ),
                  Positioned(
                    top: 7,
                    left: 0,
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
                        '${panelData.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Image.asset(
                    'assets/images/bottle.png',
                    height: 50,
                    width: 50,
                  ),
                ],
              ).px8(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'WATER',
                    style: TextStyle(
                      color: ZeplinColors.dark_blue,
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    '500 ml',
                    style: TextStyle(
                      color: ZeplinColors.dark_blue,
                      fontSize: 13,
                      fontFamily: 'OpenSans',
                    ),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  _buildBottomView() {
    return Expanded(
      child: Align(
        alignment: FractionalOffset.bottomCenter,
        child: Container(
          decoration: const BoxDecoration(
            color: ZeplinColors.pale_grey,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                spreadRadius: 5,
                offset: Offset(0, -5),
              ),
            ],
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      isScrollControlled: true,
                      isDismissible: true,
                      context: context,
                      builder: (BuildContext context) {
                        return Wrap(
                          children: [
                            Column(
                              children: [
                                Row(
                                  children: [
                                    const Text(
                                      'ADD MORE DRAWS',
                                      style: TextStyle(
                                        color: ZeplinColors.dark_blue,
                                        fontFamily: 'OpenSans',
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ).px20(),
                                    const Spacer(),
                                    IconButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      icon: const Icon(
                                        Icons.close,
                                        color: ZeplinColors.dark_blue,
                                      ),
                                    )
                                  ],
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: context.screenWidth / 4,
                                  ),
                                  child: const Text(
                                    'Same Numbers. \nMultiples Draws.',
                                    style: TextStyle(
                                      color: ZeplinColors.blue_violet_dark,
                                      fontSize: 24,
                                      fontFamily: 'OpenSans',
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ).py12(),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: context.screenWidth / 4,
                                  ),
                                  child: const Text(
                                    'You can use your favorite numbers for multiple draws.',
                                    style: TextStyle(
                                      color: ZeplinColors.dark_blue,
                                      fontSize: 16,
                                      fontFamily: 'OpenSans',
                                    ),
                                    textAlign: TextAlign.center,
                                  ).py12(),
                                ),
                                StatefulBuilder(builder: (BuildContext context,
                                    StateSetter setState) {
                                  return Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: context.screenWidth / 6,
                                    ),
                                    child: GridView.builder(
                                      shrinkWrap: true,
                                      itemCount: 6,
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 10,
                                        mainAxisSpacing: 10,
                                        childAspectRatio: 2.5,
                                      ),
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () => {
                                            setState(() {
                                              selectedDraws = index + 1;
                                            })
                                          },
                                          child: Container(
                                            height: 50,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color:
                                                    selectedDraws == index + 1
                                                        ? ZeplinColors.pink_red
                                                        : ZeplinColors
                                                            .light_blue_grey,
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                            ),
                                            child: Center(
                                              child: Text.rich(
                                                TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text: 'Next ',
                                                      style: TextStyle(
                                                        color: selectedDraws ==
                                                                index + 1
                                                            ? ZeplinColors
                                                                .pink_red
                                                            : ZeplinColors
                                                                .dark_blue,
                                                        fontSize: 16,
                                                        fontFamily: 'OpenSans',
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: (index + 1)
                                                          .toString(),
                                                      style: TextStyle(
                                                        color: selectedDraws ==
                                                                index + 1
                                                            ? ZeplinColors
                                                                .pink_red
                                                            : ZeplinColors
                                                                .dark_blue,
                                                        fontSize: 16,
                                                        fontFamily: 'OpenSans',
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: ' Draws',
                                                      style: TextStyle(
                                                        color: selectedDraws ==
                                                                index + 1
                                                            ? ZeplinColors
                                                                .pink_red
                                                            : ZeplinColors
                                                                .dark_blue,
                                                        fontSize: 16,
                                                        fontFamily: 'OpenSans',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  color: ZeplinColors.pink_red,
                                                  fontSize: 16,
                                                  fontFamily: 'OpenSans',
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                }),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: context.screenWidth / 4,
                                  ),
                                  child: const Text(
                                    'A minimum 1 draw must be selected to proceed',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.blueGrey,
                                      fontFamily: 'OpenSans',
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 40),
                                  child: ThemeButton(
                                    text: 'ADD DRAW',
                                    enabled: true,
                                    onPressed: () {
                                      setState(() {
                                        Navigator.pop(context);
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Container(
                    height: 51,
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: ZeplinColors.pink_red,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(125),
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: ZeplinColors.pink_red,
                              width: 1,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: ZeplinColors.pink_red_33,
                                offset: Offset(0, 13),
                                blurRadius: 36,
                                spreadRadius: 0,
                              ),
                            ],
                            borderRadius: BorderRadius.circular(125),
                          ),
                          child: Center(
                            child: Text(
                              selectedDraws.toString(),
                              style: const TextStyle(
                                color: ZeplinColors.pink_red,
                                fontFamily: 'OpenSans',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ).pOnly(right: 10),
                        const Text(
                          'SELECT \nDRAWS',
                          style: TextStyle(
                            color: ZeplinColors.pink_red,
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ).px16(),
                Expanded(
                  child: ThemeButton(
                    enabled: true,
                    onPressed: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                const Positioned(
                                  left: 0,
                                  bottom: 0,
                                  child: CircleAvatar(
                                    minRadius: 17,
                                    backgroundColor:
                                        ZeplinColors.pink_red_opaque,
                                  ),
                                ),
                                Image.asset(
                                  'assets/images/bottle.png',
                                  height: 40,
                                  width: 40,
                                ),
                              ],
                            ),
                            Text(
                              'x ${panelData.length}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontFamily: 'OpenSans',
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'AED ${panelData.length * 10}',
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            ),
                            const Text(
                              'BUY NOW',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ).pOnly(right: 14),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ignore: unused_element
  _ticketBuy(String sessionId, String playerId) {
    var panelData = [];

    // for (var i = 0; i < lineMap.length; i++) {
    //   String lineData = lineMap[i].values.last.join(",");
    //   if (lineData.endsWith(',')) {
    //     lineData = lineData.substring(0, lineData.length - 1);
    //   }
    //   panelData.add({
    //     "betAmountMultiple": 1,
    //     "betType": "Direct5",
    //     "pickConfig": "Number",
    //     "pickType": "Direct5",
    //     "pickedValues": lineData,
    //     "qpPreGenerated": lineMap[i].keys.first,
    //     "quickPick": lineMap[i].keys.first,
    //     "totalNumbers": 5
    //   });
    // }

    // API Request
    var request = {
      "currencyCode": "AED",
      "drawData": [
        {"drawId": "1"}
      ],
      "gameCode": "DailyLotto",
      "gameId": "3",
      "isAdvancePlay": false,
      "isUpdatedPayoutConfirmed": false,
      "lastTicketNumber": "0",
      "merchantCode": "Weaver",
      "merchantData": {
        "aliasName": "www.winboom.ae",
        "deviceCheck": false,
        "macAddress": "NA",
        "sessionId": sessionId,
        "userId": playerId
      },
      "noOfDraws": 3,
      "panelData": panelData,
      "purchaseDeviceId": "1",
      "purchaseDeviceType": "ANDROID_TERMINAL"
    };

    DGEService.ticketBuy(request).then((resp) {
      if (resp == null) {
        // Internal Server Error
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text('Boom Lotto'),
            content: const Text("Internal Server Error"),
            actions: <Widget>[
              CupertinoDialogAction(
                child: const Text('OK'),
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ],
          ),
        );
      } else {
        // success
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text('Boom Lotto'),
            content: Text(resp["responseMessage"].toString()),
            actions: <Widget>[
              CupertinoDialogAction(
                child: const Text('OK'),
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ],
          ),
        );
      }
    });
  }

  _handleTick() {
    if (!mounted) return;
    setState(() {
      if (timeDiff > 0) {
        if (drawDate != DateTime.parse(response!['currentDate'])) {
          timeDiff = timeDiff - 1;
        }
      } else {
        //print('Times up!');

        Timer(const Duration(milliseconds: 100), () {
          showDialog(
              context: context,
              builder: (context) {
                Future.delayed(const Duration(seconds: 2), () {
                  Navigator.of(context).pop(true);
                });
                return const Center(
                  child: CircularProgressIndicator(),
                );
              });
        });

        _callDge();
      }
    });
  }
}

class SelectBall extends StatefulWidget {
  final Color color;
  final Color borderColor;
  final String text;
  final double borderWidth;
  const SelectBall({
    Key? key,
    required this.color,
    required this.text,
    required this.borderColor,
    required this.borderWidth,
  }) : super(key: key);

  @override
  _SelectBallState createState() => _SelectBallState();
}

class _SelectBallState extends State<SelectBall> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 50,
      alignment: Alignment.center,
      child: Text(
        widget.text,
        style: TextStyle(
          backgroundColor: widget.color,
          color: ZeplinColors.dark_blue,
          fontSize: 18,
        ),
      ),
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: const BorderRadius.all(Radius.circular(40.0)),
        border: Border.all(
          color: widget.borderColor,
          width: widget.borderWidth,
        ),
      ),
    );
  }
}
