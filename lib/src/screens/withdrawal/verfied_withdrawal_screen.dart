import 'package:boom_lotto/src/common/common.dart';
import 'package:boom_lotto/src/common/theme.dart';
import 'package:boom_lotto/src/widgets/theme_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/src/extensions/context_ext.dart';
import 'package:velocity_x/src/flutter/padding.dart';
import 'package:boom_lotto/src/widgets/text_box.dart';

class VerifiedWithdrawalScreen extends StatefulWidget {
  const VerifiedWithdrawalScreen({Key? key}) : super(key: key);

  @override
  _VerifiedWithdrawalScreenState createState() =>
      _VerifiedWithdrawalScreenState();
}

class _VerifiedWithdrawalScreenState extends State<VerifiedWithdrawalScreen> {
  static const double accountBalance = 100;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Container(
        width: context.screenWidth,
        height: context.screenHeight - 100,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TabBar(
                indicatorWeight: 4.0,
                indicatorColor: ZeplinColors.blue_violet_dark,
                tabs: [
                  Container(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: const Text("NEW WITHDRAWAL",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: ZeplinColors.blue_violet_dark,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal,
                        )),
                  ),
                  Container(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: const Text("PENDING REQUEST",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: ZeplinColors.greyish,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal,
                        )),
                  ),
                ],
              ),
              SizedBox(
                height: context.screenHeight * 1.5,
                child: TabBarView(children: [
                  //first tab children
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(width: 10, height: 10),
                      Container(
                        width: context.screenWidth - 40,
                        margin: const EdgeInsets.all(8),
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
                            const Text(
                              "AED $accountBalance",
                              style: TextStyle(
                                color: ZeplinColors.aquamarine,
                                fontSize: 28.0,
                                fontFamily: 'OpenSans',
                                fontWeight: FontWeight.w700,
                              ),
                            ).pSymmetric(v: 8),
                            RichText(
                                text: const TextSpan(
                                  children: [
                                    TextSpan(
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
                                      style: TextStyle(
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
                          border: Border.all(
                              color: ZeplinColors.aquamarine_50, width: 1),
                          color: ZeplinColors.aquamarine_50_10,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(14.0),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10, height: 10),
                      const Text(
                          "Our team is still working on first time withdrawal request: AED 500",
                          style: TextStyle(
                            fontFamily: 'OpenSans',
                            color: ZeplinColors.dark_blue,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                          )),
                      const SizedBox(width: 10, height: 10),
                      //withdrawal amount
                      const TextBox(
                        label: 'Enter Withdraw Amount',
                        hintText: "Enter Withdraw Amount (in AED)",
                      ),
                      const Text("Minimum withdrawal amount AED 50 and the",
                          style: TextStyle(
                            fontFamily: 'OpenSans',
                            color: ZeplinColors.dark_blue,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                          )),
                      const Text("withdrawal request: AED 500",
                          style: TextStyle(
                            fontFamily: 'OpenSans',
                            color: ZeplinColors.dark_blue,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                          )),
                      const SizedBox(width: 20, height: 20),
                      //divider
                      Container(
                          width: context.screenWidth,
                          height: 0,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: ZeplinColors.light_blue_grey,
                                  width: 1))),
                      const SizedBox(width: 20, height: 20),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          "Select Amount",
                          style: TextStyle(
                            color: ZeplinColors.dark_blue,
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.w700,
                          ),
                        ).py8(),
                      ),
                      ListView.builder(
                        physics: const ScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: 2,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              width: 335,
                              height: 95,
                              decoration: BoxDecoration(
                                color: ZeplinColors.white,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                    color: ZeplinColors.aquamarine, width: 1),
                                boxShadow: const [
                                  BoxShadow(
                                      color: Color(0x2902d1a0),
                                      offset: Offset(0, 10),
                                      blurRadius: 15,
                                      spreadRadius: 0)
                                ],
                              ));
                        },
                      ),
                      //Add new account\
                      const SizedBox(width: 10, height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          OutlinedButton(
                            onPressed: () {
                              setState(() {});
                            },
                            style: ButtonStyle(
                              side: MaterialStateProperty.resolveWith((states) {
                                return const BorderSide(
                                    color: ZeplinColors.pink_red, width: 2);
                              }),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(54.0))),
                            ),
                            child: const Text(
                              '+ ADD NEW BANK',
                              style: TextStyle(
                                color: ZeplinColors.pink_red,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const Text("(Max. 3 bank accounts)",
                              style: TextStyle(
                                fontFamily: 'OpenSans',
                                color: ZeplinColors.dark_blue,
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                              )),
                        ],
                      ),
                      const SizedBox(width: 20, height: 20),
                      ThemeButton(
                        enabled: true,
                        onPressed: () {
                          // Navigator.of(context).push(
                          //   MaterialPageRoute(builder: (context) => HomeScreen()),
                          // );
                        },
                        text: "RAISE WITHDRAWAL REQUEST",
                      ),

                    ],
                  ),
                  //second Tab children
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(width: 10, height: 10),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          "Can’t see your withdrawal amount?",
                          style: TextStyle(
                            color: ZeplinColors.dark_blue,
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.w700,
                          ),
                        ).py8(),
                      ),
                      const Text(
                          "Don’t worry! It may take up to 2 to 7 working days to reflect.",
                          style: TextStyle(
                            fontFamily: 'OpenSans',
                            color: ZeplinColors.dark_blue,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                          )),
                      ListView.builder(
                        physics: const ScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: 2,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            width: 335,
                            height: 95,
                            decoration: BoxDecoration(
                              color: ZeplinColors.pale_grey,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                  color: ZeplinColors.light_blue_grey,
                                  width: 1),
                              // boxShadow: const [
                              //   BoxShadow(
                              //       color: Color(0x2902d1a0),
                              //       offset: Offset(0, 10),
                              //       blurRadius: 15,
                              //       spreadRadius: 0,)
                              // ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
