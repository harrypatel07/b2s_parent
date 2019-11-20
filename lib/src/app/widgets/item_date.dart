
import 'package:b2s_parent/src/app/helper/constant.dart';
import 'package:b2s_parent/src/app/models/month_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:math' as math;

class ItemDateLeave extends CustomPainter {
  double screenWidth;
  String title;
  MonthModule dateInMonth;
  bool isSelect = false;
  DateTime date;
  ItemDateLeave(
      this.dateInMonth, this.screenWidth, this.isSelect);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Colors.amber;
    double circleWidth = ((screenWidth - 60) / 7) - 10;
    if (dateInMonth.typeDraw == EMPTY_SCHEDULE) {
      paint.strokeWidth = 1;
      paint.style = PaintingStyle.stroke;
      canvas.drawArc(new Rect.fromLTWH(0, 0, circleWidth, circleWidth),
          -math.pi / 2, math.pi * 2, false, paint);

//      paint.strokeWidth = 4;
//      paint.style = PaintingStyle.stroke;
//      paint.color = Colors.green;

//      double percent = 1;

//      canvas.drawArc(new Rect.fromLTWH(0, 0, circleWidth, circleWidth),
//          -math.pi / 2, 2 * math.pi * percent, false, paint);

//      if (this.isSelect) {
//        //_drawCircleSelect(paint, canvas, circleWidth, Colors.green);
//      }
    }
    else if(dateInMonth.typeDraw == FILL_CIRCLE){
      paint.color = dateInMonth.color;
      canvas.drawArc(new Rect.fromLTWH(0, 0, circleWidth, circleWidth),
          circleWidth/2, circleWidth/2, false, paint);
      canvas.drawRect(new Rect.fromLTWH(circleWidth/2, circleWidth/2, circleWidth/2, 0), paint);
    } else if(dateInMonth.typeDraw == RED_DAY){
      paint.color = dateInMonth.color;
      canvas.drawArc(new Rect.fromLTWH(0, 0, circleWidth, circleWidth),
          circleWidth/2, circleWidth/2, false, paint);
      canvas.drawRect(new Rect.fromLTWH(circleWidth/2, circleWidth/2, circleWidth/2, 0), paint);
    }else if(dateInMonth.typeDraw == GREY_DAY){
      paint.color = dateInMonth.color;
      canvas.drawArc(new Rect.fromLTWH(0, 0, circleWidth, circleWidth),
          circleWidth/2, circleWidth/2, false, paint);
      canvas.drawRect(new Rect.fromLTWH(circleWidth/2, circleWidth/2, circleWidth/2, 0), paint);
    } else if (dateInMonth.typeDraw == FULL_SCHEDULE) {
      paint.color = dateInMonth.color;
      canvas.drawArc(new Rect.fromLTWH(0, 0, circleWidth, circleWidth),
          -math.pi / 2, math.pi * 2, false, paint);
      canvas.drawRect(
          new Rect.fromLTWH(-10, 0, circleWidth + 20, circleWidth), paint);

      if (this.isSelect) {
        _drawCircleSelect(paint, canvas, circleWidth, Colors.white);
      }
    } else if (dateInMonth.typeDraw == LEFT_HALF_SCHEDULE) {
      paint.color = dateInMonth.color;
      canvas.drawRect(
          new Rect.fromLTWH(
              circleWidth / 2, 0, circleWidth / 2 + 15, circleWidth),
          paint);

      canvas.drawArc(new Rect.fromLTWH(0, 0, circleWidth, circleWidth),
          math.pi / 2, 2 * math.pi, false, paint);

      if (this.isSelect) {
        _drawCircleSelect(paint, canvas, circleWidth, Colors.white);
      }
    } else if (dateInMonth.typeDraw == RIGHT_HALF_SCHEDULE) {
      paint.color = dateInMonth.color;
      canvas.drawRect(
          new Rect.fromLTWH(-10, 0, circleWidth / 2 + 10, circleWidth), paint);

      canvas.drawArc(new Rect.fromLTWH(0, 0, circleWidth, circleWidth),
          -math.pi / 2, 2 * math.pi, false, paint);

      if (this.isSelect) {
        _drawCircleSelect(paint, canvas, circleWidth, Colors.white);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  _drawCircleSelect(Paint paint, Canvas canvas, width, Color color) {
    paint.strokeWidth = 1;
    paint.style = PaintingStyle.stroke;
    paint.color = color;
    canvas.drawArc(new Rect.fromLTWH(0, 0, width, width), -math.pi / 2,
        math.pi * 2, false, paint);
  }
}
