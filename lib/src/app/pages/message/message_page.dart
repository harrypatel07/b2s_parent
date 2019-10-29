import 'package:b2s_parent/src/app/core/baseViewModel.dart';
import 'package:b2s_parent/src/app/pages/message/messageDetail/message_detail_page.dart';
import 'package:b2s_parent/src/app/pages/message/messageUser/message_user_page.dart';
import 'package:b2s_parent/src/app/pages/message/message_page_viewmodel.dart';
import 'package:b2s_parent/src/app/widgets/index.dart';
import 'package:b2s_parent/src/app/widgets/ts24_appbar_widget.dart';
import 'package:flutter/material.dart';

class MessagePage extends StatefulWidget {
  static const String routeName = "/message";
  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  MessagePageViewModel viewModel = MessagePageViewModel();

  @override
  initState() {
    viewModel.listenData();
    super.initState();
  }

  Widget appBar() {
    return TS24AppBar(
      title: new Text("Message"),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.add),
          iconSize: 30.0,
          onPressed: () {},
        )
      ],
    );
  }

  Widget body() {
    return RefreshIndicator(
      onRefresh: () async {
        viewModel.listenData();
      },
      child: viewModel.listChat.length == 0
          ? LoadingSpinner.loadingView(
              context: viewModel.context, loading: viewModel.loading)
          : ListView.builder(
              //padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
              itemCount: viewModel.listChat.length,
              itemBuilder: (context, index) {
                var _model = viewModel.listChat[index];
                return Column(
                  children: <Widget>[
                    Divider(
                      height: 12.0,
                    ),
                    ListTile(
                      onTap: () {
                        viewModel.onItemClick(_model);
                      },
                      leading: InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            MessageUserPage.routeName,
                            arguments: _model.peerId,
                          );
                        },
                        child: Hero(
                          tag: _model.peerId,
                          child:
                              // CachedNetworkImage(
                              //   imageUrl: _model.avatarUrl,
                              //   imageBuilder: (context, imageProvider) => CircleAvatar(
                              //     radius: 24.0,
                              //     backgroundImage: imageProvider,
                              //     backgroundColor: Colors.transparent,
                              //   ),
                              // ),
                              CircleAvatar(
                            radius: 24.0,
                            backgroundImage: MemoryImage(_model.avatarUrl),
                            backgroundColor: Colors.transparent,
                          ),
                        ),
                      ),
                      title: Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(_model.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20)),
                          ),
                          // SizedBox(
                          //   width: 16.0,
                          // ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                _model.datetime,
                                style: TextStyle(fontSize: 12.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                      subtitle: Text(
                        _model.message,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18.0,
                          color: Colors.grey.withOpacity(0.6),
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 14.0,
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    viewModel.context = context;
    return ViewModelProvider(
      viewmodel: viewModel,
      child: StreamBuilder<Object>(
          stream: viewModel.stream,
          builder: (context, snapshot) {
            return new TS24Scaffold(
              appBar: appBar(),
              body: body(),
            );
          }),
    );
  }
}
