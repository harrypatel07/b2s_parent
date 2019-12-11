import 'package:b2s_parent/src/app/app_localizations.dart';
import 'package:b2s_parent/src/app/helper/constant.dart';
import 'package:b2s_parent/src/app/models/month_module.dart';
import 'package:flutter/material.dart';

List<MonthModule> getDateInMonth(List<MonthModule> listDateShow,
    List<DateTime> listDate,List<DateTime> listDateGetFromSever, int year, int month) {
  final colorSelected = Color(0xFF007658);
  final colorPassed = Colors.grey;
  final colorHoliday = Colors.red;
  final colorText = Colors.white;
  final colorTextEmpty = Colors.black;
  final colorSelectedFromSever = Colors.orange;
  List<DateTime> listDateTemp = new List();
  listDate.forEach((date){
    listDateTemp.add(date);
  });
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
        listDateShow[i].color = colorSelected;
        listDateShow[i].colorText = colorText;
      } else {
        listDateShow[i].typeDraw = EMPTY_SCHEDULE;
        listDateShow[i].color = colorSelected;
        listDateShow[i].colorText = colorTextEmpty;
        if ((/*day.weekday == DateTime.saturday ||*/
            dayOfWeek.weekday == DateTime.sunday) && dayOfWeek.isAfter(DateTime.now())) {
          listDateShow[i].typeDraw = FILL_CIRCLE;
          listDateShow[i].color = colorHoliday;
          listDateShow[i].colorText = colorText;
        }
      }
    } else if (i == listDateShow.length - 1) {
      if (containsDayInList(listDateTemp, listDateShow[i - 1].date) &&
          containsDayInList(listDateTemp, listDateShow[i].date)) {
        listDateShow[i].typeDraw = RIGHT_HALF_SCHEDULE;
        listDateShow[i].color = colorSelected;
        listDateShow[i].colorText = colorText;
      } else if (containsDayInList(listDateTemp, listDateShow[i].date)) {
        listDateShow[i].typeDraw = FILL_CIRCLE;
        listDateShow[i].color = colorSelected;
        listDateShow[i].colorText = colorText;
      } else {
        listDateShow[i].typeDraw = EMPTY_SCHEDULE;
        listDateShow[i].color = colorSelected;
        listDateShow[i].colorText = colorTextEmpty;
        if ((/*day.weekday == DateTime.saturday ||*/
            dayOfWeek.weekday == DateTime.sunday) && dayOfWeek.isAfter(DateTime.now())) {
          listDateShow[i].typeDraw = FILL_CIRCLE;
          listDateShow[i].color = colorHoliday;
          listDateShow[i].colorText = colorText;
        }
      }
    } else if (containsDayInList(listDateTemp, listDateShow[i].date)) {
      if (!(containsDayInList(listDateTemp, listDateShow[i - 1].date)) &&
          !(containsDayInList(listDateTemp, listDateShow[i + 1].date))) {
        listDateShow[i].typeDraw = FILL_CIRCLE;
        listDateShow[i].color = colorSelected;
        listDateShow[i].colorText = colorText;
      } else if (containsDayInList(listDateTemp, listDateShow[i - 1].date) &&
          containsDayInList(listDateTemp, listDateShow[i + 1].date)) {
        listDateShow[i].typeDraw = FULL_SCHEDULE;
        listDateShow[i].color = colorSelected;
        listDateShow[i].colorText = colorText;
      } else if (!containsDayInList(listDateTemp, listDateShow[i - 1].date) &&
          containsDayInList(listDateTemp, listDateShow[i + 1].date)) {
        listDateShow[i].typeDraw = LEFT_HALF_SCHEDULE;
        listDateShow[i].color = colorSelected;
        listDateShow[i].colorText = colorText;
      } else if (containsDayInList(listDateTemp, listDateShow[i - 1].date) &&
          !containsDayInList(listDateTemp, listDateShow[i + 1].date)) {
        listDateShow[i].typeDraw = RIGHT_HALF_SCHEDULE;
        listDateShow[i].color = colorSelected;
        listDateShow[i].colorText = colorText;
      } else {
        listDateShow[i].typeDraw = EMPTY_SCHEDULE;
        listDateShow[i].color = colorSelected;
        listDateShow[i].colorText = colorTextEmpty;
        if ((/*day.weekday == DateTime.saturday ||*/
            dayOfWeek.weekday == DateTime.sunday) && dayOfWeek.isAfter(DateTime.now())) {
          listDateShow[i].typeDraw = FILL_CIRCLE;
          listDateShow[i].color = colorHoliday;
          listDateShow[i].colorText = colorText;
        }
      }
    } else {
      listDateShow[i].typeDraw = EMPTY_SCHEDULE;
      listDateShow[i].color = colorSelected;
      listDateShow[i].colorText = colorTextEmpty;
      if ((/*day.weekday == DateTime.saturday ||*/
          dayOfWeek.weekday == DateTime.sunday) && dayOfWeek.isAfter(DateTime.now())) {
        listDateShow[i].typeDraw = FILL_CIRCLE;
        listDateShow[i].color = colorHoliday;
        listDateShow[i].colorText = colorText;
      }
    }
    if (dayOfWeek.month == month) {
      if ((/*day.weekday == DateTime.saturday ||*/
          dayOfWeek.weekday == DateTime.sunday) && dayOfWeek.isAfter(DateTime.now())) {
        listDateShow[i].color = colorHoliday;
        listDateShow[i].colorText = colorText;
      }
      if (dayOfWeek.isBefore(DateTime.now())) {
        listDateShow[i].typeDraw = GREY_DAY;
        listDateShow[i].color = colorPassed;
        listDateShow[i].colorText = colorText;
      }
    }
    //change color day get from sever
    if(containsDayInList(listDateGetFromSever, listDateShow[i].date))
      listDateShow[i].color = colorSelectedFromSever;
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
  String _month = translation.text("COMMON.MONTH_OF_YEAR.JANUARY");
  switch (month) {
    case 1:
      _month = translation.text("COMMON.MONTH_OF_YEAR.JANUARY");
      break;
    case 2:
      _month = translation.text("COMMON.MONTH_OF_YEAR.FEBRUARY");
      break;
    case 3:
      _month = translation.text("COMMON.MONTH_OF_YEAR.MARCH");
      break;
    case 4:
      _month = translation.text("COMMON.MONTH_OF_YEAR.APRIL");
      break;
    case 5:
      _month = translation.text("COMMON.MONTH_OF_YEAR.MAY");
      break;
    case 6:
      _month = translation.text("COMMON.MONTH_OF_YEAR.JUNE");
      break;
    case 7:
      _month = translation.text("COMMON.MONTH_OF_YEAR.JULY");
      break;
    case 8:
      _month = translation.text("COMMON.MONTH_OF_YEAR.AUGUST");
      break;
    case 9:
      _month = translation.text("COMMON.MONTH_OF_YEAR.SEPTEMBER");
      break;
    case 10:
      _month = translation.text("COMMON.MONTH_OF_YEAR.OCTOBER");
      break;
    case 11:
      _month = translation.text("COMMON.MONTH_OF_YEAR.NOVEMBER");
      break;
    case 12:
      _month = translation.text("COMMON.MONTH_OF_YEAR.DECEMBER");
      break;
  }
  return _month + " / " + year.toString();
}
