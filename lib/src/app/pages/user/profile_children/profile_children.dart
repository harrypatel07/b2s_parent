import 'dart:ui';

import 'package:b2s_parent/src/app/app_localizations.dart';
import 'package:b2s_parent/src/app/core/baseViewModel.dart';
import 'package:b2s_parent/src/app/models/children.dart';
import 'package:b2s_parent/src/app/models/childrenBusSession.dart';
import 'package:b2s_parent/src/app/models/parent.dart';
import 'package:b2s_parent/src/app/pages/user/profile_children/profile_children_viewmodel.dart';
import 'package:b2s_parent/src/app/theme/theme_primary.dart';
import 'package:b2s_parent/src/app/widgets/ts24_button_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileChildrenPage extends StatefulWidget {
  static const String routeName = "/profileChildren";
  final ProfileChildrenPageArgs profileChildrenPageArgs;

  const ProfileChildrenPage({Key key, this.profileChildrenPageArgs})
      : super(key: key);
  @override
  _ProfileChildrenPageState createState() => _ProfileChildrenPageState();
}

class ProfileChildrenPageArgs {
  final List<RouteBus> listRouteBus;
  final ChildrenBusSession childrenBusSession;
  final Children children;
  final String heroTag;
  ProfileChildrenPageArgs(
      {this.listRouteBus,
      this.childrenBusSession,
      this.children,
      this.heroTag});
}

class _ProfileChildrenPageState extends State<ProfileChildrenPage> {
  ProfileChildrenViewModel viewModel = ProfileChildrenViewModel();
  @override
  void initState() {
    // TODO: implement initState
    if (widget.profileChildrenPageArgs.listRouteBus != null)
      viewModel.listRouteBus = widget.profileChildrenPageArgs.listRouteBus;
    if (widget.profileChildrenPageArgs.childrenBusSession != null)
      viewModel.childrenBusSession = widget.profileChildrenPageArgs
          .childrenBusSession; //ChildrenBusSession.list.singleWhere((bus) => bus.child.id == widget.children.id);
    viewModel.children = widget.profileChildrenPageArgs.children;
    viewModel.onCreateTime();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    Widget backButton() {
      return Positioned(
        top: 0,
        left: 0,
        child: SafeArea(
          top: true,
          bottom: false,
          child: TS24Button(
            onTap: () {
              Navigator.of(context).pop();
            },
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(25),
                  topRight: Radius.circular(25)),
              color: Colors.black38,
            ),
            width: 70,
            height: 50,
            child: Padding(
              padding: EdgeInsets.only(right: 10),
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
          ),
        ),
      );
    }

    final qrCode = Positioned(
        bottom: 0,
        left: deviceWidth / 2 - 80,
        child: viewModel.children.paidTicket
            ? QrImage(
                backgroundColor: Colors.white,
                data: viewModel.children.ticketCode.toString(),
                version: QrVersions.auto,
                size: 160.0,
              )
            : Stack(
                children: <Widget>[
                  QrImage(
                    backgroundColor: Colors.white,
                    data: viewModel.children.ticketCode.toString(),
                    version: QrVersions.auto,
                    size: 160.0,
                  ),
                  ClipRect(
                      child: new BackdropFilter(
                          filter:
                              new ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                          child: new Container(
                            width: 160.0,
                            height: 160.0,
                            decoration: new BoxDecoration(
                                color: Colors.grey.shade200.withOpacity(0.1)),
                          ))),
                ],
              )
//    BackdropFilter(
//      filter: ui.ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
//      child: new Container(
//        width: 160,
//        height: 160,
//        child: QrImage(
//          backgroundColor: Colors.white,
//          data: viewModel.children.ticketCode.toString(),
//          version: QrVersions.auto,
//          size: 160.0,
//        ),
//        //you can change opacity with color here(I used black) for background.
//        decoration: new BoxDecoration(color: Colors.black.withOpacity(0.2)),
//      ),
//    ),
        );
    final userImage = Stack(
      children: <Widget>[
        Hero(
            tag: widget.profileChildrenPageArgs.heroTag,
            child: Container(
              height: 400,
              child: Column(
                children: <Widget>[
                  Flexible(
                    flex: 8,
                    child: CachedNetworkImage(
                      imageUrl: viewModel.children.photo,
                      imageBuilder: (context, imageProvider) => Image(
                        fit: BoxFit.cover,
                        width: deviceWidth,
                        height: 350,
                        // image: MemoryImage(widget.children.photo),
                        image: imageProvider,
                      ),
                    ),
                  ),
                  Flexible(flex: 2, child: SizedBox())
                ],
              ),
            )),
        backButton(),
        qrCode
      ],
    );

