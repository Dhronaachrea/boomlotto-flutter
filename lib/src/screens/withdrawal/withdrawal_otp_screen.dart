import 'dart:async';
import 'dart:convert';
import 'package:boom_lotto/src/common/common.dart';
import 'package:boom_lotto/src/common/theme.dart';
import 'package:boom_lotto/src/widgets/theme_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:boom_lotto/src/common/shared.dart';
import 'package:boom_lotto/src/screens/home_screen.dart';
import 'package:boom_lotto/src/services/ram_service.dart';

class WithdrawalOtpScreen extends StatefulWidget {
  final String number;
  final bool type;
  final String code;
  final String countryCode;
  const WithdrawalOtpScreen(
      {Key? key,
        required this.number,
        required this.type,
        required this.code,
        required this.countryCode})
      : super(key: key);

  @override
  _WithdrawalOtpScreenState createState() => _WithdrawalOtpScreenState();
}

class _WithdrawalOtpScreenState extends State<WithdrawalOtpScreen> {
  final TextEditingController _digit1 = TextEditingController();
  final TextEditingController _digit2 = TextEditingController();
  final TextEditingController _digit3 = TextEditingController();
  final TextEditingController _digit4 = TextEditingController();
  final TextEditingController _digit5 = TextEditingController();
  final TextEditingController _digit6 = TextEditingController();
  Color borderColor = ZeplinColors.light_blue_grey;

  static const interval = Duration(seconds: 1);
  Timer _timer = Timer(interval, () {});
  final int timerMaxSeconds = 30;
  bool enabled = false;
  bool showError = false;
  bool showReferralCodeBox = false;
  int currentSeconds = 0;
  String get timerText => currentSeconds == 0
      ? '30'
      : ((timerMaxSeconds - currentSeconds) % 30).toString().padLeft(2, '0');
  Color color = const Color(0xffff7eb2);
  @override
  void initState() {
    super.initState();
    startTimeout();
  }

  @override
  void dispose() {
    super.dispose();
    _digit1.dispose();
    _digit2.dispose();
    _digit3.dispose();
    _digit4.dispose();
    _digit5.dispose();
    _digit6.dispose();
    _timer.cancel();
  }

