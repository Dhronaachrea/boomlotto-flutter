import 'package:another_flushbar/flushbar.dart';
import 'package:boom_lotto/src/common/common.dart';
import 'package:boom_lotto/src/constants/strings.dart';
import 'package:boom_lotto/src/cubit/country_list_cubit/country_list_cubit.dart';
import 'package:boom_lotto/src/cubit/country_list_cubit/country_list_state.dart';
import 'package:boom_lotto/src/cubit/login_cubit/login_cubit.dart';
import 'package:boom_lotto/src/cubit/login_cubit/login_state.dart';
import 'package:boom_lotto/src/data/model/country_list_model.dart';
import 'package:boom_lotto/src/data/model/login_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:velocity_x/velocity_x.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String flag = '';
  String code = '';
  String countryCode = '';
  final TextEditingController _mobileNumber = TextEditingController();
  List countryList = [];
  @override
  void initState() {
    super.initState();
    // RamService.getCountryList().then((res) {
    //   setState(() {
    //     countryList = res;
    //     flag = res[0]['flag'];
    //     code = res[0]['isdCode'];
    //     countryCode = res[0]['countryCode'];
    //     for (int i = 0; i < res.length; i++) {
    //       if (res[i]['isDefault'] == true) {
    //         flag = res[i]['flag'];
    //         code = res[i]['isdCode'];
    //         break;
    //       }
    //     }
    //   });
    // });
  }

  @override
  void dispose() {
    super.dispose();
    _mobileNumber.dispose();
  }

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<CountryListCubit>(context).fetchCountryList();
    return Scaffold(
      // localizationsDelegates: [
      //   GlobalCupertinoLocalizations.delegate,
      //   GlobalMaterialLocalizations.delegate,
      //   GlobalWidgetsLocalizations.delegate,
      // ],
      // supportedLocales: [
      //   Locale("en", "US"),
      //   Locale("ar", "AE"),
      // ],
      // debugShowCheckedModeBanner: false,

      // home: Directionality(
      //   textDirection:
      //       TextDirection.ltr, // change to RTL when language is arabic
      //   child: SplashScreen(),
        body: Stack(children: [
          SvgPicture.asset("assets/background.svg",
              fit: BoxFit.cover, height: double.infinity, width: double.infinity),
          Scaffold(
              backgroundColor: Colors.transparent,
              resizeToAvoidBottomInset: false,
              // appBar: AppBar(
              //   bottom: PreferredSize(
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         Text(
              //           'Get Started',
              //           style: TextStyle(
              //             color: Colors.white,
              //             fontSize: 22,
              //             fontWeight: FontWeight.w700,
              //           ),
              //         ),
              //         Text(
              //           '',
              //           style: TextStyle(
              //             color: Colors.white,
              //             fontSize: 22,
              //             fontWeight: FontWeight.w700,
              //           ),
              //         ),
              //       ],
              //     ),
              //     preferredSize: Size.fromHeight(70.0),
              //   ),
              //   elevation: 0,
              //   backgroundColor: Colors.transparent,
              // ),
              body: BlocListener<LoginCubit, LoginState>(
                  listener: (context, state) {
                    if (state is Logined) {

                      LoginModel loginModel = (state).loginModel;
                      Map loginDetails = {
                        // 'mobileNumber': loginModel.data!.mobileNo,
                        'mobileNumber': _mobileNumber.text,
                        'otpCode': loginModel.data!.mobVerificationCode,
                        'type': true,
                        'countryCode': code,
                        'countryName': countryCode
                      };
                      Navigator.pushNamed(context, OTP_SCREEN,arguments: loginDetails);
                      _mobileNumber.clear();
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
                  },
                  child: CommonContainer(
                    Column(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.only(left:20, right: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                    width: context.screenWidth,
                                    child: Text(
                                      'Please enter your mobile number',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        color: Color(0xff00004c),
                                        fontSize: 20,
                                      ),
                                    )
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Select Country",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xff00004c)),
                                    ).pOnly(bottom: 15),
                                    Container(
                                      height: 51,
                                      decoration: BoxDecoration(
                                        color: const Color(0xfff5f7f9),
                                        border: Border.all(
                                          color: const Color(0xffdce9f5),
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        children: [
                                          BlocBuilder<CountryListCubit, CountryListState>(
                                            builder: (context, state) {
                                              if (state is! CountryListLoaded) {
                                                return const Center(
                                                    child: Text(''));
                                              }
                                              // CountryListModel todos = (state).todos;
                                              CountryListModel todos = (state as CountryListLoaded).countryListModel;
                                              if(todos != null)
                                                getCountryList(todos.data);
                                              // return Text(todos.data!.games!.dAILYLOTTO!.jackpotAmount.toString());
                                              return SizedBox(
                                                width: 140,
                                                child: countryList.length > 1
                                                // child: todos.data!.length > 1
                                                    ? GestureDetector(
                                                  onTap: () async {
                                                    Navigator.pushNamed(context, COUNTRY_LIST_SCREEN, arguments: todos);
                                                    // final result = await Navigator.push(
                                                    //     context,
                                                    //     MaterialPageRoute(
                                                    //         builder: (context) =>
                                                    //             CountryListScreen(
                                                    //                 countryList:
                                                    //                     countryList)));
                                                    // if (result != null) {
                                                    //   setState(() {
                                                    //     flag = result.flag;
                                                    //     code = result.isdCode;
                                                    //     countryCode = result
                                                    //         .countryCode;
                                                    //   });
                                                    // }
                                                  },
                                                  child: Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                    children: [
                                                      Text(
                                                        flag,
                                                        style:
                                                        const TextStyle(
                                                          fontSize: 30.0,
                                                        ),
                                                      ).pOnly(left: 10.0),
                                                      Text(' $code',
                                                          style:
                                                          const TextStyle(
                                                            color: Color(
                                                                0xff00004c),
                                                            fontSize: 24.0,
                                                            fontWeight:
                                                            FontWeight
                                                                .w700,
                                                          )),
                                                      const Icon(Icons
                                                          .arrow_drop_down),
                                                    ],
                                                  ),
                                                )
                                                    : Text(
                                                  flag,
                                                  style: const TextStyle(
                                                    fontSize: 30.0,
                                                  ),
                                                ).pOnly(
                                                    left: 10.0, right: 10.0),
                                              );
                                            },
                                          ),
                                          Container(
                                            height: 22.5,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.grey,
                                                width: 1,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: TextField(
                                              controller: _mobileNumber,
                                              keyboardType: TextInputType.number,
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .digitsOnly
                                              ],
                                              style: const TextStyle(
                                                color: Color(0xff00004c),
                                                fontSize: 24.0,
                                                fontWeight: FontWeight.w700,
                                              ),
                                              maxLength: 8,
                                              decoration: const InputDecoration(
                                                  counterText: '',
                                                  border: InputBorder.none,
                                                  isDense: true,
                                                  hintText: 'Mobile Number',
                                                  hintStyle: TextStyle(
                                                    fontSize: 20.0,
                                                    color: Colors.grey,
                                                  ),
                                                  prefix: Text("  ")),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        final countryCode = code.isNotEmpty ? code.split('+')[1] : '';
                                        final mobileNumber =  _mobileNumber.text;
                                        if(mobileNumber.isEmpty)
                                        {
                                          Flushbar(
                                            message: "Plz enter mobile number!",
                                            duration: Duration(seconds: 3),
                                            backgroundColor: Colors.red,
                                            flushbarPosition: FlushbarPosition.TOP,
                                          )..show(context);
                                        }
                                        else
                                        {
                                          BlocProvider.of<LoginCubit>(context).getLogin(countryCode,mobileNumber);
                                        }

                                        // Map<String, String> params = {
                                        //   "aliasName": "www.winboom.ae",
                                        //   "mobileNo": code.substring(1) + _mobileNumber.text
                                        // };
                                        // RamService.sendRegOtp(params).then((res) {
                                        //   print(res);
                                        //   if (res["errorCode"] == 0) {
                                        //     bool type = false;
                                        //     if (res["data"]["otpActionType"] ==
                                        //         'REGISTRATION') {
                                        //       type = true;
                                        //     }
                                        //     Navigator.push(
                                        //       context,
                                        //       MaterialPageRoute(
                                        //         builder: (context) => OtpScreen(
                                        //           number: _mobileNumber.text,
                                        //           type: type,
                                        //           code: code,
                                        //           countryCode: countryCode,
                                        //         ),
                                        //       ),
                                        //     );
                                        //   }
                                        // });
                                      },
                                      child: Container(
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: const Color(0xffff0068),
                                          borderRadius: BorderRadius.circular(25),
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Color(0x54ff0068),
                                              offset: Offset(0, 13),
                                              blurRadius: 36,
                                              spreadRadius: 0,
                                            ),
                                          ],
                                        ),
                                        child: const Center(
                                          child: Text(
                                            'GET OTP',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 17,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                const Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text:
                                        'We like to keep it real. So by logging in you agree you’re above 18 years and understand our ',
                                        style: TextStyle(
                                          color: Color(0xff646464),
                                          fontSize: 12,
                                        ),
                                      ),
                                      TextSpan(
                                        text: 'Terms of Service',
                                        style: TextStyle(
                                          color: Color(0xff6200e2),
                                          fontSize: 12,
                                        ),
                                      ),
                                      TextSpan(
                                        text: ' and ',
                                        style: TextStyle(
                                          color: Color(0xff646464),
                                          fontSize: 12,
                                        ),
                                      ),
                                      TextSpan(
                                        text: 'Privacy Policy',
                                        style: TextStyle(
                                          color: Color(0xff6200e2),
                                          fontSize: 12,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '.',
                                        style: TextStyle(
                                          color: Color(0xff646464),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  style: TextStyle(
                                    color: Color(0xff646464),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    context.screenHeight,
                  ).getContainer('Let’s Get Started!'))
          )
        ]));
  }

  // void getCountryList(List<Data>? data) {
  void getCountryList(var data) {
    countryList = data!;
    flag = data[0].flag!;
    code = data[0].isdCode!;
    countryCode = data[0].countryCode!;
    // for (int i = 0; i < data.length; i++) {
    //   if (data[i].isDefault == true) {
    //     flag = data[i].flag!;
    //     code = data[i].isdCode!;
    //     break;
    //   }
    // }
  }
}
