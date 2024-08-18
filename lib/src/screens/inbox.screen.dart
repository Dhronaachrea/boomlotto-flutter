import 'dart:async';
import 'dart:convert';
import 'package:boom_lotto/src/common/common.dart';
import 'package:boom_lotto/src/common/constants.dart';
import 'package:boom_lotto/src/common/shared.dart';
import 'package:boom_lotto/src/services/weaver_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';

class InboxScreen extends StatefulWidget {
  const InboxScreen({Key? key}) : super(key: key);

  @override
  _InboxScreenState createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  Future<Map<String, dynamic>>? response;
  Map<String, dynamic>? prefs;
  Map<String, dynamic> request = {};

  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _callApi();
    // resp = readJson();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _callApi() async {
    prefs = await MySharedPreferences.instance.getAllPrefs();
    request = {
      "domainName": "www.winboom.ae",
      "limit": 500,
      "offset": 0,
      "playerId": prefs!["playerId"],
      "playerToken": prefs!["playerToken"],
    };
    setState(() {
      response = WeaverService.playerInbox(request);
    });
  }

  Future<Map<String, dynamic>> readJson() async {
    final String resp = await rootBundle.loadString('assets/response.json');
    final data = await json.decode(resp);
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      title: "INBOX",
      showBalance: false,
      child: SizedBox(
        height: context.screenHeight * 0.9,
        child: FutureBuilder(
          future: response,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final response = snapshot.data;
            final plrInboxList = response?['plrInboxList'] ?? [];
            return response['errorCode'] == 0
                ? Column(
                    children: [
                      CupertinoSearchTextField(
                        controller: _textController,
                      ).p16(),
                      Expanded(
                        child: ListView.separated(
                          reverse: true,
                          separatorBuilder: (context, index) =>
                              const Divider(height: 10),
                          itemCount: plrInboxList.length,
                          itemBuilder: (context, index) {
                            return Dismissible(
                              background: Row(
                                children: const [
                                  Spacer(),
                                  Icon(Icons.delete),
                                ],
                              ),
                              key: Key(plrInboxList[index].toString()),
                              child: ListTile(
                                onLongPress: () {},
                                onTap: () {
                                  setState(() {
                                    plrInboxList[index]["status"] = "READ";

                                    showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return _buildBottomSheet(
                                            context, response, index);
                                      },
                                    );

                                    _inboxActivity(
                                      activity: "READ",
                                      inboxId: response?["plrInboxList"][index]
                                              ["inboxId"]
                                          .toString(),
                                    );
                                  });
                                },
                                leading: plrInboxList[index]["status"] == "READ"
                                    ? const CircleAvatar(
                                        backgroundColor: Colors.grey,
                                        child: Icon(
                                          CupertinoIcons.envelope_open,
                                          color: Colors.white,
                                        ),
                                      )
                                    : const CircleAvatar(
                                        backgroundColor: Colors.green,
                                        child: Icon(
                                          CupertinoIcons.envelope,
                                          color: Colors.black,
                                        ),
                                      ),
                                title: Text(
                                  plrInboxList[index]["subject"] ?? '',
                                  style: TextStyle(
                                    fontWeight: response["plrInboxList"][index]
                                                ["status"] ==
                                            "READ"
                                        ? FontWeight.normal
                                        : FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  response?["plrInboxList"]?[index]
                                          ["content_id"] ??
                                      '',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: (response?["plrInboxList"]
                                                    ?[index]["status"] ??
                                                '') ==
                                            "READ"
                                        ? FontWeight.normal
                                        : FontWeight.bold,
                                  ),
                                ),
                                trailing: Column(
                                  children: [
                                    Text(
                                      _dateTimeDiff(
                                            response?["plrInboxList"]?[index]
                                                ["mailSentDate"],
                                          ) ??
                                          '',
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  )
                : Center(
                    child: Text(response['respMsg']),
                  );
          },
        ),
      ),
    );
  }

  _buildBottomSheet(BuildContext context, response, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: context.screenWidth,
          height: 10.0,
          color: Colors.greenAccent,
        ),
        Container(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                padding: const EdgeInsets.only(bottom: 18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      response?["plrInboxList"][index]["subject"] ?? '',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    Text(
                      response?["plrInboxList"][index]["mailSentDate"] ?? '',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontStyle: FontStyle.italic,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                response?["plrInboxList"][index]["content_id"] ?? '',
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: MaterialButton(
                        onPressed: () => {
                          _inboxActivity(
                            activity: "DELETE",
                            inboxIds: [
                              response?["plrInboxList"][index]["inboxId"]
                            ],
                          ),
                        },
                        height: 50,
                        color: Colors.white,
                        child: const FittedBox(
                          fit: BoxFit.fitHeight,
                          child: Text(
                            'Delete',
                            style:
                                TextStyle(color: Colors.purple, fontSize: 18),
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: const BorderSide(color: Colors.purple),
                        ),
                      ).px12(),
                    ),
                    Expanded(
                      child: MaterialButton(
                        onPressed: () => {Navigator.pop(context)},
                        height: 50,
                        color: Colors.purple[800],
                        child: const FittedBox(
                          fit: BoxFit.fitHeight,
                          child: Text(
                            'Close',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ).px12(),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  _inboxActivity({required String activity, String? inboxId, List? inboxIds}) {
    MySharedPreferences.instance.getAllPrefs().then((preferences) {
      var req = {
        "activity": activity,
        "domainName": Common.domainName,
        "inboxId": inboxId,
        "inboxIdList": inboxIds,
        "limit": 500,
        "offset": 0,
        "playerId": preferences['playerId'],
        "playerToken": preferences['playerToken'],
      };

      WeaverService.inboxActivity(req).then((response) {
        MySharedPreferences.instance.setStringValue(
            "unreadMsgCount", response['unreadMsgCount'].toString());
      });
    });
  }

  _dateTimeDiff(String mailSentDate) {
    var now = DateTime.now();

    DateFormat inputFormat = DateFormat('dd/MM/yyyy hh:mm:ss');
    DateTime input = inputFormat.parse(mailSentDate);

    var difference = now.difference(input);

    var days = difference.inDays;
    var hours = difference.inHours;
    var minutes = difference.inMinutes;
    var seconds = difference.inSeconds;
    if (days > 0) {
      return "$days days ago";
    } else if (hours > 0) {
      return "$hours hours ago";
    } else if (minutes > 0) {
      return "$minutes minutes ago";
    } else {
      return "$seconds seconds ago";
    }
    // if (days < 2) {
    //   return "$days day ago";
    // } else if (days <= 1) {
    //   return "yesterday";
    // } else {
    //   return "${DateFormat('hh:mm a').format(input)}";
    // }
  }
}