  startTimeout() {
    if (!mounted) return;
    var duration = interval;
    _timer = Timer.periodic(duration, (timer) {
      setState(() {
        currentSeconds = timer.tick;
        if (timer.tick >= timerMaxSeconds) timer.cancel();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var _sizedBox_TenPercent = SizedBox(
      height: context.screenHeight * 0.1,
    );
    var _sizedBox_FivePercent = SizedBox(
      height: context.screenHeight * 0.05,
    );
    return CommonContainer(
        Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _sizedBox_TenPercent,
              //illustration icon
              const Text(
                "ILLUSTRATION ICON",
                style: TextStyle(
                  fontFamily: 'OpenSans',
                  color: Color(0xff170e2a),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                ),
              ),
              _sizedBox_TenPercent,
              //its you
              const Text(
                "Just verify, It's you",
                style: TextStyle(
                  fontFamily: 'OpenSans',
                  color: ZeplinColors.blue_violet_dark,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.normal,
                ),
              ),
              //otp sent text
              const Text(
                "An OTP has been sent to your registered mobile number. Please enter it below",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'OpenSans',
                  color: Color(0xff170e2a),
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                ),
              ).p(20),
              SizedBox(height: context.screenHeight * 0.01),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextEditorForPhoneVerify(
                        code: _digit1,
                        callback: (error) {
                          showErrorMsg(error);
                        }),
                    TextEditorForPhoneVerify(
                        code: _digit2,
                        callback: (error) {
                          showErrorMsg(error);
                        }),
                    TextEditorForPhoneVerify(
                        code: _digit3,
                        callback: (error) {
                          showErrorMsg(error);
                        }),
                    TextEditorForPhoneVerify(
                        code: _digit4,
                        callback: (error) {
                          showErrorMsg(error);
                        }),
                    TextEditorForPhoneVerify(
                        code: _digit5,
                        callback: (error) {
                          showErrorMsg(error);
                        }),
                    TextEditorForPhoneVerify(
                        code: _digit6,
                        callback: (error) {
                          showErrorMsg(error);
                        }),
                  ]),
              SizedBox(height: context.screenHeight * 0.01),
              showError
                  ? const Center(
                child: Text(
                  'Please Provide valid OTP',
                  style: TextStyle(
                    color: ZeplinColors.pink_red,
                  ),
                ),
              )
                  : Container(),
              SizedBox(height: context.screenHeight * 0.02),
              currentSeconds == 30
                  ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Haven’t received the code?',
                    style: TextStyle(
                      color: ZeplinColors.dark_blue,
                      fontFamily: 'OpenSans',
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Map<String, String> params = {
                        "aliasName": "www.winboom.ae",
                        "mobileNo":
                        widget.code.substring(1) + widget.number
                      };
                      RamService.sendRegOtp(params).then((res) {
                        if (res["errorCode"] == 0) {
                          setState(() {
                            currentSeconds = 0;
                            startTimeout();
                          });
                        }
                      });
                    },
                    child: const Text(
                      ' RESEND',
                      style: TextStyle(
                        color: ZeplinColors.pink_red,
                        fontFamily: 'OpenSans',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              )
                  : Center(
                child: Text(
                  'Resend OTP in 00:$timerText sec',
                  style: const TextStyle(
                    color: ZeplinColors.pink_red,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(height: context.screenHeight * 0.03),
              //TODO need to add amount text here
              // widget.type == true
              //     ? showReferralCodeBox == false
              //     ? Center(
              //   child: OutlinedButton(
              //     onPressed: () {
              //       setState(() {
              //         showReferralCodeBox = true;
              //       });
              //     },
              //     style: ButtonStyle(
              //       side: MaterialStateProperty.resolveWith(
              //               (states) {
              //             return const BorderSide(
              //                 color: ZeplinColors.pink_red, width: 2);
              //           }),
              //       shape: MaterialStateProperty.all(
              //           RoundedRectangleBorder(
              //               borderRadius:
              //               BorderRadius.circular(54.0))),
              //     ),
              //     child: const Text(
              //       'I have referral code',
              //       style: TextStyle(
              //         color: ZeplinColors.pink_red,
              //         fontSize: 16,
              //         fontWeight: FontWeight.w500,
              //       ),
              //     ),
              //   ),
              // )
              //     : referralCode(context)
              //     : Container(),
              SizedBox(height: context.screenHeight * 0.01),
              ThemeButton(
                onPressed: () {
                  if (_digit1.text.length == 1 &&
                      _digit2.text.length == 1 &&
                      _digit3.text.length == 1 &&
                      _digit4.text.length == 1 &&
                      _digit5.text.length == 1 &&
                      _digit6.text.length == 1
                  ) {
                    setState(() {
                      showError = false;
                    });
                    Map<String, String> params = {
                      "domainName": "www.winboom.ae",
                      "deviceType": "MOBILE",
                      "loginDevice": "IOS_APP",
                      "mobileNo": widget.code.substring(1) + widget.number,
                      "otp": _digit1.text +
                          _digit2.text +
                          _digit3.text +
                          _digit4.text +
                          _digit5.text +
                          _digit6.text ,
                      "userAgent": "NA",
                      "requestIp": "132.154.253.254",
                      "countryCode": widget.countryCode,
                      "currencyCode": "AED",
                    };
                    RamService.registerPlayerWithOtp(params).then((res) {
                      if (res["errorCode"] == 0) {
                        MySharedPreferences.instance.setStringValue(
                            "playerToken", res["playerToken"]);
                        MySharedPreferences.instance.setStringValue(
                            "playerId",
                            res["playerLoginInfo"]["playerId"].toString());
                        MySharedPreferences.instance.setStringValue(
                            "userName",
                            res["playerLoginInfo"]["userName"].toString());

                        MySharedPreferences.instance.setStringValue(
                            "walletBean",
                            json
                                .encode(
                                res["playerLoginInfo"]["walletBean"])
                                .toString());

                        MySharedPreferences.instance.setStringValue(
                            "unreadMsgCount",
                            json
                                .encode(res["playerLoginInfo"]
                            ["unreadMsgCount"])
                                .toString());

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomeScreen(),
                          ),
                        );
                      }
                    });
                  } else {
                    setState(() {
                      showError = true;
                    });
                  }
                },
                enabled: enabled,
                text: 'RAISE WITHDRAWAL REQUEST',
              ),
              SizedBox(height: context.screenHeight * 0.01),
              SizedBox(
                width:context.screenWidth,
                height: 51,
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      showReferralCodeBox = true;
                    });
                  },
                  style: ButtonStyle(
                    side: MaterialStateProperty.resolveWith(
                            (states) {
                          return const BorderSide(
                              color: ZeplinColors.pink_red, width: 2);
                        }),
                    shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(54.0))),
                  ),
                  child: const Text(
                    'SAVE DETAILS',
                    style: TextStyle(
                      color: ZeplinColors.pink_red,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        context.screenHeight)
        .getContainer('Widthdrawal Screen');
  }

  void showErrorMsg(bool error) {
    setState(() {
      if (_digit1.text.length == 1 &&
          _digit2.text.length == 1 &&
          _digit3.text.length == 1 &&
          _digit4.text.length == 1 &&
          _digit5.text.length == 1 &&
          _digit6.text.length == 1) {
        enabled = true;
      } else {
        enabled = false;
      }
      showError = error;
    });
  }

  Container referralCode(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      height: context.screenHeight * 0.07,
      decoration: BoxDecoration(
        color: const Color(0x0f6200e2),
        border: Border.all(
          color: ZeplinColors.blue_violet,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
                keyboardType: TextInputType.text,
                textAlign: TextAlign.left,
                style: const TextStyle(
                  color: ZeplinColors.blue_violet,
                  fontSize: 24.0,
                ),
                maxLength: 8,
                decoration: const InputDecoration(
                  counterText: '',
                  border: InputBorder.none,
                  hintText: 'Enter Referral Code',
                  hintStyle:
                  TextStyle(color: ZeplinColors.blue_violet, fontSize: 15),
                  prefix: Text("  "),
                ),
                onChanged: (text) {}),
          ),
          MaterialButton(
            height: context.screenHeight * 0.06,
            onPressed: () {},
            color: ZeplinColors.pink_red,
            child: const Text('Verify',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                )),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ],
      ),
    );
  }
}

