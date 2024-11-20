import 'dart:developer';
import 'dart:io';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:goapp/config.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HomeScreenController extends GetxController {
  bool  isLoading = true;
  BannerAd? bannerAd;
  bool bannerAdIsLoaded = false;
  Map<String, dynamic>? firebase;
  AdManagerBannerAd? adManagerBannerAd;
  bool adManagerBannerAdIsLoaded = false;

  NativeAd? nativeAd;

  Widget currentAd = const SizedBox(
    width: 0.0,
    height: 0.0,
  );
  bool nativeAdIsLoaded = false;
  WebViewController? controller;





  getRefresh()async{
    if(appCtrl.baseUrl != ""){

      controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..loadRequest(Uri.parse(appCtrl.baseUrl))
        ..setNavigationDelegate(NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
          onPageFinished: (url) {
          },
          onUrlChange: (change) {
          },

        ));
      isLoading =false;
      update();
    }else{
      isLoading =true;
      update();
      controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..loadRequest(Uri.parse( "https://codecanyon.net/user/pixelstrap"))
        ..setNavigationDelegate(NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
          onPageFinished: (url) {
          },
          onUrlChange: (change) {
          },
        ));
      isLoading =false;
      update();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller!.clearCache();
    controller!.clearLocalStorage();
    super.dispose();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    getBanner();
    super.onReady();
  }


  getBanner() async {
    if (bannerAd == null) {
      bannerAd = BannerAd(
        adUnitId: Platform.isAndroid
            ? 'ca-app-pub-3940256099942544/6300978111'
            : 'ca-app-pub-3940256099942544/2934735716',
        request: const AdRequest(),
        size: AdSize.banner,
        listener: BannerAdListener(
          // Called when an ad is successfully received.
          onAdLoaded: (ad) {
            debugPrint('$ad loaded.');
            bannerAdIsLoaded = true;
            update();
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (ad, err) {
            debugPrint('BannerAd failed to load: $err');
            // Dispose the ad here to free resources.
            ad.dispose();
          },
        ),
      )..load();

    } else {
      bannerAd!.dispose();
      buildBanner();
      log("bannerAd ;$bannerAd");
      log("bannerAd ;${bannerAd!.size}");
    }

    FacebookAudienceNetwork.init(
      testingId: "37b1da9d-b48c-4103-a393-2e095e734bd6",
      iOSAdvertiserTrackingEnabled: true,
    );
    _showBannerAd();
  }


  _showBannerAd() {

    currentAd = FacebookBannerAd(
      // placementId: "YOUR_PLACEMENT_ID",
      placementId: "IMG_16_9_APP_INSTALL#YOUR_PLACEMENT_ID",
      bannerSize: BannerSize.STANDARD,
      listener: (result, value) {

      },
    );
    update();

  }

  buildBanner() async {
    bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId:  Platform.isAndroid
            ? "ca-app-pub-3940256099942544/6300978111"
            : 'ca-app-pub-3940256099942544/2934735716',
        listener: BannerAdListener(
          onAdLoaded: (Ad ad) {

            bannerAdIsLoaded = true;
            update();
          },
          onAdFailedToLoad: (Ad ad, LoadAdError error) {

            ad.dispose();
          },
          onAdOpened: (Ad ad) => log('$BannerAd onAdOpened.'),
          onAdClosed: (Ad ad) => log('$BannerAd onAdClosed.'),
        ),
        request: const AdRequest())
      ..load();

  }



}
