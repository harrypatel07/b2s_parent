import 'package:b2s_parent/src/app/core/baseViewModel.dart';
import 'package:b2s_parent/src/app/models/children.dart';
import 'package:b2s_parent/src/app/pages/login/login_page.dart';
import 'package:b2s_parent/src/app/pages/tabs/tabs_page_viewmodel.dart';
import 'package:b2s_parent/src/app/pages/user/profile_children/profile_children.dart';
import 'package:b2s_parent/src/app/pages/user/settings/user_settings.dart';
import 'package:b2s_parent/src/app/pages/user/tickets/tickets_children.dart';
import 'package:b2s_parent/src/app/pages/user/user_page_viewmodel.dart';
import 'package:b2s_parent/src/app/theme/theme_primary.dart';
import 'package:b2s_parent/src/app/widgets/popupConfirm.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class UserPage extends StatefulWidget {
  static const String routeName = "/user";
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;

  Animation<double> _animationTickests;

  UserPageViewModel viewModel;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
    _animationTickests = Tween(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _itemChild(
      BuildContext context, UserPageViewModel viewModel, Children children) {
    return new Column(
      children: <Widget>[
        new Container(
          //color: Colors.blue,
          margin: EdgeInsets.only(right: 10),
          child: Row(
            children: <Widget>[
              new Expanded(
                flex: 6,
                child: InkWell(
                  onTap: () => viewModel.onTapChildren(children),
                  child: new Container(
                    //margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    padding: EdgeInsets.fromLTRB(20, 7.5, 0, 7.5),
                    decoration: new BoxDecoration(
                      //color: Colors.white30, //new Color(0xFF333366),
                      //color: Colors.teal,
                      shape: BoxShape.rectangle,
                      borderRadius: new BorderRadius.circular(0.0),
                    ),
                    child: new Row(
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            print('on Tap avatar');
                            Navigator.pushNamed(
                              context,
                              ProfileChildrenPage.routeName,arguments : ProfileChildrenPageArgs(children: children),
                            );
                          },
                          child: Hero(
                            tag: children.photo,
                            child:
                                //  CircleAvatar(
                                //   radius: 20.0,
                                //   backgroundImage: MemoryImage(children.photo),
                                //   backgroundColor: Colors.transparent,
                                // ),
                                new CachedNetworkImage(
                              imageUrl: children.photo,
                              imageBuilder: (context, imageProvider) =>
                                  CircleAvatar(
                                radius: 20.0,
                                backgroundImage: imageProvider,
                                backgroundColor: Colors.transparent,
                              ),
                            ),
                          ),
                        ),
                        new Flexible(
                          child: new Container(
                            margin: EdgeInsets.only(left: 10),
                            child: new Text(
                              children.name,
                              style: TextStyle(fontSize: 14),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              new Expanded(
                flex: 1,
                child: InkWell(
//                  onTap: () => _popupChildrenManager(context, children),
                  child: new Container(
                    height: 50,
                    //color: Colors.green,
                    margin: EdgeInsets.only(top: 5, bottom: 5, right: 5),
                    child: Align(
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.edit,
                        size: 25,
                        color: Colors.orangeAccent.shade400,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        new Container(
          height: 1,
          color: Colors.grey.shade200,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    TabsPageViewModel tabsPageViewModel = ViewModelProvider.of(context);
    viewModel = tabsPageViewModel.userPageViewModel;
    viewModel.context = context;
    final hr = new Container(
      height: 1,
      color: Colors.grey.shade200,
    );
    final userImage = CachedNetworkImage(
      imageUrl: viewModel.parent.photo,
      imageBuilder: (context, imageProvider) => Container(
        height: 100.0,
        width: 100.0,
        decoration: BoxDecoration(
          // color: Colors.red,
          image: DecorationImage(image: imageProvider,
              // MemoryImage(viewModel.parent.photo)
             fit: BoxFit.cover  ),
          shape: BoxShape.circle,
        ),
      ),
    );

    final userName = Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Flexible(
            child: Text(
              viewModel.parent.name,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.w900,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
    final userInfo = Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0,top: 20.0),
          child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(8.0),
            shadowColor: Colors.white,
            child: InkWell(
              onTap: () {
                viewModel.onTapParent();
              },
              child: Container(
                height: 150.0,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.2),
                  ),
                  color: Colors.white,
                ),
                child: Container(
                  padding: const EdgeInsets.only(left: 20.0, bottom: 20.0,top: 20),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 100,
                          height: 100,
                          child: userImage,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width - 180,
                          child: userName,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
    Widget _buildIconTileSettings(IconData icon, Color color, String title) {
      return new ListTile(
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: Container(
          height: 30.0,
          width: 30.0,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Center(
            child: Icon(
              icon,
              color: Colors.white,
            ),
          ),
        ),
        trailing: Icon(LineIcons.chevron_circle_right),
        onTap: () => {
          Navigator.pushNamed(
            context,
            UserSettingsPage.routeName,
          ),
        },
      );
    }

    Widget _itemChildAdd() {
      return InkWell(
        onTap: () => viewModel.onTapCreateChildren(),
        child: new Container(
          height: 50,
          child: Align(
            alignment: Alignment.center,
            child: Icon(
              Icons.add_circle,
              size: 40,
              color: Colors.teal,
            ),
          ),
        ),
      );
    }

    Widget _buildChildrenContent() {
      List<Widget> listChildrenItem = new List();
      viewModel.listChildren.forEach((item) =>
          {listChildrenItem.add(_itemChild(context, viewModel, item))});
      listChildrenItem.add(_itemChildAdd());
      return FadeTransition(
          opacity: _animation,
          child: Container(
            //height: 200,
            color: Colors.grey.shade300,
            child: Column(
              children: listChildrenItem,
            ),
          ));
    }

    Widget _buildChildrenTitle(IconData icon, Color color, String title) {
      return new Column(
        children: <Widget>[
          new ListTile(
              title: Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              leading: Container(
                height: 30.0,
                width: 30.0,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Center(
                  child: Icon(
                    icon,
                    color: Colors.white,
                  ),
                ),
              ),
              trailing: Icon((viewModel.isShowChildrenManager)
                  ? LineIcons.chevron_circle_down
                  : LineIcons.chevron_circle_right),
              onTap: () {
                viewModel.updateStatusChildrenManager();
                if (viewModel.isShowChildrenManager)
                  _controller.forward();
                else
                  _controller.reverse();
                print("Tab title");
              }),
          if (viewModel.isShowChildrenManager) _buildChildrenContent(),
        ],
      );
    }

    Widget _buildTicketTitle(IconData icon, Color color, String title) {
      return new Column(
        children: <Widget>[
          new ListTile(
              title: Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              leading: Container(
                height: 30.0,
                width: 30.0,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Center(
                  child: Icon(
                    icon,
                    color: Colors.white,
                  ),
                ),
              ),
              trailing: Icon(LineIcons.chevron_circle_right),
              onTap: () {
                Navigator.pushNamed(context, TicketsChildrenPage.routeName);
                print("Tab tickets");
              }),
        ],
      );
    }

    Widget _buildLogOutTitle(IconData icon, Color color, String title) {
      return new Column(
        children: <Widget>[
          new ListTile(
              title: Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              leading: Container(
                height: 30.0,
                width: 30.0,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Center(
                  child: Icon(
                    icon,
                    color: Colors.white,
                  ),
                ),
              ),
              trailing: Icon(LineIcons.chevron_circle_right),
              onTap: () {
                popupConfirm(
                    context: context,
                    title: 'THÔNG BÁO',
                    desc: 'Xác nhận đăng xuất ?',
                    yes: 'Có',
                    no: 'Không',
                    onTap: () {
                      Navigator.pop(context);
                      viewModel.parent.clearLocal();
                      Navigator.pushReplacementNamed(
                          context, LoginPage.routeName);
                    });
              }),
        ],
      );
    }

    Widget secondCard() {
      return Padding(
        padding: EdgeInsets.only(right: 20.0, left: 20.0, bottom: 30.0),
        child: Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(8.0),
          shadowColor: Colors.white,
          child: Container(
            //height: 200.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              children: <Widget>[
                _buildChildrenTitle(
                    Icons.person_pin, ThemePrimary.primaryColor, "Quản lý thông tin trẻ"),
                hr,
                _buildTicketTitle(Icons.person_pin,ThemePrimary.primaryColor, "Quản lý vé"),
                hr,
                _buildIconTileSettings(
                    LineIcons.cogs, ThemePrimary.primaryColor, 'Settings'),
                hr,
                _buildLogOutTitle(Icons.exit_to_app,ThemePrimary.primaryColor, "Đăng xuất"),
              ],
            ),
          ),
        ),
      );
    }

    return ViewModelProvider(
      viewmodel: viewModel,
      child: StreamBuilder<Object>(
          stream: viewModel.stream,
          builder: (context, snapshot) {
            return Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: <Widget>[
                          Stack(
                            children: <Widget>[
                              Container(
                                height: 250.0,
                              ),
                              Container(
                                height: 150.0,
                                decoration: BoxDecoration(
                                    gradient: ThemePrimary.primaryGradient),
                              ),
                              Positioned(
                                  top: 50, right: 0, left: 0, child: userInfo)
                            ],
                          ),
                          secondCard(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
