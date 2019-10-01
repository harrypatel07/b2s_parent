import 'package:b2s_parent/src/app/core/baseViewModel.dart';
import 'package:b2s_parent/src/app/pages/locateBus/locateBus_page_viewmodel.dart';
import 'package:b2s_parent/src/app/pages/tabs/tabs_page_viewmodel.dart';
import 'package:b2s_parent/src/app/widgets/bus_attentdance_card.dart';
import 'package:b2s_parent/src/app/widgets/index.dart';
import 'package:b2s_parent/src/app/widgets/ts24_timeline.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class LocateBusPage extends StatefulWidget {
  static const String routeName = "/locateBus";
  @override
  _LocateBusPageState createState() => _LocateBusPageState();
}

class _LocateBusPageState extends State<LocateBusPage> {
  LocateBusPageViewModel viewModel;

  final double _initFabHeight = 100.0;
  double _fabHeight;
  double _panelHeightOpen = 0;
  double _panelHeightClosed = 120.0;

  ScrollController _sc = ScrollController();
  PanelController _pc = PanelController();
  bool disableScroll = true;

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
  }

  Widget _buildBody() {
    Widget __buildGoogleMap() {
      return GoogleMap(
        onMapCreated: viewModel.onMapCreated,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        compassEnabled: true,
        markers: viewModel.marker,
        initialCameraPosition: CameraPosition(
          target: viewModel.center,
          zoom: 15.0,
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
              childrenBusSession: viewModel.childrenBus,
              onTapCard: () {
                //  viewModel.listOnTap(viewModel.listChildren[index]);
              },
              onTapCall: () {}),
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

    Widget __timeLine() {
      var listTimeLine = viewModel.childrenBus.listRouteBus
          .map((item) => EventTime(item.time, item.routeName, "", item.status))
          .toList();
      return TS24TimeLine(
          listTimeLine: listTimeLine,
          height: MediaQuery.of(context).size.height);
    }

    return SingleChildScrollView(
        controller: _sc,
        physics: disableScroll
            ? NeverScrollableScrollPhysics()
            : ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[__childrenCard(), __timeLine()],
        ));
  }

  Widget _panel() {
    Widget _button(String label, IconData icon, Color color) {
      return Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Icon(
              icon,
              color: Colors.white,
            ),
            decoration:
                BoxDecoration(color: color, shape: BoxShape.circle, boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.15),
                blurRadius: 8.0,
              )
            ]),
          ),
          SizedBox(
            height: 12.0,
          ),
          Text(label),
        ],
      );
    }

    return SingleChildScrollView(
      controller: _sc,
      physics: disableScroll
          ? NeverScrollableScrollPhysics()
          : ClampingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 12.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 30,
                height: 5,
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.all(Radius.circular(12.0))),
              ),
            ],
          ),
          SizedBox(
            height: 18.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Explore Pittsburgh",
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 24.0,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 36.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _button("Popular", Icons.favorite, Colors.blue),
              _button("Food", Icons.restaurant, Colors.red),
              _button("Events", Icons.event, Colors.amber),
              _button("More", Icons.more_horiz, Colors.green),
            ],
          ),
          SizedBox(
            height: 36.0,
          ),
          Container(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Images",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    )),
                SizedBox(
                  height: 12.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CachedNetworkImage(
                      imageUrl:
                          "https://images.fineartamerica.com/images-medium-large-5/new-pittsburgh-emmanuel-panagiotakis.jpg",
                      height: 120.0,
                      width: (MediaQuery.of(context).size.width - 48) / 2 - 2,
                      fit: BoxFit.cover,
                    ),
                    CachedNetworkImage(
                      imageUrl:
                          "https://cdn.pixabay.com/photo/2016/08/11/23/48/pnc-park-1587285_1280.jpg",
                      width: (MediaQuery.of(context).size.width - 48) / 2 - 2,
                      height: 120.0,
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 36.0,
          ),
          Container(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("About",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    )),
                SizedBox(
                  height: 100.0,
                ),
                Text(
                  "Pittsburgh is a city in the Commonwealth of Pennsylvania "
                  "in the United States, and is the county seat of Allegheny County. "
                  "As of 2017, a population of 305,704 lives within the city limits, "
                  "making it the 63rd-largest city in the U.S. The metropolitan population "
                  "of 2,353,045 is the largest in both the Ohio Valley and Appalachia, "
                  "the second-largest in Pennsylvania (behind Philadelphia), "
                  "and the 26th-largest in the U.S.  Pittsburgh is located in the "
                  "south west of the state, at the confluence of the Allegheny, "
                  "Monongahela, and Ohio rivers, Pittsburgh is known both as 'the Steel City' "
                  "for its more than 300 steel-related businesses and as the 'City of Bridges' "
                  "for its 446 bridges. The city features 30 skyscrapers, two inclined railways, "
                  "a pre-revolutionary fortification and the Point State Park at the "
                  "confluence of the rivers. The city developed as a vital link of "
                  "the Atlantic coast and Midwest, as the mineral-rich Allegheny "
                  "Mountains made the area coveted by the French and British "
                  "empires, Virginians, Whiskey Rebels, and Civil War raiders. ",
                  maxLines: 7,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconLocation() {
    return Positioned(
      right: 20.0,
      bottom: _fabHeight,
      child: SizedBox(
        width: 40,
        height: 40,
        child: FloatingActionButton(
          child: Icon(
            Icons.gps_fixed,
            color: Theme.of(context).primaryColor,
          ),
          onPressed: () {},
          backgroundColor: Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    TabsPageViewModel tabsPageViewModel = ViewModelProvider.of(context);
    viewModel = tabsPageViewModel.locateBusPageViewModel;
    _panelHeightOpen = MediaQuery.of(context).size.height * 2 / 3;
    return ViewModelProvider(
      viewmodel: viewModel,
      child: StreamBuilder<Object>(
          stream: viewModel.stream,
          builder: (context, snapshot) {
            return Stack(
              children: <Widget>[
                SlidingUpPanel(
                  controller: _pc,
                  parallaxEnabled: true,
                  backdropEnabled: true,
                  parallaxOffset: .5,
                  maxHeight: _panelHeightOpen,
                  minHeight: _panelHeightClosed,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(18.0),
                      topRight: Radius.circular(18.0)),
                  panel: _buildPanel(),
                  onPanelOpened: () {
                    setState(() {
                      disableScroll = false;
                    });
                  },
                  onPanelClosed: () {
                    setState(() {
                      disableScroll = true;
                    });
                  },
                  onPanelSlide: (double pos) => setState(() {
                    _fabHeight = pos * (_panelHeightOpen - _panelHeightClosed) +
                        _initFabHeight;
                  }),
                  body: new Scaffold(
                    body: _buildBody(),
                    // body: Container()
                  ),
                ),
                _buildIconLocation()
              ],
            );
          }),
    );
  }
}
