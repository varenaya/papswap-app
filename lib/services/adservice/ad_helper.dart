import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdHelper {
  static AdRequest get adrequest => const AdRequest(
      nonPersonalizedAds: false,
      location:
          LocationParams(accuracy: 1.0, longitude: 20.5937, latitude: 78.9629));
  static String get rewardedAdunitId =>
      'ca-app-pub-8105405960317634/6099893000';
}
