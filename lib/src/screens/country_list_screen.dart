import 'package:boom_lotto/src/common/common.dart';
import 'package:boom_lotto/src/cubit/select_country_code_cubit/select_country_code_cubit.dart';
import 'package:boom_lotto/src/cubit/select_country_code_cubit/select_country_code_state.dart';
import 'package:boom_lotto/src/data/model/country_list_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:velocity_x/velocity_x.dart';

class CountryListScreen extends StatefulWidget {
  final CountryListModel countryListModel;
  const CountryListScreen({Key? key, required this.countryListModel})
      : super(key: key);

  @override
  _CountryListScreenState createState() => _CountryListScreenState();
}

class _CountryListScreenState extends State<CountryListScreen> {
  final List _searchResult = [];
  @override
  Widget build(BuildContext context) {
    return BlocListener<SelectCountryCodeCubit, SelectCountryCodeState>(
        listener: (context, state) {
          if (state is SelectCountryCodeAdded) {
            Navigator.pop(context);
          }
          else if (state is SelectCountryCodeError) {
            Fluttertoast.showToast(
              msg: state.error,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
            );

          }
        },
        child: CommonContainer(
          Container(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Select a country',
                    style: TextStyle(fontSize: 20.0, color: Color(0xff00004c))),
                const SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  onChanged: onSearchTextChanged,
                  decoration: InputDecoration(
                      fillColor: const Color(0xfff5f7f9),
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          color: Color(0xffdce9f5),
                          width: 1.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          color: Colors.blue,
                        ),
                      ),
                      prefixIcon:
                      const Icon(Icons.search, color: Color(0xffdce9f5)),
                      hintText: 'Search country',
                      hintStyle: const TextStyle(
                          fontSize: 20.0, color: Color(0xffdce9f5))),
                ),
                Expanded(
                  child: _searchResult.isNotEmpty
                      ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: _searchResult.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        contentPadding:
                        const EdgeInsets.symmetric(horizontal: 0.0),
                        onTap: () {
                          Navigator.pop(context, _searchResult[index]);
                        },
                        horizontalTitleGap: 0.0,
                        leading: Text(
                          _searchResult[index]['flag'],
                          style: const TextStyle(fontSize: 20),
                        ),
                        title: Text(
                            "${_searchResult[index]['countryName'].toString().toUpperCase()} (${_searchResult[index]['countryCode']})",
                            style: const TextStyle(color: Color(0xff00004c))),
                        trailing: Text(_searchResult[index]['isdCode'],
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Color(0xff00004c))),
                      );
                    },
                  )
                      : ListView.builder(
                    shrinkWrap: true,
                    itemCount: widget.countryListModel.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        contentPadding:
                        const EdgeInsets.symmetric(horizontal: 0.0),
                        onTap: () {
                          // Navigator.pop(context, widget.countryListModel.data![index]);
                          BlocProvider.of<SelectCountryCodeCubit>(context).updateTodo(widget.countryListModel, widget.countryListModel.data![index],index);
                        },
                        horizontalTitleGap: 0.0,
                        leading: Text(
                          widget.countryListModel.data![index].flag!,
                          style: const TextStyle(fontSize: 20),
                        ),
                        title: Text(
                            "${widget.countryListModel.data![index].countryName.toString().toUpperCase()} (${widget.countryListModel.data![index].countryName})",
                            style: const TextStyle(color: Color(0xff00004c))),
                        trailing: Text(widget.countryListModel.data![index].isdCode!,
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Color(0xff00004c))),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          context.screenHeight,
        ).getContainer('Welcome Back')
    );
  }

  onSearchTextChanged(String text) {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    for (var obj in widget.countryListModel.data!) {
      if (obj.countryName
          .toString()
          .toLowerCase()
          .contains(text.toLowerCase()) ||
          obj.isdCode.toString().contains(text)) _searchResult.add(obj);
    }

    setState(() {});
  }
}
