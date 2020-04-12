import 'package:flutter/material.dart';
import 'package:flutter_breaking_news/src/utils/utils.dart';
import 'package:intl/intl.dart';


//// FUNCTIONS - UTILS
///

Widget appBarUI() {
  return Padding(
    padding: const EdgeInsets.only(top: 8.0, left: 18, right: 18),
    child: Row(
      children: <Widget>[
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Stack Labs',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  letterSpacing: 0.2,
                  color: AppTheme.grey,
                ),
              ),
              Text(
                'News App',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  letterSpacing: 0.27,
                  color: AppTheme.darkerText,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 60,
          height: 60,
          child: Image.asset('assets/images/img_sl_logo.png'),
        )
      ],
    ),
  );
}

String enumName(String enumToString) {
  List<String> paths = enumToString.split(".");
  return paths[paths.length - 1];
}


String getStrDate(DateTime date) {
  var today = DateFormat().add_yMMMMd().format(date);
  var strDay = today.split(" ")[1].replaceFirst(',', '');
  if (strDay == '1') {
    strDay = strDay + "st";
  } else if (strDay == '2') {
    strDay = strDay + "nd";
  } else if (strDay == '3') {
    strDay = strDay + "rd";
  } else {
    strDay = strDay + "th";
  }
  var strMonth = today.split(" ")[0];
  var strYear = today.split(" ")[2];
  return "$strDay $strMonth $strYear";
}