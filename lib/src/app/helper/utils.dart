import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

double x1 = 0;
double x2 = 0;
double y = 0;

Future<Uint8List> readFileByte(String filePath) async {
  Uri myUri = Uri.parse(filePath);
  File audioFile = new File.fromUri(myUri);
  Uint8List bytes;
  await audioFile.readAsBytes().then((value) {
    bytes = Uint8List.fromList(value);
    print('reading of bytes is completed');
  }).catchError((onError) {
    print(
        'Exception Error while reading audio from path:' + onError.toString());
  });
  return bytes;
}

Offset getPositionWithDistance(
    {double dAnimationValue, Offset positionCurrent, Offset positionTarget}) {
  double d = sqrt(pow(positionTarget.dx - positionCurrent.dx, 2) +
      pow(positionTarget.dy - positionCurrent.dy, 2));
//  double A = 1 + positionTarget.dx * positionTarget.dx;
//  double B = 2 * positionTarget.dx * positionTarget.dy -
//      2 * positionCurrent.dx -
//      2 * positionCurrent.dy * positionTarget.dx;
//  double C = -(dAnimationValue*d) * (dAnimationValue*d) +
//      positionCurrent.dx * positionCurrent.dx +
//      positionTarget.dy * positionTarget.dy -
//      2 * positionCurrent.dy * positionTarget.dy +
//      positionCurrent.dy * positionCurrent.dy;
  double A = 1 +
      pow(
          (positionCurrent.dy - positionTarget.dy) /
              (positionCurrent.dx - positionTarget.dx),
          2);
  double B = -2 * positionCurrent.dx -
      2 *
          positionCurrent.dy *
          ((positionCurrent.dy - positionTarget.dy) /
              (positionCurrent.dx - positionTarget.dx));
  double C = pow(positionCurrent.dx, 2) +
      pow(positionCurrent.dx, 2) *
          pow(
              (positionCurrent.dy - positionTarget.dy) /
                  (positionCurrent.dx - positionTarget.dx),
              2) +
      2 *
          positionCurrent.dy *
          ((positionCurrent.dy - positionTarget.dy) /
              (positionCurrent.dx - positionTarget.dx)) -
      pow(100, 2);
//  double b = (positionCurrent.dx * positionTarget.dy -
//          positionTarget.dx * positionCurrent.dy) /
//      (positionCurrent.dx - positionTarget.dx);
//  double a = (positionCurrent.dy - b) / positionCurrent.dx;
  double a = ((positionCurrent.dy - positionTarget.dy) /
      (positionCurrent.dx - positionTarget.dx));
  double b = positionCurrent.dy -
      positionCurrent.dx *
          ((positionCurrent.dy - positionTarget.dy) /
              (positionCurrent.dx - positionTarget.dx));
//  double b = positionCurrent.dy -
//      positionCurrent.dx *
//          ((positionCurrent.dy - positionTarget.dy) /
//              (positionCurrent.dx - positionTarget.dx));

  // kiểm tra các hệ số
  if (A == 0) {
    if (B == 0) {
//      return Offset(x1, y);
    } else {
      x1 = -C / B;
      y = a * x1 + b;
//      return Offset(x1, y);
    }
  }
  // tính delta
  double delta = B * B - 4 * A * C;
  // tính nghiệm
  if (delta > 0) {
    if (positionCurrent.dy <= positionTarget.dy) {
      x1 = ((-B + sqrt(delta)) / (2 * A));
      y = a * x1 + b;
//      return Offset(x1, y);
    } else {
      x1 = ((-B - sqrt(delta)) / (2 * A));
      y = a * x1 + b;
//      return Offset(x2, y);
    }
  } else if (delta == 0) {
    x1 = (-b / (2 * a));
    y = a * x1 + b;
//    return Offset(x1, y);
  }
  return Offset(x1, y);
//return positionTarget;
}

bool getPointInCircle({Offset center, double r, Offset positionCurrent}) {
  double distance = (pow((positionCurrent.dx - center.dx), 2) +
          pow((positionCurrent.dy - center.dy), 2))
      .abs();
  return distance <= r * r;
}
