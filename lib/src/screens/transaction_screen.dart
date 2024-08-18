import 'dart:async';
import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:boom_lotto/src/common/common.dart';
import 'package:boom_lotto/src/common/common_string.dart';
import 'package:boom_lotto/src/common/theme.dart';
import 'package:boom_lotto/src/cubit/transaction_list_cubit/transaction_list_cubit.dart';
import 'package:boom_lotto/src/cubit/transaction_list_cubit/transaction_list_state.dart';
import 'package:boom_lotto/src/internet_connection/ConnectionStatusSingleton.dart';
import 'package:boom_lotto/src/widgets/wallet_balance_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:velocity_x/velocity_x.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({Key? key}) : super(key: key);

  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  StreamSubscription? _connectionChangeStream;
  bool checkConnection = false;

  List txnList = [];
  var searchList;
   List allTxnList = [];
  bool isVisible = false;
  String dropdownvalue = 'Today';
  var items = [
    'Today',
    'Last 10 Days',
    'Last 7 Days',
    'Last 30 Days',
    'Last 6 Months',
    'Custom'
  ];

  String _selectedDate = '';
  String _dateCount = '';
  String _range = '';
  String _rangeNew = '';
  String _rangeCount = '';
  late StateSetter myStateValue;
  String? fromDate;
  String? toDate;
  DateTime selectedFromDate = DateTime.now();
  DateTime selectedToDate = DateTime.now();

  static DateTime now = DateTime.now();
  static String uiDateFormat = 'MMM dd, yyyy';
  static String apiDateFormat = 'dd/MM/yyyy';
  bool showError = false;

  String transactionDates = DateFormat(uiDateFormat).format(now) +
      ' to ' +
      DateFormat(uiDateFormat).format(now);

  bool isShowDatePicker = false;
  SharedPreferences? prefs;
  bool day10Value = false;
  bool day7Value = false;
  bool day30Value = false;
  bool day180Value = false;
  bool allTypeValue = false;
  bool depositTypeValue = false;
  bool withdrawlTypeValue = false;
  bool bonusTypeValue = false;
  bool gamePlayTypeValue = false;
  bool winningTypeValue = false;
  String transTypeValue = 'ALL';
  String numberOfDays = '30';
  TextEditingController editingController = TextEditingController();
  bool searchValue = false;
  var result;
  bool resultValue = false;

  Future<void> _selectFromDate(BuildContext context) async {
    showGeneralDialog(
      context: context,
      pageBuilder: (context, animation1, animation2) {
        return Container();
      },
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      transitionDuration: const Duration(milliseconds: 200),
      transitionBuilder: (context, anim1, anim2, child) {
        final curvedValue = Curves.easeIn.transform(anim1.value) - 1.0;
        return Transform(
          transform: Matrix4.translationValues(0, curvedValue * 200, 0.0),
          child: Dialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 5),
            child: Wrap(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Calendar(
                      callback: (selected) {
                        setState(() {
                          selectedFromDate = selected;
                          fromDate =
                              _formatDate(uiDateFormat, selectedFromDate);
                        });
                      },
                      lastDay: selectedToDate,
                    ).px16(),
                    TextButton(
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.blue),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('OK'),
                    )
                  ],
                ),
              ],
            ).pOnly(bottom: 12),
          ),
        );
      },
    );
  }

  Future<void> _selectToDate(BuildContext context) async {
    showGeneralDialog(
      context: context,
      pageBuilder: (context, animation1, animation2) {
        return Container();
      },
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      transitionDuration: const Duration(milliseconds: 200),
      transitionBuilder: (context, anim1, anim2, child) {
        final curvedValue = Curves.easeIn.transform(anim1.value) - 1.0;
        return Transform(
          transform: Matrix4.translationValues(0, curvedValue * 200, 0.0),
          child: Dialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 5),
            child: Wrap(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    ToCalendar(
                      callback: (selected) {
                        setState(() {
                          selectedToDate = selected;
                          toDate = _formatDate(uiDateFormat, selectedToDate);
                        });
                      },
                      firstDay: selectedFromDate,
                    ).px16(),
                    TextButton(
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.blue),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('OK'),
                    )
                  ],
                ),
              ],
            ).pOnly(bottom: 12),
          ),
        );
      },
    );
  }

  _formatDate(String dateFormat, DateTime date) {
    return DateFormat(dateFormat).format(date);
  }

  @override
  void initState() {
    super.initState();
    initPrefs();
    ConnectionStatusSingleton connectionStatus =
        ConnectionStatusSingleton.getInstance();
    _connectionChangeStream =
        connectionStatus.connectionChange.listen(connectionChanged);
    setState(() {
      checkConnection = connectionStatus.hasConnection;
    });
    if (checkConnection == false)
      Flushbar(
        message: 'No Internet Connection!',
        duration: Duration(seconds: 3),
        backgroundColor: Colors.red,
        flushbarPosition: FlushbarPosition.TOP,
      )..show(context);
  }

  void connectionChanged(dynamic hasConnection) {
    setState(() {
      checkConnection = !hasConnection;
    });
    if (hasConnection == false)
      Flushbar(
        message: 'No Internet Connection!',
        duration: Duration(seconds: 3),
        backgroundColor: Colors.red,
        flushbarPosition: FlushbarPosition.TOP,
      )..show(context);
    else
      Flushbar(
        message: 'Internet Connection Available!',
        duration: Duration(seconds: 3),
        backgroundColor: Colors.green,
        flushbarPosition: FlushbarPosition.TOP,
      )..show(context);
  }

  _transactionList(String fromDate, String toDate, String transTypeValue) {
    var request = {
      // "domainName": "www.winboom.ae",
      // "fromDate": fromDate,
      // "toDate": toDate,
      // "limit": "10",
      // "offset": "0",
      // "playerId": 7422,
      // "playerToken": "QGLu7SeN3gkqzdX8C3V90RasN_gA1lZG_8p5GjxLsWU",
      // "txnType": "ALL"
      "domainName": "www.winboom.ae",
      "fromDate": _subtractDays1(
        apiDateFormat,
        const Duration(days: 30),
      ),
      "toDate": toDate,
      "limit": "100",
      "offset": "0",
      "playerId": prefs!.getInt('playerId'),
      "playerToken": prefs!.getString('playerToken'),
      // "txnType": "ALL"
      "txnType": transTypeValue
    };
    print(json.encode(request));

    BlocProvider.of<TransactionListCubit>(context).fetchTransactionList(request);
    // WeaverService.transactionDetails(request).then((response) {
    //   print(response);
    //   setState(() {
    //     txnList = response["txnList"] ?? [];
    //   });
    // });
  }

  _customTransactionList(String fromDate, String toDate, String transTypeValue) {
    var request = {
      // "domainName": "www.winboom.ae",
      // "fromDate": fromDate,
      // "toDate": toDate,
      // "limit": "10",
      // "offset": "0",
      // "playerId": 7422,
      // "playerToken": "QGLu7SeN3gkqzdX8C3V90RasN_gA1lZG_8p5GjxLsWU",
      // "txnType": "ALL"
      "domainName": "www.winboom.ae",
      "fromDate": fromDate,
      "toDate": toDate,
      "limit": "100",
      "offset": "0",
      "playerId": prefs!.getInt('playerId'),
      "playerToken": prefs!.getString('playerToken'),
      // "txnType": "ALL"
      "txnType": transTypeValue
    };
    print(json.encode(request));

    BlocProvider.of<TransactionListCubit>(context)
        .fetchTransactionList(request);
    // WeaverService.transactionDetails(request).then((response) {
    //   print(response);
    //   setState(() {
    //     txnList = response["txnList"] ?? [];
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      title: transaction_screen,
      child: Stack(
        children: [
          BlocBuilder<TransactionListCubit, TransactionListState>(
            builder: (context, TransactionListState state) {
              if (state is! TransactionListLoaded && state is! TransactionListLoadedData) {
                return const Center(child: CircularProgressIndicator());
              }

              else if (state is TransactionListLoaded) {
                result = (state).transactionListModel;
                if (result != null)
                {
                  allTxnList = result;
                  txnList = result;
                }
              }

              return Container(
                margin: const EdgeInsets.only(top: 0),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.8),
                      spreadRadius: 3,
                      blurRadius: 3,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                  color: Colors.white,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    // txnList != null && txnList.length > 0
                         Container(
                            height: context.screenHeight * 0.08,
                            margin: const EdgeInsets.only(
                                left: 20, right: 20, top: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                    width: context.screenWidth * 0.75,
                                    height: context.screenWidth * 0.12,
                                    decoration: BoxDecoration(
                                        color: ZeplinColors.dull_grey,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(25))),
                                    child: TextField(
                                      controller: editingController,
                                      decoration: InputDecoration(
                                        // labelText: "Search",
                                        hintText: "Search",
                                        hintStyle: TextStyle(fontSize: 20),
                                        prefixIcon: Image.asset(
                                            'assets/icons/search_icon.png',
                                            color: ZeplinColors.dark_grey),
                                        border: InputBorder.none,
                                      ),
                                      onChanged: onSearchTextChanged,
                                    )),
                                InkWell(
                                  onTap: () {
                                    showFilterDialog(context);
                                  },
                                  child: Container(
                                    width: context.screenWidth * 0.12,
                                    height: context.screenWidth * 0.12,
                                    // padding: const EdgeInsets.all(1),
                                    decoration: BoxDecoration(
                                      color: ZeplinColors.dull_grey,
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: Image.asset(
                                        'assets/icons/filter_icon.png',
                                        color: ZeplinColors.dark_grey),
                                  ),
                                )
                              ],
                            )),
                            Container(
                                height: context.screenHeight * 0.7,
                                child: ListView(
                                  scrollDirection: Axis.vertical,
                                  children: [
                                    WalletBalanceContainer(
                                        walletValue: json.decode(prefs!.getString("walletBean").toString())),
                                    txnList != null && txnList.length > 0
                                        ? Container(
                                      margin: const EdgeInsets.only(
                                          left: 20, right: 20, top: 5, bottom: 5),
                                      // padding: const EdgeInsets.all(8),
                                      // width: context.screenWidth / 5,
                                      width: context.screenWidth,

                                      child: Text(
                                        last_transaction,
                                        style: const TextStyle(
                                          color: ZeplinColors.dark_blue,
                                          fontSize: 18,
                                          fontFamily: 'OpenSans',
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    )
                                        : Text(''),
                                    _buildTransactionList(txnList),
                                  ],
                                ),
                            )
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  _buildHeader() {
    return SizedBox(
      height: 50.0,
      child: Row(
        children: <Widget>[
          Container(
            height: 50,
            padding: const EdgeInsets.only(left: 15, top: 15),
            child: const Text(
              " Transactions",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          const Spacer(),
          Row(
            children: [
              DropdownButton(
                value: dropdownvalue,
                dropdownColor: const Color.fromRGBO(248, 249, 249, 1),
                focusColor: const Color.fromRGBO(107, 131, 140, 0.09),
                icon: const Icon(Icons.keyboard_arrow_down),
                items: items.map((String items) {
                  return DropdownMenuItem(
                    value: items,
                    child: Text(
                      items,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(104, 129, 137, 1),
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    newValue == 'Custom' ? isVisible = true : isVisible = false;
                    dropdownvalue = newValue!;

                    // selectedtoDate = DateTime.parse(newValue);
                    // print(selectedtoDate);

                    switch (newValue) {
                      case 'Today':
                        transactionDates = _formatDate(uiDateFormat, now) +
                            ' to ' +
                            _formatDate(uiDateFormat, now);
                        _transactionList(_formatDate(apiDateFormat, now),
                            _formatDate(apiDateFormat, now,),'ALL');
                        break;
                      case 'Last 10 Days':
                        transactionDates = _subtractDays(
                              uiDateFormat,
                              const Duration(days: 10),
                            ) +
                            ' to ' +
                            _formatDate(uiDateFormat, now);

                        _transactionList(
                            _subtractDays(
                              apiDateFormat,
                              const Duration(days: 10),
                            ),
                            _formatDate(apiDateFormat, now),'ALL');
                        break;
                      case 'Last 7 Days':
                        transactionDates = _subtractDays(
                              uiDateFormat,
                              const Duration(days: 7),
                            ) +
                            ' to ' +
                            _formatDate(uiDateFormat, now);

                        _transactionList(
                          _subtractDays(
                            apiDateFormat,
                            const Duration(days: 7),
                          ),
                          _formatDate(apiDateFormat, now),
                            'ALL'
                        );
                        break;
                      case 'Last 30 Days':
                        transactionDates = _subtractDays(
                              uiDateFormat,
                              const Duration(days: 30),
                            ) +
                            ' to ' +
                            _formatDate(uiDateFormat, now);

                        _transactionList(
                            _subtractDays(
                              apiDateFormat,
                              const Duration(days: 30),
                            ),
                            _formatDate(apiDateFormat, now),'ALL');
                        break;
                      case 'Last 6 Months':
                        transactionDates = _subtractDays(
                              uiDateFormat,
                              const Duration(days: 180),
                            ) +
                            ' to ' +
                            _formatDate(uiDateFormat, now);

                        _transactionList(
                            _subtractDays(
                              apiDateFormat,
                              const Duration(days: 180),
                            ),
                            _formatDate(apiDateFormat, now),'ALL');
                        break;
                      case 'Custom':
                        txnList = [];
                        break;

                      default:
                        transactionDates = _formatDate(uiDateFormat, now) +
                            ' to ' +
                            _formatDate(uiDateFormat, now);
                    }
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  _subtractDays(String dateFormat, Duration duration) {
    return DateFormat(dateFormat).format(DateTime.now().subtract(duration));
  }

  _buildTransactionList(List txnList) {
    return txnList != null && txnList.length > 0
        ? ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: txnList.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
                padding: const EdgeInsets.all(8),
                // width: context.screenWidth / 5,
                width: context.screenWidth,
                decoration: BoxDecoration(
                  color: txnList[index].particular == 'WINNING'
                      ? ZeplinColors.aquamarine_50_10
                      : ZeplinColors.white,
                  border:
                      Border.all(color: ZeplinColors.aquamarine_50, width: 1),
                  // color: const Color.fromRGBO(107, 131, 140, 0.09),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          txnList[index].txnType,
                          // 'Withdrawal',
                          style: const TextStyle(
                            color: ZeplinColors.dark_blue,
                            fontSize: 16,
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          txnList[index].gameGroup,
                          // 'Cash U',
                          style: const TextStyle(fontSize: 16),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Text(
                              DateFormat('dd MMM')
                                  .format(
                                    DateTime.parse(
                                      txnList[index].transactionDate,
                                    ),
                                  )
                                  .toString(),
                              // '10 Oct 2021, ',
                              style: const TextStyle(fontSize: 14),
                            ),
                            Padding(
                                padding: EdgeInsets.only(left: 1),
                                child: Text(
                                  DateFormat('HH:mm:ss')
                                      .format(
                                        DateTime.parse(
                                          txnList[index].transactionDate,
                                        ),
                                      )
                                      .toString(),
                                  // '10:00 am',
                                  style: const TextStyle(fontSize: 14),
                                ))
                          ],
                        )
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Amount',
                          style: const TextStyle(
                            fontSize: 14,
                            // fontWeight: FontWeight.bold,
                            // color: Colors.blueGrey
                          ),
                        ),
                        RichText(
                            text: TextSpan(
                          children: [
                            TextSpan(
                              text: txnList[index].debitAmount != null
                                  ? '- ' + txnList[index].currency + ' '
                                  : '+ ' + txnList[index].currency + ' ',
                              style: const TextStyle(
                                color: ZeplinColors.dark_blue,
                                fontWeight: FontWeight.w400,
                                fontSize: 18,
                                fontFamily: "OpenSans",
                              ),
                            ),
                            TextSpan(
                              text: txnList[index].debitAmount != null
                                  ? txnList[index].debitAmount.toString()
                                  : '0',
                              style: const TextStyle(
                                color: ZeplinColors.dark_blue,
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                                fontFamily: "OpenSans",
                              ),
                            ),
                          ],
                        )),
                      ],
                    )
                  ],
                ),
              );
            },
          )
        : Container(
            height: context.screenHeight * 0.58,
            width: context.screenWidth,
            color: Colors.transparent,
            margin: const EdgeInsets.only(left: 20, right: 20, top: 150),
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(noTransaction,
                    style: const TextStyle(
                        color: ZeplinColors.blue_violet_dark,
                        fontWeight: FontWeight.w800,
                        fontFamily: "OpenSans",
                        fontStyle: FontStyle.normal,
                        fontSize: 25),
                    textAlign: TextAlign.center),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 40, right: 40),
                  child: Text(
                      "It seems you haven’t done any transaction yet. It will be reflected once you make any payment.",
                      style: const TextStyle(
                          color: ZeplinColors.dark_blue,
                          fontWeight: FontWeight.w400,
                          fontFamily: "OpenSans",
                          fontStyle: FontStyle.normal,
                          fontSize: 18),
                      textAlign: TextAlign.center),
                )
              ],
            ),
          );
  }

  _buildDateRow() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(left: 10.0, right: 15.0),
            child: const Divider(
              color: Colors.black,
              height: 50,
            ),
          ),
        ),
        Text(
          transactionDates,
          style: const TextStyle(
            fontSize: 15,
          ),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(left: 15.0, right: 10.0),
            child: const Divider(
              color: Colors.black,
              height: 50,
            ),
          ),
        ),
      ],
    );
  }

  _buildDatePicker(BuildContext context) {
    return Visibility(
      visible: isVisible,
      child: Column(
        children: [
          Container(
            height: 40,
            width: context.screenWidth,
            color: Colors.grey.withOpacity(0.1),
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: context.screenWidth / 2.5,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MaterialButton(
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today),
                          Text(fromDate ?? 'Select Date'),
                        ],
                      ),
                      onPressed: () => _selectFromDate(context),
                    ),
                  ),
                ),
                SizedBox(
                  width: context.screenWidth / 2.5,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MaterialButton(
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today),
                          Text(toDate ?? 'Select Date'),
                        ],
                      ),
                      onPressed: () => _selectToDate(context),
                    ),
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    setState(() {
                      if (fromDate == null || toDate == null) {
                        showError = true;
                        return;
                      }
                      showError = false;
                      transactionDates =
                          _formatDate(uiDateFormat, selectedFromDate) +
                              ' to ' +
                              _formatDate(uiDateFormat, selectedToDate);

                      _transactionList(
                          _formatDate(apiDateFormat, selectedFromDate),
                          _formatDate(apiDateFormat, selectedToDate),'ALL');
                    });
                  },
                ),
              ],
            ),
          ),
          Visibility(
            visible: showError,
            child: const Text(
              'From Date and To Date cannot be blank',
              style: TextStyle(color: Colors.red, fontSize: 10),
            ),
          )
        ],
      ),
    );
  }

  void showFilterDialog(BuildContext context) {
    showModalBottomSheet(
        isScrollControlled: true,
        // isDismissible: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        backgroundColor: Colors.white,
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter mystate) {
            myStateValue = mystate;
            return Container(
                height: context.screenHeight * 0.87,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'FILTER',
                            style: const TextStyle(
                              color: ZeplinColors.dark_blue,
                              fontSize: 18,
                              fontFamily: 'OpenSans',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                              mystate(() {
                                isShowDatePicker = false;
                              });
                            },
                            child: Container(
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Icon(Icons.clear),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Text(search_by_duration,
                          style: const TextStyle(
                              color: ZeplinColors.dark_blue,
                              fontWeight: FontWeight.w700,
                              fontFamily: "OpenSans",
                              fontStyle: FontStyle.normal,
                              fontSize: 18),
                          textAlign: TextAlign.left),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              mystate(() {
                                day10Value = true;
                                day7Value = false;
                                day30Value = false;
                                day180Value = false;
                                numberOfDays = '10';
                              });
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: ZeplinColors.light_blue_grey,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    color: day10Value == true
                                        ? ZeplinColors.dark_grey
                                        : Colors.transparent),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: 20, right: 20, top: 10, bottom: 10),
                                  child: Text(last_10days,
                                      style: const TextStyle(
                                          color: ZeplinColors.dark_blue,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: "OpenSans",
                                          fontStyle: FontStyle.normal,
                                          fontSize: 18),
                                      textAlign: TextAlign.center),
                                )),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          InkWell(
                            onTap: () {
                              mystate(() {
                                day7Value = true;
                                day10Value = false;
                                day30Value = false;
                                day180Value = false;
                                numberOfDays = '7';
                              });
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: ZeplinColors.light_blue_grey,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    color: day7Value == true
                                        ? ZeplinColors.dark_grey
                                        : Colors.transparent),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: 20, right: 20, top: 10, bottom: 10),
                                  child: Text(last_7days,
                                      style: const TextStyle(
                                          color: ZeplinColors.dark_blue,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: "OpenSans",
                                          fontStyle: FontStyle.normal,
                                          fontSize: 18),
                                      textAlign: TextAlign.center),
                                )),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              mystate(() {
                                day30Value = true;
                                day7Value = false;
                                day10Value = false;
                                day180Value = false;
                                numberOfDays = '30';
                              });
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: ZeplinColors.light_blue_grey,
                                    ),
                                    color: day30Value == true
                                        ? ZeplinColors.dark_grey
                                        : Colors.transparent,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: 20, right: 20, top: 10, bottom: 10),
                                  child: Text(last_30days,
                                      style: const TextStyle(
                                          color: ZeplinColors.dark_blue,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: "OpenSans",
                                          fontStyle: FontStyle.normal,
                                          fontSize: 18),
                                      textAlign: TextAlign.center),
                                )),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          InkWell(
                            onTap: () {
                              mystate(() {
                                day180Value = true;
                                day30Value = false;
                                day7Value = false;
                                day10Value = false;
                                numberOfDays = '180';
                              });
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: ZeplinColors.light_blue_grey,
                                    ),
                                    color: day180Value == true
                                        ? ZeplinColors.dark_grey
                                        : Colors.transparent,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: 20, right: 20, top: 10, bottom: 10),
                                  child: Text(last_180days,
                                      style: const TextStyle(
                                          color: ZeplinColors.dark_blue,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: "OpenSans",
                                          fontStyle: FontStyle.normal,
                                          fontSize: 18),
                                      textAlign: TextAlign.center),
                                )),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Text(searchByDate,
                          style: const TextStyle(
                              color: ZeplinColors.dark_blue,
                              fontWeight: FontWeight.w700,
                              fontFamily: "OpenSans",
                              fontStyle: FontStyle.normal,
                              fontSize: 18),
                          textAlign: TextAlign.left),
                    ),
                    InkWell(
                      onTap: () {
                        mystate(() {
                          isShowDatePicker = true;
                        });
                      },
                      child: Container(
                          margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            border: Border.all(
                                color: isShowDatePicker == true ? ZeplinColors.blue_violet_dark : ZeplinColors.light_blue_grey, width: 1),
                            color: ZeplinColors.pale_grey,
                          ),
                          child: Padding(
                              padding: EdgeInsets.only(
                                  left: 10, right: 10, top: 15, bottom: 15),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Opacity(
                                    opacity: 0.5,
                                    child: Text(
                                        _range != ''
                                            ? _rangeNew
                                            : selectedDateRange,
                                        style: const TextStyle(
                                            color: ZeplinColors.dark_blue,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: "OpenSans",
                                            fontStyle: FontStyle.normal,
                                            fontSize: 18),
                                        textAlign: TextAlign.left),
                                  ),
                                  Image.asset('assets/icons/date_picker.png',
                                      color: isShowDatePicker == true ? ZeplinColors.blue_violet_dark : ZeplinColors.dark_grey),
                                ],
                              ))),
                    ),
                    isShowDatePicker == true
                        ? SfDateRangePicker(
                            onSelectionChanged: _onSelectionChanged,
                            selectionMode: DateRangePickerSelectionMode.range,
                            selectionShape: DateRangePickerSelectionShape.rectangle,
                            startRangeSelectionColor: ZeplinColors.blue_violet_dark,
                            endRangeSelectionColor: ZeplinColors.blue_violet_dark,
                            rangeSelectionColor: ZeplinColors.blue_violet,
                            todayHighlightColor: Colors.transparent,
                            selectionRadius: 20,
                              initialSelectedRange: PickerDateRange(
                                DateTime.now()
                                    .subtract(const Duration(days: 4)),
                                DateTime.now().add(const Duration(days: 3))),
                          )
                        : Text(''),
                    SizedBox(
                      height: 20,
                    ),
                    isShowDatePicker == true
                        ? Text('')
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 20),
                                child: Text(transaction_type,
                                    style: const TextStyle(
                                        color: ZeplinColors.dark_blue,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: "OpenSans",
                                        fontStyle: FontStyle.normal,
                                        fontSize: 18),
                                    textAlign: TextAlign.left),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 20, right: 20),
                                child: Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        mystate(() {
                                          allTypeValue = true;
                                          depositTypeValue = false;
                                          withdrawlTypeValue = false;
                                          winningTypeValue = false;
                                          bonusTypeValue = false;
                                          gamePlayTypeValue = false;
                                          transTypeValue = all.toUpperCase();
                                        });
                                      },
                                      child: Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                color: ZeplinColors
                                                    .light_blue_grey,
                                              ),
                                              color: allTypeValue == true
                                                  ? ZeplinColors.dark_grey
                                                  : Colors.transparent,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20))),
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                left: 20,
                                                right: 20,
                                                top: 10,
                                                bottom: 10),
                                            child: Text(all,
                                                style: const TextStyle(
                                                    color:
                                                        ZeplinColors.dark_blue,
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: "OpenSans",
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 18),
                                                textAlign: TextAlign.center),
                                          )),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    InkWell(
                                        onTap: () {
                                          mystate(() {
                                            depositTypeValue = true;
                                            allTypeValue = false;
                                            withdrawlTypeValue = false;
                                            winningTypeValue = false;
                                            bonusTypeValue = false;
                                            gamePlayTypeValue = false;
                                            transTypeValue = deposit.toUpperCase();
                                          });
                                        },
                                        child: Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: ZeplinColors
                                                      .light_blue_grey,
                                                ),
                                                color: depositTypeValue == true
                                                    ? ZeplinColors.dark_grey
                                                    : Colors.transparent,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20))),
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: 20,
                                                  right: 20,
                                                  top: 10,
                                                  bottom: 10),
                                              child: Text(deposit,
                                                  style: const TextStyle(
                                                      color: ZeplinColors
                                                          .dark_blue,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontFamily: "OpenSans",
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize: 18),
                                                  textAlign: TextAlign.center),
                                            ))),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        mystate(() {
                                          withdrawlTypeValue = true;
                                          depositTypeValue = false;
                                          allTypeValue = false;
                                          winningTypeValue = false;
                                          bonusTypeValue = false;
                                          gamePlayTypeValue = false;
                                          transTypeValue = withdrawal.toUpperCase();
                                        });
                                      },
                                      child: Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                color:
                                                ZeplinColors.light_blue_grey,
                                              ),
                                              color: withdrawlTypeValue == true
                                                  ? ZeplinColors.dark_grey
                                                  : Colors.transparent,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20))),
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                left: 20,
                                                right: 20,
                                                top: 10,
                                                bottom: 10),
                                            child: Text(withdrawal,
                                                style: const TextStyle(
                                                    color: ZeplinColors.dark_blue,
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: "OpenSans",
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 18),
                                                textAlign: TextAlign.center),
                                          )),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 20, right: 20),
                                child: Row(
                                  children: [
                                    InkWell(
                                        onTap: () {
                                          mystate(() {
                                            bonusTypeValue = true;
                                            withdrawlTypeValue = false;
                                            depositTypeValue = false;
                                            allTypeValue = false;
                                            winningTypeValue = false;
                                            gamePlayTypeValue = false;
                                            transTypeValue = bonus.toUpperCase();
                                          });
                                        },
                                      child: Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                color:
                                                ZeplinColors.light_blue_grey,
                                              ),
                                              color: bonusTypeValue == true
                                                  ? ZeplinColors.dark_grey
                                                  : Colors.transparent,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20))),
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                left: 20,
                                                right: 20,
                                                top: 10,
                                                bottom: 10),
                                            child: Text(bonus,
                                                style: const TextStyle(
                                                    color: ZeplinColors.dark_blue,
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: "OpenSans",
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 18),
                                                textAlign: TextAlign.center),
                                          ))
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        mystate(() {
                                          gamePlayTypeValue = true;
                                          bonusTypeValue = false;
                                          withdrawlTypeValue = false;
                                          depositTypeValue = false;
                                          allTypeValue = false;
                                          winningTypeValue = false;
                                          transTypeValue = game_play.toUpperCase();
                                        });
                                      },
                                      child: Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                color:
                                                ZeplinColors.light_blue_grey,
                                              ),
                                              color: gamePlayTypeValue == true
                                                  ? ZeplinColors.dark_grey
                                                  : Colors.transparent,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20))),
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                left: 20,
                                                right: 20,
                                                top: 10,
                                                bottom: 10),
                                            child: Text(game_play,
                                                style: const TextStyle(
                                                    color: ZeplinColors.dark_blue,
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: "OpenSans",
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 18),
                                                textAlign: TextAlign.center),
                                          )),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        mystate(() {
                                          winningTypeValue = true;
                                          gamePlayTypeValue = false;
                                          bonusTypeValue = false;
                                          withdrawlTypeValue = false;
                                          depositTypeValue = false;
                                          allTypeValue = false;
                                          transTypeValue = winning.toUpperCase();
                                        });
                                      },
                                      child: Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                color:
                                                ZeplinColors.light_blue_grey,
                                              ),
                                              color: winningTypeValue == true
                                                  ? ZeplinColors.dark_grey
                                                  : Colors.transparent,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20))),
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                left: 20,
                                                right: 20,
                                                top: 10,
                                                bottom: 10),
                                            child: Text(winning,
                                                style: const TextStyle(
                                                    color: ZeplinColors.dark_blue,
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: "OpenSans",
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 18),
                                                textAlign: TextAlign.center),
                                          )),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                    InkWell(
                      onTap: () {
                switch (numberOfDays) {
                  case '7':
                    _customTransactionList(_subtractDays(
                          apiDateFormat,
                          const Duration(days: 7),
                        ),
                        _formatDate(apiDateFormat, now),transTypeValue);
                    break;

                  case '10':
                    _customTransactionList(_subtractDays(
                      apiDateFormat,
                      const Duration(days: 10),
                    ),
                        _formatDate(apiDateFormat, now),transTypeValue);
                    break;

                  case '30':
                    _customTransactionList(_subtractDays(apiDateFormat, const Duration(days: 30)),
                        _formatDate(apiDateFormat, now),
                        transTypeValue
                    );
                    break;

                  case '180':
                    _customTransactionList(_subtractDays(apiDateFormat, const Duration(days: 180)),
                        _formatDate(apiDateFormat, now),
                        transTypeValue
                    );
                    break;

                  case 'customDate':
                    _customTransactionList(
                        _range.split('-')[0], _range.split('-')[1],transTypeValue);

                    break;

                  default:
                    _transactionList(_subtractDays(apiDateFormat, const Duration(days: 30)),
                        _formatDate(apiDateFormat, now),
                      'ALL'
                    );
                    break;
                }

                        print('rangeValue $_range');
                        Navigator.of(context).pop();
                        mystate(() {
                          isShowDatePicker = false;
                        });
                      },
                      child: Container(
                          width: context.screenWidth,
                          height: context.screenHeight * 0.065,
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(
                              left: 20,
                              right: 20,
                              top: isShowDatePicker == true
                                  ? context.screenHeight * 0.01
                                  : context.screenHeight * 0.15),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25)),
                              boxShadow: [
                                BoxShadow(
                                    color: ZeplinColors.pink_red_opaque,
                                    offset: Offset(0, 13),
                                    blurRadius: 36,
                                    spreadRadius: 0)
                              ],
                              color: ZeplinColors.pink_red),
                          child: Text("DONE",
                              style: TextStyle(
                                fontFamily: 'OpenSans',
                                color: ZeplinColors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.normal,
                                letterSpacing: 0.84,
                              ))),
                    )
                  ],
                ));
          });
        });
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    myStateValue(() {
      numberOfDays = 'customDate';
      if (args.value is PickerDateRange) {
        _range =
            DateFormat('dd/MM/yyyy').format(args.value.startDate).toString() +
                ' - ' +
                DateFormat('dd/MM/yyyy')
                    .format(args.value.endDate ?? args.value.startDate)
                    .toString();

         _rangeNew =
           DateFormat('dd/MM/yyyy').format(args.value.startDate).toString().split('/')[0]+' '+
            DateFormat.MMM().format(args.value.startDate).toString() +' '+
               DateFormat('dd/MM/yyyy').format(args.value.startDate).toString().split('/')[2]+
                ' - ' +
                    DateFormat('dd/MM/yyyy').format(args.value.endDate ?? args.value.startDate).toString().split('/')[0]+' '+
                    DateFormat.MMM().format(args.value.endDate ?? args.value.startDate).toString() +' '+
                    DateFormat('dd/MM/yyyy').format(args.value.endDate ?? args.value.startDate).toString().split('/')[2];

        // print('dateRange $_range');
        print('dateRange $_rangeNew');
      } else if (args.value is DateTime) {
        _selectedDate = args.value.toString();
      } else if (args.value is List<DateTime>) {
        _dateCount = args.value.length.toString();
      } else {
        _rangeCount = args.value.length.toString();
      }
    });
  }

  void initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _transactionList(
          _formatDate(apiDateFormat, now), _formatDate(apiDateFormat, now),'ALL');
    });
  }

  _subtractDays1(String dateFormat, Duration duration) {
    return DateFormat(dateFormat).format(DateTime.now().subtract(duration));
  }

  void onSearchTextChanged(String value) {
    print('value $value');
    if (value.isEmpty) {
      _transactionList(
          _formatDate(apiDateFormat, now), _formatDate(apiDateFormat, now),'ALL');
    }
    else
      {
        searchList = [];
        allTxnList.forEach((transDetail) {
          if((transDetail.particular).toString().toLowerCase().contains(value) ||
              (transDetail.txnType).toString().toLowerCase().contains(value) ||
              // transDetail.debitAmount != null ? transDetail.debitAmount.toInt().toString().contains(value) : false ||
              transDetail.gameGroup.toString().toLowerCase().contains(value)
          )
          {
            searchList.add(transDetail);
          }

          print(searchList.length);
        });
        // txnList.clear();
        txnList = searchList;

        BlocProvider.of<TransactionListCubit>(context).fetchSearchTransactionList(txnList,);
        print('length');
        print(txnList.length);
        print(allTxnList.length);
      }
  }
  }

