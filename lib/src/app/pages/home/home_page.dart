import 'package:b2s_parent/src/app/core/baseViewModel.dart';
import 'package:b2s_parent/src/app/pages/home/home_page_viewmodel.dart';
import 'package:b2s_parent/src/app/pages/locateBus/locateBus_page.dart';
import 'package:b2s_parent/src/app/pages/tabs/tabs_page_viewmodel.dart';
import 'package:b2s_parent/src/app/widgets/index.dart';
import 'package:b2s_parent/src/models/category.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  static const String routeName = "/home";
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomePageViewModel viewModel;
  @override
  Widget build(BuildContext context) {
    TabsPageViewModel tabsPageViewModel = ViewModelProvider.of(context);
    viewModel = tabsPageViewModel.homePageViewModel;
    viewModel.context = context;
    return ViewModelProvider(
      viewmodel: viewModel,
      child: StreamBuilder<Object>(
          stream: viewModel.stream,
          builder: (context, snapshot) {
            return TS24Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                leading: appBarIconSideMenu(context),
              ),
              body: HomeBodyWidget(),
              // drawer: SideMenuPage(),
            );
          }),
    );
  }
}

class HomeBodyWidget extends StatefulWidget {
  @override
  _HomeBodyWidgetState createState() => _HomeBodyWidgetState();
}

class _HomeBodyWidgetState extends State<HomeBodyWidget> {
  HomePageViewModel viewModel;

  Widget _searchBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18),
      margin: EdgeInsets.symmetric(horizontal: 28),
      decoration: ShapeDecoration(
        shape: StadiumBorder(),
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.school),
          SizedBox(width: 13),
          Expanded(
            child: TextFormField(
              // readOnly: true,
              decoration: InputDecoration(
                hintText: "Nhập tên trường tìm kiếm nhà xe...",
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          Icon(Icons.home),
          SizedBox(width: 13),
          Expanded(
            child: TextFormField(
              // readOnly: true,
              decoration: InputDecoration(
                hintText: "Nhập địa chỉ nhà bạn...",
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _categoryList() {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.44,
        crossAxisSpacing: 10,
        mainAxisSpacing: 12,
      ),
      padding: EdgeInsets.only(left: 28, right: 28, bottom: 58),
      itemCount: Category.categories.length,
      itemBuilder: (context, index) => BusCategoryCard(
        Category.categories[index],
        onPress: () {
          viewModel.categoryOnPress(Category.categories[index]);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    viewModel = ViewModelProvider.of(context);
    return SingleChildScrollView(
      child: BusHomeContainer(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        ),
        children: <Widget>[
          SizedBox(height: 117),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 28),
            child: Text(
              "Tìm nhà xe cho trẻ?",
              style: TextStyle(
                fontSize: 30,
                height: 0.9,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          SizedBox(height: 40),
          _searchBar(),
          SizedBox(height: 42),
          _categoryList(),
        ],
      ),
    );
  }
}
