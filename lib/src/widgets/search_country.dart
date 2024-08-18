import 'package:boom_lotto/src/common/theme.dart';
import 'package:boom_lotto/src/services/ram_service.dart';
import 'package:boom_lotto/src/widgets/extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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