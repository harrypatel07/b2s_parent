import 'dart:async';

import 'package:b2s_parent/src/app/core/baseViewModel.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocateBusPageViewModel extends ViewModelBase {
  bool showGoolgeMap = false;
  bool showSpinner = true;
  Completer<GoogleMapController> mapController = Completer();

  final LatLng center = const LatLng(10.777317, 106.677513);
  final Set<Marker> marker = <Marker>{};

  void onMapCreated(GoogleMapController controller) {
    mapController.complete(controller);
    Future.delayed(const Duration(milliseconds: 1000), () {
      showSpinner = false;
      this.updateState();
    });
  }
}
