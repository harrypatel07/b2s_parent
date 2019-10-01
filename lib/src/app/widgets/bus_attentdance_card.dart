import 'package:b2s_parent/src/app/models/childrenBusSession.dart';
import 'package:b2s_parent/src/app/theme/theme_primary.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BusAttentdanceCard extends StatelessWidget {
  final ChildrenBusSession childrenBusSession;
  final Function onTapCard;
  final Function onTapCall;
  const BusAttentdanceCard(
      {Key key, this.childrenBusSession, this.onTapCard, this.onTapCall})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget ____left() {
      return Container(
        width: 13,
        decoration: BoxDecoration(
          color: Color(childrenBusSession.status.statusColor),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(18),
            topLeft: Radius.circular(18),
          ),
        ),
      );
    }

    Widget ____right() {
      Widget _____userImage() {
        return Container(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              CachedNetworkImage(
                imageUrl: childrenBusSession.child.photo,
                imageBuilder: (context, imageProvider) => CircleAvatar(
                  radius: 35.0,
                  backgroundImage: imageProvider,
                  backgroundColor: Colors.transparent,
                ),
              ),
              Expanded(
                child: Container(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      childrenBusSession.child.name,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }

      Widget _____status() {
        return Expanded(
          child: Container(
            padding: const EdgeInsets.only(top: 12, bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Text(
                    "Viet My School",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black38),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Text(
                    "Xe sắp đến đón trong 10 phúts",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        height: 10,
                        width: 10,
                        decoration: BoxDecoration(
                          color: Color(childrenBusSession.status.statusColor),
                          shape: BoxShape.circle,
                        )),
                    SizedBox(
                      width: 5,
                    ),
                    Text(childrenBusSession.status.statusName,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        )),
                  ],
                ),
              ],
            ),
          ),
        );
      }

      Widget _____driverPhone() {
        return Container(
          width: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onTapCall,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.only(right: 12),
                        alignment: Alignment.centerLeft,
                        child: Icon(
                          Icons.call,
                          color: ThemePrimary.primaryColor,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: Text(
                            "Gọi\ndriver",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 11,
                                color: Colors.black38,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Icon(
                        FontAwesomeIcons.busAlt,
                        color: ThemePrimary.primaryColor,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: Text(
                          "123 tran hung dao q 5 dsadsa",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                              fontSize: 11,
                              color: Colors.black38,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      }

      return Expanded(
        child: Container(
            child: Row(
          children: <Widget>[
            _____userImage(),
            _____status(),
            _____driverPhone()
          ],
        )),
      );
    }

    return new InkWell(
      borderRadius: BorderRadius.circular(18.0),
      onTap: onTapCard,
      child: Card(
        margin: EdgeInsets.only(bottom: 15),
        // elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
        child: Container(
            height: 120,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: <Widget>[
                ____left(),
                ____right(),
              ],
            )),
      ),
    );
  }
}
