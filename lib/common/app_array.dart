import '../config.dart';

class AppArray {


  var settingList = [
    {"title": "darkMode", "icon": svgAssets.moon},
    {"title": "rtl", "icon": svgAssets.rtl},
    {"title": "language", "icon": svgAssets.language},
    {"title": "aboutUs", "icon": svgAssets.about},
    {"title": "privacy", "icon": svgAssets.privacy},
    {"title": "terms", "icon": svgAssets.terms},
    {"title": "share", "icon": svgAssets.share},
    {"title": "rate", "icon": svgAssets.rate},
  ];


// Languages list
  var languagesList = [
    {
      "image": eImageAssets.english,
      "title": appFonts.english,
      'locale': const Locale('en', 'US'),
      "code": "en"
    },
    {
      "image": eImageAssets.indian,
      "title": appFonts.hindi,
      'locale': const Locale('hi', 'IN'),
      "code": "hi"
    },
    {
      "image": eImageAssets.french,
      "title": appFonts.french,
      'locale': const Locale('fr', 'CA'),
      "code": "fr"
    },
    {
      "image": eImageAssets.italian,
      "title": appFonts.italian,
      'locale': const Locale('it', 'IT'),
      "code": "it"
    },
    {
      "image": eImageAssets.german,
      "title": appFonts.german,
      'locale': const Locale('ge', 'GE'),
      "code": "ge"
    },
    {
      "image": eImageAssets.japanese,
      "title": appFonts.japanese,
      'locale': const Locale('ja', 'JP'),
      "code": "ja"
    },
  ];


  var bottomList = [{
    "title": appFonts.search,
    "icon": svgAssets.searchLine,
    "darkIcon": svgAssets.search
  },
    {
      "title": appFonts.home,
      "icon": svgAssets.homeLine,
      "darkIcon": svgAssets.home
    },{
      "title": appFonts.settings,
      "icon": svgAssets.settingLine,
      "darkIcon": svgAssets.setting
    }];
}
