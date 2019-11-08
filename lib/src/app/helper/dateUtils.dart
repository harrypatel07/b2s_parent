import 'package:b2s_parent/src/app/helper/constant.dart';
import 'package:b2s_parent/src/app/models/month_module.dart';
import 'package:flutter/material.dart';

List<MonthModule> getDateInMonth(List<MonthModule> listDateShow,
    List<DateTime> listDate, int year, int month) {
  List<DateTime> listDateTemp = new List();
  listDateTemp = listDate;
  DateTime endDate = new DateTime(year, month + 1, 0);
  int totalDate = endDate.day;
  DateTime startDate = new DateTime(year, month, 1);
  int day = startDate.weekday;
  if (day != 7) {
    for (int i = 0; i < day; i++) {
      DateTime emptyDay = new DateTime.utc(1999, 1, 1);
      MonthModule monthModule = new MonthModule(emptyDay);
      if (listDateShow.every((monthModule) => monthModule.date == emptyDay))
        listDateShow.add(monthModule);
    }
  }
  for (int i = 0; i < totalDate; i++) {
    DateTime day = new DateTime.utc(year, month, i + 1);
    MonthModule monthModule = new MonthModule(day);
    if (listDateShow.every((monthModule) => monthModule.date != day))
      listDateShow.add(monthModule);
  }
  for (int i = listDateShow.length - 1; i >= 0; i--) {
    DateTime day = new DateTime(year, month, listDateShow[i].date.day);
    if (day.month == month) {
      if ((/*day.weekday == DateTime.saturday ||*/ day.weekday == DateTime.sunday) && day.isAfter(DateTime.now())) {
        if (!containsDayInList(listDateTemp, day))
          listDateTemp.add(day);
      }
    }
  }
  for (int i = listDateShow.length - 1; i >= 0; i--) {
    DateTime dayOfWeek = new DateTime(year, month, listDateShow[i].date.day);
    if (i == 0) {
      if (containsDayInList(listDateTemp, listDateShow[i + 1].date)) {
        listDateShow[i].typeDraw = LEFT_HALF_SCHEDULE;
        listDateShow[i].color = Colors.green;
      } else {
        listDateShow[i].typeDraw = EMPTY_SCHEDULE;
        listDateShow[i].color = Colors.green;
        if ((/*day.weekday == DateTime.saturday ||*/
            dayOfWeek.weekday == DateTime.sunday) && dayOfWeek.isAfter(DateTime.now())) {
          listDateShow[i].typeDraw = FILL_CIRCLE;
          listDateShow[i].color = Colors.red;
        }
      }
    } else if (i == listDateShow.length - 1) {
      if (containsDayInList(listDateTemp, listDateShow[i - 1].date) &&
          containsDayInList(listDateTemp, listDateShow[i].date)) {
        listDateShow[i].typeDraw = RIGHT_HALF_SCHEDULE;
        listDateShow[i].color = Colors.green;
      } else if (containsDayInList(listDateTemp, listDateShow[i].date)) {
        listDateShow[i].typeDraw = FILL_CIRCLE;
        listDateShow[i].color = Colors.green;
      } else {
        listDateShow[i].typeDraw = EMPTY_SCHEDULE;
        listDateShow[i].color = Colors.green;
        if ((/*day.weekday == DateTime.saturday ||*/
            dayOfWeek.weekday == DateTime.sunday) && dayOfWeek.isAfter(DateTime.now())) {
          listDateShow[i].typeDraw = FILL_CIRCLE;
          listDateShow[i].color = Colors.red;
        }
      }
    } else if (containsDayInList(listDateTemp, listDateShow[i].date)) {
      if (!(containsDayInList(listDateTemp, listDateShow[i - 1].date)) &&
          !(containsDayInList(listDateTemp, listDateShow[i + 1].date))) {
        listDateShow[i].typeDraw = FILL_CIRCLE;
        listDateShow[i].color = Colors.green;
      } else if (containsDayInList(listDateTemp, listDateShow[i - 1].date) &&
          containsDayInList(listDateTemp, listDateShow[i + 1].date)) {
        listDateShow[i].typeDraw = FULL_SCHEDULE;
        listDateShow[i].color = Colors.green;
      } else if (!containsDayInList(listDateTemp, listDateShow[i - 1].date) &&
          containsDayInList(listDateTemp, listDateShow[i + 1].date)) {
        listDateShow[i].typeDraw = LEFT_HALF_SCHEDULE;
        listDateShow[i].color = Colors.green;
      } else if (containsDayInList(listDateTemp, listDateShow[i - 1].date) &&
          !containsDayInList(listDateTemp, listDateShow[i + 1].date)) {
        listDateShow[i].typeDraw = RIGHT_HALF_SCHEDULE;
        listDateShow[i].color = Colors.green;
      } else {
        listDateShow[i].typeDraw = EMPTY_SCHEDULE;
        listDateShow[i].color = Colors.green;
        if ((/*day.weekday == DateTime.saturday ||*/
            dayOfWeek.weekday == DateTime.sunday) && dayOfWeek.isAfter(DateTime.now())) {
          listDateShow[i].typeDraw = FILL_CIRCLE;
          listDateShow[i].color = Colors.red;
        }
      }
    } else {
      listDateShow[i].typeDraw = EMPTY_SCHEDULE;
      listDateShow[i].color = Colors.green;
      if ((/*day.weekday == DateTime.saturday ||*/
          dayOfWeek.weekday == DateTime.sunday) && dayOfWeek.isAfter(DateTime.now())) {
        listDateShow[i].typeDraw = FILL_CIRCLE;
        listDateShow[i].color = Colors.red;
      }
    }
    if (dayOfWeek.month == month) {
      if ((/*day.weekday == DateTime.saturday ||*/
          dayOfWeek.weekday == DateTime.sunday) && dayOfWeek.isAfter(DateTime.now())) {
        listDateShow[i].color = Colors.red;
      }
      if (dayOfWeek.isBefore(DateTime.now())) {
        listDateShow[i].typeDraw = GREY_DAY;
        listDateShow[i].color = Colors.grey;
      }
    }
  }
  return listDateShow;
}

bool containsDayInList(List<DateTime> lst, DateTime dateTime) {
  for (int i = 0; i < lst.length; i++) {
    if (lst[i].day == dateTime.day && lst[i].month == dateTime.month)
      return true;
  }
  return false;
}

String getPageViewTitle(int month, int year) {
  String _month = "Tháng 1 /";
  switch (month) {
    case 1:
      _month = "Tháng 1 /";
      break;
    case 2:
      _month = "Tháng 2 /";
      break;
    case 3:
      _month = "Tháng 3 /";
      break;
    case 4:
      _month = "Tháng 4 /";
      break;
    case 5:
      _month = "Tháng 5 /";
      break;
    case 6:
      _month = "Tháng 6 /";
      break;
    case 7:
      _month = "Tháng 7 /";
      break;
    case 8:
      _month = "Tháng 8 /";
      break;
    case 9:
      _month = "Tháng 9 /";
      break;
    case 10:
      _month = "Tháng 10 /";
      break;
    case 11:
      _month = "Tháng 11 /";
      break;
    case 12:
      _month = "Tháng 12 /";
      break;
  }
  return _month + " " + year.toString();
}
