import 'dart:convert';
import 'dart:developer';

import 'package:boom_lotto/src/common/constants.dart';
import 'package:boom_lotto/src/common/shared.dart';
import 'package:boom_lotto/src/widgets/app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MyWebView extends StatefulWidget {
  final int gameNumber;
  const MyWebView({Key? key, required this.gameNumber}) : super(key: key);

  @override
  _MyWebViewState createState() => _MyWebViewState();
}

class _MyWebViewState extends State<MyWebView> {
  final GlobalKey<ScaffoldState> myKey = GlobalKey<ScaffoldState>();
  late WebViewController _controller;
  double progress = 0;

  String? sessionId;
  String? playerId;
  String? userName;
  Map walletBean = {};
  String? finalUrlString;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _getAllPrefs();
    });
  }

  _getAllPrefs() async {
    await MySharedPreferences.instance.getAllPrefs().then(
          (prefs) => setState(() {
            if (prefs.length != 0) {
              sessionId = prefs["playerToken"];
              playerId = prefs["playerId"];
              userName = prefs["userName"];
              walletBean = jsonDecode(prefs["walletBean"]);

              log("sessionId $sessionId");
              log("playerId $playerId");
              log("userName $userName");
              log("walletBean $walletBean");
            } else {
              sessionId = '-';
              playerId = '-';
              userName = '-';
              walletBean = {'totalBalance': '0'};
            }
            log('${Constants.GAME_URL}ige/DUBAI/${widget.gameNumber}/buy/$playerId/$userName/$sessionId/${walletBean["totalBalance"]}/${Common.appDefaultLang}/${Common.currency}/${Common.currency}/${Common.domainName}/1');
          }),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size(double.infinity, kToolbarHeight),
        child: MyAppBar(
          title: 'Game Play',
        ),
      ),
      body: Stack(
        children: [
          WebView(
            initialUrl:
                '${Constants.GAME_URL}ige/DUBAI/${widget.gameNumber}/buy/$playerId/$userName/$sessionId/${walletBean["totalBalance"]}/${Common.appDefaultLang}/${Common.currency}/${Common.currency}/${Common.domainName}/1',
            navigationDelegate: (action) {
              return NavigationDecision.navigate;
            },
            javascriptMode: JavascriptMode.unrestricted,
            javascriptChannels: {
              JavascriptChannel(
                name: 'loadInstantGameUrl',
                onMessageReceived: (JavascriptMessage response) {
                  _controller.loadUrl(response.message);
                },
              ),
              JavascriptChannel(
                name: 'showLoginDialog',
                onMessageReceived: (JavascriptMessage response) {
                  Navigator.pop(context);
                },
              ),
              JavascriptChannel(
                name: 'goToHome',
                onMessageReceived: (JavascriptMessage response) {
                  Navigator.pop(context);
                },
              ),
              JavascriptChannel(
                name: 'backToLobby',
                onMessageReceived: (JavascriptMessage response) {
                  Navigator.pop(context);
                },
              ),
              JavascriptChannel(
                name: 'informSessionExpiry',
                onMessageReceived: (JavascriptMessage response) {
                  Navigator.pop(context);
                },
              ),
            },
            onWebViewCreated: (WebViewController webViewController) {
              _controller = webViewController;
            },
            onPageFinished: (url) {},
            debuggingEnabled: true,
            onProgress: (progress) {
              setState(() {
                this.progress = progress / 100;
              });
            },
          ),
          progress < 1.0
              ? LinearProgressIndicator(
                  value: progress,
                  color: Colors.deepPurple,
                  backgroundColor: Colors.purple[50],
                )
              : Container(),
        ],
      ),
    );
  }
}
