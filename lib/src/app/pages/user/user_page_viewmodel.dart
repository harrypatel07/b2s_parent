import 'package:b2s_parent/src/app/app_localizations.dart';
import 'package:b2s_parent/src/app/core/app_setting.dart';
import 'package:b2s_parent/src/app/core/baseViewModel.dart';
import 'package:b2s_parent/src/app/models/children.dart';
import 'package:b2s_parent/src/app/models/itemCustomPopupMenu.dart';
import 'package:b2s_parent/src/app/models/parent.dart';
import 'package:b2s_parent/src/app/models/res-partner.dart';
import 'package:b2s_parent/src/app/models/ticketCode.dart';
import 'package:b2s_parent/src/app/pages/login/login_page.dart';
import 'package:b2s_parent/src/app/pages/payment/payment_page.dart';
import 'package:b2s_parent/src/app/pages/user/edit_profile_children/edit_profile_children.dart';
import 'package:b2s_parent/src/app/service/barcode-service.dart';
import 'package:b2s_parent/src/app/service/onesingal-service.dart';
import 'package:b2s_parent/src/app/widgets/popupConfirm.dart';
import 'package:b2s_parent/src/app/widgets/restart_widget.dart';
import 'package:b2s_parent/src/app/widgets/ts24_utils_widget.dart';
import 'package:flutter/cupertino.dart';

import 'edit_profile_parent/edit_profile_parent.dart';

class UserPageViewModel extends ViewModelBase {
  bool check = true;
  bool isShowChildrenManager;
  Parent parent;
  List<Children> listChildren;
  bool loadingListChildren = false;
  CustomPopupMenu selectedLanguage;
  List<CustomPopupMenu> listLanguages;

  UserPageViewModel() {
    isShowChildrenManager = false;
    parent = new Parent();
    listChildren = parent.listChildren;
    listLanguages = [
      CustomPopupMenu(id: 0, title: "Tiếng Việt", subTitle: "vi"),
      CustomPopupMenu(id: 1, title: "English", subTitle: "en")
    ];
    selectedLanguage = (translation.currentLanguage == 'vi')
        ? listLanguages[0]
        : listLanguages[1];

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

  onTapRemoveChildren(Children children) {
    popupConfirm(
        context: context,
        title: translation.text("POPUP_CONFIRM.TITLE"),
        desc: translation.text("POPUP_CONFIRM.DESC_DELETE_CHILD"),
        yes: translation.text("POPUP_CONFIRM.YES"),
        no: translation.text("POPUP_CONFIRM.NO"),
        onTap: () async {
          Navigator.pop(context);
          parent.listChildren.remove(children);
          listChildren.remove(children);
          children.parentId = 0;
          ResPartner resPartner = ResPartner.fromChildren(children);
          bool result = await api.updateCustomer(resPartner);
          if (result) {
            await api.getParentInfo(parent.id);
//      api.getTicketOfListChildren();
            // children.gender = gender.displayName;
            // children.schoolName = school.displayName;
//      return true;
          }
//    return false;
          this.updateState();
        });
  }

  onChangeLanguage(String language) async {
    await translation.setNewLanguage(language, true);
    OneSignalService.sendTags(parent.toJsonOneSignal(language: language));
    RestartWidget.restartApp(context);
  }
}
