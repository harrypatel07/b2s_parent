class Message {
  bool fromMe;
  String body;

  Message(this.body, this.fromMe);
}

class Messages {
  String senderId;
  String receiverId;
  String timestamp;
  String content;
  int type;
  Messages(
      {this.senderId,
      this.receiverId,
      this.timestamp,
      this.type,
      this.content});
  Messages.fromJson(Map<dynamic, dynamic> json) {
    senderId = json['senderId'];
    receiverId = json['receiverId'];
    timestamp = json['timestamp'];
    type = json['type'];
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["senderId"] = this.senderId;
    data["receiverId"] = this.receiverId;
    data["timestamp"] = this.timestamp;
    data["type"] = this.type;
    data["content"] = this.content;
    return data;
  }
}
