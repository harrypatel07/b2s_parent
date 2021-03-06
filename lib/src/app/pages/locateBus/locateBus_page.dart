import 'package:b2s_parent/src/app/core/baseViewModel.dart';
import 'package:b2s_parent/src/app/models/childrenBusSession.dart';
import 'package:b2s_parent/src/app/pages/locateBus/locateBus_page_viewmodel.dart';
import 'package:b2s_parent/src/app/widgets/bus_attentdance_card.dart';
import 'package:b2s_parent/src/app/widgets/index.dart';
import 'package:b2s_parent/src/app/widgets/ts24_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class LocateBusPage extends StatefulWidget {
  static const String routeName = "/locateBus";
  final LocateBusArgument args;

  const LocateBusPage(this.args);
  @override
  _LocateBusPageState createState() => _LocateBusPageState();
}

class LocateBusArgument {
  final ChildrenBusSession data;

  LocateBusArgument(this.data);
}

class _LocateBusPageState extends State<LocateBusPage> {
  LocateBusPageViewModel viewModel = LocateBusPageViewModel();

  final double _initFabHeight = 145.0;
  double _fabHeight;
  double _panelHeightOpen = 0;
  double _panelHeightClosed = 145.0;

  ScrollController _sc = ScrollController();
  PanelController _pc = PanelController();
  bool disableScroll = true;
  GlobalKey _key = GlobalKey();
  Size _size = Size(0, 0);

  @override
  void dispose() {
    _sc.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _fabHeight = _initFabHeight;
    _sc.addListener(() {
      // if (_pc.isPanelOpen()) {
      //   setState(() {
      //     disableScroll = _sc.offset <= 0;
      //   });
      // }
    });

    viewModel.context = context;
    viewModel.childrenBus = widget.args.data;
    viewModel.listenData();
    // viewModel.listenData(widget.args.data.sessionID);
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {
          _getSize();
        }));
  }

  _getSize() {
    final RenderBox renderBox = _key.currentContext.findRenderObject();
    _size = renderBox.size;
  }

  Widget _buildBody() {
    Widget __buildGoogleMap() {
      return GoogleMap(
        onMapCreated: viewModel.onMapCreated,
        myLocationEnabled: viewModel.myLocationEnabled ? true : false,
        myLocationButtonEnabled: false,
        compassEnabled: true,
        markers: Set<Marker>.of(viewModel.markers.values),
        polylines: Set<Polyline>.of(viewModel.polyline.values),
        onTap: (lat) {
          var coord = lat;
          print('${coord.latitude}, ${coord.longitude}');
        },
        initialCameraPosition: CameraPosition(
          target: viewModel.center,
          zoom: 3.0,
        ),
      );
    }

    return Stack(
      children: <Widget>[
        viewModel.showGoolgeMap ? __buildGoogleMap() : Container(),
        viewModel.showSpinner
            ? LoadingIndicator.progress(
                context: context, loading: true, position: Alignment.topCenter)
            : Container()
      ],
    );
  }

  Widget _buildPanel() {
    Widget __childrenCard() {
      return Stack(
        children: <Widget>[
          BusAttentdanceCard(
            key: _key,
            tagHero: (viewModel.childrenBus.type != null)
                ? viewModel.childrenBus.type.toString()
                : '' + viewModel.childrenBus.child.id.toString(),
            colorLeft: Colors.grey,
            colorRight: Colors.grey,
            isExten: true,
            onTapLeave: () {
              viewModel.onTapLeave();
            },
            onTapChatDriver: () {
              viewModel.onTapChatDriver();
            },
            onTapChatAttendant: () {
              viewModel.onTapChatAttendant();
            },
            childrenBusSession: viewModel.childrenBus,
          ),
          Positioned(
            left: MediaQuery.of(context).size.width / 2 - 15,
            top: 5,
            child: GestureDetector(
              // onTap: () {
              //   _pc.close();
              // },
              // onLongPress: () {
              //   _pc.close();
              // },
              onVerticalDragDown: (drag) {
                _pc.close();
              },
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  width: 30,
                  height: 5,
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.all(Radius.circular(12.0))),
                ),
              ),
            ),
          ),
        ],
      );
    }

