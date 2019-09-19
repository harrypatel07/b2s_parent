import 'package:b2s_parent/src/app/core/baseViewModel.dart';
import 'package:b2s_parent/src/app/pages/sidemenu/sidemenu_page_viewmodel.dart';
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
              ColorFilter.mode(Colors.black.withOpacity(.2), BlendMode.darken),
          fit: BoxFit.cover,
        ),
      ),
      accountName: Text(
        "Minh Luân",
        style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 20,
            fontWeight: FontWeight.bold),
      ),
      accountEmail: Text(
        "luanvm@ts24corp.com",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      currentAccountPicture: CircleAvatar(
        backgroundColor: Theme.of(context).platform == TargetPlatform.iOS
            ? Colors.blue
            : Colors.white,
        child: Image(
          width: 60,
          image: NetworkImage(viewModel.mainProfilePicture),
          fit: BoxFit.cover,
        ),
      ),
      otherAccountsPictures: <Widget>[
        GestureDetector(
          onTap: viewModel.switchUser,
          child: CircleAvatar(
            backgroundColor: Theme.of(context).platform == TargetPlatform.iOS
                ? Colors.blue
                : Colors.white,
            child: Image(
              width: 30,
              image: NetworkImage(viewModel.otherProfilePicture),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildListContent(BuildContext context) {
    return ListView(
      children: <Widget>[
        new ListTile(
            title: new Text("First Page"),
            trailing: new Icon(Icons.arrow_upward),
            onTap: () {
              Navigator.of(context).pop();
            }),
        new ListTile(
            title: new Text("Second Page"),
            trailing: new Icon(Icons.arrow_right),
            onTap: () {
              Navigator.of(context).pop();
            }),
        new Divider(),
        new ListTile(
          title: new Text("Close"),
          trailing: new Icon(Icons.cancel),
          onTap: () => Navigator.of(context).pop(),
        )
      ],
    );
  }

  SideMenuPageViewModel viewModel = SideMenuPageViewModel();
  @override
  Widget build(BuildContext context) {
    viewModel.context = context;
    return ViewModelProvider(
      viewmodel: viewModel,
      child: StreamBuilder<Object>(
          stream: viewModel.stream,
          builder: (context, snapshot) {
            return Drawer(
              elevation: 4,
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
            );
          }),
    );
  }
}
