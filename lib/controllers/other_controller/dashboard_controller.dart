import 'dart:convert';
import 'dart:developer';

import 'package:citypressgo/controllers/other_controller/setting_controller.dart';
import 'package:citypressgo/screens/other_screens/settings_screens/index.dart';
import 'package:citypressgo/widgets/common_button.dart';

import '../../config.dart';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';

import '../../utils/extensions.dart';

class DashboardController extends GetxController  with GetSingleTickerProviderStateMixin {
  final pageController = PageController(initialPage: 0);
  TextEditingController searchCtrl = TextEditingController();
  dynamic exitData;TabController? tabController;

  /// Controller to handle bottom nav bar and also handles initial page
  final controller = NotchBottomBarController(index: 0);

  int maxCount = 1;Locale locale = const Locale("en", "US");


  @override
  void onReady() async {
    // TODO: implement onReady
    tabController =
        TabController(length: appArray.bottomList.length, vsync: this);
    update();
    tabController!.addListener(() {});
    await FirebaseFirestore.instance
        .collection("themeColor")
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        appCtrl.appTheme.primary =
            hexStringToColor(value.docs[0].data()["selectedThemeColor"]);
      }
      log("appCtrl.appTheme.primary :${appCtrl.appTheme.primary}");
      appCtrl.update();
      Get.forceAppUpdate();
    });

    onExitData();

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
    searchCtrl.text = "https://";
    update();
    super.onReady();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  /// widget list
  final List<Widget> bottomBarPages = [
    const SearchScreen(),
    HomeScreen(),
    const SettingsScreen(),
  ];

  onExitData() async {
    FirebaseFirestore.instance
        .collection("exitPopupConfiguration")
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        exitData = value.docs[0].data();
      }
    });
  }

  Future onBackPressed(context) async {
    if (exitData != null) {
      return showDialog(
          context: context,
          builder: (context) {
            return Theme(
                data: ThemeData(
                  dialogBackgroundColor: appCtrl.appTheme.white,
                  dialogTheme: DialogTheme(
                    shadowColor: appCtrl.appTheme.lightGray,
                      backgroundColor: appCtrl.appTheme.white,
                      surfaceTintColor: appCtrl.appTheme.white),
                ),
                child: AlertDialog(
                    backgroundColor: appCtrl.appTheme.white,
                    title: Text(
                      exitData['title'],
                      style: AppCss.outfitMedium18
                          .textColor(appCtrl.appTheme.black),
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          exitData['desc'] ?? "",
                          style: AppCss.outfitMedium16
                              .textColor( appCtrl.appTheme.black),
                        ),
                        if(exitData['showImage'] == true)
                          Image.network(
                                exitData['image'],
                                height: Sizes.s100,
                                width: Sizes.s2,
                              )

                      ],
                    ),
                    actions: <Widget>[
                      Row(children: [
                        Expanded(
                            child: CommonButton(
                          title: exitData['negativeText'],
                          onTap: () => Get.back(),
                          style: AppCss.outfitMedium14
                              .textColor(appCtrl.appTheme.white),
                        )),
                        Expanded(
                            child: CommonButton(
                          title: exitData['positiveText'],
                          style: AppCss.outfitMedium14
                              .textColor(appCtrl.appTheme.white),
                          onTap: () => SystemNavigator.pop(),
                        )),
                      ])
                    ]));
          });
    } else {
      SystemNavigator.pop();
    }
  }


  getCheckoutList() async {
    String storageList = appCtrl.storage.read(session.checkOutItems) ??"";
    String socialList = appCtrl.storage.read(session.social) ??"";

    if(storageList == "") {
      FirebaseFirestore.instance
          .collection(session.checkOutItems)
          .where("isActive", isEqualTo: true)
          .snapshots()
          .listen((event) {
        if (event.docs.isNotEmpty) {
          appCtrl.checkoutList = [];
          update();

          List<QueryDocumentSnapshot<dynamic>>  check =
              event.docs.where((element) => element.data()['isActive'] == true).toList();

          for(QueryDocumentSnapshot<dynamic> d in check){
            appCtrl.checkoutList.add(d.data());
          }
        }

        appCtrl.update();
        appCtrl.storage.write(session.checkOutItems, jsonEncode(appCtrl.checkoutList));
        appCtrl.update();
      });
    }else{
      appCtrl.checkoutList = [];

      if(storageList.isNotEmpty){
        appCtrl.checkoutList = jsonDecode(storageList);
        appCtrl.update();
      }
    }

    if(socialList == "") {
      FirebaseFirestore.instance
          .collection(session.socialConfig).where("title", whereNotIn: ['desc', 'copyRight'])

          .snapshots()
          .listen((event) {
        if (event.docs.isNotEmpty) {
          appCtrl.socialLink = [];
          List<QueryDocumentSnapshot<dynamic>>  check =
              event.docs.toList();
          for(QueryDocumentSnapshot<dynamic> d in check){
            appCtrl.socialLink.add(d.data());
          }

        }
        appCtrl.update();
        appCtrl.storage.write(session.social, jsonEncode(appCtrl.socialLink));
        appCtrl.update();
      });
    }else{
      appCtrl.socialLink =[];
      if(socialList.isNotEmpty){
        appCtrl.socialLink = jsonDecode(socialList);
        appCtrl.update();
      }


    }
  }

  onLeftTap(title) {
    if (title == "Moon") {
      final setting = Get.isRegistered<SettingController>() ? Get.find<SettingController>() : Get.put(SettingController());
      setting.onStatusChange();

    } else if (title == "Language") {
      Get.toNamed(routeName.languageScreen);
    } else if (title == "Home 1") {
      pageController.jumpToPage(1);
      controller.jumpTo(1);
    } else if (title == "Setting 1") {
      pageController.jumpToPage(2);
      controller.jumpTo(2);
    } else if (title == "Convert Shape") {
      Get.toNamed(routeName.languageScreen);
    } else if (title == "Home 2") {
      pageController.jumpToPage(1);
      controller.jumpTo(1);
    } else if (title == "Setting 2") {
      pageController.jumpToPage(2);
      controller.jumpTo(2);
    } else if (title == "Search 2") {
      pageController.jumpToPage(0);
      controller.jumpTo(0);
    } else if (title == "Global") {
      Get.toNamed(routeName.languageScreen);
    } else if (title == "Notification") {
      Get.toNamed(routeName.notification);
    } else if (title == "Search 1") {
      pageController.jumpToPage(0);
      controller.jumpTo(0);
    }
    update();
  }

  onRightTap(title) {
    log("title :$title");
    if (title == "Moon") {
      final setting = Get.isRegistered<SettingController>() ? Get.find<SettingController>() : Get.put(SettingController());
      setting.onStatusChange();
    } else if (title == "Language") {
    } else if (title == "Home 1") {
      maxCount = 1;
      update();

    } else if (title == "Setting 1") {
      maxCount = 2;
      update();
    } else if (title == "Convert Shape") {
    } else if (title == "Home 2") {
      maxCount = 1;
      update();
    } else if (title == "Setting 2") {
      maxCount = 2;
      update();
    } else if (title == "Search 2") {
      maxCount = 0;
      update();
    } else if (title == "Global") {
      Get.toNamed(routeName.languageScreen);
    } else if (title == "Notification") {
      Get.toNamed(routeName.notification);
    } else if (title == "Search 1") {
      maxCount = 0;
      update();
    }else if (title == "Search") {
      maxCount = 0;
      update();
    }
    update();
  }
}
