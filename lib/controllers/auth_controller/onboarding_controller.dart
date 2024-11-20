import 'dart:developer';

import 'package:citypressgo/config.dart';

import '../../utils/extensions.dart';

class OnBoardingController extends GetxController {
  PageController pageCtrl = PageController();
  List onBoardingLists = [];
  bool isLastPage = false;
  int selectIndex = 0;
  Locale? locale = const Locale("en", "US");

  @override
  void onInit() async {
    await FirebaseFirestore.instance
        .collection("onBoardScreenConfiguration")
        .get()
        .then((value) async {
      if (value.docs.isNotEmpty) {
        onBoardingLists =  value.docs;
        selectIndex = 0;
      }
    });
    update();

    await FirebaseFirestore.instance.collection("themeColor").get().then((value) {
      if(value.docs.isNotEmpty){

        appCtrl.appTheme.primary = hexStringToColor(value.docs[0].data()["selectedThemeColor"]);
      }
      log("appCtrl.appTheme.primary :${appCtrl.appTheme.primary}");
      appCtrl.update();
      Get.forceAppUpdate();
    });



    appCtrl.isTheme = appCtrl.storage.read("isDark") ?? false;

    appCtrl.update();
    ThemeService().switchTheme(appCtrl.isTheme);
    Get.forceAppUpdate();


    //language
    var language = await appCtrl.storage.read("locale") ?? "en";

    if (language != null) {
      appCtrl.languageVal = language;
      if (language == "en") {
        locale = const Locale("en", "US");
      } else if (language == "hi") {
        locale = const Locale("hi", "IN");
      } else if (language == "it") {
        locale = const Locale("it", "IT");
      } else if (language == "fr") {
        locale = const Locale("fr", "CA");
      } else if (language == "ge") {
        locale = const Locale("ge", "GE");
      } else if (language == "ja") {
        locale = const Locale("ja", "JP");
      }
    } else {
      locale = const Locale("en", "US");
    }
    update();

    // TODO: implement onInit
    super.onInit();
  }

  @override
  void onReady() async {}
}