typedef OtpCallback = void Function(bool showError);

class TextEditorForPhoneVerify extends StatefulWidget {
  final TextEditingController code;
  final OtpCallback callback;
  const TextEditorForPhoneVerify({required this.code, required this.callback});

  @override
  _TextEditorForPhoneVerifyState createState() =>
      _TextEditorForPhoneVerifyState();
}

class _TextEditorForPhoneVerifyState extends State<TextEditorForPhoneVerify> {
  Color borderColor = ZeplinColors.light_blue_grey;
  final FocusNode _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focus.removeListener(() {
      _onFocusChange;
    });
    _focus.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (_focus.hasFocus == true) {
      borderColor = ZeplinColors.blue_violet;
    } else {
      borderColor = ZeplinColors.light_blue_grey;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65,
      width: 50.0,
      decoration: BoxDecoration(
        color: ZeplinColors.pale_grey,
        border: Border.all(
          color: borderColor,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        focusNode: _focus,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        style: const TextStyle(
            fontSize: 32.0,
            fontWeight: FontWeight.w700,
            color: ZeplinColors.dark_blue),
        maxLength: 1,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        controller: widget.code,
        decoration: const InputDecoration(
          border: InputBorder.none,
          counterText: "",
        ),
        onChanged: (text) {
          widget.callback(false);
          if (text.length == 1) {
            FocusScope.of(context).nextFocus();
          } else {
            FocusScope.of(context).previousFocus();
          }
        },
      ),
    );
  }
}
