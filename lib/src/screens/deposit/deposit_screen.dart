import 'package:boom_lotto/src/bloc/deposit/bloc/deposit_bloc.dart';
import 'package:boom_lotto/src/common/common.dart';
import 'package:boom_lotto/src/common/theme.dart';
import 'package:boom_lotto/src/services/ram_service.dart';
import 'package:boom_lotto/src/widgets/extensions.dart';
import 'package:boom_lotto/src/widgets/theme_button.dart';
import 'package:boom_lotto/src/widgets/text_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'add_deposit.dart';

class DepositScreen extends StatefulWidget {
  const DepositScreen({Key? key}) : super(key: key);

  @override
  _DepositScreenState createState() => _DepositScreenState();
}

class IdProof {
  final String docName;
  final String docDisplayName;

  IdProof({
    required this.docName,
    required this.docDisplayName,
  });
}

class _DepositScreenState extends State<DepositScreen> {
  int selectedIndex = 0;
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _dateOfBirth = TextEditingController();
  final TextEditingController _idNumber = TextEditingController();
  String _nationality = '';
  List<IdProof> idProofTypes = [
    IdProof(docName: "PASSPORT", docDisplayName: "Passport"),
    IdProof(docName: "DRIVING_LICENSE", docDisplayName: "Driving Licence"),
  ];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      title: "DEPOSIT",
      showBalance: false,
      child: Column(
        children: [
          Row(
            children: [
              Image.asset('assets/images/badge.png').p16(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Get First Deposit',
                    style: TextStyle(
                      color: ZeplinColors.dark_blue,
                      fontSize: 16,
                      fontFamily: 'OpenSans',
                    ),
                  ),
                  Text(
                    '100% Bonus',
                    style: TextStyle(
                      color: Color(0xff02d1a0),
                      fontSize: 24,
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'AED 100',
                    style: TextStyle(
                      color: ZeplinColors.dark_blue,
                      fontSize: 24,
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              )
            ],
          ),
          Container(
            height: 0,
            decoration: BoxDecoration(
              border: Border.all(
                color: ZeplinColors.light_blue_grey,
                width: 1,
              ),
            ),
          ),
          BlocConsumer<DepositBloc, DepositState>(
            bloc: BlocProvider.of<DepositBloc>(context),
            listener: (context, state) {
              if (state.status.isSubmissionInProgress) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return const Center(child: CircularProgressIndicator());
                  },
                );
              }
              if (state.status == FormzStatus.submissionSuccess) {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const AddDeposit()),
                );
              }
            },
            builder: (context, state) {
              return Container(
                padding: const EdgeInsets.only(left: 18, right: 18, bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Welcome!',
                            style: TextStyle(
                              color: ZeplinColors.blue_violet_dark,
                              fontSize: 24,
                              fontFamily: 'OpenSans',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            "You are depositing for first time. Let's know you better.",
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              color: ZeplinColors.dark_blue.withOpacity(0.6),
                              fontSize: 20,
                              fontFamily: 'OpenSans',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Text(
                      'Be assure all details as per your ID Proof.',
                      style: TextStyle(
                        color: ZeplinColors.dark_blue,
                        fontSize: 16,
                        fontFamily: 'OpenSans',
                      ),
                    ).py8(),
                    TextBox(
                      controller: _firstName,
                      label: 'First Name',
                      hintText: "Enter Your First Name",
                      errorText: state.firstName.invalid
                          ? 'First Name cannot be Empty'
                          : null,
                    ),
                    TextBox(
                      controller: _lastName,
                      label: 'Last Name',
                      hintText: "Enter Your Last Name",
                      errorText: state.lastName.invalid
                          ? 'Last Name cannot be Empty'
                          : null,
                    ),
                    TextBox(
                      controller: _dateOfBirth,
                      label: 'Date Of Birth',
                      hintText: "Enter Your Date Of Birth",
                      isCalendar: true,
                      errorText: state.dateOfBirth.invalid
                          ? 'Date Of Birth cannot be Empty'
                          : null,
                    ),
                    DropDown(
                      label: 'Nationality',
                      hintText: "Select Your Nationality",
                      openWidget: const SearchCountry(),
                      callback: (result) {
                        setState(() {
                          _nationality = result;
                        });
                      },
                    ),
                    const Text(
                      'ID Proof',
                      style: TextStyle(
                        color: ZeplinColors.dark_blue,
                        fontFamily: 'OpenSans',
                        fontWeight: FontWeight.w700,
                      ),
                    ).py8(),
                    SizedBox(
                      height: 50,
                      child: ListView.builder(
                        itemCount: idProofTypes.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          final idProof = idProofTypes[index];
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedIndex = index;
                              });
                            },
                            child: Wrap(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8.0),
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
                                  child: Text(
                                    idProof.docDisplayName,
                                    style: TextStyle(
                                      color: selectedIndex == index
                                          ? ZeplinColors.pink_red
                                          : ZeplinColors.dark_blue,
                                      fontSize: 18,
                                      fontFamily: 'OpenSans',
                                    ),
                                  ),
                                ).pOnly(right: 4),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    TextBox(
                      controller: _idNumber,
                      hintText: "Enter ID Number",
                      inputType: TextInputType.number,
                      errorText: state.idNumber.invalid
                          ? 'ID Number cannot be Empty'
                          : null,
                    ),
                    ThemeButton(
                      enabled: true,
                      onPressed: () {
                        context.read<DepositBloc>().add(
                              FormSubmitted(
                                firstName: _firstName.text,
                                lastName: _lastName.text,
                                dateOfBirth: _dateOfBirth.text,
                                nationality: _nationality,
                                idProofType:
                                    idProofTypes[selectedIndex].docDisplayName,
                                idNumber: _idNumber.text,
                              ),
                            );

                        // Navigator.of(context).push(
                        //   MaterialPageRoute(
                        //       builder: (context) => const AddDeposit()),
                        // );
                      },
                      text: "PROCEED TO DEPOSIT",
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class SuccessDialog extends StatelessWidget {
  const SuccessDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
              children: const <Widget>[
                Icon(Icons.info),
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Form Submitted Successfully!',
                      softWrap: true,
                    ),
                  ),
                ),
              ],
            ),
            ElevatedButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchCountry extends StatefulWidget {
  const SearchCountry({Key? key}) : super(key: key);

  @override
  _SearchCountryState createState() => _SearchCountryState();
}

class _SearchCountryState extends State<SearchCountry> {
  List countryList = [];
  String flag = '';
  String code = '';
  String countryCode = '';
  final List _searchResult = [];
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    RamService.getCountryList().then((res) {
      setState(() {
        countryList = res;
        flag = res[0]['flag'];
        code = res[0]['isdCode'];
        countryCode = res[0]['countryCode'];
        for (int i = 0; i < res.length; i++) {
          if (res[i]['isDefault'] == true) {
            flag = res[i]['flag'];
            code = res[i]['isdCode'];
            break;
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(18),
        ),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select a country',
            style: TextStyle(
              fontSize: 20.0,
              color: ZeplinColors.dark_blue,
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          CupertinoSearchTextField(
            controller: _textController,
            onChanged: (text) {
              setState(() {
                _searchResult.clear();
                if (text.isEmpty) {
                  return;
                }
                for (var obj in countryList) {
                  if (obj["countryName"]
                          .toString()
                          .toLowerCase()
                          .contains(text.toLowerCase()) ||
                      obj["isdCode"].toString().contains(text)) {
                    _searchResult.add(obj);
                  }
                }
              });
            },
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _searchResult.isNotEmpty
                  ? _searchResult.length
                  : countryList.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0.0),
                  onTap: () {
                    Navigator.pop(
                      context,
                      _searchResult.isNotEmpty
                          ? _searchResult[index]
                          : countryList[index],
                    );
                  },
                  horizontalTitleGap: 0.0,
                  leading: Text(
                    _searchResult.isNotEmpty
                        ? _searchResult[index]['flag']
                        : countryList[index]['flag'],
                    style: const TextStyle(fontSize: 20),
                  ),
                  title: Text(
                    _searchResult.isNotEmpty
                        ? "${_searchResult[index]['countryName'].toString().capitalize()} (${_searchResult[index]['countryCode']})"
                        : "${countryList[index]['countryName'].toString().capitalize()} (${countryList[index]['countryCode']})",
                    style: const TextStyle(
                      color: Color(0xff00004c),
                    ),
                  ),
                  trailing: Text(
                    _searchResult.isNotEmpty
                        ? _searchResult[index]['isdCode']
                        : countryList[index]['isdCode'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff00004c),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
