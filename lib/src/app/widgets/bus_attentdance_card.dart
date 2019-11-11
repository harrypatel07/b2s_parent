import 'package:b2s_parent/src/app/models/childrenBusSession.dart';
import 'package:b2s_parent/src/app/pages/user/profile_children/profile_children.dart';
import 'package:b2s_parent/src/app/theme/theme_primary.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BusAttentdanceCard extends StatelessWidget {
  final ChildrenBusSession childrenBusSession;
  final Function onTapCard;
  final Function onTapCall;
  final Function onTapLeave;
  final bool isExten;
  const BusAttentdanceCard(
      {Key key,
      this.childrenBusSession,
      this.onTapCard,
      this.onTapCall,
      this.onTapLeave,
      this.isExten})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    bool isEnableButtonLeave =
        (childrenBusSession.status.statusID != StatusBus.list[2].statusID &&
            childrenBusSession.status.statusID != StatusBus.list[3].statusID);
    Widget ____left() {
      return Container(
        height: (isExten) ? 345 : 140,
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
          onTap: () {
            Navigator.pushNamed(context, ProfileChildrenPage.routeName,
                arguments: childrenBusSession.child);
          },
          child: Container(
            padding: const EdgeInsets.all(10.0),
            child: CachedNetworkImage(
              imageUrl: childrenBusSession.child.photo,
              imageBuilder: (context, imageProvider) => CircleAvatar(
                radius: 35.0,
                backgroundImage: imageProvider,
                backgroundColor: Colors.transparent,
              ),
            ),
            // CircleAvatar(
            //   radius: 24.0,
            //   backgroundImage: MemoryImage(childrenBusSession.child.photo),
            //   backgroundColor: Colors.transparent,
            // ),
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
                        fontWeight: FontWeight.bold, color: Colors.black38),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Text(
                    childrenBusSession.notification,
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
                      child: Text('Gọi tài xế',
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
                    onTap: isEnableButtonLeave ? onTapLeave : null,
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
                              ? Colors.red
                              : Colors.grey[400]),
                      width: 80,
                      height: 35,
//                            color: Colors.amber,
                      child: Text('Xin nghỉ',
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
          color: Colors.white,
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
                    style: TextStyle(fontSize: 16),
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
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
              )
            ],
          ),
        );
      }

      Widget rowIcon(String title, String content, String phoneNumber) {
        return Container(
          color: Colors.white,
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
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              Expanded(
                flex: 7,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 10,
                      child: Container(
                        padding: EdgeInsets.only(top: 10, bottom: 10, left: 5),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          content,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
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
                              color: Colors.amber,
                            ),
                          ),
                        ),
                      ),
                    ),
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
                              color: Colors.lightBlue,
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
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  )),
            ),
            if (isExten)
              Container(
                child: Column(
                  children: <Widget>[
                    hr,
                    row1('Trường:',
                        childrenBusSession.child.schoolName.toString(), 70),
                    hr,
                    row1(
                        'Lớp', childrenBusSession.child.classes.toString(), 40),
                    hr,
                    row1('Biển số xe:',
                        childrenBusSession.vehicleName.toString(), 40),
                    hr,
                    rowIcon(
                        'Tài xế:',
                        childrenBusSession.driver.name.toString(),
                        childrenBusSession.driver.phone.toString()),
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
        margin: EdgeInsets.only(bottom: 15),
        // elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
        child: Container(
            height: (isExten) ? 345 : 140,
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
      ),
    );
  }
}
