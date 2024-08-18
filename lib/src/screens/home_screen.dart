import 'dart:async';
import 'package:boom_lotto/src/widgets/theme_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:boom_lotto/src/common/common.dart';
import 'package:boom_lotto/src/common/theme.dart';
import 'package:boom_lotto/src/constants/strings.dart';
import 'package:boom_lotto/src/cubit/banner_cubit/todos_cubit.dart';
import 'package:boom_lotto/src/cubit/banner_cubit/todos_state.dart';
import 'package:boom_lotto/src/cubit/game_info_cubit/game_info_cubit.dart';
import 'package:boom_lotto/src/cubit/game_info_cubit/game_info_state.dart';
import 'package:boom_lotto/src/cubit/game_list_cubit/game_list_cubit.dart';
import 'package:boom_lotto/src/cubit/game_list_cubit/game_list_state.dart';
import 'package:boom_lotto/src/data/model/game_info_model.dart';
import 'package:boom_lotto/src/data/model/game_list_model.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const duration = Duration(seconds: 1);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String time = '';
  String date = '';
  int timeDiff = 0;
  Map<String, dynamic>? response;
  Timer timer = Timer(HomeScreen.duration, () {});
  var gameInfoData;

  String serverTime = '';

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<TodosCubit>(context).fetchTodos();
    BlocProvider.of<GameInfoCubit>(context).fetchGameInfo();
    BlocProvider.of<GameListCubit>(context).fetchGameList();
    return MyScaffold(
      child: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Column(
          children: [
            BlocBuilder<TodosCubit, TodosState>(
              builder: (context, TodosState state) {
                if (state is! TodosLoaded) {
                  return const Center(child: CircularProgressIndicator());
                }
                final todos = (state).todos;
                return SizedBox(
                  height: 150,
                  child: ListView(
                    children: [
                      CarouselSlider(
                        options: CarouselOptions(
                            height: 150.0,
                            autoPlay: true,
                            aspectRatio: 16 / 9,
                            viewportFraction: 1,
                            autoPlayInterval: const Duration(seconds: 5)),
                        items: _getItems(todos?.data?.hOME),
                      )
                    ],
                  ),
                );
              },
            ),
            BlocBuilder<GameInfoCubit, GameInfoState>(
              builder: (context, state) {
                if (state is! GameInfoLoaded) {
                  return const Center(child: Text(''));
                }
                GameInfoModel todos = (state).todos;
                if(todos != null)
                getGameTimer(todos, context);
                // return Text(todos.data!.games!.dAILYLOTTO!.jackpotAmount.toString());
                return todos != null ? Container(
                  margin: const EdgeInsets.all(5.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    elevation: 2,
                    shadowColor: Colors.black,
                    color: Colors.white,
                    child: Column(
                      children: [
                        ListTile(
                          contentPadding:
                          const EdgeInsets.symmetric(horizontal: 10.0),
                          horizontalTitleGap: 0.0,
                          title: Text(
                            "JACKPOT",
                            style: TextStyle(
                                color: Colors.indigo[900],
                                fontWeight: FontWeight.w500),
                          ),
                          subtitle: Text(
                            // gameInfoData.values.length >= 1
                            //     ? gameInfoData["jackpot_amount"]
                            //     : '',
                            todos.data!.games!.dAILYLOTTO!.jackpotAmount
                                .toString(),
                            style: TextStyle(
                                color: Colors.indigo[900],
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          trailing: Image.asset(
                            "assets/icons/2.0x/app_icon.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                        const Divider(color: Colors.grey),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Starts in",
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey[600],
                                        fontWeight: FontWeight.w500),
                                  ),
                                  _buildTimer(),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "Next Draw",
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey[600],
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    date,
                                    style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ).pOnly(bottom: 20.0, top: 20.0),
                        ThemeButton(
                          onPressed: () {
                            Navigator.pushNamed(context, GAME_SCREEN);
                          },
                          text: AppLocalizations.of(context)!.playNow,
                          enabled: true,
                        )
                      ],
                    ),
                  ),
                ) : Text('');

                },
              ),
              BlocBuilder<GameListCubit, GameListState>(
                builder: (context, state) {
                  if (state is! GameListLoaded) {
                    return const Center(child: Text(''));
                  }
                  GameListModel gameListModel = (state).todos;
                  return _getGamesList(gameListModel, context);
                },
              ),
            ],
          ),
        ),
    );
  }

  List<Container> _getItems(imageItemList) {
    List<Container> items = [];
    if(imageItemList != null)
    for (int i = 0; i < imageItemList.length; i++) {
      items.add(
        Container(
          margin: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18.0),
            image: DecorationImage(
              image: NetworkImage(imageItemList[i].imageItem),
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    }
    return items;
  }

  Text _buildTimer() {
    // ignore: unused_local_variable
    int days = timeDiff ~/ (24 * 60 * 60) % 24;
    int hours = timeDiff ~/ (60 * 60) % 24;
    int minutes = (timeDiff ~/ 60) % 60;
    int seconds = timeDiff % 60;
    time =
        '${(days == 0) ? '' : '${_appendZero(days.toString())} ${AppLocalizations.of(context)!.d} : '}${(hours == 0) ? '' : '${_appendZero(hours.toString())} ${AppLocalizations.of(context)!.h} : '}${_appendZero(minutes.toString())} ${AppLocalizations.of(context)!.m} : ${_appendZero(seconds.toString())} ${AppLocalizations.of(context)!.s}';
    return Text(
      time,
      style: const TextStyle(
          color: ZeplinColors.bright_orange,
          fontSize: 18,
          fontWeight: FontWeight.w600),
    );
  }

  String _appendZero(String str) {
    return str.padLeft(2, '0');
  }

  Widget _getGamesList(GameListModel todos1, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppLocalizations.of(context)!.manyWays,
                style: const TextStyle(
                  color: ZeplinColors.dark_blue,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.left)
            .pOnly(top: 20.0, left: 10, bottom: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Opacity(
              opacity: 0.6000000238418579,
              child: Text(
                AppLocalizations.of(context)!.chooseYourGame,
                style: const TextStyle(
                  color: ZeplinColors.dark_blue,
                  fontSize: 12,
                ),
              ),
            ),
            todos1.data!.ige!.engines!.dUBAI!.games!.length > 4
                ? GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, GAME_SCREEN);
                    },
                    child: Container(
                      width: 80,
                      height: 25,
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(13)),
                          border: Border.all(
                              color: const Color(0x0a03004c), width: 1),
                          color: const Color(0x0a02004c)),
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context)!.viewAll,
                          style: const TextStyle(
                            color: ZeplinColors.dark_blue,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  )
                : Container()
          ],
        ).pOnly(left: 10, bottom: 10, top: 5),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2),
          itemBuilder: (_, index) => Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
              side: const BorderSide(color: ZeplinColors.light_blue_grey),
            ),
            elevation: 1,
            shadowColor: Colors.black,
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  // margin: const EdgeInsets.all(5.0),
                  height: 110,
                  width: context.screenWidth / 2 - 20,
                  decoration: BoxDecoration(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(18)),
                    image: DecorationImage(
                      image: NetworkImage(todos1
                          .data!.ige!.engines!.dUBAI!.games![index].imagePath
                          .toString()),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(2),
                  padding: const EdgeInsets.all(5.0),
                  width: context.screenWidth / 2 - 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        todos1.data!.ige!.engines!.dUBAI!.games![index].gameName
                            .toString()
                            .toUpperCase(),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: ZeplinColors.dark_blue,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.winUpto,
                                style: const TextStyle(
                                  color: ZeplinColors.bright_orange,
                                  fontSize: 12,
                                ),
                              ),
                              const Text(
                                'AED100,000',
                                style: TextStyle(
                                  color: ZeplinColors.bright_orange,
                                  // fontSize: 12,
                                ),
                              )
                            ],
                          ).p(2),
                          Row(
                            children: [
                              Text(
                                '${todos1.data!.ige!.engines!.dUBAI!.games![0].currencyCode} ',
                                style: const TextStyle(
                                    fontSize: 15,
                                    color: ZeplinColors.dark_blue),
                              ),
                              Text(
                                '${todos1.data!.ige!.engines!.dUBAI!.games![0].prizeSchemes!.i2}',
                                style: const TextStyle(
                                    fontSize: 15,
                                    color: ZeplinColors.dark_blue,
                                    fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          itemCount: 4,
        ),
      // ),
      // itemCount: todos1 != null ? todos1.data?.ige?.engines?.dUBAI?.games?.length : 0,
      ],
    );
  }

  void getGameTimer(GameInfoModel todos, BuildContext context) {
    gameInfoData = todos.data!.games!.dAILYLOTTO;
    serverTime = todos.data!.serverTime!.date.toString();

    timeDiff =
        DateTime.parse(todos.data!.games!.dAILYLOTTO!.drawDate.toString())
            .difference(DateTime.parse(serverTime))
            .inSeconds;

    timer = Timer.periodic(HomeScreen.duration, (Timer t) {
      _handleTick(context);
    });
    // build(context);
    date = _changeDateFormat(
        todos.data!.games!.dAILYLOTTO!.nextDrawDate.toString());
  }

  _handleTick(BuildContext context) {
    if (timeDiff > 0) {
      if (DateTime.parse(gameInfoData.drawDate) != DateTime.parse(serverTime)) {
        timeDiff = timeDiff - 1;
      }
    } else {
      // BlocProvider.of<GameInfoCubit>(context).fetchGameInfo();
    }
  }

  String _changeDateFormat(String date) {
    String formattedDate = DateFormat('MMM').format(DateTime.parse(date)) +
        " " +
        _appendZero(DateFormat('d').format(DateTime.parse(date))) +
        ', ' +
        DateFormat('EEEE').format(DateTime.parse(date));
    return formattedDate;
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({Key? key}) : super(key: key);
//
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   final GlobalKey<ScaffoldState> myKey = GlobalKey<ScaffoldState>();
//   List imageItemList = [];
//   List gamesList = [];
//   Map gameInfoData = {};
//   String serverTime = '';
//   String time = '';
//   String date = '';
//   int timeDiff = 0;
//   Map<String, dynamic>? response;
//   static const duration = Duration(seconds: 1);
//   Timer timer = Timer(duration, () {});
//   @override
//   void initState() {
//     super.initState();
//     MySharedPreferences.instance
//         .getAllPrefs()
//         .then((prefs) => {log(prefs.toString())});
//
//     MySharedPreferences.instance.getStringValue("bannerList").then((value) {
//       imageItemList = json.decode(value);
//       _getItems();
//     });
//
//     Map<String, String> params = {"deviceType": "MOBILE"};
//     // WinService.getFooterBanner(params).then((res) {
//     //   setState(() {
//     //     if (res["errorCode"] == 0) {
//     //       imageItemList = res["data"]["HOME"];
//     //       _getItems();
//     //     }
//     //   });
//     // });
//
//     WinService.getGamesInfo(params).then((res) {
//       setState(() {
//         response = res;
//         gameInfoData = response!["data"]["games"]["DAILYLOTTO"];
//         serverTime = response!["data"]["serverTime"]["date"];
//
//         timeDiff = DateTime.parse(gameInfoData["draw_date"])
//             .difference(DateTime.parse(serverTime))
//             .inSeconds;
//         timer = Timer.periodic(duration, (Timer t) {
//           _handleTick();
//         });
//         date = _changeDateFormat(gameInfoData["next_draw_date"]);
//       });
//     });
//
//     // WinService.fetchmatchlist(params).then((res) {
//     //   setState(() {
//     //     gamesList = res?["data"]["ige"]["engines"]["DUBAI"]["games"] ?? [];
//     //   });
//     // });
//     MySharedPreferences.instance.getStringValue("gamesList").then((value) {
//       gamesList = json.decode(value);
//     });
//   }
//
//   @override
//   void dispose() {
//     timer.cancel();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       key: myKey,
//       appBar: PreferredSize(
//         preferredSize: const Size(double.infinity, kToolbarHeight),
//         child: MyAppBar(myKey: myKey),
//       ),
//       drawer: const MyDrawer(),
//       body: CommonContainer(
//         _view(context),
//         context.screenHeight * 0.9,
//       ).getContainer(),
//     );
//   }
//
//   ListView _view(BuildContext context) {
//     return ListView(
//       children: [
//         CarouselSlider(
//           options: CarouselOptions(
//               height: 150.0,
//               autoPlay: true,
//               aspectRatio: 16 / 9,
//               viewportFraction: 0.9,
//               autoPlayInterval: const Duration(seconds: 5)),
//           items: _getItems(),
//         ),
//         Container(
//           margin: const EdgeInsets.all(5.0),
//           child: Card(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(18.0),
//             ),
//             elevation: 2,
//             shadowColor: Colors.black,
//             color: Colors.white,
//             child: Column(
//               children: [
//                 ListTile(
//                   contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
//                   horizontalTitleGap: 0.0,
//                   title: Text(
//                     "JACKPOT",
//                     style: TextStyle(
//                         color: Color(0xff00004c), fontWeight: FontWeight.w500),
//                   ),
//                   subtitle: Text(
//                     gameInfoData.values.isNotEmpty
//                         ? gameInfoData["jackpot_amount"]
//                         : '',
//                     style: TextStyle(
//                         color: Color(0xff00004c),
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold),
//                   ),
//                   trailing: SvgPicture.asset("assets/jackpot_logo.svg",
//                       fit: BoxFit.cover),
//                 ),
//                 const Divider(color: Colors.grey),
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 10.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "Starts in",
//                             style: TextStyle(
//                                 fontSize: 15,
//                                 color: Colors.grey[600],
//                                 fontWeight: FontWeight.w500),
//                           ),
//                           _buildTimer(),
//                         ],
//                       ),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.end,
//                         children: [
//                           Text(
//                             "Next Draw",
//                             textAlign: TextAlign.right,
//                             style: TextStyle(
//                                 fontSize: 15,
//                                 color: Colors.grey[600],
//                                 fontWeight: FontWeight.w500),
//                           ),
//                           Text(
//                             date,
//                             style: TextStyle(
//                                 color: Colors.grey[600],
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.bold),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ).pOnly(bottom: 20.0, top: 20.0),
//                 ButtonTheme(
//                   minWidth: context.screenWidth - 40,
//                   height: 60,
//                   child: MaterialButton(
//                     onPressed: () {
//                       Navigator.of(context).push(
//                         MaterialPageRoute(
//                           builder: (context) => const GameScreen(),
//                         ),
//                       );
//                     },
//                     color: Color(0xffff0068),
//                     child: const Text(
//                       'BUY NOW',
//                       style: TextStyle(color: Colors.white, fontSize: 20),
//                     ),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(30.0),
//                     ),
//                   ).pOnly(bottom: 20.0),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         Column(
//           children: _getGamesList(),
//         ),
//       ],
//     );
//   }
//
//   Text _buildTimer() {
//     // int days = timeDiff ~/ (24 * 60 * 60) % 24;
//     int hours = timeDiff ~/ (60 * 60) % 24;
//     int minutes = (timeDiff ~/ 60) % 60;
//     int seconds = timeDiff % 60;
//
//     time =
//         '${(hours == 0) ? '' : '${_appendZero(hours.toString())} H : '}${_appendZero(minutes.toString())} M : ${_appendZero(seconds.toString())} S';
//     return Text(
//       time,
//       style: TextStyle(
//           color: Colors.grey[600], fontSize: 20, fontWeight: FontWeight.bold),
//     );
//   }
//
//   _handleTick() {
//     if (!mounted) return;
//     setState(() {
//       if (timeDiff > 0) {
//         if (DateTime.parse(gameInfoData["draw_date"]) !=
//             DateTime.parse(serverTime)) {
//           timeDiff = timeDiff - 1;
//         }
//       } else {
//         Map<String, String> params = {"deviceType": "MOBILE"};
//         WinService.getGamesInfo(params).then((res) {
//           response = res;
//           gameInfoData = response!["data"]["games"]["DAILYLOTTO"];
//           serverTime = response!["data"]["serverTime"]["date"];
//
//           timeDiff = DateTime.parse(gameInfoData["draw_date"])
//               .difference(DateTime.parse(serverTime))
//               .inSeconds;
//           date = _changeDateFormat(gameInfoData["next_draw_date"]);
//         });
//       }
//     });
//   }
//
//   String _appendZero(String str) {
//     return str.padLeft(2, '0');
//   }
//
//   String _changeDateFormat(String date) {
//     String formattedDate = DateFormat('MMM').format(DateTime.parse(date)) +
//         " " +
//         _appendZero(DateFormat('d').format(DateTime.parse(date))) +
//         ', ' +
//         DateFormat('EEEE').format(DateTime.parse(date));
//     return formattedDate;
//   }
//
//   List<Container> _getItems() {
//     List<Container> items = [];
//     for (int i = 0; i < imageItemList.length; i++) {
//       items.add(
//         Container(
//           margin: const EdgeInsets.all(10.0),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(18.0),
//             image: DecorationImage(
//               image: NetworkImage(imageItemList[i]["imageItem"]),
//               fit: BoxFit.cover,
//             ),
//           ),
//         ),
//       );
//     }
//     return items;
//   }
//
//   List<Row> _getGamesList() {
//     List<Widget> items = [];
//     List<Row> rows = [];
//     for (int i = 0; i < gamesList.length; i++) {
//       items.add(
//         InkWell(
//           onTap: () {
//             Navigator.of(context).push(
//               MaterialPageRoute(
//                 builder: (context) => MyWebView(
//                   gameNumber: gamesList[i]["gameNumber"],
//                 ),
//               ),
//             );
//           },
//           child: Card(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(10.0),
//             ),
//             elevation: 1,
//             shadowColor: Colors.black,
//             color: Colors.white,
//             child: Column(
//               children: [
//                 Container(
//                   margin: const EdgeInsets.all(5.0),
//                   height: 100,
//                   width: context.screenWidth / 2 - 20,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10.0),
//                     image: DecorationImage(
//                       image: NetworkImage(gamesList[i]["imagePath"]),
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 5.0),
//                   width: context.screenWidth / 2 - 20,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         gamesList[i]["gameName"].toString().toUpperCase(),
//                         style: TextStyle(
//                           fontSize: 15,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.grey[600],
//                         ),
//                       ),
//                       Text(
//                         'AED 100',
//                         style: TextStyle(
//                           fontSize: 15,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.grey[600],
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 10)
//               ],
//             ),
//           ),
//         ),
//       );
//       if (items.length == 1) {
//         rows.add(
//           Row(
//             children: items,
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           ),
//         );
//       } else if (items.length == 2) {
//         rows.removeLast();
//         rows.add(
//           Row(
//             children: items,
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           ),
//         );
//         items = [];
//       }
//     }
//     return rows;
//   }
// }

