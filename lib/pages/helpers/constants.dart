import 'package:flutter/material.dart';

class ApiConstants {
  // static String baseUrl = 'https://comparify-20221226.azurewebsites.net/api';
  static String baseUrl = 'https://comparify-20230219.azurewebsites.net/api';
  static String findByNamePageEndpoint = '/searchproductv3function';
  static String findByCodePageEndpoint = '/productv3codefunction';
  static String findByCategoryPageEndpoint = '/searchproductbycategoryv3function';
  static String findByIds = '/favouriteProductsV3Function';

  static const double mainFontSize = 12;
  static const double productCardFontSize = 14;
  static const double titleFontSize = 24;
  static const double languageFontSize = 16;

  static const Color mainFontColor = Color(0xFF23336D);
  static const Color favoriteColor = Color(0xFFD81A0E);
  static const Color appBarFontColor = Color(0xFFFDFDFD);
  static const Color nameFontColor = Color(0xFF0000A0);
  static const Color mainBackgroundColor = Color(0xFFFDFDFD);
  static const Color buttonsAndMenuColor = Color(0xFF0C46DD);
  static const Color bottomMenuColor = Color(0xFFFFFFFF);
  static const Color unselectedBottomMenuColor = Color(0xFF828282);
  static const Color retailerPriceBackgroundColor = Color(0xFFECF2FF);
  static const Color bestPriceFontColor = Color(0xFF11934D);
  static const Color tooltipBackgroundColor = Color(0xFFFBFBFF);

  static const bool showTopBar = true;
}

