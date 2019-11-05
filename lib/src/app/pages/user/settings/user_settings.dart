import 'package:b2s_parent/src/app/core/baseViewModel.dart';
import 'package:b2s_parent/src/app/pages/user/settings/user_settings_viewmodel.dart';
import 'package:b2s_parent/src/app/theme/theme_primary.dart';
import 'package:b2s_parent/src/app/widgets/ts24_appbar_widget.dart';
import 'package:flutter/material.dart';

class UserSettingsPage extends StatefulWidget {
  static const String routeName = "/settings";
  @override
  _UserSettingsPageState createState() => _UserSettingsPageState();
}

class _UserSettingsPageState extends State<UserSettingsPage> {
  final hr = new Container(
    height: 1,
    color: Colors.grey.shade200,
  );
  _titleReminder() {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          "Reminder",
          style: TextStyle(
              color: Colors.orange, fontSize: 18, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  _itemReminder(String title, String button, String subtitle) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Column(
        children: <Widget>[
          Container(
            child: Row(
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      color: Colors.black54),
                ),
                Spacer(),
                Text(button,
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.indigoAccent,
                        fontSize: 18)),
              ],
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              subtitle,
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  _titleNotification(String title, String button) {
    return Container(
        padding: EdgeInsets.all(20.0),
        child: Row(
          children: <Widget>[
            Text(
              title,
              style: TextStyle(
                  color: Colors.orange,
                  fontSize: 18,
                  fontWeight: FontWeight.w700),
            ),
            Spacer(),
            InkWell(
              onTap: () => {
                viewModel.onChangedAll(),
              },
              child: Text(
                button,
                style: TextStyle(
                    color: Colors.indigoAccent,
                    fontSize: 18,
                    fontWeight: FontWeight.w700),
              ),
            )
          ],
        ));
  }

  _itemNotification(
      String title, String subtitle, bool value, Function onChanged) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 10, 20, 10),
      child: Row(
        children: <Widget>[
          Container(
            width: 60,
            padding: EdgeInsets.only(left: 0),
            //alignment: Alignment.topLeft,
            child: Checkbox(value: value, onChanged: onChanged),
          ),
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    title,
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: Colors.black54),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    subtitle,
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                _titleReminder(),
                _itemReminder("Pick up reminder", "Change",
                    "Currently 1.0 Km before pick up spot"),
                _itemReminder("Drop reminder", "Change",
                    "Currently 1.0 Km before drop spot"),
              ],
            ),
          ),
          hr,
          Container(
            child: Column(
              children: <Widget>[
                _titleNotification("Set Notification alert", "Select all"),
                _itemNotification(
                    "Pick up Notification",
                    "When bus reached at pickup reminder spot",
                    viewModel.pickUpNotification,
                    (b) => {viewModel.onChangedPickUpNotification()}),
                _itemNotification(
                    "Drop Notification",
                    "When bus reached at drop reminder spot",
                    viewModel.dropNotification,
                    (b) => {viewModel.onChangeDropNotification()}),
                _itemNotification(
                    "Reached at school",
                    "Hangsout video call",
                    viewModel.reachedAtSchool,
                    (b) => {viewModel.onChangeReachedAtSchool()}),
                _itemNotification(
                    "Left from school",
                    "Also notify when receving invites",
                    viewModel.leftFromSchool,
                    (b) => {viewModel.onChangeLeftFromSchool()}),
              ],
            ),
          )
        ],
      ),
    );
  }

  UserSettingsViewModel viewModel = UserSettingsViewModel();
  @override
  Widget build(BuildContext context) {
    viewModel.context = context;
    return ViewModelProvider(
      viewmodel: viewModel,
      child: StreamBuilder<Object>(
          stream: viewModel.stream,
          builder: (context, snapshot) {
            return new Scaffold(
              appBar: new TS24AppBar(
                  title: new Text("Settings"),
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context, false),
                  )),
              backgroundColor: ThemePrimary.history_page_backgroundcolor,
              body: _buildBody(),
              // drawer: SideMenuPage(),
            );
          }),
    );
  }
}
