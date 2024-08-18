import 'dart:io';

import 'package:boom_lotto/src/common/common.dart';
import 'package:boom_lotto/src/common/theme.dart';
import 'package:boom_lotto/src/cubit/withdrawal_cubit/verification_withdrawal_cubit/verification_withdrawal_cubit.dart';
import 'package:boom_lotto/src/data/model/id_proof.dart';
import 'package:boom_lotto/src/data/model/profile.dart';
import 'package:boom_lotto/src/screens/withdrawal/withdrawal_otp_screen.dart';
import 'package:boom_lotto/src/widgets/search_country.dart';
import 'package:boom_lotto/src/widgets/show_toast.dart';
import 'package:boom_lotto/src/widgets/theme_button.dart';
import 'package:boom_lotto/src/widgets/text_box.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:velocity_x/velocity_x.dart';

bool idVerified = false;
enum Gender { Male, Female }

class VerificationWithdrawalScreen extends StatefulWidget {
  final String amount;

  VerificationWithdrawalScreen({Key? key, required this.amount})
      : super(key: key);

  @override
  _VerificationWithdrawalScreenState createState() =>
      _VerificationWithdrawalScreenState();
}

class _VerificationWithdrawalScreenState
    extends State<VerificationWithdrawalScreen> {
  static const double accountBalance = 100;
  int selectedIndex = 0;
  List<IdProof> idProofTypes = [
    IdProof(docName: "PASSPORT ID", docDisplayName: "Passport ID"),
    IdProof(docName: "Emirates ID", docDisplayName: "Emirates ID"),
  ];
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _dateOfBirth = TextEditingController();
  final TextEditingController _idNumber = TextEditingController();
  final TextEditingController _expiryDateOfID = TextEditingController();
  PlatformFile? file;
  List<File>? files;
  Gender? _gender = Gender.Female;

  @override
  Widget build(BuildContext context) {
    const _sizedBox_10 = SizedBox(
      height: 10,
      width: 10,
    );
    const _sizedBox_20 = SizedBox(height: 20, width: 20);
    const _assuranceText =
        Text("Make sure all details are as per your ID proof.",
            style: TextStyle(
              fontFamily: 'OpenSans',
              color: ZeplinColors.dark_blue,
              fontSize: 13,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.normal,
            ));
    return MyScaffold(
        title: "WITHDRAWAL",
        showBalance: true,
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sizedBox_10,
                const Text("Withdraw Amount",
                    style: TextStyle(
                      fontFamily: 'OpenSans',
                      color: ZeplinColors.dark_blue,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                    )),
                _sizedBox_10,
                Row(
                  children: const [
                    Text("First time withdrawal request:",
                        style: TextStyle(
                          fontFamily: 'OpenSans',
                          color: ZeplinColors.dark_blue,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                        )),
                    Text("AED 500",
                        style: TextStyle(
                          fontFamily: 'OpenSans',
                          color: ZeplinColors.blue_violet,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.normal,
                        ))
                  ],
                ),
                _sizedBox_10,
                const Text(
                    "Withdrawing for the first time?\nLet’s do it safely and securely! ",
                    style: TextStyle(
                      fontFamily: 'OpenSans',
                      color: ZeplinColors.dark_blue,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                    )),
                _sizedBox_10,
                const Text(
                    "Your profile and bank details must be updated and approved for withdrawing your winnings.",
                    style: TextStyle(
                      fontFamily: 'OpenSans',
                      color: ZeplinColors.dark_blue,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                    )),
                _sizedBox_20,
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                color: idVerified
                                    ? ZeplinColors.greyish
                                    : ZeplinColors.blue_violet_dark,
                                height: 5,
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: CircleAvatar(
                                  backgroundColor: idVerified
                                      ? ZeplinColors.greyish
                                      : ZeplinColors.blue_violet_dark,
                                  child: const Text('01'),
                                ),
                              ),
                            ],
                          ),
                          Text("ID VERIFICATION",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: idVerified
                                    ? ZeplinColors.greyish
                                    : ZeplinColors.blue_violet_dark,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.normal,
                              )),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                color: idVerified
                                    ? ZeplinColors.blue_violet_dark
                                    : ZeplinColors.greyish,
                                height: 5,
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: CircleAvatar(
                                  backgroundColor: idVerified
                                      ? ZeplinColors.blue_violet_dark
                                      : ZeplinColors.greyish,
                                  child: const Text('02'),
                                ),
                              ),
                            ],
                          ),
                          Text("BANK DETAILS",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: idVerified
                                    ? ZeplinColors.blue_violet_dark
                                    : ZeplinColors.greyish,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.normal,
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
                _sizedBox_20,
                idVerified
                    ? _bankDetails(_sizedBox_10, _sizedBox_20, _assuranceText)
                    : _idVerification(
                        _sizedBox_10, _sizedBox_20, _assuranceText, context),
              ],
            ),
          ),
        ));
  }

  _idVerification(SizedBox _sizedBox_10, SizedBox _sizedBox_20,
      Text _assuranceText, BuildContext context) {
    String? genderGroupValue = '';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _assuranceText,
        _sizedBox_10,
        TextBox(
          controller: _firstName,
          label: 'First Name',
          hintText: "Enter Your First Name",
        ),
        TextBox(
          controller: _lastName,
          label: 'Last Name',
          hintText: "Enter Your Last Name",
        ),
        TextBox(
          controller: _dateOfBirth,
          label: 'Date of Birth',
          hintText: "Enter Your Last Name",
          isCalendar: true,
        ),
        // //TODO Need to cange it later
        // const DropDown(
        //   label: 'Gender',
        //   hintText: "Select Your Gender",
        //   openWidget: SearchCountry(),
        // ),
        //Gender
        const Text("Gender",
            style: TextStyle(
              fontFamily: 'OpenSans',
              color: ZeplinColors.dark_blue,
              fontSize: 14,
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.normal,
            )).py8(),
        //radio buttons for gender
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Radio<Gender>(
                    value: Gender.Female,
                    groupValue: _gender,
                    onChanged: (Gender? value) {
                      setState(() {
                        _gender = value;
                      });
                    }),
                const Text("Female",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontFamily: 'OpenSans',
                      color: ZeplinColors.dark_blue,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                    )),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Radio<Gender>(
                    value: Gender.Male,
                    groupValue: _gender,
                    onChanged: (Gender? value) {
                      setState(() {
                        _gender = value;
                      });
                    }),
                const Text("Male",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontFamily: 'OpenSans',
                      color: ZeplinColors.dark_blue,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                    )),
              ],
            ),
          ],
        ),
        const DropDown(
          label: 'Nationality',
          hintText: "Select Your Nationality",
          openWidget: SearchCountry(),
        ),
        _sizedBox_10,
        const Text(
          'ID Proof',
          style: TextStyle(
            color: ZeplinColors.dark_blue,
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.w700,
          ),
        ),
        _sizedBox_10,
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
                      width: context.screenWidth * 0.4,
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
                      child: Center(
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
                      ),
                    ).pOnly(right: 4),
                  ],
                ),
              );
            },
          ),
        ),
        _sizedBox_10,
        TextBox(
          controller: _idNumber,
          hintText: "Enter ID Number",
          inputType: TextInputType.number,
        ),
        _sizedBox_10,
        TextBox(
          controller: _expiryDateOfID,
          label: 'Expiry Date of ${idProofTypes[selectedIndex].docDisplayName}',
          hintText: "DD/MM/YY",
          isCalendar: true,
        ),
        _sizedBox_10,
        const Text("Proof of Bank Details",
            style: TextStyle(
              fontFamily: 'OpenSans',
              color: ZeplinColors.dark_blue,
              fontSize: 14,
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.normal,
            )),
        _sizedBox_10,
        const Text(
            "You have to upload Emirates ID document as a proof of ID. Remember, you are using Emirates ID then upload picture of both the front and back side. ",
            style: TextStyle(
              fontFamily: 'OpenSans',
              color: ZeplinColors.dark_blue,
              fontSize: 13,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.normal,
            )),
        _sizedBox_10,
        //attachment box
        Container(
          height: 103,
          decoration: BoxDecoration(
            border: Border.all(color: ZeplinColors.aquamarine_50, width: 1),
            color: ZeplinColors.aquamarine_50_10,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              _sizedBox_10,
              //add attachment icon and text
              GestureDetector(
                onTap: () async {
                  print("Add attachment On tap is called for id verification");
                  FilePickerResult? pickedFile = await getFile();
                  if (pickedFile != null) {
                    files =
                        pickedFile.paths.map((path) => File(path!)).toList();
                    file = pickedFile.files.first;
                    print(file!.name);
                    print(file!.bytes);
                    print(file!.size);
                    print(file!.extension);
                    print(file!.path);
                    setState(() {});
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.attachment,
                        color: ZeplinColors.blue_violet),
                    _sizedBox_10,
                    const Text("Add Attachments",
                        style: TextStyle(
                          fontFamily: 'OpenSans',
                          color: ZeplinColors.blue_violet,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.normal,
                        ))
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10.0),
                child: const Text(
                  "Max file size should be 2MB each and supported format is jpg, jpeg, png, gif, pdf",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'OpenSans',
                    color: ZeplinColors.dark_blue,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(right: 10.0),
                alignment: Alignment.bottomRight,
                child: const Text("Attachment limit 5",
                    style: TextStyle(
                      fontFamily: 'OpenSans',
                      color: ZeplinColors.dark_blue,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                    )),
              )
            ],
          ),
        ),
        _sizedBox_10,
        //file name
        files == null || files!.isEmpty
            ? const SizedBox()
            : Container(
                child: Row(
                  children: [
                    Expanded(child: Text(file!.name)),
                    IconButton(
                        padding: const EdgeInsets.all(0),
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            files = null;
                            file = null;
                          });
                        }),
                  ],
                ),
                width: double.infinity,
                // padding: const EdgeInsets.all(10),
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: ZeplinColors.light_blue_grey,
                    width: 1,
                  ),
                ),
              ),
        _sizedBox_10,
        //divider
        Container(
            width: context.screenWidth,
            height: 0,
            decoration: BoxDecoration(
                border:
                    Border.all(color: ZeplinColors.light_blue_grey, width: 1))),
        _sizedBox_10,
        //residence details
        const Text("Current Residence Details",
            style: TextStyle(
              fontFamily: 'OpenSans',
              color: ZeplinColors.dark_blue,
              fontSize: 22,
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.normal,
            )),
        _sizedBox_10,
        const Text("Lorem ipsum details will be here",
            style: TextStyle(
              fontFamily: 'OpenSans',
              color: ZeplinColors.dark_blue,
              fontSize: 16,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.normal,
            )),
        _sizedBox_10,
        const DropDown(
          label: 'Country',
          hintText: "Select Country",
          openWidget: SearchCountry(),
        ),
        const DropDown(
          label: 'State/Emirate',
          hintText: "Select State",
          openWidget: SearchCountry(),
        ),
        const DropDown(
          label: 'City',
          hintText: "Select City",
          openWidget: SearchCountry(),
        ),
        _sizedBox_20,
        BlocListener<VerificationWithdrawalCubit, VerificationWithdrawalState>(
          listener: (context, state) {
            if (state is VerificationWithdrawalError) {
              ShowToast.showToast(state.error);
            } else if (state is VeificationWithdrawaled) {
              ShowToast.showToast(state.success);
              setState(() {
                idVerified = true;
              });
            }
          },
          child:ThemeButton(
            enabled: true,
            onPressed: () {
              Profile profile = Profile(
                firstName: _firstName.text.trim(),
                lastName:_lastName.text.trim(),
                dateOfBirth: _dateOfBirth.text,
                gender: _gender == Gender.Male ? "M":"F",
                nationality: "UAE",
                idNumber: _idNumber.text.trim(),
                expirtyDateOfId: _expiryDateOfID.text,
                country:'India',
                state:'Delhi',
                city:'Delhi',
                path: file != null?file!.path:null,
              );
              print("firstName: ${profile.firstName}");
              print("lastName: ${profile.lastName}");
              print("_dateOfBirth: ${profile.dateOfBirth}");
              print("_idNumber: ${profile.idNumber}");
              print("_expiryDateOfID: ${profile.expirtyDateOfId}");
              print("_gender: ${profile.gender}");
              print("files : ${profile.path}");
              BlocProvider.of<VerificationWithdrawalCubit>(context)
                  .updatePlayerProfile(profile);
              // print("firstName: ${_firstName.text}");
              // print("lastName: ${_lastName.text}");
              // print("_dateOfBirth: ${_dateOfBirth.text}");
              // print("_idNumber: ${_idNumber.text}");
              // print("_expiryDateOfID: ${_expiryDateOfID.text}");
              // print("_gender: $_gender");
              // print("files : ${files!.first.path}");
              setState(() {
                idVerified = true;
              });
            },
            text: "PROCEED TO BANK DETAILS",
          ),
        ),
        // ThemeButton(
        //   enabled: true,
        //   onPressed: () {
        //     Profile profile = Profile(
        //       firstName: _firstName.text.trim(),
        //       lastName:_lastName.text.trim(),
        //       dateOfBirth: _dateOfBirth.text,
        //       gender: _gender == Gender.Male ? "M":"F",
        //       nationality: "UAE",
        //       idNumber: _idNumber.text.trim(),
        //       expirtyDateOfId: _expiryDateOfID.text,
        //       country:'India',
        //       state:'Delhi',
        //       city:'Delhi',
        //     );
        //     BlocProvider.of<VerificationWithdrawalCubit>(context)
        //         .updatePlayerProfile(profile);
        //     // print("firstName: ${_firstName.text}");
        //     // print("lastName: ${_lastName.text}");
        //     // print("_dateOfBirth: ${_dateOfBirth.text}");
        //     // print("_idNumber: ${_idNumber.text}");
        //     // print("_expiryDateOfID: ${_expiryDateOfID.text}");
        //     // print("_gender: $_gender");
        //     // print("files : ${files!.first.path}");
        //     setState(() {
        //       idVerified = true;
        //     });
        //   },
        //   text: "PROCEED TO BANK DETAILS",
        // ),
      ],
    );
  }

  _bankDetails(
      SizedBox _sizedBox_10, SizedBox _sizedBox_20, Text _assuranceText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _assuranceText,
        const TextBox(
          label: 'Beneficiary Name',
          hintText: "Enter Beneficiary Name",
        ),
        const TextBox(
          label: 'Nick Name',
          hintText: "Enter Your Nick Name",
        ),
        const DropDown(
          label: 'Country',
          hintText: "Select Country",
          openWidget: SearchCountry(),
        ),
        const DropDown(
          label: 'Bank Name',
          hintText: "Select Bank Name",
          openWidget: SearchCountry(),
        ),
        const TextBox(
          label: 'IBAN/Account Number',
          hintText: "Enter IBAN/Account Number",
        ),
        const TextBox(
          label: 'Confirm IBAN/Account Number',
          hintText: "Enter IBAN/Account Number",
        ),
        const Text("Proof of Bank ID",
            style: TextStyle(
              fontFamily: 'OpenSans',
              color: ZeplinColors.dark_blue,
              fontSize: 14,
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.normal,
            )),
        _sizedBox_10,
        const Text(
          "Upload your Bank Details as a proof here. Remember, we will check your details for approving your bank profile.",
          style: TextStyle(
            fontFamily: 'OpenSans',
            color: ZeplinColors.dark_blue,
            fontSize: 13,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
          ),
        ),
        _sizedBox_10,
        //attachment box
        Container(
          height: 103,
          decoration: BoxDecoration(
            border: Border.all(color: ZeplinColors.aquamarine_50, width: 1),
            color: ZeplinColors.aquamarine_50_10,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              _sizedBox_10,
              //add attachment icon and text
              GestureDetector(
                onTap: () async {
                  print("Add attachment On tap is called for bank details");
                  FilePickerResult? pickedFile = await getFile();
                  if (pickedFile != null) {
                    files =
                        pickedFile.paths.map((path) => File(path!)).toList();
                    file = pickedFile.files.first;
                    print(file!.name);
                    print(file!.bytes);
                    print(file!.size);
                    print(file!.extension);
                    print(file!.path);
                    setState(() {});
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.attachment,
                        color: ZeplinColors.blue_violet),
                    _sizedBox_10,
                    const Text("Add Attachments",
                        style: TextStyle(
                          fontFamily: 'OpenSans',
                          color: ZeplinColors.blue_violet,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.normal,
                        ))
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10.0),
                child: const Text(
                  "Max file size should be 2MB each and supported format is jpg, jpeg, png, gif, pdf",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'OpenSans',
                    color: ZeplinColors.dark_blue,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(right: 10.0),
                alignment: Alignment.bottomRight,
                child: const Text("Attachment limit 5",
                    style: TextStyle(
                      fontFamily: 'OpenSans',
                      color: ZeplinColors.dark_blue,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                    )),
              )
            ],
          ),
        ),
        _sizedBox_10,
        //file name
        files == null || files!.isEmpty
            ? const SizedBox()
            : Container(
          child: Row(
            children: [
              Expanded(child: Text(file!.name)),
              IconButton(
                  padding: const EdgeInsets.all(0),
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      files = null;
                      file = null;
                    });
                  }),
            ],
          ),
          width: double.infinity,
          // padding: const EdgeInsets.all(10),
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: ZeplinColors.light_blue_grey,
              width: 1,
            ),
          ),
        ),
        _sizedBox_10,
        const Text(
            "Note: Bank Profile approval can take up to 7 working days on our back-end.",
            style: TextStyle(
              fontFamily: 'OpenSans',
              color: ZeplinColors.dark_blue,
              fontSize: 13,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.normal,
            )),
        _sizedBox_20,
        ThemeButton(
          enabled: true,
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => const WithdrawalOtpScreen(
                        number: '8920122402',
                        type: true,
                        code: '1234',
                        countryCode: '91',
                      )),
            );
          },
          text: "SUBMIT",
        ),
      ],
    );
  }

  Future<FilePickerResult?> getFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'gif', 'png', 'jpeg'],
    );
    return result;
  }
}
