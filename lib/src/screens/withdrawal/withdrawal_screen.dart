import 'dart:math';

import 'package:boom_lotto/src/common/common.dart';
import 'package:boom_lotto/src/common/theme.dart';
import 'package:boom_lotto/src/constants/strings.dart';
import 'package:boom_lotto/src/cubit/email_verification_cubit/email_otp_cubit.dart';
import 'package:boom_lotto/src/cubit/withdrawal_cubit/withdrawal_cubit.dart';
import 'package:boom_lotto/src/cubit/withdrawal_cubit/withdrawal_state.dart';
import 'package:boom_lotto/src/data/model/id_proof.dart';
import 'package:boom_lotto/src/data/model/payment_option_model.dart';
import 'package:boom_lotto/src/widgets/show_toast.dart';
import 'package:boom_lotto/src/widgets/theme_button.dart';
import 'package:boom_lotto/src/widgets/text_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:velocity_x/velocity_x.dart';

class WithdrawalScreen extends StatefulWidget {
  const WithdrawalScreen({Key? key}) : super(key: key);

  @override
  _WithdrawalScreenState createState() => _WithdrawalScreenState();
}

class _WithdrawalScreenState extends State<WithdrawalScreen> {
  double? accountBalance = 100;
  int selectedIndex = 0;
  bool otpSent = false;
  List<IdProof> idProofTypes = [
    IdProof(docName: "PASSPORT", docDisplayName: "Passport ID"),
    IdProof(docName: "DRIVING_LICENSE", docDisplayName: "Driving Licence"),
  ];
  final TextEditingController _amount = TextEditingController();
  final TextEditingController _emailId = TextEditingController();
  final TextEditingController _otp = TextEditingController();
  var rand = new Random();

  @override
  void initState() {
    accountBalance = rand.nextInt(100) % 2 == 0 ? 100 : 0.0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<WithdrawalCubit>(context).getPaymentOption();
    return MyScaffold(
      title: "WITHDRAWAL",
      showBalance: true,
      showBottomNavigationBar: true,
      child: BlocBuilder<WithdrawalCubit, WithdrawalState>(
        builder: (context, state) {
          if (state is! Withdrawaled) {
            return const Center(child: Text(''));
          }
          PaymentOptionModel paymentOptionModel = (state).paymentOption;
          double minValue =
              (paymentOptionModel.payTypeMap?.TwoTwo?.minValue) ?? 0.0;
          // print(
          //     "paymentOptionModel : ${paymentOptionModel.payTypeMap?.TwoTwo
          //         ?.minValue} type: ${paymentOptionModel.payTypeMap?.TwoTwo
          //         ?.minValue.runtimeType}");
          //paymentOptionModel : 1.0 type: double
          //account balance is less than min value insufficient balance else verification
          return accountBalance! < minValue
              ? _inSufficientBalanceBuild()
              : _emailVerificationBuild();
        },
      ),

      // accountBalance > 0 ?
      // // verification withdrawal screen is for bank and id verification
      // const VerificationWithdrawalScreen() :
      // // //When email is not verified
      // //  _emailVerificationBuild():
      // // //verified withdrawal screen
      // // const VerifiedWithdrawalScreen():
      // _inSufficientBalanceBuild(),
    );
  }

