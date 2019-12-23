import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class BusAttentdanceCardShimmer extends StatefulWidget {
  const BusAttentdanceCardShimmer({Key key}) : super(key: key);
  @override
  _BusAttentdanceCardShimmerState createState() =>
      _BusAttentdanceCardShimmerState();
}

class _BusAttentdanceCardShimmerState extends State<BusAttentdanceCardShimmer> {
  final _color = Colors.grey[200];
  Widget _shimmer({Widget widget}) {
    return Shimmer(
      period: Duration(seconds: 2),
      direction: ShimmerDirection.ltr,
      gradient:
          LinearGradient(colors: [_color, Colors.white, _color, Colors.white]),
      child: widget,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget ____left() {
      return _shimmer(
          widget: Container(
        height: 140,
        width: 13,
        decoration: BoxDecoration(
          color: _color,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(18),
            topLeft: Radius.circular(18),
          ),
        ),
      ));
    }

    Widget ____right() {
      Widget _____userImage() {
        return Column(
          children: <Widget>[
            Container(height: 10,color: _color,),
            _shimmer(
                widget: Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              width: 70,
              height: 70,
//            padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(color: _color, shape: BoxShape.circle),
            )),
          ],
        );
      }

      Widget _____status() {
        return Expanded(
          flex: 1,
          child: Container(
            padding: const EdgeInsets.only(top: 0, bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 15,
                ),
                _shimmer(
                    widget: Container(
                  margin: EdgeInsets.only(left: 25),
                  color: _color,
                  padding: const EdgeInsets.only(bottom: 5),
                  width: 150,
                  height: 15,
                )),
                SizedBox(
                  height: 15,
                ),
                _shimmer(
                    widget: Container(
                      margin: EdgeInsets.only(left: 25),
                      color: _color,
                      padding: const EdgeInsets.only(bottom: 5),
                      width: 150,
                      height: 15,
                    )),
                SizedBox(
                  height: 15,
                ),
                _shimmer(
                    widget: Container(
                      margin: EdgeInsets.only(left: 25),
                      color: _color,
                      padding: const EdgeInsets.only(bottom: 5),
                      width: 150,
                      height: 15,
                    )),
//                _shimmer(
//                  widget: Container(
//                    height: 15,
//                    width: 100,
//                    color: _color,
//                  ),
//                )
              ],
            ),
          ),
        );
      }

//      Widget _____driverPhone() {
//        return Container(
//          width: 100,
//          padding: EdgeInsets.only(top: 10),
//          child: Column(
//            mainAxisAlignment: MainAxisAlignment.center,
//            children: <Widget>[
//              Container(
//                padding: EdgeInsets.only(right: 10),
//                color: Colors.transparent,
//                child: _shimmer(
//                    widget: Container(
//                  alignment: Alignment.center,
//                  decoration: BoxDecoration(
//                      borderRadius: BorderRadius.circular(18.0), color: _color),
//                  width: 80,
//                  height: 35,
//                )),
//              ),
//              SizedBox(
//                height: 15,
//              ),
//              Container(
//                padding: EdgeInsets.only(right: 10),
//                color: Colors.transparent,
//                child: _shimmer(
//                    widget: Container(
//                  alignment: Alignment.center,
//                  decoration: BoxDecoration(
//                      borderRadius: BorderRadius.circular(18.0), color: _color),
//                  width: 80,
//                  height: 35,
//                )),
//              ),
//            ],
//          ),
//        );
//      }

      return Container(
        width: MediaQuery.of(context).size.width - 43,
//        height: 265,
        color: Colors.transparent,
        child: Column(
          children: <Widget>[
            Container(
                height: 104,
                child: Row(
                  children: <Widget>[
                    _____userImage(),
                    _____status(),
//                    _____driverPhone()
                  ],
                )),
            _shimmer(
              widget: Container(
                color: _color,
                padding: EdgeInsets.only(left: 15),
                width: MediaQuery.of(context).size.width - 120,
                height: 20,
              ),
            ),
            SizedBox(height: 10,),
          ],
        ),
      );
    }

    return Card(
      margin: EdgeInsets.only(bottom: 15),
      // elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
      ),
      child: Container(
          height: 140,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            children: <Widget>[
              Container(
//                  height: 275,
                child: Row(
                  children: <Widget>[
                    ____left(),
                    ____right(),
                  ],
                ),
              ),
//                hr,
            ],
          )),
    );
  }
}
