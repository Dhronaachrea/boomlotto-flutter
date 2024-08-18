import 'package:boom_lotto/src/common/theme.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/src/extensions/context_ext.dart';
import 'package:velocity_x/src/flutter/padding.dart';

class WalletBalanceContainer extends StatelessWidget {
  var walletValue;

   WalletBalanceContainer({
  Key? key,
  required this.walletValue,
  }) : super(key: key);
  

  @override
  Widget build(BuildContext context) {
  return Container(
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
            walletValue['currency']+" "+walletValue['totalBalance'].toString(),
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
                  text: "Withdrawable Amount ",
                  style: TextStyle(
                    color: ZeplinColors.light_blue,
                    fontSize: 13,
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                TextSpan(
                  text: walletValue['currency']+" "+walletValue['withdrawableBal'].toString(),
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
  );
  }
  }