  _emailVerificationBuild() {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        height: context.screenHeight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: context.screenWidth - 40,
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  const Text(
                    "Your current Boom balance is",
                    style: TextStyle(
                      color: ZeplinColors.dark_blue,
                      fontSize: 16,
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.w400,
                    ),
                  ).pSymmetric(v: 8),
                  Text(
                    "AED $accountBalance",
                    style: const TextStyle(
                      color: ZeplinColors.aquamarine,
                      fontSize: 28.0,
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.w700,
                    ),
                  ).pSymmetric(v: 8),
                  RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: "Withdrawable Amount",
                            style: TextStyle(
                              color: ZeplinColors.light_blue,
                              fontSize: 13,
                              fontFamily: 'OpenSans',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          TextSpan(
                            text: " AED $accountBalance",
                            style: const TextStyle(
                              color: ZeplinColors.dark_blue,
                              fontSize: 13,
                              fontFamily: 'OpenSans',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      )),
                ],
              ),
              decoration: BoxDecoration(
                border: Border.all(color: ZeplinColors.aquamarine_50, width: 1),
                color: ZeplinColors.aquamarine_50_10,
                borderRadius: const BorderRadius.all(
                  Radius.circular(14.0),
                ),
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Withdraw Now (Amount in AED)
                  RichText(
                      text: const TextSpan(children: [
                        TextSpan(
                            text: "Withdraw Now ",
                            style: TextStyle(
                              fontFamily: 'OpenSans',
                              color: ZeplinColors.dark_blue,
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.normal,
                            )),
                        TextSpan(
                            text: "(Amount in AED)",
                            style: TextStyle(
                              fontFamily: 'OpenSans',
                              color: ZeplinColors.dark_blue,
                              fontSize: 22,
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                            )),
                      ])),
                  const Text(
                    "Withdrawal charges for amount less than AED 300 is AED 10 (within the UAE) and AED 20 (outside the UAE). ",
                    style: TextStyle(
                      fontFamily: 'OpenSans',
                      color: ZeplinColors.dark_blue,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                    ),
                  ).pSymmetric(v: 8),
                ],
              ),
            ),
            TextBox(
              inputFormatters: [FilteringTextInputFormatter
                  .digitsOnly
              ],
              //inputType: TextInputType.number,
              controller: _amount,
              label: 'Amount',
              hintText: "Enter Your Amount",
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                TextBox(
                  controller: _emailId,
                  label: 'Email',
                  hintText: "Enter Your Email",
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    width: 100,
                    child: BlocListener<EmailOtpCubit, EmailOtpState>(
                      listener: (context, state) {
                        if (state is EmailOtpError) {
                          ShowToast.showToast(state.error);
                        } else if (state is EmailedOtp) {
                          setState(() {
                            otpSent = true;
                          });
                          ShowToast.showToast(state.success);
                        }
                      },
                      child: ThemeButton(
                        borderRadius: 8.0,
                        enabled: true,
                        onPressed: () {
                          BlocProvider.of<EmailOtpCubit>(context)
                              .getEmailOtp(
                              _amount.text.trim(), _emailId.text.trim());
                        },
                        text: "Get OTP",
                      ),
                    ),
                  ).pLTRB(0, 30, 8, 8),
                ),
              ],
            ),
            otpSent ?
            const Text("We have sent the code verification to your Email ID.",
                style: TextStyle(
                  fontFamily: 'OpenSans',
                  color: ZeplinColors.dark_blue,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                )) :
            const SizedBox(),
            TextBox(
              controller: _otp,
              label: 'Enter OTP',
              hintText: "Enter OTP Here",
            ),
            const Text(
              "You are withdrawing for the first time. So, we need to verify some of your details. Just two simple steps,  for this time only.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ZeplinColors.dark_blue,
                fontSize: 13,
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.w400,
              ),
            ).p(14),
            BlocListener<EmailOtpCubit, EmailOtpState>(
              listener: (context, state) {
                if (state is VerifyOtpError) {
                  print("VerifyOtpError state.error: ${state.error}");
                  ShowToast.showToast(state.error);
                } else if (state is VerifiedOtp) {
                  ShowToast.showToast(state.success);
                  Navigator.pushReplacementNamed(context, VERIFICATION_WITHDRAWAL_SCREEN,arguments: _amount.text.trim);
                }
              },
              child: ThemeButton(
                enabled: true,
                onPressed: () {
                  BlocProvider.of<EmailOtpCubit>(context)
                      .verifyEmailOtp(_amount.text.trim(), _emailId.text.trim(),
                      _otp.text.trim());
                  //Navigator.pushReplacementNamed(context, VERIFICATION_WITHDRAWAL_SCREEN,arguments: _amount.text.trim);
                },
                text: "CONTINUE",
              ),
            ),
            otpSent ?const SizedBox():const SizedBox(
              height: 60.0,
            ),
          ],
        ),
      ),
    );
  }

  _inSufficientBalanceBuild() {
    var _sizedBox_10TenPercent = SizedBox(
      height: context.screenHeight * 0.1,
    );
    var _sizedBox_10FivePercent = SizedBox(
      height: context.screenHeight * 0.05,
    );
    return SingleChildScrollView(
      child: Container(
        width: context.screenWidth,
        height: context.screenHeight - 100,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            _sizedBox_10TenPercent,
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
            _sizedBox_10TenPercent,
            const Text("Oops!\nInsufficient Balance",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'OpenSans',
                  color: ZeplinColors.blue_violet,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.normal,
                )),
            _sizedBox_10FivePercent,
            // Minimum withdrawal amount is AED 10
            RichText(
                text: const TextSpan(children: [
                  TextSpan(
                      text: "Minimum withdrawal amount is AED",
                      style: TextStyle(
                        fontFamily: 'OpenSans',
                        color: ZeplinColors.dark_blue,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                      )),
                  TextSpan(
                      text: " 10 ",
                      style: TextStyle(
                        fontFamily: 'OpenSans',
                        color: ZeplinColors.dark_blue,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal,
                      )),
                ])),
            _sizedBox_10FivePercent,
            Container(
              width: context.screenWidth - 40,
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  const Text(
                    "Your current account balance is",
                    style: TextStyle(
                      color: ZeplinColors.dark_blue,
                      fontSize: 16,
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.w400,
                    ),
                  ).pSymmetric(v: 8),
                  Text(
                    "AED $accountBalance",
                    style: const TextStyle(
                      color: ZeplinColors.aquamarine,
                      fontSize: 28.0,
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.w700,
                    ),
                  ).pSymmetric(v: 8),
                ],
              ),
              decoration: BoxDecoration(
                border: Border.all(color: ZeplinColors.aquamarine_50, width: 1),
                color: ZeplinColors.aquamarine_50_10,
                borderRadius: const BorderRadius.all(
                  Radius.circular(14.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _apiError(){
    return SizedBox(
      height: context.screenHeight - 160,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          Center(child: Text('Api response error'))
        ],
      ),
    );
  }
}
