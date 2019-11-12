import 'package:b2s_parent/src/app/core/app_setting.dart';
import 'package:b2s_parent/src/app/core/baseViewModel.dart';
import 'package:b2s_parent/src/app/helper/constant.dart';
import 'package:b2s_parent/src/app/widgets/dateUtils.dart';
import 'package:b2s_parent/src/app/models/children.dart';
import 'package:b2s_parent/src/app/models/childrenBusSession.dart';
import 'package:b2s_parent/src/app/models/month_module.dart';
import 'package:intl/intl.dart';

class LeavePageViewModel extends ViewModelBase {
  List<DateTime> listDate;
  List<MonthModule> listDateShowPresent;
  List<MonthModule> listDateShowNext;
  DateTime dateDefault;
  DateTime dayOfNextMonth;
  int pagePosition;
  String pageViewTitle ;
  Children childPrimary;
  List<Children> listChildren;
  LeavePageViewModel(){
    listChildren = new List();
    listDate = new List() ;
    listDateShowPresent = new List();
    listDateShowNext = new List();
    dateDefault = new DateTime.now();
    dayOfNextMonth = new DateTime(new DateTime.now().year,new DateTime.now().month + 1, new DateTime.now().day);
    pagePosition = 0;
    pageViewTitle = getPageViewTitle(new DateTime.now().month,new DateTime.now().year);
  }
  onChangeChildren(int childrenId){
    listChildren.forEach((child){
      if(child.id == childrenId) {
        childPrimary = child;
        onLoad(childrenId);
        this.updateState();
      }
    });
  }
  onLoad(int childrenId){
    listDate = List();
    api.getListLeaveByIdChildren(childrenId).then((listStrDate){
      listStrDate.forEach((strDate){
        DateTime date = DateTime.parse(strDate);
        if(date.isAfter(DateTime.now()))
          listDate.add(date);
      });
      this.updateState();
    });
  }
  onSend() {
    listDate.sort((a,b)=>a.compareTo(b));
    List<String> listStringDate = listDate.map((date)=>DateFormat('yyyy-MM-dd').format(date).toString()).toList();
    api.updateLeaveByIdChildren(childPrimary.id, listStringDate);
    // send listDate
//    saveChildrenStatus();
    this.updateState();
  }
  void updateSelected(DateTime day){
    if(listDate.contains(day))
      listDate.remove(day);
    else
      listDate.add(day);
    this.updateState();
  }
  void onPageViewChange(int page){
    print("Page position :"+ page.toString());
    pagePosition = page;
    if(page == 0)
      pageViewTitle = getPageViewTitle(dateDefault.month,dateDefault.year);
    else  pageViewTitle = getPageViewTitle(dayOfNextMonth.month,dayOfNextMonth.year);
    this.updateState();
  }
  void saveChildrenStatus(){
    if(containsDayInList(listDate, DateTime.now())){
      updateChildPrimaryStatus(ChildrenBusSession.list,StatusBus.list[3],TYPE_ALL);
      print("update child primary status today");
    }
  }
  void updateChildPrimaryStatus(List<ChildrenBusSession> list,StatusBus status,int type){
      switch(type){
        case TYPE_ALL:
          list.forEach((s)=>{
            s.status = status,
          });
          break;
        case TYPE_DEPART:
          list[0].status = status;
          break;
        case TYPE_ARRIVE:
          list[1].status = status;
          break;
      }
  }
}
