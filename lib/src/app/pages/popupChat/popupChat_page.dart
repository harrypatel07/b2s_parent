import 'package:flutter/material.dart';

class PopupChatPage extends StatefulWidget {
  static const String routeName = '/popupChat';
  @override
  _PopupChatPageState createState() => _PopupChatPageState();
}

class _PopupChatPageState extends State<PopupChatPage> {
  Offset pos = Offset(50, 50);
  @override
  Widget build(BuildContext context) {
    OverlayEntry orverlayEntry = OverlayEntry(
        builder: (context) => Stack(
              children: <Widget>[
                Positioned(
                  top: pos.dy,
                  left: pos.dx,
                  child: Draggable(
                      feedback: Container(
                        height: 50,
                        width: 50,
                        color: Colors.blue,
                      ),
                      childWhenDragging: Container(),
                      onDraggableCanceled: (view, offset) {
                        setState(() {
                          pos = offset;
                        });
                      },
                      child: Container(
                        height: 50,
                        width: 50,
                        color: Colors.blue,
                      )),
                ),
              ],
            ));

    return Overlay(
      initialEntries: [orverlayEntry],
    );
  }
}
