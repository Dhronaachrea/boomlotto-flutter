import 'package:boom_lotto/src/common/common.dart';
import 'package:boom_lotto/src/common/theme.dart';
import 'package:boom_lotto/src/widgets/text_box.dart';
import 'package:boom_lotto/src/widgets/theme_button.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class AddDeposit extends StatefulWidget {
  const AddDeposit({Key? key}) : super(key: key);

  @override
  _AddDepositState createState() => _AddDepositState();
}

class _AddDepositState extends State<AddDeposit> {
  int selectedIndex = 0;
  List<int> amounts = [50, 100, 250, 500];
  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      showBalance: false,
      showDrawer: false,
      title: "ADD DEPOSIT",
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 18,
                ),
                const Text(
                  'Deposit Amount',
                  style: TextStyle(
                    color: ZeplinColors.dark_blue,
                    fontSize: 22,
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.w700,
                  ),
                ).py16(),
                Text(
                  "You are depositing for first time. Let's know you better.",
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    color: ZeplinColors.dark_blue.withOpacity(0.6),
                    fontSize: 18,
                    fontFamily: 'OpenSans',
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  height: 70,
                  child: ListView.builder(
                    itemCount: amounts.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      final amount = amounts[index];
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          decoration: BoxDecoration(
                            color: selectedIndex == index
                                ? ZeplinColors.pink_red_8
                                : Colors.white,
                            border: Border.all(
                              color: selectedIndex == index
                                  ? ZeplinColors.pink_red
                                  : ZeplinColors.light_blue_grey,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Center(
                            child: Text(
                              amount.toString(),
                              style: TextStyle(
                                color: selectedIndex == index
                                    ? ZeplinColors.pink_red
                                    : ZeplinColors.dark_blue,
                                fontSize: 18,
                                fontFamily: 'OpenSans',
                              ),
                            ),
                          ),
                        ).pOnly(right: 12),
                      );
                    },
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextBox(
                      hintText: "AED ${amounts[selectedIndex]}",
                    ),
                    const Text(
                      '*Charges: Extra 5% (Excl.)',
                      style: TextStyle(
                        color: ZeplinColors.dark_blue,
                        fontSize: 14,
                        fontFamily: 'OpenSans',
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.all(18),
                  child: const Text(
                    "By proceeding, I agree to the additional 5% charges applicable on this transaction.",
                    style: TextStyle(
                      fontFamily: 'OpenSans',
                      color: ZeplinColors.dark_blue,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),
                ThemeButton(
                  onPressed: () {},
                  enabled: true,
                  text: "PROCEED",
                ),
              ],
            ),
          ),
          const PendingDeposit(),
          const CancelPendingWithdrawals(),
        ],
      ),
    );
  }
}

class CancelPendingWithdrawals extends StatelessWidget {
  const CancelPendingWithdrawals({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: ZeplinColors.light_blue_grey,
              width: 1,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 18,
              ),
              const Text(
                'Save Some Bucks',
                style: TextStyle(
                  color: ZeplinColors.dark_blue,
                  fontSize: 22,
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.w700,
                ),
              ).pOnly(bottom: 18),
              Text(
                'Lorem ipsul dolor dantestu valetu lorem.',
                style: TextStyle(
                  color: ZeplinColors.dark_blue.withOpacity(0.6),
                  fontSize: 16,
                  fontFamily: 'OpenSans',
                ),
              ).pOnly(bottom: 18),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: ZeplinColors.pink_red,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(54),
                ),
                child: Center(
                  child: Column(
                    children: const [
                      Text(
                        'Cancel Pending Withdrawals',
                        style: TextStyle(
                          color: ZeplinColors.pink_red,
                          fontSize: 14,
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Save some bucks on charges.',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class PendingDeposit extends StatelessWidget {
  const PendingDeposit({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: ZeplinColors.light_blue_grey,
              width: 1,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 18,
              ),
              const Text(
                'Pending Deposit',
                style: TextStyle(
                  color: ZeplinColors.dark_blue,
                  fontSize: 22,
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.w700,
                ),
              ).pOnly(bottom: 18),
              Text(
                'Lorem ipsul dolor dantestu valetu lorem.',
                style: TextStyle(
                  color: ZeplinColors.dark_blue.withOpacity(0.6),
                  fontSize: 16,
                  fontFamily: 'OpenSans',
                ),
              ).pOnly(bottom: 18),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: ZeplinColors.light_blue_grey,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Text(
                          'Wallet Topup',
                          style: TextStyle(
                            color: ZeplinColors.blue_violet_dark,
                            fontSize: 17,
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.w700,
                          ),
                        ).py4(),
                        const Text(
                          'Cash U',
                          style: TextStyle(
                            color: ZeplinColors.dark_blue_two,
                            fontSize: 16,
                            fontFamily: 'OpenSans',
                          ),
                        ).py4(),
                        const Text(
                          '14 Jul 2021, 03:00pm',
                          style: TextStyle(
                            color: ZeplinColors.dark_blue,
                            fontSize: 14,
                            fontFamily: 'OpenSans',
                          ),
                        ).py4(),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'Amount',
                          style: TextStyle(
                            color: ZeplinColors.dark_blue_two,
                            fontSize: 12,
                            fontFamily: 'OpenSans',
                          ),
                        ),
                        const Text(
                          ' AED 10',
                          style: TextStyle(
                            color: ZeplinColors.dark_blue,
                            fontSize: 18,
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.w700,
                          ),
                        ).pOnly(bottom: 4),
                        const Text(
                          'Pending',
                          style: TextStyle(
                            color: ZeplinColors.bright_orange,
                            fontSize: 14,
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.w600,
                          ),
                        ).py4(),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
