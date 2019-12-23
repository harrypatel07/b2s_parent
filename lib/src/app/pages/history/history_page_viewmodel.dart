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
  bool loadingMore = false;
  bool loadMoreDone = false;
  HistoryPageViewModel() {
    controller = ScrollController();
    controller.addListener(() {
      if (controller.offset >= controller.position.maxScrollExtent &&
          !controller.position.outOfRange) onLoadMore();
    });
    onLoad();
  }
  onLoad() {
    loading = true;
    loadMoreDone = false;
    this.updateState();
    listHistoryTrip = List();
    skip = 0;
    api.getHistoryTrip(take: take, skip: skip).then((data) {
      if (data.length > 0) {
        listHistoryTrip = data;
//        data.forEach((item) {
//          listHistoryTrip.add(item);
//          skip += item.trip.length;
//        });
        skip = take;
        loading = false;
        this.updateState();
      } else {
        loading = false;
        this.updateState();
      }
    });
  }

  onLoadMore() {
    if(loadMoreDone)
      return;
    loadingMore = true;
    this.updateState();
    int countItemLoadMore = 0;
    api.getHistoryTrip(take: take, skip: skip ).then((data) {
      if (data.length > 0) {
        data.forEach((item) {
          countItemLoadMore += item.trip.length;
        });
        if(countItemLoadMore < take)
          loadMoreDone = true;
        listHistoryTrip.addAll(data);
        skip += take;
        loadingMore = false;
        this.updateState();
      } else {
        loadMoreDone = true;
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
