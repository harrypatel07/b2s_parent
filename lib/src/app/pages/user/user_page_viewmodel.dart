import 'package:b2s_parent/src/app/core/app_setting.dart';
import 'package:b2s_parent/src/app/core/baseViewModel.dart';
import 'package:b2s_parent/src/app/models/children.dart';
import 'package:b2s_parent/src/app/models/parent.dart';
import 'package:b2s_parent/src/app/models/res-partner.dart';
import 'package:b2s_parent/src/app/models/sale-order-line.dart';
import 'package:b2s_parent/src/app/models/sale-order.dart';
import 'package:b2s_parent/src/app/pages/user/edit_profile_children/edit_profile_children.dart';
import 'package:flutter/cupertino.dart';

import 'edit_profile_parent/edit_profile_parent.dart';

class UserPageViewModel extends ViewModelBase {
  bool check = true;
  bool isShowChildrenManager;
  Parent parent;
  List<Children> listChildren;

  UserPageViewModel() {
    isShowChildrenManager = false;
    parent = new Parent();
    listChildren = parent.listChildren;

    //demo update insert children
    // api.getTitleCustomer().then((value) {
    //   print(value);
    //   listChildren[0].name = "Học sinh nữ";
    //   listChildren[0].gender = value[0].displayName;
    //   listChildren[0].genderId = value[0].id;
    //   ResPartner child = ResPartner.fromChildren(listChildren[0]);
    //   api.updateCustomer(child).then((result) {
    //     if (result) parent.saveLocal();
    //   });
    //   // Children newChild = Children();
    //   // newChild.name = "Học sinh nam";
    //   // newChild.parentId = parent.id;
    //   // newChild.age = 12;
    //   // listChildren.add(newChild);
    //   // api.insertCustomer(ResPartner.fromChildren(newChild)).then((result) {
    //   //   if (result) parent.saveLocal();
    //   // });
    // });
  }
  onTapParent() async{
    await Navigator.pushNamed(context, EditProfileParent.routeName,arguments: parent).then((_){
      this.updateState();
    });
  }
  onTapChildren(Children children) async{
    await Navigator.pushNamed(context, EditProfileChildren.routeName,arguments: ProfileChildrenArgs(parent:parent,childId: children.id)).then((r){
      if(r!=null) {
        listChildren = r;
        this.updateState();
      }
    });
  }
  onTapCreateChildren()async{
    await Navigator.pushNamed(context, EditProfileChildren.routeName,arguments: ProfileChildrenArgs(parent:parent)).then((r){
      if(r!=null){
        listChildren = r;
        this.updateState();
      }
    });
  }
  updateStatusChildrenManager() {
    isShowChildrenManager = !isShowChildrenManager;
    this.updateState();
  }
  @override
  void dispose() {
    super.dispose();
  }
}
