import 'package:b2s_parent/src/app/app_localizations.dart';
import 'package:b2s_parent/src/app/models/childrenBusSession.dart';
import 'package:b2s_parent/src/app/theme/theme_primary.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:validators/sanitizers.dart';

class BusAttentdanceCard extends StatelessWidget {
  final ChildrenBusSession childrenBusSession;
  final Function onTapCard;
  final Function onTapCall;
  final Function onTapLeave;
  final Function onTapChatDriver;
  final Function onTapChatAttendant;
  final Function onTapProfileChildren;
  final MaterialColor colorRight;
  final MaterialColor colorLeft;
  final Color colorText;
  final bool isExten;
  final String tagHero;
  const BusAttentdanceCard(
      {Key key,
      this.childrenBusSession,
      this.onTapCard,
      this.onTapCall,
      this.onTapLeave,
      this.onTapChatDriver,
      this.onTapChatAttendant,
      this.onTapProfileChildren,
      this.colorRight = Colors.grey,
      this.colorLeft = Colors.grey,
      this.colorText = Colors.black,
      this.tagHero,
      this.isExten})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    bool isEnableButtonLeave =
        (childrenBusSession.status.statusID == StatusBus.list[0].statusID);
    Widget ____left() {
      return Container(
        height: (isExten) ? 395 : 140,
        width: 13,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Colors.black12,
                offset: Offset(0.0, 15.0),
                blurRadius: 15.0),
          ],
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
        return InkWell(
          onTap: onTapProfileChildren,
          child: Hero(
            tag: tagHero,
            child: CachedNetworkImage(
              imageUrl: childrenBusSession.child.photo,
              imageBuilder: (context, imageProvider) => Stack(
                children: <Widget>[
                  Container(
                      padding: const EdgeInsets.all(10.0),
                      child: CircleAvatar(
                        radius: 35.0,
                        backgroundImage: imageProvider,
                        backgroundColor: Colors.transparent,
                      )
                      // CircleAvatar(
                      //   radius: 24.0,
                      //   backgroundImage: MemoryImage(childrenBusSession.child.photo),
                      //   backgroundColor: Colors.transparent,
                      // ),
                      ),
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: childrenBusSession.type == 0
                              ? ThemePrimary.primaryColor
                              : ThemePrimary.colorDriverApp),
//                  color: Colors.red,
                      alignment: Alignment.center,
                      child: Icon(
                        childrenBusSession.type == 0
                            ? Icons.school
                            : Icons.home,
                        color: Colors.white,
                        size: 17,
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
                    childrenBusSession.schoolName,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: colorText),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Text(
                    childrenBusSession.notification,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: colorText),
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
                    Expanded(
                      child: Text(
                          childrenBusSession.status.statusID == 3
                              ? "${StatusBus.getStatusName(childrenBusSession.status.statusID)}(${childrenBusSession.note.toString()})"
                              : StatusBus.getStatusName(childrenBusSession.status.statusID),
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: colorText)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }

      Widget _____driverPhone() {
        onTapDisable() {
          print('onTapDisable');
        }

        return Container(
          width: 100,
          padding: EdgeInsets.only(top: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(right: 10),
                color: Colors.transparent,
                child: InkWell(
                    onTap: () {
                      launch("tel://${childrenBusSession.driver.phone}");
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black26,
                                offset: Offset(0.0, 5.0),
                                blurRadius: 5.0),
                          ],
                          borderRadius: BorderRadius.circular(18.0),
                          color: ThemePrimary.primaryColor),
                      width: 80,
                      height: 35,
//                            color: Colors.amber,
                      child: Text(
                          translation.text("BUS_ATTENDANCE_CARD.CALL_DRIVER"),
                          style: TextStyle(
                              fontSize: 11,
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    )),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                padding: EdgeInsets.only(right: 10),
                color: Colors.transparent,
                child: InkWell(
                    onTap: isEnableButtonLeave ? onTapLeave : onTapDisable,
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black26,
                                offset: Offset(0.0, 5.0),
                                blurRadius: 5.0),
                          ],
                          borderRadius: BorderRadius.circular(18.0),
                          color: isEnableButtonLeave
                              ? ThemePrimary.colorDriverApp
                              : Colors.grey[400]),
                      width: 80,
                      height: 35,
//                            color: Colors.amber,
                      child: Text(
                          translation.text("BUS_ATTENDANCE_CARD.REQUEST_LEAVE"),
                          style: TextStyle(
                              fontSize: 11,
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    )),
              ),
            ],
          ),
        );
      }

      final hr = Container(
        height: 1,
        color: Colors.grey.shade300,
      );
      Widget row1(String title, String content, double height) {
        return Container(
          height: height,
          color: Colors.transparent,
          padding: EdgeInsets.only(left: 15.0, right: 15.0),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Container(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    title,
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 16, color: colorText),
                  ),
                ),
              ),
              Expanded(
                flex: 7,
                child: Container(
                  padding: EdgeInsets.only(top: 10, bottom: 10, left: 5),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    content,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: colorText),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
              )
            ],
          ),
        );
      }

      Widget rowIcon(
          String title, String content, String phoneNumber, Function onTap) {
        return Container(
          color: Colors.transparent,
          padding: EdgeInsets.only(left: 15.0, right: 15.0),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Container(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    title,
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 16, color: colorText),
                  ),
                ),
              ),
              Expanded(
                flex: 7,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: (phoneNumber != null &&
                              toBoolean(phoneNumber) != false)
                          ? 10
                          : 14,
                      child: Container(
                        padding: EdgeInsets.only(top: 10, bottom: 10, left: 5),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          content,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: colorText),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    if (phoneNumber != null && toBoolean(phoneNumber) != false)
                      Expanded(
                        flex: 2,
                        child: InkWell(
                          onTap: () {
                            launch("tel://$phoneNumber");
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 2),
//color: Colors.amber,
                            child: Align(
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.call,
                                color: ThemePrimary.primaryColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    if (phoneNumber != null && toBoolean(phoneNumber) != false)
                      Expanded(
                        flex: 2,
                        child: InkWell(
                          onTap: () {
                            launch("sms://$phoneNumber");
                          },
                          child: Container(
// color: Colors.red,
                            margin: EdgeInsets.only(left: 2),
                            child: Align(
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.message,
                                color: ThemePrimary.primaryColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    Expanded(
                      flex: 2,
                      child: InkWell(
                        onTap: onTap,
                        child: Container(
// color: Colors.red,
                          margin: EdgeInsets.only(left: 4),
                          child: Align(
                            alignment: Alignment.center,
                            child: Icon(
                              FontAwesomeIcons.facebookMessenger,
                              color: ThemePrimary.primaryColor,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      }

      return Container(
        width: isExten
            ? MediaQuery.of(context).size.width - 13
            : MediaQuery.of(context).size.width - 43,
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
                    _____driverPhone()
                  ],
                )),
            Container(
              padding: EdgeInsets.only(left: 15),
              width: MediaQuery.of(context).size.width - 43,
              height: 35,
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    childrenBusSession.child.name.toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                        color: colorText),
                    overflow: TextOverflow.ellipsis,
                  )),
            ),
            if (isExten)
              Container(
                child: Column(
                  children: <Widget>[
                    hr,
                    row1(translation.text("BUS_ATTENDANCE_CARD.SCHOOL"),
                        childrenBusSession.child.schoolName.toString(), 70),
                    hr,
                    row1(translation.text("BUS_ATTENDANCE_CARD.CLASS"),
                        childrenBusSession.child.classes.toString(), 40),
                    hr,
                    row1(translation.text("BUS_ATTENDANCE_CARD.BUS_ID"),
                        childrenBusSession.vehicleName.toString(), 40),
                    hr,
                    rowIcon(
                        translation.text("BUS_ATTENDANCE_CARD.ATTENDANCE"),
                        childrenBusSession.attendant.name.toString(),
                        childrenBusSession.attendant.phone.toString(),
                        onTapChatAttendant),
                    hr,
                    rowIcon(
                        translation.text("BUS_ATTENDANCE_CARD.DRIVER"),
                        childrenBusSession.driver.name.toString(),
                        childrenBusSession.driver.phone.toString(),
                        onTapChatDriver),
                  ],
                ),
              ),
          ],
        ),
      );
    }

    return new InkWell(
      borderRadius: BorderRadius.circular(18.0),
      onTap: onTapCard,
      child: Card(
        color: Colors.transparent,
        margin: EdgeInsets.only(bottom: 8),
        // elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
        child: Stack(
          children: <Widget>[
            Container(
              height: (isExten) ? 395 : 140,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: colorRight[100],
                      offset: Offset(1.5, 1.5),
                      blurRadius: 5.0),
                  BoxShadow(
                      color: colorRight[100],
                      offset: Offset(-1.5, -1.5),
                      blurRadius: 5.0),
                  BoxShadow(
                      color: colorRight[100],
                      offset: Offset(-1.5, 1.5),
                      blurRadius: 5.0),
                  BoxShadow(
                      color: colorRight[100],
                      offset: Offset(1.5, -1.5),
                      blurRadius: 5.0),
//                  BoxShadow(
//                    color: Colors.orange[100],
//                    blurRadius: 10.0, // has the effect of softening the shadow
//                    spreadRadius: 1.0, // has the effect of extending the shadow
//                    offset: Offset(
//                      10.0, // horizontal, move right 10
//                      10.0, // vertical, move down 10
//                    ),
//                  )
                ],
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [colorLeft[200], colorRight[300]],
                ),
//                color: Colors.deepPurpleAccent,
                borderRadius: BorderRadius.circular(18),
              ),
//              child: Stack(
//                children: <Widget>[
//                  Positioned(
//                    top: isExten ? -75 : 10,
//                    right: -230,
//                    child: Container(
//                      margin: EdgeInsets.only(right: 5),
//                      height: isExten ? 600 : 300,
//                      width: MediaQuery.of(context).size.width,
//                      decoration: BoxDecoration(
//                        shape: BoxShape.circle,
//                        gradient: LinearGradient(
//                          begin: Alignment.topLeft,
//                          end: Alignment.bottomRight,
//                          colors: [colorLeft[100], colorRight[600]],
//                        ),
////                color: Colors.deepPurpleAccent,
////                    borderRadius: BorderRadius.circular(18),
//                      ),
//                    ),
//                  )
//                ],
//              ),
            ),
            Container(
                height: (isExten) ? 395 : 140,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.transparent,
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
          ],
        ),
      ),
    );
  }
}
