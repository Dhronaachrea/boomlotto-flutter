import 'package:boom_lotto/main.dart';
import 'package:boom_lotto/src/common/constants.dart';
import 'package:boom_lotto/src/common/theme.dart';
import 'package:boom_lotto/src/constants/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'bell_icon.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  List<String> lang = ["EN", "AR"];
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: textDirection,
      child: Drawer(
        child: Container(
          color: ZeplinColors.dark_blue,
          child: Column(
            children: [
              DrawerHeader(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        Image.asset('assets/icons/2.0x/app_icon.png').px8(),
                        const Spacer(),
                        SizedBox(
                          height: 25,
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: lang.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedLang = index;
                                    textDirection = selectedLang == 0
                                        ? TextDirection.ltr
                                        : TextDirection.rtl;

                                    selectedLang == 0
                                        ? MyApp.of(context).setLocale(
                                            const Locale('en', 'US'),
                                          )
                                        : MyApp.of(context).setLocale(
                                            const Locale('ar', 'AE'),
                                          );
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                  ),
                                  decoration: BoxDecoration(
                                    color: selectedLang == index
                                        ? ZeplinColors.pink_red
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(43),
                                    border: selectedLang == index
                                        ? null
                                        : Border.all(
                                            color: Colors.white,
                                            width: 1,
                                          ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      lang[index],
                                      style: const TextStyle(
                                        fontFamily: 'Poppins',
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w300,
                                        fontStyle: FontStyle.normal,
                                      ),
                                    ),
                                  ),
                                ).pOnly(right: 4),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.7),
                                spreadRadius: 1,
                                blurRadius: 100,
                              ),
                            ],
                            borderRadius: const BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          child: const CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 25.0,
                            child: CircleAvatar(
                              backgroundImage: AssetImage(
                                'assets/images/avatar.png',
                              ),
                              radius: 23.0,
                            ),
                          ),
                        ).pOnly(right: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.marhaba,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontFamily: 'OpenSans',
                              ),
                            ),
                            const Text(
                              'Ankit',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontFamily: 'OpenSans',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ).pOnly(right: 20),
                        const Spacer(),
                        const BellIcon(
                          count: 3,
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Container(
                height: 0,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: ZeplinColors.light_blue_grey.withOpacity(0.3),
                    width: 1,
                  ),
                ),
              ).pOnly(bottom: 30),
              Expanded(
                child: MediaQuery.removePadding(
                  removeTop: true,
                  context: context,
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      DrawerTile(
                        heading: AppLocalizations.of(context)!.boom5,
                        subtitle: AppLocalizations.of(context)!.boom5Subtitle,
                        icon: CupertinoIcons.game_controller,
                        navigateTo: GAME_SCREEN,
                      ),
                      DrawerTile(
                        heading: AppLocalizations.of(context)!.instantWin,
                        subtitle:
                            AppLocalizations.of(context)!.instantWinSubtitle,
                        icon: CupertinoIcons.bolt,
                      ),
                      DrawerTile(
                        heading: AppLocalizations.of(context)!.myAccount,
                        subtitle: AppLocalizations.of(context)!.myAccount,
                        icon: CupertinoIcons.person,
                        navigateTo: TICKETS_SCREEN,
                      ),
                      const DrawerTile(
                        heading: 'My Transactions',
                        subtitle:
                            'My Tickets, My Transactions, Deposit, Withdrawal',
                        icon: CupertinoIcons.person,
                        navigateTo: TRANSACTIONS_SCREEN,
                      ),
                      DrawerTile(
                        heading: AppLocalizations.of(context)!.results,
                        subtitle: AppLocalizations.of(context)!.resultsSubtitle,
                        icon: CupertinoIcons.alarm,
                      ),
                      DrawerTile(
                        heading: AppLocalizations.of(context)!.winnerList,
                        subtitle:
                            AppLocalizations.of(context)!.winnerListSubtitle,
                        icon: CupertinoIcons.bolt,
                        navigateTo: WINNER_LIST_SCREEN,
                      ),
                      DrawerTile(
                        heading: AppLocalizations.of(context)!.howToPlay,
                        subtitle:
                            AppLocalizations.of(context)!.howToPlaySubtitle,
                        icon: CupertinoIcons.question_circle,
                      ),
                      DrawerTile(
                        heading: AppLocalizations.of(context)!.media,
                        subtitle: AppLocalizations.of(context)!.mediaSubtitle,
                        icon: CupertinoIcons.play_rectangle,
                      ),
                      DrawerTile(
                        heading: AppLocalizations.of(context)!.refer,
                        subtitle: AppLocalizations.of(context)!.referSubtitle,
                        icon: CupertinoIcons.person_2,
                      ),
                      DrawerTile(
                        heading: AppLocalizations.of(context)!.settings,
                        subtitle:
                            AppLocalizations.of(context)!.settingsSubtitle,
                        icon: CupertinoIcons.gear,
                      ),
                      const DrawerTile(
                        heading: "Withdrawal",
                        subtitle: 'withdraw amount from account',
                        icon: CupertinoIcons.gear,
                        navigateTo: WITHDRAWAL_SCREEN,
                      ),
                      DrawerTile(
                        heading: AppLocalizations.of(context)!.signIn,
                        subtitle: '',
                        icon: CupertinoIcons.gear,
                        navigateTo: LOGIN_SCREEN,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class DrawerTile extends StatelessWidget {
  final String heading;
  final String subtitle;
  final IconData icon;
  final String? navigateTo;

  const DrawerTile({
    Key? key,
    required this.heading,
    required this.subtitle,
    required this.icon,
    this.navigateTo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      // leading: Icon(
      //   icon,
      //   color: Colors.grey[400],
      // ),
      title: Container(
        margin: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              heading,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                fontFamily: 'OpenSans',
                color: Colors.white,
              ),
            ).pOnly(bottom: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                fontFamily: 'OpenSans',
                color: Colors.white.withOpacity(0.4),
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        navigateTo == null ? {} : Navigator.pushNamed(context, navigateTo!);
      },
    );
  }
}
