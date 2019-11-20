import 'package:b2s_parent/src/app/core/baseViewModel.dart';
import 'package:b2s_parent/src/app/models/children.dart';
import 'package:b2s_parent/src/app/models/childrenBusSession.dart';

class ProfileChildrenViewModel extends ViewModelBase {
  ChildrenBusSession childrenBusSession;
  Children children;
  List<RouteBus> listRouteBus = List();
  String startDepart;
  String endDepart;
  String startArrive;
  String endArrive;
  ProfileChildrenViewModel() {}
  ///age children
  onCreateAge(){
    if(children.birthday != null)
      children.age = DateTime.now().year - DateTime.parse(children.birthday.toString()).year;
  }
  ///Tạo thời gian đón, đến trường, về ,đến nhà
  onCreateTime() {
    if (listRouteBus.length <= 0) return;
    List<RouteBus> listDepart =
        listRouteBus.where((routeBus) => routeBus.type == 0).toList();
    if (listDepart.length > 0) {
      startDepart =
          listDepart[0].time.substring(0, listDepart[0].time.length - 3);
      endDepart = listDepart[listDepart.length - 1]
          .time
          .substring(0, listDepart[listDepart.length - 1].time.length - 3);
    }
    List<RouteBus> listArrive =
        listRouteBus.where((routeBus) => routeBus.type == 1).toList();
    if (listArrive.length > 0) {
      startArrive =
          listArrive[0].time.substring(0, listArrive[0].time.length - 3);
      endArrive = listArrive[listArrive.length - 1]
          .time
          .substring(0, listArrive[listArrive.length - 1].time.length - 3);
    }
  }
}
