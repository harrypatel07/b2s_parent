import 'package:b2s_parent/src/app/core/baseViewModel.dart';
import 'package:b2s_parent/src/app/models/menu.dart';
import 'package:b2s_parent/src/app/pages/sidemenu/sidemenu_page_viewmodel.dart';
import 'package:b2s_parent/src/app/pages/sidemenu/widgets/listContent_clipper.dart';
import 'package:b2s_parent/src/app/pages/tabs/tabs_page_viewmodel.dart';
import 'package:flutter/material.dart';

class SideMenuPage extends StatefulWidget {
  @override
  _SideMenuPageState createState() => _SideMenuPageState();

  static final SideMenuPage _singleton = new SideMenuPage._internal();

  factory SideMenuPage() {
    return _singleton;
  }

  SideMenuPage._internal();
}

class _SideMenuPageState extends State<SideMenuPage> {
  Widget _buildHeader(BuildContext context) {
    return UserAccountsDrawerHeader(
      decoration: BoxDecoration(
        image: DecorationImage(
          alignment: Alignment.bottomCenter,
          image: AssetImage('assets/images/sidemenu_bg.jpg'),
          colorFilter:
              ColorFilter.mode(Colors.black.withOpacity(.5), BlendMode.darken),
          fit: BoxFit.cover,
        ),
      ),
      accountName: viewModel.childPrimary != null
          ? Text(
              viewModel.childPrimary.name,
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            )
          : Container(),
      accountEmail: viewModel.childPrimary != null &&
              viewModel.childPrimary.schoolName != null
          ? Text(
              viewModel.childPrimary.schoolName,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            )
          : Container(),
      currentAccountPicture: viewModel.childPrimary != null
          ? CircleAvatar(
              radius: 35.0,
              backgroundImage: MemoryImage(viewModel.childPrimary.photo),
              backgroundColor: Colors.transparent,
            )
          : Container(),
      //  CachedNetworkImage(
      //   imageUrl: viewModel.childPrimary.photo,
      //   imageBuilder: (context, imageProvider) => CircleAvatar(
      //     radius: 35.0,
      //     backgroundImage: imageProvider,
      //     backgroundColor: Colors.transparent,
      //   ),
      // ),
      // CircleAvatar(
      //   backgroundColor: Theme.of(context).platform == TargetPlatform.iOS
      //       ? Colors.blue
      //       : Colors.white,
      //   child: CachedNetworkImage(
      //     width: 60,
      //     imageUrl: viewModel.childPrimary.photo,
      //     fit: BoxFit.cover,
      //   ),
      // ),
      otherAccountsPictures: <Widget>[
        ...viewModel.listChildOther.map(
          (children) => GestureDetector(
            onTap: () {
              viewModel.switchUser(children);
            },
            child:
                //  CircleAvatar(
                //   backgroundColor:
                //       Theme.of(context).platform == TargetPlatform.iOS
                //           ? Colors.blue
                //           : Colors.white,
                //   child: CachedNetworkImage(
                //     width: 30,
                //     imageUrl: children.photo,
                //     fit: BoxFit.cover,
                //   ),
                // ),
                //   CachedNetworkImage(
                // imageUrl: children.photo,
                // imageBuilder: (context, imageProvider) => CircleAvatar(
                //   radius: 35.0,
                //   backgroundImage: imageProvider,
                //   backgroundColor: Colors.transparent,
                // ),
                CircleAvatar(
              radius: 35.0,
              backgroundImage: MemoryImage(children.photo),
              backgroundColor: Colors.transparent,
            ),
          ),
        )
      ],
    );
  }

  Widget _buildListContent(BuildContext context) {
    return ListView(
      padding: EdgeInsets.only(top: 0),
      children: <Widget>[
        ...Menu.tabMenu
            .map((menu) => ClipPath(
                  clipper: ListContentClipper(),
                  child: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.topRight,
                      stops: [.3, 1],
                      colors: viewModel.currentIndex == menu.index
                          ? [Color(0xFFFFD752), Color(0xFFD4AF0B)]
                          : [Colors.white, Colors.white],
                    )),
                    child: ListTile(
                        leading: new Icon(
                          menu.iconData,
                        ),
                        title: new Text(
                          menu.title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () {
                          viewModel.listContentOnTap(menu);
                        }),
                  ),
                ))
            .toList(),
        Divider(),
        ListTile(
          title: new Text("Close"),
          trailing: new Icon(Icons.cancel),
          onTap: () => Navigator.of(context).pop(),
        )
      ],
    );
  }

  SideMenuPageViewModel viewModel = SideMenuPageViewModel();
  TabsPageViewModel tabsPageViewModel;
  @override
  Widget build(BuildContext context) {
    viewModel.context = context;
    tabsPageViewModel = ViewModelProvider.of(context);
    if (tabsPageViewModel != null)
      viewModel.currentIndex = tabsPageViewModel.currentTabIndex;
    return ViewModelProvider(
      viewmodel: viewModel,
      child: StreamBuilder<Object>(
          stream: viewModel.stream,
          builder: (context, snapshot) {
            return Drawer(
              elevation: 4,
              child: Container(
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 4,
                      child: _buildHeader(context),
                    ),
                    Expanded(
                      flex: 6,
                      child: _buildListContent(context),
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }
}
