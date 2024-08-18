import 'dart:async';
import 'dart:convert';
import 'package:another_flushbar/flushbar.dart';
import 'package:boom_lotto/src/common/common.dart';
import 'package:boom_lotto/src/common/theme.dart';
import 'package:boom_lotto/src/constants/strings.dart';
import 'package:boom_lotto/src/cubit/login_cubit/login_cubit.dart';
import 'package:boom_lotto/src/cubit/login_cubit/login_state.dart';
import 'package:boom_lotto/src/cubit/referral_code_cubit/referral_code_cubit.dart';
import 'package:boom_lotto/src/cubit/referral_code_cubit/referral_code_state.dart';
import 'package:boom_lotto/src/cubit/sign_up_cubit/sign_up_cubit.dart';
import 'package:boom_lotto/src/cubit/sign_up_cubit/sign_up_state.dart';
import 'package:boom_lotto/src/data/model/login_model.dart';
import 'package:boom_lotto/src/data/model/referral_code_model.dart';
import 'package:boom_lotto/src/data/model/signup_model.dart';
import 'package:boom_lotto/src/widgets/theme_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:boom_lotto/src/common/shared.dart';
import 'package:boom_lotto/src/screens/home_screen.dart';
import 'package:boom_lotto/src/services/ram_service.dart';

class OtpScreen extends StatefulWidget {
  String? number;
  bool? type;
  String? code;
  String? countryCode;
  String? countryName;

  OtpScreen(
      {Key? key,
        required this.number,
        required this.type,
        required this.code,
        required this.countryCode,
        required this.countryName,
      })
      : super(key: key);

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _digit1 = TextEditingController();
  final TextEditingController _digit2 = TextEditingController();
  final TextEditingController _digit3 = TextEditingController();
  final TextEditingController _digit4 = TextEditingController();
  Color borderColor = ZeplinColors.light_blue_grey;

  static const interval = Duration(seconds: 1);
  Timer _timer = Timer(interval, () {});
  final int timerMaxSeconds = 30;
  bool enabled = false;
  bool showError = false;
  bool showReferralCodeBox = false;
  int currentSeconds = 0;
  LoginModel? loginModel;
  final TextEditingController referralController = new TextEditingController();
  SharedPreferences? prefs;
  String? txt_value = '';
  String? phone_number;
  String? otp_value;
  String? countryName;

  String get timerText{
    if(currentSeconds == 0)
      return '30';
    else
      return ((timerMaxSeconds - currentSeconds) % 30).toString().padLeft(2, '0');
  }
  // String get timerText =>
  //     currentSeconds == 0
  //     ? '30'
  //     : ((timerMaxSeconds - currentSeconds) % 30).toString().padLeft(2, '0');
  Color color = const Color(0xffff7eb2);
  @override
  void initState() {
    super.initState();
    initPrefs();
    startTimeout();
  }

