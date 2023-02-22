import 'package:comparify/pages/helpers/constants.dart';
import 'package:comparify/pages/helpers/multi_languages.dart';
import 'package:flutter/material.dart';

class BottomMenu extends StatelessWidget {
  final selectedTab;
  ValueChanged<int> changeTab;

  BottomMenu({this.selectedTab, required this.changeTab});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: const ImageIcon(
                AssetImage("assets/catalogs.png"),
                size: 18,
              ),
              label: MultiLanguages.of(context)!.translate('items')),
          // "Preces"),
          BottomNavigationBarItem(
              icon: const ImageIcon(
                AssetImage("assets/scanner.png"),
                size: 18,
              ),
              label: MultiLanguages.of(context)!.translate('scanner')),
          BottomNavigationBarItem(
              icon: const ImageIcon(
                AssetImage("assets/store.png"),
                size: 18,
              ),
              label: MultiLanguages.of(context)!.translate('stores')),
          BottomNavigationBarItem(
              icon: const ImageIcon(
                AssetImage("assets/favorits.png"),
                size: 18,
              ),
              label: MultiLanguages.of(context)!.translate('favorites')),
          BottomNavigationBarItem(
              icon: const ImageIcon(
                AssetImage("assets/comparify.png"),
                size: 18,
              ),
              label: MultiLanguages.of(context)!.translate('comparify')),
        ],
        currentIndex: selectedTab,
        onTap: (index) => changeTab(index),
        selectedItemColor: ApiConstants.buttonsAndMenuColor,
        backgroundColor: ApiConstants.bottomMenuColor,
        unselectedItemColor: ApiConstants.unselectedBottomMenuColor,
        selectedLabelStyle: const TextStyle(overflow: TextOverflow.ellipsis),
        unselectedLabelStyle: const TextStyle(overflow: TextOverflow.ellipsis),
        type: BottomNavigationBarType.fixed);
  }
}
