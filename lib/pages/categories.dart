import 'package:comparify_cross/pages/category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

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
        padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
        mainAxisSpacing: 15,
        crossAxisSpacing: 10,
        crossAxisCount: 2,
        children: [
          SongbookCard(
              'Maize un konditoreja', 'assets/categories/3d_maize.png'),
          //1
          SongbookCard(
              'Piena produkti un olas', 'assets/categories/3d_piens.png'),
          //2
          SongbookCard('Augļi un dārzeņi', 'assets/categories/3d_darzini.png'),
          //3
          SongbookCard('Gaļa, zivs un gatava kulinārija',
              'assets/categories/3d_gala.png'),
          //4
          SongbookCard('Bakaleja', 'assets/categories/3d_bakaleja.png'),
          //5
          SongbookCard('Saldēta pārtika', 'assets/categories/3d_saldeti.png'),
          //6
          SongbookCard('Dzērieni', 'assets/categories/3d_dzerieni.png'),
          //7
          SongbookCard(
              'Alkoholiskie dzērieni', 'assets/categories/3d_alko.png'),
          //8
          SongbookCard(
              'Zīdaiņu un bērnu preces', 'assets/categories/3d_berniem.png'),
          //9
          SongbookCard('Mājai, tīrīšanai un mājdzīvniekiem',
              'assets/categories/3d_majai.png'),
          //11
          // SongbookCard('Vegāniem un veģetāriešiem'),//10
        ],
      ),
    );
  }
}

class SongbookCard extends StatelessWidget {
  final SongBookWidgetStyle style = SongBookWidgetStyle();

  String categoriesName = '';
  String imageUrl = '';

  SongbookCard(String categoriesName, String imageUrl) {
    this.categoriesName = categoriesName;
    this.imageUrl = imageUrl;
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
        constraints: const BoxConstraints(
            maxWidth: 150, maxHeight: 140, minHeight: 140, minWidth: 150),
        child: InkWell(
            onTap: () {
              openCategoryClick(context);
            },
            child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child:
                    Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                  Flexible(
                    flex: 8,
                    child: ClipRRect(
                      child: Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(imageUrl),
                                fit: BoxFit.fitHeight),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12.0))),
                        //ColorsExtension.appPurple),
                        // width: 120,
                        // height: 120,
                        width: MediaQuery.of(context).size.width * 0.6,
                        height: MediaQuery.of(context).size.width * 0.6,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 6.0),
                    child: Text(
                      categoriesName,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: Color(0xFF0C46DD), fontSize: 20),
                    ),
                  )
                ]))));
  }

  Future<dynamic> openCategoryClick(BuildContext context) {
    return Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Category(
                categoriesName: this.categoriesName, imageUrl: this.imageUrl)));
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