  @override
  void dispose() {
    super.dispose();
    _digit1.dispose();
    _digit2.dispose();
    _digit3.dispose();
    _digit4.dispose();
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
    return MultiBlocListener(listeners: [
      BlocListener<SignUpCubit, SignUpState>(
        listener: (context, state) {
          if (state is SignedUp) {
            SignUpModel signUpModel = (state).signUpModel;

            if (signUpModel.errorCode == 0) {
              prefs!.setString('playerToken', signUpModel.playerToken.toString());
              prefs!.setInt('playerId', int.parse(signUpModel.playerLoginInfo!.playerId.toString()));
              prefs!.setString('userName', signUpModel.playerLoginInfo!.userName.toString());
              prefs!.setString('walletBean', json.encode(signUpModel.playerLoginInfo!.walletBean).toString());
              prefs!.setString('unreadMsgCount', json.encode(signUpModel.playerLoginInfo!.unreadMsgCount).toString());
              // MySharedPreferences.instance.setStringValue(
              //     "playerToken", signUpModel.playerToken.toString());
              // MySharedPreferences.instance.setStringValue(
              //     "playerId", signUpModel.playerLoginInfo!.playerId.toString());
              // MySharedPreferences.instance.setStringValue(
              //     "userName", signUpModel.playerLoginInfo!.userName.toString());
              // MySharedPreferences.instance.setStringValue(
              //     "walletBean", json.encode(signUpModel.playerLoginInfo!.walletBean).toString());
              // MySharedPreferences.instance.setStringValue(
              //     "unreadMsgCount", json.encode(signUpModel.playerLoginInfo!.unreadMsgCount).toString());
              Navigator.pushNamed(context, HOME_SCREEN);
            }
            else if(signUpModel.errorCode == 10453)
            Flushbar(
              message: 'Otp Verification Failed',
              duration: Duration(seconds: 3),
              backgroundColor: Colors.red,
              flushbarPosition: FlushbarPosition.TOP,
            )..show(context);

          } else if (state is SignUpError) {
            Flushbar(
              message: state.error,
              duration: Duration(seconds: 3),
              backgroundColor: Colors.red,
              flushbarPosition: FlushbarPosition.TOP,
            )..show(context);
            // CupertinoAlertDialog(
            //   title: const Text('Boom Lotto'),
            //   content: Text(state.error),
            //   actions: <Widget>[
            //     CupertinoDialogAction(
            //       child: const Text('OK'),
            //       onPressed: () => Navigator.of(context).pop(true),
            //     ),
            //   ],
            // );
          }
          else if(state is SigningUp)
            Center(child: CircularProgressIndicator());

        },
      ),
      BlocListener<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state is Logined) {
              loginModel = (state).loginModel;
              _digit1.clear();
              _digit2.clear();
              _digit3.clear();
              _digit4.clear();
              // widget.number = loginModel!.data!.mobileNo;
              widget.code = loginModel!.data!.mobVerificationCode;
              // widget.type = true;
              startTimeout();
              // Map loginDetails = {
              //   'mobileNumber': loginModel.data!.mobileNo,
              //   'otpCode': loginModel.data!.mobVerificationCode,
              //   'type': true,
              //   'countryCode': widget.code,
              //   'countryName': widget.countryCode
              // };
              // Navigator.pushNamed(context, OTP_SCREEN,arguments: loginDetails);
            } else if (state is LoginError) {
              Flushbar(
                message: state.error,
                duration: Duration(seconds: 3),
                backgroundColor: Colors.red,
                flushbarPosition: FlushbarPosition.TOP,
              )..show(context);
              // CupertinoAlertDialog(
              //   title: const Text('Boom Lotto'),
              //   content: Text(state.error),
              //   actions: <Widget>[
              //     CupertinoDialogAction(
              //       child: const Text('OK'),
              //       onPressed: () => Navigator.of(context).pop(true),
              //     ),
              //   ],
              // );
            }
          }),
      BlocListener<ReferralCodeCubit, ReferralCodeState>(
          listener: (context, state) {
            if (state is ReferraledCode) {
              ReferralCodeModel referralCodeModel = (state).referralCodeModel;
              referralController.clear();
            } else if (state is ReferralCodeError) {
              CupertinoAlertDialog(
                title: const Text('Boom Lotto'),
                content: Text(state.error),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: const Text('OK'),
                    onPressed: () => Navigator.of(context).pop(true),
                  ),
                ],
              );
            }
          })
    ],
        child: CommonContainer(
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Enter the code we just sent',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: ZeplinColors.dark_blue, fontSize: 24)),
                  const SizedBox(
                    height: 10.0,
                  ),
                  // Text('On ${widget.code} - ${widget.number}',
                  Text('On ${widget.countryCode} - ${widget.number}',
                      style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: ZeplinColors.dark_blue)),
                  SizedBox(height: context.screenHeight * 0.09),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextEditorForPhoneVerify(
                            code: _digit1,
                            callback: (error) {
                              showErrorMsg(error);
                            },
                          countryName: countryName = widget.countryName!,
                          phone_number: widget.countryCode!.split('+')[1] + widget.number!,
                          otp_value: _digit1.text + _digit2.text + _digit3.text + _digit4.text,
                          txt_value: '1'
                        ),
                        TextEditorForPhoneVerify(
                            code: _digit2,
                            callback: (error) {
                              showErrorMsg(error);
                            },
                            countryName: countryName = widget.countryName!,
                            phone_number: widget.countryCode!.split('+')[1] + widget.number!,
                            otp_value: _digit1.text + _digit2.text + _digit3.text + _digit4.text,
                            txt_value: '2'
                            ),
                        TextEditorForPhoneVerify(
                            code: _digit3,
                            callback: (error) {
                              showErrorMsg(error);
                            },
                            countryName: countryName = widget.countryName!,
                            phone_number: widget.countryCode!.split('+')[1] + widget.number!,
                            otp_value: _digit1.text + _digit2.text + _digit3.text + _digit4.text,
                            txt_value: '3'
                            ),
                        TextEditorForPhoneVerify(
                            code: _digit4,
                            callback: (error) {
                              showErrorMsg(error);
                            },
                            countryName: countryName = widget.countryName!,
                            phone_number: widget.countryCode!.split('+')[1] + widget.number!,
                            otp_value: _digit1.text + _digit2.text + _digit3.text + _digit4.text,
                            txt_value: '4'
                            ),
                      ]),
                  SizedBox(height: context.screenHeight * 0.01),
                  // showError
                  //     ? const Center(
                  //   child: Text(
                  //     'Please Provide valid OTP',
                  //     style: TextStyle(
                  //       color: ZeplinColors.pink_red,
                  //     ),
                  //   ),
                  // )
                  //     : Container(),
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
                          // Map<String, String> params = {
                          //   "aliasName": "www.winboom.ae",
                          //   "mobileNo": widget.code.substring(1) + widget.number
                          // };
                          // RamService.sendRegOtp(params).then((res) {
                          //   if (res["errorCode"] == 0) {
                          //     setState(() {
                          //       currentSeconds = 0;
                          //       startTimeout();
                          //     });
                          //   }
                          // });
                          print(widget.number);
                          print(widget.countryCode!.split('+')[1]);
                          BlocProvider.of<LoginCubit>(context).getLogin(widget.countryCode!.split('+')[1],widget.number!);
                          // BlocProvider.of<LoginCubit>(context).getLogin(widget.countryCode!.split('+')[1] + widget.number!);
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
                      '00:$timerText',
                      style: const TextStyle(
                        color: ZeplinColors.pink_red,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(height: context.screenHeight * 0.03),
                  widget.type == true
                      ? showReferralCodeBox == false
                      ? Center(
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
                        'I have referral code',
                        style: TextStyle(
                          color: ZeplinColors.pink_red,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  )
                      : referralCode(context)
                      : Container(),
                  SizedBox(height: context.screenHeight * 0.01),
                  ThemeButton(
                    onPressed: () {
                      if(enabled == true)
                      {
                        Map<String, String> params = {
                          "domainName": "www.winboom.ae",
                          "deviceType": "MOBILE",
                          "loginDevice": "IOS_APP",
                          "mobileNo": widget.countryCode!.split('+')[1] + widget.number!,
                          // "mobileNo": widget.number!,
                          "otp": _digit1.text +
                              _digit2.text +
                              _digit3.text +
                              _digit4.text,
                          "userAgent": "NA",
                          "requestIp": "132.154.253.254",
                          "countryCode": widget.countryName!,
                          // "currencyCode": widget.countryName!,
                          "currencyCode": "AED",
                        };
                        print(params);
                        if(_digit4.text.isNotEmpty)
                          BlocProvider.of<SignUpCubit>(context).getSignUp(params,_digit4.text);
                        else
                          Flushbar(
                            message: "Plz fill correct otp!",
                            duration: Duration(seconds: 3),
                            backgroundColor: Colors.red,
                            flushbarPosition: FlushbarPosition.TOP,
                          )..show(context);

                        // if (_digit1.text.length == 1 &&
                        //     _digit2.text.length == 1 &&
                        //     _digit3.text.length == 1 &&
                        //     _digit4.text.length == 1) {
                        //   setState(() {
                        //     showError = false;
                        //   });
                        //   Map<String, String> params = {
                        //     "domainName": "www.winboom.ae",
                        //     "deviceType": "MOBILE",
                        //     "loginDevice": "IOS_APP",
                        //     "mobileNo": widget.code.substring(1) + widget.number,
                        //     "otp": _digit1.text +
                        //         _digit2.text +
                        //         _digit3.text +
                        //         _digit4.text,
                        //     "userAgent": "NA",
                        //     "requestIp": "132.154.253.254",
                        //     "countryCode": widget.countryCode,
                        //     "currencyCode": "AED",
                        //   };
                        //   RamService.registerPlayerWithOtp(params).then((res) {
                        //     if (res["errorCode"] == 0) {
                        //       MySharedPreferences.instance.setStringValue(
                        //           "playerToken", res["playerToken"]);
                        //       MySharedPreferences.instance.setStringValue(
                        //           "playerId",
                        //           res["playerLoginInfo"]["playerId"].toString());
                        //       MySharedPreferences.instance.setStringValue(
                        //           "userName",
                        //           res["playerLoginInfo"]["userName"].toString());
                        //
                        //       MySharedPreferences.instance.setStringValue(
                        //           "walletBean",
                        //           json
                        //               .encode(
                        //                   res["playerLoginInfo"]["walletBean"])
                        //               .toString());
                        //
                        //       MySharedPreferences.instance.setStringValue(
                        //           "unreadMsgCount",
                        //           json
                        //               .encode(res["playerLoginInfo"]
                        //                   ["unreadMsgCount"])
                        //               .toString());
                        //
                        //       Navigator.push(
                        //         context,
                        //         MaterialPageRoute(
                        //           builder: (context) => const HomeScreen(),
                        //         ),
                        //       );
                        //     }
                        //   });
                        // } else {
                        //   setState(() {
                        //     showError = true;
                        //   });
                        // }
                      }
                    },
                    enabled: enabled,
                    text: 'Sign In',
                  ),
                ],
              ),
            ),
            context.screenHeight).getContainer('Welcome Back'));
  }

  void showErrorMsg(bool error) {
    setState(() {
      if (_digit1.text.length == 1 &&
          _digit2.text.length == 1 &&
          _digit3.text.length == 1 &&
          _digit4.text.length == 1) {
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
                controller: referralController,
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
            onPressed: () {
              BlocProvider.of<ReferralCodeCubit>(context).getReferralCode(referralController.text);
            },
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

  void initPrefs() async{
    prefs = await SharedPreferences.getInstance();
  }
}

typedef OtpCallback = void Function(bool showError);

class TextEditorForPhoneVerify extends StatefulWidget {
  final TextEditingController code;
  final OtpCallback callback;
  final String txt_value;
  final String phone_number;
  final String otp_value;
  final String countryName;

  const TextEditorForPhoneVerify(
      {
        Key? key,
        required this.txt_value,
        required this.phone_number,
        required this.otp_value,
        required this.countryName,
        required this.code,
        required this.callback
      }
      ) : super(key: key);

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
      width: 56.0,
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
            hintText: "-",
            hintStyle: const TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.w400,
                color: ZeplinColors.dark_grey)
        ),
        onChanged: (text) {
          if(widget.txt_value == '4')
            {
              Map<String, String> params = {
                "domainName": "www.winboom.ae",
                "deviceType": "MOBILE",
                "loginDevice": "IOS_APP",
                "mobileNo": widget.phone_number,
                // "mobileNo": widget.number!,
                "otp": widget.otp_value+widget.code.text,
                "userAgent": "NA",
                "requestIp": "132.154.253.254",
                "countryCode": widget.countryName,
                // "currencyCode": widget.countryName!,
                "currencyCode": "AED",
              };
              print(params);
                BlocProvider.of<SignUpCubit>(context).getSignUp(params,widget.code.text);
            }
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
