import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget displaySnackBar(String message)
{
  return Container(
    color: Colors.red,
    child: CupertinoAlertDialog(
      title: const Text('Boom Lotto'),
      content: Text('state.error'),
    ),
  );
}