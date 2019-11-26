import 'package:b2s_parent/src/app/core/app_setting.dart';
import 'package:b2s_parent/src/app/core/baseViewModel.dart';
import 'package:b2s_parent/src/app/models/children.dart';
import 'package:b2s_parent/src/app/models/historyTrip.dart';
import 'package:b2s_parent/src/app/models/parent.dart';
import 'package:b2s_parent/src/app/pages/history/history_page.dart';
import 'package:b2s_parent/src/app/pages/historyDetail/history_detail_page.dart';
import 'package:flutter/cupertino.dart';

class HistoryPageViewModel extends ViewModelBase {
  List<HistoryTrip> listHistoryTrip = List();
  int take = 20;
  int skip = 0;
  HistoryPageViewModel() {
    onLoad();
  }
  onLoad() {
    loading = true;
    api.getHistoryTrip(take: take, skip: skip).then((data) {
      if (data.length > 0) {
        data.forEach((item) {
          listHistoryTrip.insert(0, item);
        });
        loading = false;
        this.updateState();
        skip += take;
      }
    });
  }
  onTapHistoryDetail(HistoryInfo historyInfo){
    Navigator.pushNamed(context, HistoryDetailPage.routeName,arguments: historyInfo);
  }
  Children getChildrenFromParent(int childrenId){
    return Parent().listChildren.firstWhere((children)=>children.id == childrenId);
  }
}
