// import 'package:comparify_cross/product_card.dart';
// import 'package:comparify_cross/services/api_service.dart';
// import 'package:flutter/material.dart';
//
// import 'models/products_dto_v2.dart';
//
// class HomePage extends StatefulWidget {
//   @override
//   _HomeState createState() => new _HomeState();
// }
//
// class _HomeState extends State<HomePage> with TickerProviderStateMixin {
//   late TabController tabController;
//
//   List<Tab> tabs = [
//     Tab(child: Text("Maize un konditoreja")),
//     Tab(child: Text("Piena produkti un olas")),
//     Tab(child: Text("Augļi un dārzeņi")),
//     Tab(child: Text("Gaļa, zivs un gatava kulinārija")),
//     Tab(child: Text("Bakaleja")),
//     Tab(child: Text("Saldēta pārtika")),
//     Tab(child: Text("Dzērieni")),
//     Tab(child: Text("Alkoholiskie dzērieni")),
//     Tab(child: Text("Zīdaiņu un bērnu preces")), //9
//     Tab(child: Text("Mājai, tīrīšanai, mājdzīvniekiem")) //11
//   ];
//
//   late List<ProductsDTOV2>? productModels = [];
//
//   Future<List> _loadData(int category) async {
//     return (await ApiService().searchByCategory(category))!;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     tabController = new TabController(length: 10, vsync: this);
//
//     var tabBarItem = TabBar(
//       tabs: tabs,
//       isScrollable: true,
//       controller: tabController,
//       indicatorColor: Colors.white,
//     );
//
//     var category1 = buildFutureBuilder(1);
//     var category2 = buildFutureBuilder(2);
//     var category3 = buildFutureBuilder(3);
//     var category4 = buildFutureBuilder(4);
//     var category5 = buildFutureBuilder(5);
//     var category6 = buildFutureBuilder(6);
//     var category7 = buildFutureBuilder(7);
//     var category8 = buildFutureBuilder(8);
//     var category9 = buildFutureBuilder(9);
//     var category11 = buildFutureBuilder(11);
//
//     return DefaultTabController(
//         length: tabs.length,
//         child: Scaffold(
//           body: NestedScrollView(
//               headerSliverBuilder:
//                   (BuildContext context, bool innerBoxIsScrolled) {
//                 return <Widget>[
//                   SliverAppBar(
//                     title: Text('Comparify'),
//                     pinned: true,
//                     floating: true,
//                     bottom: tabBarItem,
//                   ),
//                 ];
//               },
//               body: TabBarView(
//                 controller: tabController,
//                 children: [
//                   category1,
//                   category2,
//                   category3,
//                   category4,
//                   category5,
//                   category6,
//                   category7,
//                   category8,
//                   category9,
//                   category11
//                 ],
//               )),
//         ));
//   }
//
//   FutureBuilder<List<dynamic>> buildFutureBuilder(int category) {
//     return FutureBuilder(
//         future: _loadData(category),
//         builder: (BuildContext ctx, AsyncSnapshot<List> snapshot) =>
//             snapshot.hasData
//                 ? ListView.builder(
//                     // render the list
//                     itemCount: snapshot.data!.length,
//                     itemBuilder: (context, index) {
//                       return ProductCard(snapshot.data![index]);
//                     })
//                 : const Center(
//                     // render the loading indicator
//                     child: CircularProgressIndicator(),
//                   ));
//   }
// }
