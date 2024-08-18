import 'package:boom_lotto/src/common/constants.dart';
import 'package:boom_lotto/src/common/theme.dart';
import 'package:boom_lotto/src/widgets/extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';

class TextBox extends StatefulWidget {
  const TextBox({
    Key? key,
    this.hintText,
    this.label,
    this.inputType,
    this.isCalendar,
    this.errorText,
    this.controller,
    this.inputFormatters
  }) : super(key: key);

  final String? label;
  final String? hintText;
  final TextInputType? inputType;
  final bool? isCalendar;
  final String? errorText;
  final TextEditingController? controller;
  final List<TextInputFormatter>? inputFormatters;

  @override
  State<TextBox> createState() => _TextBoxState();
}

class _TextBoxState extends State<TextBox> {
  var selectedDate;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.label != null
            ? Text(
                widget.label!,
                style: const TextStyle(
                  color: ZeplinColors.dark_blue,
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.w700,
                ),
              ).py8()
            : Container(),
        TextFormField(
          //inputFormatters: widget.inputFormatters??[],
          onTap: () {
            widget.isCalendar == true ? _showCalendar(context) : null;
          },
          controller: widget.controller,
          readOnly: widget.isCalendar == true,
          keyboardType: widget.inputType ?? TextInputType.text,
          scrollPadding: const EdgeInsets.only(bottom: 40),
          decoration: InputDecoration(
            errorText: widget.errorText,
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.grey,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            fillColor: ZeplinColors.pale_grey,
            filled: true,
            hintText: widget.hintText,
            hintStyle: TextStyle(
              color: ZeplinColors.dark_blue.withOpacity(0.5),
              fontWeight: FontWeight.w400,
              fontFamily: "OpenSans",
              fontStyle: FontStyle.normal,
              fontSize: 16,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: ZeplinColors.light_blue_grey,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            border: OutlineInputBorder(
              borderSide: const BorderSide(
                color: ZeplinColors.light_blue_grey,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ).pOnly(bottom: 8)
      ],
    );
  }

  _showCalendar(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: ZeplinColors.pink_red,
              onPrimary: ZeplinColors.white,
              onSurface: ZeplinColors.dark_blue,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: ZeplinColors.pink_red, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        selectedDate = DateFormat(Common.dateFormat).format(pickedDate);
        widget.controller?.text = selectedDate;
      });
    });
  }
}

typedef StringCallback = void Function(String);

class DropDown extends StatefulWidget {
  const DropDown({
    Key? key,
    this.label,
    this.hintText,
    required this.openWidget,
    this.callback,
  }) : super(key: key);

  final String? label;
  final String? hintText;
  final Widget openWidget;
  final StringCallback? callback;

  @override
  _DropDownState createState() => _DropDownState();
}

class _DropDownState extends State<DropDown> {
  var selectedNationality;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.label != null
            ? Text(
                widget.label!,
                style: const TextStyle(
                  color: ZeplinColors.dark_blue,
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.w700,
                ),
              ).py8()
            : Container(),
        GestureDetector(
          onTap: () async {
            if (FocusScope.of(context).isFirstFocus) {
              FocusScope.of(context).requestFocus(FocusNode());
            }
            var result = await showModalBottomSheet(
              backgroundColor: Colors.transparent,
              context: context,
              builder: (ctx) {
                return widget.openWidget;
              },
            );
            setState(() {
              selectedNationality = result;
              widget.callback!(
                  selectedNationality["countryName"].toString().capitalize());
            });
          },
          child: Container(
            height: 51,
            decoration: BoxDecoration(
              color: ZeplinColors.pale_grey,
              border: Border.all(
                color: ZeplinColors.light_blue_grey,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Text(
                    selectedNationality != null
                        ? selectedNationality["countryName"]
                            .toString()
                            .capitalize()
                        : widget.hintText ?? '',
                    style: TextStyle(
                      color: selectedNationality != null
                          ? Colors.black
                          : ZeplinColors.dark_blue.withOpacity(0.5),
                      fontWeight: FontWeight.w400,
                      fontFamily: "OpenSans",
                      fontStyle: FontStyle.normal,
                      fontSize: 16,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.arrow_drop_down,
                    color: Colors.grey[800],
                  ),
                ],
              ),
            ),
          ).pOnly(bottom: 8),
        )
      ],
    );
  }
}
