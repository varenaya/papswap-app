import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdHelper {
  static AdRequest get adrequest =>
      const AdManagerAdRequest(nonPersonalizedAds: false);
  static String get rewardedAdunitId =>
      'ca-app-pub-8105405960317634/6099893000';
}
