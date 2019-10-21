import 'package:b2s_parent/src/app/core/baseViewModel.dart';
import 'package:b2s_parent/src/app/models/children.dart';
import 'package:b2s_parent/src/app/models/parent.dart';

class UserPageViewModel extends ViewModelBase {
  bool check = true;
  bool isShowChildrenManager;
  Parent parent;
  List<Children> listChildren;

  UserPageViewModel() {
    isShowChildrenManager = false;
    parent = new Parent();
    listChildren = parent.listChildren;
  }

  updateStatusChildrenManager() {
    isShowChildrenManager = !isShowChildrenManager;
    this.updateState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
