import 'package:b2s_parent/src/app/core/baseViewModel.dart';

class SideMenuPageViewModel extends ViewModelBase {
  String mainProfilePicture =
      "https://cdn1.iconfinder.com/data/icons/children-avatar-flat/128/children_avatar-01-512.png";
  String otherProfilePicture =
      "https://cdn1.iconfinder.com/data/icons/children-avatar-flat/128/children_avatar-11-256.png";

  void switchUser() {
    String backupString = mainProfilePicture;
    mainProfilePicture = otherProfilePicture;
    otherProfilePicture = backupString;
    this.updateState();
  }
}
