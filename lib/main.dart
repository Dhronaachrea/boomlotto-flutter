import 'package:boom_lotto/src/internet_connection/ConnectionStatusSingleton.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:boom_lotto/src/constants/strings.dart';
import 'package:boom_lotto/src/screens/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'dart:async';
import 'package:flutter_svg/svg.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  ConnectionStatusSingleton connectionStatus = ConnectionStatusSingleton.getInstance();
  connectionStatus.initialize();
  runApp(MyApp(router: AppRouter()));
}

class MyApp extends StatefulWidget {
  final AppRouter router;
  const MyApp({Key? key, required this.router}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('en', 'US');
  void setLocale(Locale value) {
    setState(() {
      _locale = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      locale: _locale,
      supportedLocales: AppLocalizations.supportedLocales,
      debugShowCheckedModeBanner: false,
      onGenerateRoute: widget.router.generateRoute,
      home: const SplashScreen(),
      // home: Stack(
      //   children: [
      //     SvgPicture.asset("assets/background.svg", fit: BoxFit.cover),
      //     SplashScreen()
      //   ],
      // )
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Map<String, String> params = {"deviceType": "MOBILE"};
    // WinService.getFooterBanner(params).then((res) {
    //   if (res["errorCode"] == 0) {
    //     MySharedPreferences.instance
    //         .setStringValue("bannerList", json.encode(res["data"]["HOME"]));
    //   }
    // });

    // WinService.fetchmatchlist(params).then((res) {
    //   MySharedPreferences.instance.setStringValue("gamesList",
    //       json.encode(res?["data"]["ige"]["engines"]["DUBAI"]["games"]));
    // });

    Timer(
      const Duration(seconds: 2),
      () => Navigator.pushReplacementNamed(context, HOME_SCREEN),
      // () => Navigator.pushReplacementNamed(context, LOGIN_SCREEN),
      // () => Navigator.pushReplacementNamed(context, TRANSACTIONS_SCREEN),

    );
  }

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset("assets/launch_image.svg",
    fit: BoxFit.cover, height: double.infinity, width: double.infinity);
  }
}
