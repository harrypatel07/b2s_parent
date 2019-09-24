import 'package:b2s_parent/src/app/widgets/index.dart';
import 'package:b2s_parent/src/app/widgets/ts24_appbar_widget.dart';
import 'package:b2s_parent/src/models/chat.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class MessagePage extends StatefulWidget {
  static const String routeName = "/message";
  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  @override
  Widget build(BuildContext context) {
    return new TS24Scaffold(
      appBar: new TS24AppBar(
        title: new Text("Message"),
      ),
      body: ListView.builder(
        itemCount: ChatModel.dummyData.length,
        itemBuilder: (context, index) {
          ChatModel _model = ChatModel.dummyData[index];
          return Column(
            children: <Widget>[
              Divider(
                height: 12.0,
              ),
              ListTile(
                leading: CachedNetworkImage(
                  imageUrl: _model.avatarUrl,
                  imageBuilder: (context, imageProvider) => CircleAvatar(
                    radius: 24.0,
                    backgroundImage: imageProvider,
                    backgroundColor: Colors.transparent,
                  ),
                ),
                title: Row(
                  children: <Widget>[
                    Text(_model.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(
                      width: 16.0,
                    ),
                    Text(
                      _model.datetime,
                      style: TextStyle(fontSize: 12.0),
                    ),
                  ],
                ),
                subtitle: Text(
                  _model.message,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
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
}
