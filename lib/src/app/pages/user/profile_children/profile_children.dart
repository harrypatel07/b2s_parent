import 'package:b2s_parent/src/app/core/baseViewModel.dart';
import 'package:b2s_parent/src/app/models/children.dart';
import 'package:b2s_parent/src/app/models/childrenBusSession.dart';
import 'package:b2s_parent/src/app/models/parent.dart';
import 'package:b2s_parent/src/app/pages/user/profile_children/profile_children_viewmodel.dart';
import 'package:b2s_parent/src/app/theme/theme_primary.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileChildrenPage extends StatefulWidget {
  static const String routeName = "/profileChildren";
  final ProfileChildrenPageArgs profileChildrenPageArgs;

  const ProfileChildrenPage({Key key, this.profileChildrenPageArgs}) : super(key: key);
  @override
  _ProfileChildrenPageState createState() => _ProfileChildrenPageState();
}
class ProfileChildrenPageArgs{
  final List<RouteBus> listRouteBus;
  final ChildrenBusSession childrenBusSession;

  ProfileChildrenPageArgs(this.listRouteBus,this.childrenBusSession);
}
class _ProfileChildrenPageState extends State<ProfileChildrenPage> {
  ProfileChildrenViewModel viewModel = ProfileChildrenViewModel();
  int age = 0;
  @override
  void initState() {
    // TODO: implement initState
    viewModel.listRouteBus = widget.profileChildrenPageArgs.listRouteBus;
    viewModel.childrenBusSession = widget.profileChildrenPageArgs.childrenBusSession; //ChildrenBusSession.list.singleWhere((bus) => bus.child.id == widget.children.id);
    age = DateTime.now().year - DateTime.parse(widget.profileChildrenPageArgs.childrenBusSession.child.birthday).year;
    viewModel.onCreateTime();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    final cancelBtn = Positioned(
      top: 50.0,
      left: 20.0,
      child: Container(
        height: 35.0,
        width: 35.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey.withOpacity(0.5),
        ),
        child: IconButton(
          icon: Icon(LineIcons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
          iconSize: 20.0,
        ),
      ),
    );
    final qrCode = Positioned(
      bottom: 0,
      left: deviceWidth / 2 - 80,
      child: QrImage(
        backgroundColor: Colors.white,
        data: viewModel.childrenBusSession.child.name,
        version: QrVersions.auto,
        size: 160.0,
      ),
    );
    final userImage = Stack(
      children: <Widget>[
        Hero(
            tag: viewModel.childrenBusSession.child.photo,
            child: Container(
              height: 400,
              child: Column(
                children: <Widget>[
                  Flexible(
                    flex: 8,
                    child: CachedNetworkImage(
                      imageUrl: viewModel.childrenBusSession.child.photo,
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
        cancelBtn,
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
                  viewModel.childrenBusSession.child.name,
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
                        viewModel.childrenBusSession.child.gender.toString(),
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
        viewModel.childrenBusSession.child.location,
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
        color: Colors.white,
        padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 15, bottom: 15),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: SizedBox(),
                ),
                Expanded(
                  flex: 5,
                  child: Row(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 3, right: 3, bottom: 3),
                        child: Icon(
                          type ? Icons.home : Icons.school,
                          color: type ? Colors.orange : Colors.green,
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
                  flex: 5,
                  child: Align(
                    alignment: Alignment.centerLeft,
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
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: SizedBox(),
                ),
                Expanded(
                  flex: 5,
                  child: Row(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 3, right: 3, bottom: 3),
                        child: Icon(
                          type ? Icons.school : Icons.home,
                          color: type ? Colors.green : Colors.orange,
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
                  flex: 5,
                  child: Align(
                    alignment: Alignment.centerLeft,
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
                            color: ThemePrimary.primaryColor,
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
                            color: ThemePrimary.primaryColor,
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
                  rowTitle('THÔNG TIN HỌC SINH'),
                  row1('Họ và tên :', children.name),
                  hr,
                  row1('Tuổi :', age.toString()),
                  hr,
                  row1('Trường :', children.schoolName),
                  hr,
                  row1('Lớp :', children.classes),
                  hr,
                  row1('Địa chỉ :', children.location),
                  hr,
                  row1('Số điện thoại :', children.phone),
                  hr,
                  row1('Email :', children.email),
                  hr,
                  row1('Phụ huynh :', Parent().name),
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
            child: Column(
              children: <Widget>[
                rowTitle('THÔNG TIN XE BUS'),
                row1('Biển số xe :', viewModel.childrenBusSession.vehicleName.toString()),
                hr,
                rowIcon('Tài xế :', viewModel.childrenBusSession.driver.name,
                    viewModel.childrenBusSession.driver.phone),
                if(viewModel.startDepart!=null)hr,
//                rowIcon('QL đưa đón :', busSession., '0983932940'),
//                hr,
//                rowIcon('QL tại trường :', 'Âu Dương Phong', '0983932940'),
//                hr,
                if(viewModel.startDepart!=null)row2('Giờ đón :', viewModel.startDepart, 'Đến trường :', viewModel.endDepart, true),
                if(viewModel.startDepart!=null)hr,
                if(viewModel.startArrive!=null)row2('Giờ về :', viewModel.startArrive, 'Về nhà :', viewModel.endArrive, false),
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
    return Scaffold(
      body: ViewModelProvider(
        viewmodel: viewModel,
        child: StreamBuilder(
          stream: viewModel.stream,
          builder: (context,snapshot){
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  userImage,
                  userName,
                  userLocation,
                  childrenInfo(viewModel.childrenBusSession.child),
                  if(viewModel.listRouteBus.length > 0)busInfo
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
