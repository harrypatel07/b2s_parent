import 'package:b2s_parent/main.dart';
import 'package:b2s_parent/src/app/app_localizations.dart';
import 'package:b2s_parent/src/app/core/app_setting.dart';
import 'package:b2s_parent/src/app/core/baseViewModel.dart';
import 'package:b2s_parent/src/app/models/children.dart';
import 'package:b2s_parent/src/app/models/itemCustomPopupMenu.dart';
import 'package:b2s_parent/src/app/pages/tabs/tabs_page_viewmodel.dart';
import 'package:b2s_parent/src/app/pages/user/profile_children/profile_children.dart';
import 'package:b2s_parent/src/app/pages/user/tickets/tickets_children.dart';
import 'package:b2s_parent/src/app/pages/user/user_page_viewmodel.dart';
import 'package:b2s_parent/src/app/theme/theme_primary.dart';
import 'package:b2s_parent/src/app/widgets/index.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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
  GlobalKey _key = GlobalKey();
  Size _size = Size(0, 0);
  _getSize() {
    final RenderBox renderBox = _key.currentContext.findRenderObject();
    _size = renderBox.size;
  }

  void _handleSelectLanguage(CustomPopupMenu choice) {
    viewModel.selectedLanguage = choice;
    viewModel.onChangeLanguage(choice.subTitle);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {
          _getSize();
        }));
    _controller = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
    _animationTickests = Tween(begin: 0.0, end: 1.0).animate(_controller);
    super.initState();
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
        Container(
          height: 60,
          width: MediaQuery.of(context).size.width - 40,
          child: new Slidable(
            actionPane: SlidableStrechActionPane(),
            actionExtentRatio: 0.25,
            child: InkWell(
              onTap: () => viewModel.onTapChildren(children),
              child: new Container(
                height: 60,
                width: MediaQuery.of(context).size.width - 40,
                color: Colors.grey[300],
                child: Row(
                  children: <Widget>[
                    new Expanded(
                      flex: 6,
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
                                  ProfileChildrenPage.routeName,
                                  arguments: ProfileChildrenPageArgs(
                                      children: children,
                                      heroTag: children.id.toString()),
                                );
                              },
                              child: Hero(
                                tag: children.id.toString(),
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
                    new Expanded(
                      flex: 1,
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
                  ],
                ),
              ),
            ),
            secondaryActions: <Widget>[
              IconSlideAction(
                caption: translation.text("COMMON.DELETE"),
                color: Colors.red,
                icon: Icons.delete,
                onTap: () => viewModel.onTapRemoveChildren(children),
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
          image: DecorationImage(
              image: imageProvider,
              // MemoryImage(viewModel.parent.photo)
              fit: BoxFit.cover),
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
          padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
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
                  padding:
                      const EdgeInsets.only(left: 20.0, bottom: 20.0, top: 20),
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
    Widget _buildIconTileLanguages(IconData icon, Color color, String title) {
      return PopupMenuButton<CustomPopupMenu>(
        child: ListTile(
          title: Container(
            alignment: Alignment.centerLeft,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
                SizedBox(
                  height: 2,
                ),
                Text(
                  viewModel.selectedLanguage.title,
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 12),
                )
              ],
            ),
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
//          onTap: () {
//            viewModel.onChangeLanguage();
////          Navigator.pushNamed(
////            context,
////            UserSettingsPage.routeName,
////          ),
//          },
        ),
//          elevation:  30.2,
        initialValue: viewModel.selectedLanguage,
        onSelected: _handleSelectLanguage,
        offset: Offset(50, viewModel.selectedLanguage.id == 0 ? 50 : 100),
        itemBuilder: (BuildContext context) {
          return viewModel.listLanguages.map((CustomPopupMenu vehicle) {
            return PopupMenuItem<CustomPopupMenu>(
              height: 50,
              value: vehicle,
              child: Text(
                vehicle.title.toString(),
                style: TextStyle(fontSize: 14),
              ),
            );
          }).toList();
        },
      );
    }
//
//    Widget _buildIconTilePayment(IconData icon, Color color, String title) {
//      return new ListTile(
//        title: Text(
//          title,
//          style: TextStyle(fontWeight: FontWeight.bold),
//        ),
//        leading: Container(
//          height: 30.0,
//          width: 30.0,
//          decoration: BoxDecoration(
//            color: color,
//            borderRadius: BorderRadius.circular(10.0),
//          ),
//          child: Center(
//            child: Icon(
//              icon,
//              color: Colors.white,
//            ),
//          ),
//        ),
//        trailing: Icon(LineIcons.chevron_circle_right),
//        onTap: () => {viewModel.onTapPayment()},
//      );
//    }

    Widget _itemChildAdd() {
      return InkWell(
        onTap: () => viewModel.onTapCreateChildren(),
        child: Center(
          child: new Container(
            margin: EdgeInsets.all(5),
            height: 45,
            width: 45,
            decoration: BoxDecoration(
                color: ThemePrimary.colorDriverApp, shape: BoxShape.circle),
            child: Stack(
              children: <Widget>[
                Center(
                  child: Icon(
                    Icons.crop_free,
                    size: 35,
                    color: Colors.white,
                  ),
                ),
                Center(
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 20,
                  ),
                )
              ],
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
//              height: 85,
              color: Colors.grey.shade300,
              child: viewModel.loadingListChildren
                  ? Column(
                      children: <Widget>[
                        Container(
                          height: 100,
                          child: LoadingSpinner.loadingView(
                              context: context,
                              loading: viewModel.loadingListChildren),
                        ),
                        _itemChildAdd()
                      ],
                    )
                  : Column(
                      children: listChildrenItem,
                    )
//            Column(
//                    children: listChildrenItem,
//                  ),
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
                viewModel.onTapLogout();
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
                _buildChildrenTitle(Icons.person_pin, ThemePrimary.primaryColor,
                    translation.text("USER_PAGE.CHILDREN_MANAGER")),
                hr,
                _buildTicketTitle(Icons.extension, ThemePrimary.primaryColor,
                    translation.text("USER_PAGE.TICKET_MANAGER")),
                hr,
                // _buildIconTilePayment(
                //     LineIcons.paypal, ThemePrimary.primaryColor, translation.text("USER_PAGE.PAYMENT")),
//                hr,
//                _buildIconTileSettings(
//                    LineIcons.cogs, ThemePrimary.primaryColor, 'Cài đặt'),
                hr,
                _buildLogOutTitle(Icons.exit_to_app, ThemePrimary.primaryColor,
                    translation.text("USER_PAGE.LOG_OUT")),
                hr,
                _buildIconTileLanguages(
                    LineIcons.language,
                    ThemePrimary.primaryColor,
                    translation.text("USER_PAGE.LANGUAGES")),
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
                      key: _key,
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
//                    if(_size.height < MediaQuery.of(context).size.height)
//                      Container(
//                        color: Colors.red,
//                        height: 50,
//                        child: Center(
//                          child: Text("version $version"),
//                        ),
//                      )
                    if (_size.height >= MediaQuery.of(context).size.height)
                      Container(
                        height: 50,
                        child: Center(
                          child: Text("${translation.text("VERSION")} $version"),
                        ),
                      )
                    else
                      Column(
                        children: <Widget>[
                          SizedBox(
                            height: MediaQuery.of(context).size.height -
                                _size.height -
                                120,
                          ),
                          Container(
                            height: 50,
                            child: Center(
                              child: Text("${translation.text("VERSION")} $version"),
                            ),
                          )
                        ],
                      )
                  ],
                ),
              ),
            );
          }),
    );
  }
}
