import 'package:b2s_parent/src/app/core/baseViewModel.dart';
import 'package:b2s_parent/src/app/helper/constant.dart';
import 'package:b2s_parent/src/app/helper/dateUtils.dart';
import 'package:b2s_parent/src/app/models/month_module.dart';

class LeavePageViewModel extends ViewModelBase {
  List<DateTime> listDate;
  List<MonthModule> listDateShowPresent;
  List<MonthModule> listDateShowNext;
  DateTime dateDefault;
  DateTime dayOfNextMonth;
  int pagePosition;
  String pageViewTitle ;
  onCreate(){
    listDate = [new DateTime.utc(2019,9,1), new DateTime.utc(2019,10,4), new DateTime.utc(2019,10,6)];
    listDateShowPresent = new List();
    listDateShowNext = new List();
    dateDefault = new DateTime.now();
    dayOfNextMonth = new DateTime(new DateTime.now().year,new DateTime.now().month + 1, new DateTime.now().day);
    pagePosition = 0;
    pageViewTitle = getPageViewTitle(new DateTime.now().month,new DateTime.now().year);
  }
  onSend() {
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
}
