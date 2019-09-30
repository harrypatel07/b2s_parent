import 'package:b2s_parent/src/app/core/baseViewModel.dart';

class LeavePageViewModel extends ViewModelBase {
  List<DateTime> listDate = [];
  onSend() {
    this.updateState();
  }
}
