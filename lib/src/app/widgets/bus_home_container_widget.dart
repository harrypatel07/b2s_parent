import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BusHomeContainer extends StatelessWidget {
  const BusHomeContainer({
    Key key,
    @required this.children,
    this.height,
    this.decoration,
    this.appBar = false,
  }) : super(key: key);

  final bool appBar;
  final List<Widget> children;
  final Decoration decoration;
  final double height;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    final pokeSize = screenSize.width * 1;
    final pokeTop = -(screenSize.width * 0.154);
    final pokeRight = -(screenSize.width * .1);
    final appBarTop = pokeSize / 2 + pokeTop - IconTheme.of(context).size / 2;

    return Container(
      width: screenSize.width,
      decoration: decoration,
      child: Stack(
        children: <Widget>[
          Positioned(
            top: -15,
            right: 0,
            child: Image.asset(
              "assets/images/bus_bg.gif",
              // width: pokeSize,
              height: 300,
              // color: Color(0xFF303943).withOpacity(0.05),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (appBar)
                Padding(
                  padding: EdgeInsets.only(left: 26, right: 26, top: appBarTop),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      InkWell(
                        child: Icon(Icons.arrow_back),
                        onTap: Navigator.of(context).pop,
                      ),
                      Icon(Icons.menu),
                    ],
                  ),
                ),
              if (children != null) ...children,
            ],
          ),
        ],
      ),
    );
  }
}
