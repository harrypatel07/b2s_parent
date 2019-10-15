import 'package:b2s_parent/src/app/core/baseViewModel.dart';

class UserSettingsViewModel extends ViewModelBase {
  bool selectedAll;
  bool pickUpNotification;
  bool dropNotification;
  bool reachedAtSchool;
  bool leftFromSchool;
  UserSettingsViewModel(){
    selectedAll = false;
    pickUpNotification = true;
    dropNotification = false;
    reachedAtSchool = false;
    leftFromSchool = false;
  }
  onChangedPickUpNotification(){
    pickUpNotification = ! pickUpNotification;
    this.updateState();
  }
  onChangeDropNotification(){
    dropNotification =! dropNotification;
    this.updateState();
  }
  onChangeReachedAtSchool(){
    reachedAtSchool =! reachedAtSchool;
    this.updateState();
  }
  onChangeLeftFromSchool(){
    leftFromSchool =! leftFromSchool;
    this.updateState();
  }
  onChangedAll(){
    selectedAll =! selectedAll;
    pickUpNotification = selectedAll;
    dropNotification = selectedAll;
    reachedAtSchool = selectedAll;
    leftFromSchool = selectedAll;
    this.updateState();
    print("select all");
  }
}