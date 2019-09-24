class ChatModel {
  final String avatarUrl;
  final String name;
  final String datetime;
  final String message;

  ChatModel({this.avatarUrl, this.name, this.datetime, this.message});

  static List<ChatModel> dummyData = [
    ChatModel(
      avatarUrl: "https://randomuser.me/api/portraits/women/34.jpg",
      name: "Ms Phương",
      datetime: "20:18",
      message: "Hôm nay trường có sự kiện abc",
    ),
    ChatModel(
      avatarUrl: "https://randomuser.me/api/portraits/women/49.jpg",
      name: "Ms Châu",
      datetime: "19:22",
      message: "hmmmm....",
    ),
    ChatModel(
      avatarUrl: "https://randomuser.me/api/portraits/men/81.jpg",
      name: "Mr Tho",
      datetime: "11:05",
      message: "hmmmm...",
    ),
    ChatModel(
      avatarUrl: "https://randomuser.me/api/portraits/men/83.jpg",
      name: "Mr Minh",
      datetime: "09:46",
      message: "hmmmm...",
    ),
  ];
}
