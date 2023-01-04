import 'package:comparify_cross/category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'ad_helper.dart';

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  CategoriesState createState() => CategoriesState();
}

class CategoriesState extends State<Categories> {

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/

    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;

    return Container(
      child: GridView.count(
        // childAspectRatio: (itemWidth / itemHeight),
        shrinkWrap: true,
        padding: EdgeInsets.only(top: 20, left: 15, right: 15),
        mainAxisSpacing: 15,
        crossAxisSpacing: 10,
        crossAxisCount: 2,
        children: [
          SongbookCard('Maize un konditoreja'), //1
          SongbookCard('Piena produkti un olas'), //2
          SongbookCard('Augļi un dārzeņi'), //3
          SongbookCard('Gaļa, zivs un gatava kulinārija'), //4
          SongbookCard('Bakaleja'), //5
          SongbookCard('Saldēta pārtika'), //6
          SongbookCard('Dzērieni'), //7
          SongbookCard('Alkoholiskie dzērieni'), //8
          SongbookCard('Zīdaiņu un bērnu preces'), //9
          SongbookCard('Mājai, tīrīšanai un mājdzīvniekiem'), //11
          // SongbookCard('Vegāniem un veģetāriešiem'),//10
        ],
      ),
    );
  }
}

class SongbookCard extends StatelessWidget {
  final SongBookWidgetStyle style = SongBookWidgetStyle();

  String categoriesName = '';

  NeumorphicStyle nstyle = NeumorphicStyle(
      shape: NeumorphicShape.concave,
      boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
      depth: 0,
      lightSource: LightSource.topLeft,
      color: const Color(0xFF0C46DD));

  SongbookCard(String categoriesName) {
    this.categoriesName = categoriesName;
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
          maxWidth: 150, maxHeight: 140, minHeight: 140, minWidth: 150),
      child: NeumorphicButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      Category(categoriesName: this.categoriesName)));
        },
        // boxShape: NeumorphicBoxShape.roundRect(
        //     BorderRadius.circular(12)),
        style: nstyle,
        padding: const EdgeInsets.only(top: 16.0),
        child: Column(
          children: <Widget>[
            Flexible(
              flex: 8,
              child: ClipRRect(
                child: Container(
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      color: const Color(0xFF0C46DD)), //ColorsExtension.appPurple),
                  // width: 120,
                  // height: 120,
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: MediaQuery.of(context).size.width * 0.3,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 6.0),
              child: Text(
                categoriesName,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SongBookWidgetStyle extends StatelessWidget {
  double borderRadius = 10;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