    final userName = Container(
        width: deviceWidth,
        padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
        child: Row(
          children: <Widget>[
            Flexible(
              flex: 9,
              child: Container(
                child: Text(
                  viewModel.children.name,
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                  //overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Flexible(
              flex: 3,
              child: Container(
                margin: EdgeInsets.only(left: 10),
                //padding: EdgeInsets.symmetric(horizontal: 3.0),
                height: 30.0,
                width: 80.0,
                decoration: BoxDecoration(
                    gradient: ThemePrimary.chatBubbleGradient,
                    borderRadius: BorderRadius.circular(30.0)),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                        viewModel.children.gender.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 18.0,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ));
    final hr = Container(
      height: 1,
      color: Colors.grey.shade300,
    );
    final userLocation = Container(
      padding: EdgeInsets.only(left: 20.0, right: 20.0),
      child: Text(
        viewModel.children.location,
        style: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
          color: Colors.grey.withOpacity(0.8),
        ),
      ),
    );
    Widget rowTitle(String title) {
      return Container(
        padding: EdgeInsets.only(top: 10, bottom: 10, left: 15.0, right: 15.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12), topRight: Radius.circular(12)),
          color: Colors.amber,
        ),
        height: 40,
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget row2(String title1, String content1, String title2, String content2,
        bool type) {
      return Container(
        padding: EdgeInsets.only(left: 5.0, right: 5.0, top: 15, bottom: 15),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
//                Expanded(
//                  flex: 1,
//                  child: SizedBox(),
//                ),
                Expanded(
                  flex: 5,
                  child: Row(
                    children: <Widget>[
                      SizedBox(width: 10,),
                      Container(
                        margin: EdgeInsets.only(top: 3, right: 3, bottom: 3),
                        child: Icon(
                          type ? Icons.home : Icons.school,
                          color: !type
                              ? ThemePrimary.primaryColor
                              : ThemePrimary.colorDriverApp,
                          size: 20,
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          title1,
                          textAlign: TextAlign.left,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      content1,
                      textAlign: TextAlign.left,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
//                Expanded(
//                  flex: 1,
//                  child: SizedBox(),
//                ),
                Expanded(
                  flex: 5,
                  child: Row(
                    children: <Widget>[
                      SizedBox(width: 10,),
                      Container(
                        margin: EdgeInsets.only(top: 3, right: 3, bottom: 3),
                        child: Icon(
                          type ? Icons.school : Icons.home,
                          color: type
                              ? ThemePrimary.primaryColor
                              : ThemePrimary.colorDriverApp,
                          size: 20,
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          title2,
                          textAlign: TextAlign.left,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      content2,
                      textAlign: TextAlign.left,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      );
    }

    Widget row1(String title, String content) {
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
              child: Container(
                padding: EdgeInsets.only(top: 10, bottom: 10, left: 5),
                alignment: Alignment.centerLeft,
                child: Text(
                  content,
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      );
    }

    Widget rowIcon(
        {String title, String content, String phoneNumber, Function onTap}) {
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
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 7,
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: (phoneNumber != null && !(phoneNumber is bool))
                        ? 10
                        : 14,
                    child: Container(
                      padding: EdgeInsets.only(top: 10, bottom: 10, left: 5),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        content,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  if (phoneNumber != null && !(phoneNumber is bool))
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
                  if (phoneNumber != null && !(phoneNumber is bool))
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

    childrenInfo(Children children) {
      return Padding(
        padding: EdgeInsets.only(bottom: 20.0, left: 20.0, right: 20.0),
        child: Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(12.0),
          shadowColor: Colors.white,
          child: Container(
            padding: EdgeInsets.all(0.0),
            width: deviceWidth,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              color: Colors.white,
            ),
            constraints: BoxConstraints(minHeight: 100.0),
            child: Container(
              child: Column(
                children: <Widget>[
                  rowTitle(translation
                      .text("USER_PROFILE.CHILDREN_PROFILE")
                      .toUpperCase()),
                  row1('${translation.text("USER_PROFILE.FULL_NAME")}:',
                      children.name),
                  hr,
                  row1(
                      '${translation.text("USER_PROFILE.AGE")}:',
                      (children.age is bool || children.age == null)
                          ? ''
                          : children.age.toString()),
                  hr,
                  row1(
                      '${translation.text("USER_PROFILE.SCHOOL")}:',
                      (children.schoolName is bool || children.age == null)
                          ? ''
                          : children.schoolName.toString()),
                  hr,
                  row1(
                      '${translation.text("USER_PROFILE.CLASS")}:',
                      (children.classes is bool || children.classes == null)
                          ? ''
                          : children.classes.toString()),
                  hr,
                  row1(
                      '${translation.text("USER_PROFILE.ADDRESS")}:',
                      (children.location is bool || children.location == null)
                          ? ''
                          : children.location.toString()),
                  hr,
                  row1(
                      '${translation.text("USER_PROFILE.PHONE_NUMBER")}:',
                      (children.phone is bool || children.phone == null)
                          ? ''
                          : children.phone.toString()),
                  hr,
                  row1(
                      '${translation.text("USER_PROFILE.EMAIL")}:',
                      (children.email is bool || children.email == null)
                          ? ''
                          : children.email.toString()),
                  hr,
                  row1('${translation.text("USER_PROFILE.PARENT")}:',
                      Parent().name),
                  Container(
                    height: 1,
                    margin: EdgeInsets.only(bottom: 10),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    }

    final busInfo = Padding(
      padding: EdgeInsets.only(bottom: 20.0, left: 20.0, right: 20.0),
      child: Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(12.0),
        shadowColor: Colors.white,
        child: Container(
          padding: EdgeInsets.all(0.0),
          width: deviceWidth,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: Colors.white,
          ),
          constraints: BoxConstraints(minHeight: 100.0),
          child: Container(
            child: viewModel.childrenBusSession != null
                ? Column(
                    children: <Widget>[
                      rowTitle(translation
                          .text("USER_PROFILE.BUS_TITLE")
                          .toUpperCase()),
                      row1(translation.text("USER_PROFILE.BUS_ID"),
                          viewModel.childrenBusSession.vehicleName.toString()),
                      hr,
                      rowIcon(
                          title: translation.text("USER_PROFILE.DRIVER"),
                          content: viewModel.childrenBusSession.driver.name,
                          phoneNumber:
                              viewModel.childrenBusSession.driver.phone,
                          onTap: () {
                            viewModel.onTapChatDriver();
                          }),
                      if (viewModel.startDepart != null &&
                          !(viewModel.startDepart is bool))
                        hr,
                      rowIcon(
                          title: translation.text("USER_PROFILE.ATTENDANCE"),
                          content: viewModel.childrenBusSession.attendant.name
                              .toString(),
                          phoneNumber: viewModel
                              .childrenBusSession.attendant.phone
                              .toString(),
                          onTap: () {
                            viewModel.onTapChatAttendant();
                          }),
                      hr,
//                rowIcon('QL tại trường :', 'Âu Dương Phong', '0983932940'),
//                hr,
                      if (viewModel.startDepart != null &&
                          !(viewModel.startDepart is bool))
                        row2(
                            translation.text("USER_PROFILE.TIME_DEPART"),
                            viewModel.startDepart,
                            translation.text("USER_PROFILE.TIME_AT_SCHOOL"),
                            viewModel.endDepart,
                            true),
                      if (viewModel.startArrive != null &&
                          !(viewModel.startDepart is bool))
                        hr,
                      if (viewModel.startArrive != null &&
                          !(viewModel.startDepart is bool))
                        row2(
                            translation.text("USER_PROFILE.TIME_ARRIVE"),
                            viewModel.startArrive,
                            translation.text("USER_PROFILE.TIME_AT_HOME"),
                            viewModel.endArrive,
                            false),
                      Container(
                        height: 1,
                        margin: EdgeInsets.only(bottom: 10),
                      )
                    ],
                  )
                : Container(),
          ),
        ),
      ),
    );
    viewModel.context = context;
    return Scaffold(
      body: ViewModelProvider(
        viewmodel: viewModel,
        child: StreamBuilder(
          stream: viewModel.stream,
          builder: (context, snapshot) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  userImage,
                  userName,
                  SizedBox(height: 15,),
//                  userLocation,
                  childrenInfo(viewModel.children),
                  if (viewModel.listRouteBus.length > 0) busInfo
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
