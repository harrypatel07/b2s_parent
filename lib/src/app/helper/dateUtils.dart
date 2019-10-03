import 'package:b2s_parent/src/app/helper/constant.dart';
import 'package:b2s_parent/src/app/models/month_module.dart';
import 'package:flutter/material.dart';

List<MonthModule> getDateInMonth(List<MonthModule> listDateShow,List<DateTime> listDate,int year, int month) {
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
    DateTime dayOfWeek = new DateTime(year, month, i);
    if (dayOfWeek.month == month) {
      if (dayOfWeek.weekday == 6 || dayOfWeek.weekday == 7) {
        if (!containsDayInList(listDateTemp, dayOfWeek))
          listDateTemp.add(dayOfWeek);
      }
    }
  }
  for (int i = listDateShow.length - 1; i >= 0; i--) {
    DateTime dayOfWeek = new DateTime(year, month, i);
    if (i == 0) {
      if (containsDayInList(listDateTemp, listDateShow[i+1].date)) {
        listDateShow[i].typeDraw = LEFT_HALF_SCHEDULE;
        listDateShow[i].color = Colors.green;
      } else {
        listDateShow[i].typeDraw = EMPTY_SCHEDULE;
        listDateShow[i].color = Colors.green;
      }
    }
    else if (i == listDateShow.length - 1) {
     if (containsDayInList(listDateTemp, listDateShow[i - 1].date) && containsDayInList(listDateTemp, listDateShow[i].date)) {
        listDateShow[i].typeDraw = RIGHT_HALF_SCHEDULE;
        listDateShow[i].color = Colors.green;
      }
     else if (containsDayInList(listDateTemp, listDateShow[i].date)) {
       listDateShow[i].typeDraw = FILL_CIRCLE;
       listDateShow[i].color = Colors.green;
     }
     else {
        listDateShow[i].typeDraw = EMPTY_SCHEDULE;
        listDateShow[i].color = Colors.green;
      }
    } else if (containsDayInList(listDateTemp, listDateShow[i].date)) {
            if (!(containsDayInList(listDateTemp, listDateShow[i - 1].date)) &&
          !(containsDayInList(listDateTemp, listDateShow[i + 1].date))) {
        listDateShow[i].typeDraw = FILL_CIRCLE;
        listDateShow[i].color = Colors.green;
      }
      else
      if (containsDayInList(listDateTemp, listDateShow[i-1].date) && containsDayInList(listDateTemp, listDateShow[i+1].date)) {
        listDateShow[i].typeDraw = FULL_SCHEDULE;
        listDateShow[i].color = Colors.green;
      } else if (!containsDayInList(listDateTemp, listDateShow[i - 1].date) &&
          containsDayInList(listDateTemp, listDateShow[i+1].date)) {
        listDateShow[i].typeDraw = LEFT_HALF_SCHEDULE;
        listDateShow[i].color = Colors.green;
      } else if (containsDayInList(listDateTemp, listDateShow[i-1].date) &&
          !containsDayInList(listDateTemp, listDateShow[i+1].date)) {
        listDateShow[i].typeDraw = RIGHT_HALF_SCHEDULE;
        listDateShow[i].color = Colors.green;
      } else {
        listDateShow[i].typeDraw = EMPTY_SCHEDULE;
        listDateShow[i].color = Colors.green;
      }
    } else {
      listDateShow[i].typeDraw = EMPTY_SCHEDULE;
      listDateShow[i].color = Colors.green;
    }
        if (dayOfWeek.month == month) {
          if (dayOfWeek.weekday == DateTime.saturday || dayOfWeek.weekday == DateTime.sunday) {
            listDateShow[i + day - 1].color = Colors.red;
          }
          if (dayOfWeek.isBefore(DateTime.now())) {
            listDateShow[i].typeDraw = GREY_DAY;
            listDateShow[i].color = Colors.grey;
          }
        }
  }
    return listDateShow;
}
bool containsDayInList(List<DateTime> lst,DateTime dateTime){
  for(int i = 0;i<lst.length;i++) {
    if (lst[i].day == dateTime.day && lst[i].month == dateTime.month)
      return true;
  }
  return false;
}
String getPageViewTitle(int month,int year){
  String _month = "January";
  switch(month){
    case 1: _month = "January"; break;
    case 2: _month = "February"; break;
    case 3: _month = "March"; break;
    case 4: _month = "April"; break;
    case 5: _month = "May"; break;
    case 6: _month = "June"; break;
    case 7: _month = "July"; break;
    case 8: _month = "August"; break;
    case 9: _month = "September"; break;
    case 10: _month = "October"; break;
    case 11: _month = "November"; break;
    case 12: _month = "December"; break;
  }
  return _month + " " + year.toString();
}