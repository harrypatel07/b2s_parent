import 'package:flutter/material.dart';

class TicketPass extends StatefulWidget {
  const TicketPass({
    this.width = 300,
    @required this.child,
    this.color = Colors.white,
    this.height = 200,
    this.elevation = 1.0,
    this.shadowColor = Colors.black,

    this.curve = Curves.easeOut,
    this.animationDuration = const Duration(seconds: 1),
    this.alignment = Alignment.center,
    this.shrinkIcon = const CircleAvatar(
      maxRadius: 14,
      child: Icon(
        Icons.keyboard_arrow_up,
        color: Colors.white,
        size: 20,
      ),
    ),
    this.separatorHeight = 1.0,
    this.separatorColor = Colors.black,
    this.expansionTitle = const Text(
      'Purchased By',
      style: TextStyle(
        fontWeight: FontWeight.w600,
      ),
    ),
    this.titleColor = Colors.blue,
    this.titleHeight = 50.0,
    this.purchaserList,
    this.ticketTitle = const Text(
      'Sample title',
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w600,
        fontSize: 18,
      ),
    ),
    this.expansionChild,
  });

  final double width;
  final double height;
  final double elevation;
  final double titleHeight;
  final Widget child;
  final Color color;
  final Color shadowColor;
  final Color titleColor;
  final Curve curve;
  final Duration animationDuration;
  final Alignment alignment;
  final Widget shrinkIcon;
  final Color separatorColor;
  final double separatorHeight;
  final Text expansionTitle;
  final Text ticketTitle;
  final Widget expansionChild;
  final List<String> purchaserList;

  @override
  _TicketPassState createState() => _TicketPassState();
}

class _TicketPassState extends State<TicketPass> {
  bool switcher = false;
  Widget _myWidget() {
      return ClipPath(
        clipper: TicketClipper(),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              widget.child,
              Expanded(
                child: Container(),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    switcher = !switcher;
                  });
                },
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: widget.titleHeight,
                    decoration: BoxDecoration(
                      color: widget.titleColor,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 20),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: widget.ticketTitle,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return PhysicalShape(
      clipper: TicketClipper(),
      color: widget.color,
      elevation: widget.elevation,
      shadowColor: widget.shadowColor,
      child: AnimatedContainer(
        duration: widget.animationDuration,
        curve: widget.curve,
        width: widget.width,
        height:widget.height,
        child: _myWidget(),
      ),
    );
  }
}

class TicketClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();

    path.lineTo(0.0, size.height/2 - 20);
    path.relativeArcToPoint(const Offset(0, 40),
        radius: const Radius.circular(10.0), largeArc: true);
    path.lineTo(0.0, size.height - 10);
    path.quadraticBezierTo(0.0, size.height, 10.0, size.height);
    path.lineTo(size.width - 10.0, size.height);
    path.quadraticBezierTo(
        size.width, size.height, size.width, size.height - 10);
    path.lineTo(size.width, size.height/2 + 20);
    path.arcToPoint(Offset(size.width, size.height/2-20 ),
        radius: const Radius.circular(10.0), largeArc: true);
    path.lineTo(size.width, 10.0);
    path.quadraticBezierTo(size.width, 0.0, size.width - 10.0, 0.0);
    path.lineTo(10.0, 0.0);
    path.quadraticBezierTo(0.0, 0.0, 0.0, 10.0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
