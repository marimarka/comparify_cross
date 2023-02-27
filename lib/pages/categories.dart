import 'package:comparify/pages/category.dart';
import 'package:comparify/pages/helpers/constants.dart';
import 'package:flutter/material.dart';

import 'helpers/multi_languages.dart';

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
          CatalogItemCard(
              "breadCatalog",
              'assets/categories/3d_maize.png'),
          //1
          CatalogItemCard("milkCatalog", 'assets/categories/3d_piens.png'),
          //2
          CatalogItemCard(
              "vegetablesCatalog", 'assets/categories/3d_darzini.png'),
          //3
          CatalogItemCard("meatCatalog", 'assets/categories/3d_gala.png'),
          //4
          CatalogItemCard("bacaley", 'assets/categories/3d_bakaleja.png'),
          //5
          CatalogItemCard("iced", 'assets/categories/3d_saldeti.png'),
          //6
          CatalogItemCard("drinks", 'assets/categories/3d_dzerieni.png'),
          //7
          CatalogItemCard("alcoDrinks", 'assets/categories/3d_alko.png'),
          //8
          CatalogItemCard("babiesGoods", 'assets/categories/3d_berniem.png'),
          //9
          CatalogItemCard("houseGoods", 'assets/categories/3d_majai.png'),
          //11
          // SongbookCard('Vegāniem un veģetāriešiem'),//10
        ],
      ),
    );
  }
}

class CatalogItemCard extends StatelessWidget {
  final SongBookWidgetStyle style = SongBookWidgetStyle();

  String categoriesName = '';
  String imageUrl = '';

  CatalogItemCard(String categoriesName, String imageUrl) {
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
                      MultiLanguages.of(context)!.translate(categoriesName),
                      textAlign: TextAlign.center,
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: ApiConstants.mainFontColor,
                          fontSize: ApiConstants.mainFontSize,
                          letterSpacing: 0.7,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ]))));
  }

  Future<dynamic> openCategoryClick(BuildContext context) {
    return Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                Category(categoriesName: categoriesName, imageUrl: imageUrl)));
  }
}

class SongBookWidgetStyle extends StatelessWidget {
  double borderRadius = 10;

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}
