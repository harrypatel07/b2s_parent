import 'package:flutter/material.dart';

class TS24TimeLine extends StatelessWidget {
  final List<EventTime> listTimeLine;
  final double height;
  const TS24TimeLine(
      {Key key, @required this.listTimeLine, this.height = double.infinity})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double iconSize = 20;

    // return ListView(
    //   physics: NeverScrollableScrollPhysics(),
    //   children: List.generate(
    //       listTimeLine.length,
    //       (index) => Padding(
    //             padding: const EdgeInsets.only(left: 24.0, right: 24),
    //             child: Row(
    //               children: <Widget>[
    //                 _lineStyle(context, iconSize, index, listTimeLine.length,
    //                     listTimeLine[index].isFinish),
    //                 _displayTime(listTimeLine[index].time),
    //                 _displayContent(listTimeLine[index])
    //               ],
    //             ),
    //           )),
    // );

    return Container(
      constraints: BoxConstraints(maxHeight: height),
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemCount: listTimeLine.length,
        padding: const EdgeInsets.all(0),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24),
            child: Row(
              children: <Widget>[
                _lineStyle(context, iconSize, index, listTimeLine.length,
                    listTimeLine[index].isFinish),
                _displayTime(listTimeLine[index].time),
                _displayContent(listTimeLine[index])
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _displayContent(EventTime event) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
        child: Container(
          padding: const EdgeInsets.all(14.0),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(12)),
              boxShadow: [
                BoxShadow(
                    color: Color(0x20000000),
                    blurRadius: 5,
                    offset: Offset(0, 3))
              ]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(event.task),
              SizedBox(
                height: 12,
              ),
              Text(event.desc)
            ],
          ),
        ),
      ),
    );
  }

  Widget _displayTime(String time) {
    return Container(
        width: 80,
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(time),
        ));
  }

  Widget _lineStyle(BuildContext context, double iconSize, int index,
      int listLength, bool isFinish) {
    return Container(
        decoration: CustomIconDecoration(
            iconSize: iconSize,
            lineWidth: 1,
            firstData: index == 0 ?? true,
            lastData: index == listLength - 1 ?? true,
            isFinish: isFinish),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(50)),
              boxShadow: [
                BoxShadow(
                    offset: Offset(0, 3),
                    color: Color(0x20000000),
                    blurRadius: 5)
              ]),
          child: Icon(
              isFinish
                  ? Icons.fiber_manual_record
                  : Icons.radio_button_unchecked,
              size: iconSize,
              color: Theme.of(context).accentColor),
        ));
  }
}

class EventTime {
  final String time;
  final String task;
  final String desc;
  final bool isFinish;

  const EventTime(this.time, this.task, this.desc, this.isFinish);
}

class CustomIconDecoration extends Decoration {
  final double iconSize;
  final double lineWidth;
  final bool firstData;
  final bool lastData;
  final bool isFinish;
  CustomIconDecoration({
    @required double iconSize,
    @required double lineWidth,
    @required bool firstData,
    @required bool lastData,
    this.isFinish,
  })  : this.iconSize = iconSize,
        this.lineWidth = lineWidth,
        this.firstData = firstData,
        this.lastData = lastData;

  @override
  BoxPainter createBoxPainter([onChanged]) {
    return IconLine(
        iconSize: iconSize,
        lineWidth: lineWidth,
        firstData: firstData,
        lastData: lastData,
        isFinish: isFinish);
  }
}

class IconLine extends BoxPainter {
  final double iconSize;
  final bool firstData;
  final bool lastData;
  final bool isFinish;
  final Paint paintLine;

  IconLine({
    @required double iconSize,
    @required double lineWidth,
    @required bool firstData,
    @required bool lastData,
    this.isFinish,
  })  : this.iconSize = iconSize,
        this.firstData = firstData,
        this.lastData = lastData,
        paintLine = Paint()
          ..color = isFinish != false ? Colors.blue : Colors.grey
          ..strokeCap = StrokeCap.round
          ..strokeWidth = lineWidth
          ..style = PaintingStyle.stroke;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final leftOffset = Offset((iconSize / 2) + 24, offset.dy);
    final double iconSpace = iconSize / 1.5;

    final Offset top = configuration.size.topLeft(Offset(leftOffset.dx, 0.0));
    final Offset centerTop = configuration.size
        .centerLeft(Offset(leftOffset.dx, leftOffset.dy - iconSpace));

    final Offset centerBottom = configuration.size
        .centerLeft(Offset(leftOffset.dx, leftOffset.dy + iconSpace));
    final Offset end =
        configuration.size.bottomLeft(Offset(leftOffset.dx, leftOffset.dy * 2));

    if (!firstData) canvas.drawLine(top, centerTop, paintLine);
    if (!lastData) canvas.drawLine(centerBottom, end, paintLine);
  }
}
