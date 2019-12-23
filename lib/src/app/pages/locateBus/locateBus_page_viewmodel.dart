import 'dart:async';

import 'package:b2s_parent/src/app/core/app_setting.dart';
import 'package:b2s_parent/src/app/core/baseViewModel.dart';
import 'package:b2s_parent/src/app/models/chat.dart';
import 'package:b2s_parent/src/app/models/childrenBusSession.dart';
import 'package:b2s_parent/src/app/models/picking-transport-info.dart';
import 'package:b2s_parent/src/app/pages/message/messageDetail/message_detail_page.dart';
import 'package:b2s_parent/src/app/service/index.dart';
import 'package:b2s_parent/src/app/theme/theme_primary.dart';
import 'package:b2s_parent/src/app/widgets/icon_marker_custom.dart';
import 'package:b2s_parent/src/app/widgets/popupConfirm.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LocateBusPageViewModel extends ViewModelBase {
  bool showGoolgeMap = true;
  bool showSpinner = false;
  bool myLocationEnabled = false;
  //Completer<GoogleMapController> _mapController = Completer();
  GoogleMapController mapController;
  LatLng center = const LatLng(10.777338, 106.677491);

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  final MarkerId markerBus = MarkerId("MarkerBus");
  final MarkerId markerSchool = MarkerId("MarkerSchool");
  final MarkerId markerChild = MarkerId("NarkerChild");
  //VStar school
  final LatLng pinTo = LatLng(10.743524, 106.699328);
  //TS24corp
  final LatLng pinFrom = LatLng(10.777433, 106.677502);

  Map<PolylineId, Polyline> polyline = <PolylineId, Polyline>{};
  PolylineId selectedPolyline = PolylineId("Polyline01");
  List<LatLng> polylinePoint = [];
  Location location = Location();

  ChildrenBusSession childrenBus;

  Firestore firestore = Firestore.instance;
  Geoflutterfire geo = Geoflutterfire();
  DocumentReference docRef;
  StreamSubscription streamCloud;
  Timer timer;
  LocateBusPageViewModel() {
//    childrenBus = ChildrenBusSession.list.singleWhere((item) =>
//        item.child.id == Children.getChildrenPrimary(Children.list).id);
  }

  @override
  dispose() {
    if (streamCloud != null) streamCloud.cancel();
    if (timer != null) timer.cancel();
    super.dispose();
  }

  void onMapCreated(GoogleMapController controller) async {
    // _mapController.complete(controller);
    mapController = controller;
    //Get style map
    String _pathStyleMap =
        await Common.getJsonFile("assets/json/styleMap_uber.json");
    mapController.setMapStyle(_pathStyleMap);

    this.updateState();
    animateMyLocation(animate: false);
    initMarkers();
  }

  void animateMyLocation({bool animate = true}) async {
    var myLoc = await location.getLocation();
    if (animate) {
      center = LatLng(myLoc.latitude, myLoc.longitude);
      _animateCamera(LatLng(myLoc.latitude, myLoc.longitude));
    }
    myLocationEnabled = true;
//    childrenBus.status = StatusBus.list[0];
    // this.updateState();
  }

  Future initMarkers() async {
    markers.clear();
    final iconBus = await GoogleMapService.getMarkerIcon(
        'assets/images/icon_bus02.png',
        width: 60);
    final iconSchool = await iconMarkerCustom(
        icon: Icons.school, backgroundColor: ThemePrimary.primaryColor);
    final iconChild = await iconMarkerCustom(
        icon: Icons.home, backgroundColor: ThemePrimary.colorDriverApp);
    for (var item in childrenBus.listRouteBus) {
      if (item.isSchool)
        markers[markerSchool] = Marker(
            markerId: markerSchool,
            position: LatLng(item.lat, item.lng),
            icon: iconSchool,
            infoWindow: InfoWindow(title: item.routeName));
      else
        markers[markerChild] = Marker(
            markerId: markerChild,
            position: LatLng(item.lat, item.lng),
            icon: iconChild,
            infoWindow: InfoWindow(title: item.routeName));
    }
    //tạo marker bus
    api.getCoordinateVehicleById(childrenBus.vehicleId).then((data) {
      markers[markerBus] = Marker(
          markerId: markerBus,
          position: LatLng(data.xPosx, data.xPosy),
          icon: iconBus,
          rotation: data.xPosz,
          infoWindow: InfoWindow(title: childrenBus.vehicleName.toString()));
      this.updateState();
      _animateCamera(LatLng(data.xPosx, data.xPosy));
      //tracking bus di chuyển
      _trackingCoordBus();
    });
//    Create marker bus
//    markers[markerBus] = Marker(
//      markerId: markerBus,
//      position: await location.getLocation(),
//      icon: iconBus,
//    );
//
//    //Create marker school
//    markers[markerSchool] = Marker(
//      markerId: markerSchool,
//      position: pinTo,
//      icon: iconSchool,
//      infoWindow: InfoWindow(title: "VStar School"),
//    );
//
//    //Create marker child
//    markers[markerChild] = Marker(
//      markerId: markerChild,
//      position: pinFrom,
//      icon: iconChild,
//    );

    this.updateState();
    //Draw polyline
    // var step = await GoogleMapService.directionGetListStep(
    //     LatLng(10.777433, 106.677502), LatLng(10.743524, 106.699328));
    // routes.addAll(step);

    // polyline.clear();
//    polyline[selectedPolyline] = Polyline(
//      polylineId: selectedPolyline,
//      visible: true,
//      color: Colors.blue.withOpacity(0.5),
//      width: 5,
//      zIndex: 2,
//      points: routes,
//    );
    // var index = 0;
    // this.updateState();

    // Timer.periodic(new Duration(seconds: 2), (timer) {
    //   index++;
    //   if (index == routes.length)
    //     timer.cancel();
    //   else {
    //     final Marker _marker = markers[markerBus];
    //     markers[markerBus] = _marker.copyWith(positionParam: routes[index]);
    //     //if (index >= 1) polyline[selectedPolyline].points.add(routes[index]);
    //     //Chuyển status children
    //     if (index == 36) {
    //       childrenBus.status = StatusBus.list[1];
    //       childrenBus.notification = "Xe đang di chuyển,tốc độ 40km/h";
    //       cloudSerivce.updateChildrenBusSession(childrenBus);
    //     }
    //     if (index == routes.length - 1) {
    //       childrenBus.status = StatusBus.list[2];
    //       childrenBus.notification = "Xe đã tới trường.";
    //       cloudSerivce.updateChildrenBusSession(childrenBus);
    //     }
    //     this.updateState();
    //   }
    // });
  }

  listenData() async {
    if (streamCloud != null) streamCloud.cancel();
    streamCloud = await cloudService.busSession
        .listenBusSessionForChildren([childrenBus], () {
      this.updateState();
    });
  }

  Future<DocumentReference> addGeoPoint() async {
    GeoFirePoint point =
        geo.point(latitude: center.latitude, longitude: center.longitude);
    return firestore
        .collection('locations')
        .add({'position': point.data, 'session_driver_id': 'S0001'});
  }

  final List<LatLng> routes = [
    LatLng(10.7851902757137, 106.68906357139349),
    LatLng(10.784724239877542, 106.68867129832506),
    LatLng(10.78433955392249, 106.68834440410137),
    LatLng(10.784017774282574, 106.68809898197651),
    LatLng(10.783455894167915, 106.68752700090408),
    LatLng(10.78270101020468, 106.68680749833584),
    LatLng(10.781994539858356, 106.68603904545307),
    LatLng(10.781239652228427, 106.68531987816095),
    LatLng(10.780914575689206, 106.68506607413292),
    LatLng(10.780725853281915, 106.68485350906849),
    LatLng(10.780481139757285, 106.68467380106449),
    LatLng(10.780280230792883, 106.68445721268654),
    LatLng(10.780043092170487, 106.68427750468254),
    LatLng(10.779841524194518, 106.6840347647667),
    LatLng(10.779640614803082, 106.68376889079809),
    LatLng(10.779383714074353, 106.68351978063583),
    LatLng(10.779018124197686, 106.6831724345684),
    LatLng(10.778793500287424, 106.68298032134771),
    LatLng(10.778793500287424, 106.68298032134771),
    LatLng(10.77852441247921, 106.6827268525958),
    LatLng(10.77852441247921, 106.6827268525958),
    LatLng(10.778347874937001, 106.68253473937511),
    LatLng(10.778171007929872, 106.68234262615442),
    LatLng(10.778374223830479, 106.67896840721369),
    LatLng(10.778257959320666, 106.67886212468147),
    LatLng(10.778125226695073, 106.67869046330452),
    LatLng(10.77796087529841, 106.67853523045778),
    LatLng(10.777880511055743, 106.67835552245378),
    LatLng(10.777715830163576, 106.67819995433092),
    LatLng(10.777514919353116, 106.6781184822321),
    LatLng(10.777290294321, 106.67817547917366),
    LatLng(10.777174029392498, 106.67803265154362),
    LatLng(10.777033062223484, 106.67788948863745),
    LatLng(10.776900658420502, 106.67775873094797),
    LatLng(10.77685652380657, 106.67768497020006),
    LatLng(10.776936888322625, 106.67757902294397),
  ];

  Future getFireCollection() async {
    if (docRef == null)
      docRef = await addGeoPoint();
    else {
      var querysnapshot = await firestore
          .collection('locations')
          .where("session_driver_id", isEqualTo: 'S0001')
          .getDocuments();
      querysnapshot.documents.forEach((doc) {
        GeoPoint pos = doc.data['position']['geopoint'];
        print(pos.latitude);
      });
      // GeoFirePoint point =
      //     geo.point(latitude: 10.322223, longitude: 10.3321321);
      // docRef.updateData({'position': point.data});
      // docRef.snapshots().listen((onData) {
      //   GeoPoint pos = onData.data['position']['geopoint'];
      //   print(pos.latitude);
      // });
    }
  }

  createMarker() {
//    for(var item in childrenBus.listRouteBus){
//      markers[markerChild] = Marker(
//        markerId: markerChild,
//        position: LatLng(item.lat,item.lng),
//        icon: iconChild;
//      );
//    }
  }
  onTapLeave() {
    popupConfirm(
      context: context,
      title: 'THÔNG BÁO',
      desc: 'Xác nhận thay đổi trạng thái ?',
      yes: 'Có',
      no: 'Không',
      onTap: () {
        childrenBus.status = StatusBus.list[3];
        updateChildren(childrenBus);
//    loadData();
        this.updateState();
        Navigator.pop(context);
        print('onTap leave');
      },
    );
  }

  onTapChatDriver() {
    Chatting chatting = Chatting(
        peerId: childrenBus.driver.id.toString(),
        name: childrenBus.driver.name,
        message: 'Hi',
        listMessage: new List(),
        avatarUrl: childrenBus.driver.phone,
        datetime: DateTime.now().toIso8601String());
    Navigator.pushNamed(
      context,
      MessageDetailPage.routeName,
      arguments: chatting,
    );
  }

  onTapChatAttendant() {
    Chatting chatting = Chatting(
        peerId: childrenBus.attendant.id.toString(),
        name: childrenBus.attendant.name.toString(),
        message: 'Hi',
        listMessage: new List(),
        avatarUrl: childrenBus.attendant.photo,
        datetime: DateTime.now().toIso8601String());
    Navigator.pushNamed(
      context,
      MessageDetailPage.routeName,
      arguments: chatting,
    );
  }

  updateChildren(ChildrenBusSession session) async {
    var picking = PickingTransportInfo.fromChildrenBusSession(session);
    await api.updatePickingTransportInfo(picking);
  }

  _animateCamera(LatLng latlng) {
    if (mapController != null)
      mapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: latlng, zoom: 14.0)));
  }

  _trackingCoordBus() {
    if (timer != null) timer.cancel();
    timer = Timer.periodic(new Duration(seconds: 3), (timer) {
      if (childrenBus.status.statusID == 2 || childrenBus.status.statusID == 4)
        timer.cancel();
      api.getCoordinateVehicleById(childrenBus.vehicleId).then((data) {
        final _marker = markers[markerBus];
        markers[markerBus] = _marker.copyWith(
            rotationParam: data.xPosz,
            positionParam: LatLng(data.xPosx, data.xPosy));
        this.updateState();
        _animateCamera(LatLng(data.xPosx, data.xPosy));
      });
    });
  }
}
