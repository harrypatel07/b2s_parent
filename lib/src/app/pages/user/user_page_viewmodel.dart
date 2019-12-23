import 'package:b2s_parent/src/app/app_localizations.dart';
import 'package:b2s_parent/src/app/core/app_setting.dart';
import 'package:b2s_parent/src/app/core/baseViewModel.dart';
import 'package:b2s_parent/src/app/models/children.dart';
import 'package:b2s_parent/src/app/models/parent.dart';
import 'package:b2s_parent/src/app/models/ticketCode.dart';
import 'package:b2s_parent/src/app/pages/login/login_page.dart';
import 'package:b2s_parent/src/app/pages/payment/payment_page.dart';
import 'package:b2s_parent/src/app/pages/user/edit_profile_children/edit_profile_children.dart';
import 'package:b2s_parent/src/app/service/barcode-service.dart';
import 'package:b2s_parent/src/app/widgets/popupConfirm.dart';
import 'package:b2s_parent/src/app/widgets/ts24_utils_widget.dart';
import 'package:flutter/cupertino.dart';

import 'edit_profile_parent/edit_profile_parent.dart';

class UserPageViewModel extends ViewModelBase {
  bool check = true;
  bool isShowChildrenManager;
  Parent parent;
  List<Children> listChildren;
  bool loadingListChildren = false;

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
  onTapParent() async {
    await Navigator.pushNamed(context, EditProfileParent.routeName,
            arguments: parent)
        .then((_) {
      this.updateState();
    });
  }

  onTapChildren(Children children) async {
    await Navigator.pushNamed(context, EditProfileChildren.routeName,
            arguments:
                ProfileChildrenArgs(parent: parent, childId: children.id))
        .then((r) {
      if (r != null) {
        listChildren = r;
        this.updateState();
      }
    });
  }

  onTapCreateChildren() async {
//    await Navigator.pushNamed(context, EditProfileChildren.routeName,arguments: ProfileChildrenArgs(parent:parent)).then((r){
//      if(r!=null){
//        listChildren = r;
//        this.updateState();
//      }
//    });
    String qrResult = await BarCodeService.scan();
    if (qrResult != null) {
      TicketCode ticketCode = TicketCode();
      bool checkCode = ticketCode.checkTicketCode(qrResult);
      if (checkCode) {
        //
        loadingListChildren = true;
        this.updateState();
        var result = await api.checkChildrenHasParent(
            int.parse(ticketCode.childrenId.toString()));
        //
        loadingListChildren = false;
        this.updateState();
        if (result)
          return LoadingDialog.showMsgDialog(
              context, translation.text("USER_PAGE.NOTICE_REGISTERED"));
        else {
          parent = Parent();
          listChildren = parent.listChildren;
          this.updateState();
        }
      } else {
        return LoadingDialog.showMsgDialog(
            context, translation.text("TICKET_PAGE.CODE_INVALID"));
      }
    }
    // api.checkTagsExistByName("Trường Lê Hồng Phong");
  }

  updateStatusChildrenManager() {
    isShowChildrenManager = !isShowChildrenManager;
    this.updateState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  onTapPayment() {
    Navigator.pushNamed(context, PaymentPage.routeName);
  }

  onTapLogout() {
    popupConfirm(
        context: context,
        title: translation.text("POPUP_CONFIRM.TITLE"),
        desc: translation.text("POPUP_CONFIRM.DESC_LOG_OUT"),
        yes: translation.text("POPUP_CONFIRM.YES"),
        no: translation.text("POPUP_CONFIRM.NO"),
        onTap: () {
          Navigator.pop(context);
          parent.clearLocal();
          Navigator.pushReplacementNamed(context, LoginPage.routeName);
        });
  }
}
