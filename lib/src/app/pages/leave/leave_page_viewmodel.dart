import 'package:b2s_parent/src/app/core/baseViewModel.dart';
import 'package:b2s_parent/src/app/helper/constant.dart';
import 'package:b2s_parent/src/app/helper/dateUtils.dart';
import 'package:b2s_parent/src/app/models/children.dart';
import 'package:b2s_parent/src/app/models/childrenBusSession.dart';
import 'package:b2s_parent/src/app/models/month_module.dart';

class LeavePageViewModel extends ViewModelBase {
  List<DateTime> listDate;
  List<MonthModule> listDateShowPresent;
  List<MonthModule> listDateShowNext;
  DateTime dateDefault;
  DateTime dayOfNextMonth;
  int pagePosition;
  String pageViewTitle ;
  Children childPrimary;
  LeavePageViewModel(){
    listDate = [new DateTime.utc(2019,9,1), new DateTime.utc(2019,10,4), new DateTime.utc(2019,10,5)];
    listDateShowPresent = new List();
    listDateShowNext = new List();
    dateDefault = new DateTime.now();
    dayOfNextMonth = new DateTime(new DateTime.now().year,new DateTime.now().month + 1, new DateTime.now().day);
    pagePosition = 0;
    pageViewTitle = getPageViewTitle(new DateTime.now().month,new DateTime.now().year);
    childPrimary = Children.getChildrenPrimary(Children.list);
  }
  onSend() {
    // send listDate
    saveChildrenStatus();
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