typedef DateCallback = void Function(DateTime date);

class Calendar extends StatefulWidget {
  final DateCallback callback;
  final DateTime lastDay;
  const Calendar({
    Key? key,
    required this.callback,
    required this.lastDay,
  }) : super(key: key);

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  final DateTime _firstDay = DateTime(DateTime.now().year - 5);

  DateTime? _selectedDay;
  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      firstDay: _firstDay,
      lastDay: widget.lastDay,
      focusedDay: widget.lastDay,
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      headerStyle: const HeaderStyle(
        titleCentered: true,
        formatButtonVisible: false,
        titleTextStyle: TextStyle(fontWeight: FontWeight.bold),
      ),
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;

          widget.callback(selectedDay);
        });
      },
    );
  }
}

class ToCalendar extends StatefulWidget {
  final DateCallback callback;
  final DateTime firstDay;
  const ToCalendar({
    Key? key,
    required this.callback,
    required this.firstDay,
  }) : super(key: key);

  @override
  _ToCalendarState createState() => _ToCalendarState();
}

class _ToCalendarState extends State<ToCalendar> {
  final DateTime _lastDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      firstDay: widget.firstDay,
      lastDay: _lastDay,
      focusedDay: _focusedDay,
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      headerStyle: const HeaderStyle(
        titleCentered: true,
        formatButtonVisible: false,
        titleTextStyle: TextStyle(fontWeight: FontWeight.bold),
      ),
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
          widget.callback(selectedDay);
        });
      },
    );
  }
}

class BottomNavigationView extends StatelessWidget {
  const BottomNavigationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: const BoxDecoration(
        color: Colors.deepPurpleAccent,
        borderRadius: BorderRadius.all(Radius.circular(40.0)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const <Widget>[
          TabItem(
            icon: Icons.home,
            text: 'Home',
          ),
          TabItem(
            icon: Icons.emoji_emotions,
            text: 'Boom5',
          ),
          TabItem(
            icon: Icons.add_circle,
          ),
          TabItem(
            icon: CupertinoIcons.bolt_fill,
            text: 'Instant Win',
          ),
          TabItem(
            icon: Icons.person,
            text: 'Our Winners',
          ),
        ],
      ),
    ).p20();
  }
}

class TabItem extends StatelessWidget {
  final IconData icon;
  final String? text;
  const TabItem({
    Key? key,
    required this.icon,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Icon(
          icon,
          size: 30,
          color: Colors.white,
        ),
        text != null
            ? Text(
                text!,
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                ),
              )
            : Container(),
      ],
    );
  }
}
