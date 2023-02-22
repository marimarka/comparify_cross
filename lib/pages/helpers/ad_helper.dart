import 'dart:io';

class AdHelper {

  // real
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-4344029966896694/3372828328';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-4344029966896694/7034252021';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  //test
  // static String get bannerAdUnitId {
  //   if (Platform.isAndroid) {
  //     return 'ca-app-pub-3940256099942544/6300978111';
  //   } else if (Platform.isIOS) {
  //     return 'ca-app-pub-3940256099942544/2934735716';
  //   } else {
  //     throw new UnsupportedError('Unsupported platform');
  //   }
  // }
//test
//   static String get interstitialAdUnitId {
//     if (Platform.isAndroid) {
//       return "ca-app-pub-3940256099942544/1033173712";
//     } else if (Platform.isIOS) {
//       return "ca-app-pub-3940256099942544/4411468910";
//     } else {
//       throw new UnsupportedError("Unsupported platform");
//     }
//   }

  // real
  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-4344029966896694/1449937215';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-4344029966896694/7136792407';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  // static String get rewardedAdUnitId {
  //   if (Platform.isAndroid) {
  //     return '<YOUR_ANDROID_REWARDED_AD_UNIT_ID>';
  //   } else if (Platform.isIOS) {
  //     return '<YOUR_IOS_REWARDED_AD_UNIT_ID>';
  //   } else {
  //     throw UnsupportedError('Unsupported platform');
  //   }
  // }
}