import 'package:flutter/material.dart';

class ApiConstants {
  static String baseUrl = 'https://comparify-20221226.azurewebsites.net/api';
  static String findByNamePageEndpoint = '/searchproductv2function';
  static String findByCodePageEndpoint = '/productv2codefunction';
  static String findByCategoryPageEndpoint = '/searchproductbycategoryv2function';

  // static String baseUrl = 'https://comparify-20230210.azurewebsites.net/api';
  // static String findByNamePageEndpoint = '/searchproductv3function';
  // static String findByCodePageEndpoint = '/productv3codefunction';
  // static String findByCategoryPageEndpoint = '/searchproductbycategoryv3function';

  static const double mainFontSize = 12;

  static const Color mainFontColor = Color(0xFF23336D);
  static const Color appBarFontColor = Color(0xFFFDFDFD);
  static const Color nameFontColor = Color(0xFF0000A0);
  static const Color mainBackgroundColor = Color(0xFFFDFDFD);
  static const Color buttonsAndMenuColor = Color(0xFF0C46DD);
  static const Color bottomMenuColor = Color(0xFFFFFFFF);
  static const Color unselectedBottomMenuColor = Color(0xFF828282);

  static const bool showTopBar = true;
}