//    Widget __timeLine() {
//      var listTimeLine = viewModel.childrenBus.listRouteBus
//          .map((item) => EventTime(item.time, item.routeName, "", item.status))
//          .toList();
//      return TS24TimeLine(
//          listTimeLine: listTimeLine,
//          height: MediaQuery.of(context).size.height);
//    }

    return SingleChildScrollView(
        controller: _sc,
        physics: disableScroll
            ? NeverScrollableScrollPhysics()
            : ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            __childrenCard(),
            //  __timeLine()
          ],
        ));
  }

  Widget _backButton() {
    return Positioned(
      top: 0,
      left: 0,
      child: SafeArea(
        top: true,
        bottom: false,
        child: TS24Button(
          onTap: () {
            Navigator.of(context).pop();
          },
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(25),
                topRight: Radius.circular(25)),
            color: Colors.black38,
          ),
          width: 70,
          height: 50,
          child: Padding(
            padding: EdgeInsets.only(right: 10),
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconLocation() {
    return Positioned(
      right: 10.0,
      top: 0,
      child: SizedBox(
        width: 40,
        height: 40,
        child: FloatingActionButton(
          child: Icon(
            Icons.gps_fixed,
            color: Theme.of(context).primaryColor,
          ),
          onPressed: viewModel.animateMyLocation,
          backgroundColor: Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TabsPageViewModel tabsPageViewModel = ViewModelProvider.of(context);
    // viewModel = tabsPageViewModel.locateBusPageViewModel;
    _panelHeightOpen = _size.height;
    return StatefulWrapper(
      onInit: () {},
      child: ViewModelProvider(
        viewmodel: viewModel,
        child: StreamBuilder<Object>(
            stream: viewModel.stream,
            builder: (context, snapshot) {
              return Material(
                child: SizedBox.expand(
                  child: Stack(
                    children: <Widget>[
                      _buildBody(),
                      DraggableScrollableSheet(
                        minChildSize: 180 /
                            MediaQuery.of(context)
                                .size
                                .height, // 0.1 times of available height, sheet can't go below this on dragging
                        maxChildSize: 435 /
                            MediaQuery.of(context)
                                .size
                                .height, // 0.7 times of available height, sheet can't go above this on dragging
                        initialChildSize: 180 /
                            MediaQuery.of(context)
                                .size
                                .height, // 0.1 times of available height, sheet start at this size when opened for first time
                        builder: (BuildContext context,
                            ScrollController controller) {
                          return SingleChildScrollView(
//                                dragStartBehavior: MyBehavior(),

                            controller: controller,
                            child: Stack(
                              children: <Widget>[
                                Container(
                                  color: Colors.transparent,
                                  width: MediaQuery.of(context).size.width,
                                  height: 435,
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  left: 0,
                                  child: _buildPanel(),
                                ),
//                                  _buildPanel(),
                                _buildIconLocation(),
                              ],
                            ),
                          );
                        },
                      ),
                      _backButton()
                    ],
                  ),
                ),
//                Stack(
//                  children: <Widget>[
//                    SlidingUpPanel(
//                      controller: _pc,
//                      parallaxEnabled: true,
//                      backdropEnabled: true,
//                      parallaxOffset: .5,
//                      maxHeight: _panelHeightOpen,
//                      minHeight: _panelHeightClosed,
//                      borderRadius: BorderRadius.only(
//                          topLeft: Radius.circular(18.0),
//                          topRight: Radius.circular(18.0)),
//                      panel: _buildPanel(),
//                      onPanelOpened: () {
//                        setState(() {
//                          disableScroll = false;
//                        });
//                      },
//                      onPanelClosed: () {
//                        setState(() {
//                          disableScroll = true;
//                        });
//                      },
//                      onPanelSlide: (double pos) => setState(() {
//                        _fabHeight =
//                            pos * (_panelHeightOpen - _panelHeightClosed) +
//                                _initFabHeight;
//                      }),
//                      body: new Scaffold(
//                        body: _buildBody(),
//                        // body: Container()
//                      ),
//                    ),
//                    _buildIconLocation(),
//                    _backButton()
//                  ],
//                ),
              );
            }),
      ),
    );
  }
}
