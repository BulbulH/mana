import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutterecom/main.dart';
import 'package:flutterecom/models/request/createOrderModel.dart';
import 'package:flutterecom/models/responce/getAllProductsResponceModel.dart';
import 'package:flutterecom/utils/appTheme.dart';
import 'package:flutterecom/utils/commonMethod.dart';
import 'package:flutterecom/utils/consts.dart';
import 'package:flutterecom/utils/languages_local.dart';
import 'package:flutterecom/utils/prefrences.dart';


class LanguagePickerDialog extends StatefulWidget {
  Function refresh;
  LanguagePickerDialog(this.refresh);
  @override
  _LanguagePickerDialogState createState() => _LanguagePickerDialogState();
}

class _LanguagePickerDialogState extends State<LanguagePickerDialog> {
  Map<String,String> languages = {
    "English":"en",
    "Arabic":"ar",
    "German":"de",
    "French":"fr",
    "Japanese":"ja",
    "Spanish":"es",
  };
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Divider(),
            ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.4,
                ),
                child: ListView(
                  shrinkWrap: true,
                  children: []..addAll(
                      languages.keys.toList().map((key){
                        return GestureDetector(
                              onTap: (){
                                setLanguageCode(languages[key]).then((value) {
                                    widget.refresh();
                                });
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                padding: EdgeInsets.all(15),
                                child: Text(
                                  key,
                                  style: TextStyle(
                                      fontFamily: "Normal",
                                      color: themeTextColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800
                                  ),
                                ),
                              )
                          );

                      }).toList()
                  ),
                )
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}