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
  ScrollController controller;
  int take = 10;
  int skip = 0;
  bool loadingMore = true;
  HistoryPageViewModel() {
    controller = ScrollController();
    controller.addListener(() {
      if (controller.offset == controller.position.maxScrollExtent)
        onLoadMore();
    });
    onLoad();
  }
  onLoad() {
    loading = true;
    take = 10;
    skip = 0;
    api.getHistoryTrip(take: take, skip: skip).then((data) {
      if (data.length > 0) {
        listHistoryTrip = List();
        data.forEach((item) {
          listHistoryTrip.add(item);
        });
        loading = false;
        skip += take;
        take += 10;
        this.updateState();
      } else {
        loading = false;
        this.updateState();
      }
    });
  }

  onLoadMore() {
    loadingMore = true;
    api.getHistoryTrip(take: take, skip: skip).then((data) {
      if (data.length > 0) {
        data.forEach((item) {
          listHistoryTrip.add(item);
        });
        loadingMore = false;
        skip += take;
        take += 10;
        this.updateState();
      } else {
        loadingMore = false;
        this.updateState();
      }
    });
  }

  onTapHistoryDetail(HistoryInfo historyInfo) {
    if (historyInfo.status.statusID != 3)
      Navigator.pushNamed(context, HistoryDetailPage.routeName,
          arguments: historyInfo);
  }

  Children getChildrenFromParent(int childrenId) {
    return Parent()
        .listChildren
        .firstWhere((children) => children.id == childrenId);
  }
}
